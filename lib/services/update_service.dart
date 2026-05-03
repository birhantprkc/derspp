import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  static const String _repo = 'navidicted/derspp';
  static const String _apiUrl =
      'https://api.github.com/repos/$_repo/releases/latest';

  static http.Client? _currentDownloadClient;
  static bool get isDownloading => _currentDownloadClient != null;
  static final ValueNotifier<double?> downloadProgress = ValueNotifier(null);
  static String? _downloadedApkPath;
  static String? get downloadedApkPath => _downloadedApkPath;

  static final _notifications = FlutterLocalNotificationsPlugin();

  static const String _keyFrequency = 'update_check_frequency';
  static const String _keyLastCheck = 'last_update_check_timestamp';

  static Future<void> initialize() async {
    if (kIsWeb || !Platform.isAndroid) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        final path = details.payload;
        if (path != null && await File(path).exists()) {
          await installApk(path);
        }
      },
    );
    try {
      await _notifications.cancelAll();
    } catch (_) {}
  }

  static Future<void> _showProgressNotification(
    int progress,
    String title,
  ) async {
    final android = AndroidNotificationDetails(
      'update_channel',
      'Güncelleme',
      channelDescription: 'Uygulama güncelleme ilerlemesi',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      ongoing: progress < 100,
      onlyAlertOnce: true,
      icon: '@mipmap/ic_launcher',
    );
    final platform = NotificationDetails(android: android);
    await _notifications.show(
      999,
      title,
      progress < 100 ? 'İndiriliyor... %$progress' : 'İndirme tamamlandı',
      platform,
    );
  }

  static Future<void> _safeCancel(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (_) {
      try {
        await _notifications.cancelAll();
      } catch (_) {}
    }
  }

  static Future<void> setFrequency(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFrequency, frequency);
  }

  static Future<String> getFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFrequency) ?? 'daily';
  }

  static void cancelDownload() {
    _currentDownloadClient?.close();
    _currentDownloadClient = null;
  }

  static Future<bool> shouldCheckNow() async {
    final prefs = await SharedPreferences.getInstance();
    final frequency = prefs.getString(_keyFrequency) ?? 'daily';
    if (frequency == 'manual') return false;

    final lastCheck = prefs.getInt(_keyLastCheck) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    int interval;
    switch (frequency) {
      case 'daily':
        interval = 24 * 60 * 60 * 1000;
        break;
      case 'every3days':
        interval = 3 * 24 * 60 * 60 * 1000;
        break;
      case 'weekly':
        interval = 7 * 24 * 60 * 60 * 1000;
        break;
      case 'monthly':
        interval = 30 * 24 * 60 * 60 * 1000;
        break;
      default:
        interval = 24 * 60 * 60 * 1000;
    }

    return now - lastCheck >= interval;
  }

  static Future<void> markChecked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastCheck, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<Map<String, dynamic>?> checkUpdate() async {
    // MOCK DATA
    // return {
    //   "tag_name": "v9.9.9-TEST",
    //   "body":
    //       "# Test Sürümü Hazır!\n\nSahte güncelleme.\n\n### Yenilikler:\n- Sahte güncelleme",
    //   "assets": [
    //     {
    //       "name": "derspp-universal.apk",
    //       "browser_download_url":
    //           "",
    //     },
    //   ],
    // };

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);
      final latestVersion = data['tag_name'].toString().replaceAll('v', '');

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      await markChecked();
      if (_isNewer(latestVersion, currentVersion)) {
        return data;
      }
    } catch (e) {
      debugPrint('Güncelleme kontrolü başarısız: $e');
    }
    return null;
  }

  static bool _isNewer(String latest, String current) {
    try {
      List<int> latestParts = latest.split('.').map(int.parse).toList();
      List<int> currentParts = current.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        if (i >= currentParts.length) return true;
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
    } catch (e) {
      return latest != current;
    }
    return false;
  }

  static Future<String> _getArchSuffix() async {
    if (kIsWeb) return 'universal';
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final abi = info.supportedAbis.first;
      if (abi.contains('arm64')) return 'arm64-v8a';
      if (abi.contains('armeabi')) return 'armeabi-v7a';
      if (abi.contains('x86_64')) return 'x86_64';
    } catch (_) {}
    return 'universal';
  }

  static Future<String?> findMatchingAsset(List<dynamic> assets) async {
    final arch = await _getArchSuffix();

    for (var asset in assets) {
      final name = asset['name'].toString().toLowerCase();
      if (name.contains(arch) && name.endsWith('.apk')) {
        return asset['browser_download_url'];
      }
    }
    for (var asset in assets) {
      final name = asset['name'].toString().toLowerCase();
      if (name.contains('universal') && name.endsWith('.apk')) {
        return asset['browser_download_url'];
      }
    }
    for (var asset in assets) {
      final name = asset['name'].toString().toLowerCase();
      if (name.contains(arch) && name.endsWith('.apk')) {
        return asset['browser_download_url'];
      }
    }
    for (var asset in assets) {
      final name = asset['name'].toString().toLowerCase();
      if (name.contains('universal') && name.endsWith('.apk')) {
        return asset['browser_download_url'];
      }
    }
    return null;
  }

  static Future<void> _showInstallNotification(String filePath) async {
    await _safeCancel(999);

    final android = AndroidNotificationDetails(
      'update_channel',
      'Güncelleme',
      channelDescription: 'Uygulama güncelleme ilerlemesi',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      icon: '@mipmap/ic_launcher',
    );
    final platform = NotificationDetails(android: android);
    await _notifications.show(
      998,
      'Güncelleme hazır',
      'derspp\'yi güncellemek için dokunun',
      platform,
      payload: filePath,
    );
  }

  static Future<void> downloadAndInstall({
    required String url,
    required Function(double) onProgress,
  }) async {
    if (isDownloading) return;
    if (!Platform.isAndroid) return;

    var status = await Permission.requestInstallPackages.status;
    if (!status.isGranted) {
      status = await Permission.requestInstallPackages.request();
      if (!status.isGranted) throw 'Kurulum izni verilmedi.';
    }

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/update.apk';
    final file = File(filePath);

    _currentDownloadClient = http.Client();
    final request = http.Request('GET', Uri.parse(url));

    bool completed = false;

    try {
      final response = await _currentDownloadClient!.send(request);

      if (response.statusCode != 200) {
        throw 'İndirme başarısız: ${response.statusCode}';
      }

      final total = response.contentLength ?? 0;
      int downloaded = 0;
      int lastNotifiedProgress = -1;

      final sink = file.openWrite();
      try {
        await for (var chunk in response.stream) {
          if (_currentDownloadClient == null) {
            await sink.close();
            await file.delete();
            throw 'İndirme iptal edildi.';
          }
          downloaded += chunk.length;
          if (total > 0) {
            final progress = downloaded / total;
            downloadProgress.value = progress;
            onProgress(progress);

            final intProgress = (progress * 100).toInt();
            if (intProgress > lastNotifiedProgress) {
              _showProgressNotification(intProgress, 'derspp güncelleniyor');
              lastNotifiedProgress = intProgress;
            }
          }
          sink.add(chunk);
        }
      } finally {
        await sink.close();
      }

      completed = true;
    } finally {
      _currentDownloadClient?.close();
      _currentDownloadClient = null;
      downloadProgress.value = null;

      if (!completed) {
        await _safeCancel(999);
        if (await file.exists()) await file.delete();
      }
    }

    _downloadedApkPath = filePath;
    await _showInstallNotification(filePath);
    await installApk(filePath);
  }

  static Future<void> installApk(String path) async {
    final result = await OpenFile.open(path);
    if (result.type != ResultType.done) {
      debugPrint('Kurulum başlatılamadı: ${result.message}');
    }
  }
}
