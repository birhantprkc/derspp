import 'package:flutter/foundation.dart';
import '../database/database.dart';

/// Web platformuna özel CORS proxy servisi.
/// Native platformlarda (Android, iOS, Desktop) proxy devre dışıdır.
class CorsProxyService {
  static CorsProxyService? _instance;
  static CorsProxyService get instance => _instance ??= CorsProxyService._();
  CorsProxyService._();

  String? _proxyUrl;
  bool _isEnabled = true;
  bool _initialized = false;

  /// Proxy URL'ini database'den yükler.
  /// Servisler ilk istekte bu metodu çağırır.
  Future<void> init(AppDatabase db) async {
    if (_initialized) return;
    try {
      final settings = await db.select(db.settings).get();
      final map = {for (var s in settings) s.key: s.value};
      _proxyUrl = map['corsProxyUrl'];
      if (map.containsKey('corsProxyEnabled')) {
        _isEnabled = map['corsProxyEnabled'] == 'true';
      }
    } catch (e) {
      debugPrint('CorsProxyService init hatası: $e');
    }
    _initialized = true;
  }

  /// In-memory güncelleme — ayarlar ekranından çağrılır.
  void updateProxyUrl(String? url) {
    _proxyUrl = (url != null && url.trim().isEmpty) ? null : url?.trim();
  }

  void updateProxyEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Web'de proxy aktifse URL'i wrap eder, değilse orijinal URL'i döner.
  ///
  /// Örnek:
  ///   proxy = "https://corsproxy.io/?url="
  ///   orijinal = "https://example.com/api"
  ///   sonuç   = "https://corsproxy.io/?url=https%3A%2F%2Fexample.com%2Fapi"
  Uri wrapUrl(Uri original) {
    if (!kIsWeb || !_isEnabled) return original;
    final proxy = _proxyUrl;
    if (proxy == null || proxy.isEmpty) return original;

    // Proxy URL'inin sonunda "=" veya "/" olup olmadığına göre encode et
    final encoded = Uri.encodeComponent(original.toString());
    return Uri.parse('$proxy$encoded');
  }

  /// String URL versiyonu — servisler bu metodu kullanır.
  String wrapUrlString(String url) {
    if (!kIsWeb) return url;
    return wrapUrl(Uri.parse(url)).toString();
  }

  bool get isActive => kIsWeb && _isEnabled && (_proxyUrl?.isNotEmpty ?? false);
  bool get isEnabled => _isEnabled;
  String? get proxyUrl => _proxyUrl;
}
