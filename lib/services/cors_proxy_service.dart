import 'package:flutter/foundation.dart';
import '../database/database.dart';

/// Proxy service for web
/// Disabled on native platforms.
class CorsProxyService {
  static CorsProxyService? _instance;
  static CorsProxyService get instance => _instance ??= CorsProxyService._();
  CorsProxyService._();

  static const String defaultProxyUrl = '';

  String? _proxyUrl;
  bool _isEnabled = true;
  bool _initialized = false;

  Future<void> init(AppDatabase db) async {
    if (_initialized) return;
    try {
      final settings = await db.select(db.settings).get();
      final map = {for (var s in settings) s.key: s.value};
      _proxyUrl = map['corsProxyUrl'];

      if (kIsWeb && (_proxyUrl == null || _proxyUrl!.trim().isEmpty)) {
        _proxyUrl = defaultProxyUrl;
        await db
            .into(db.settings)
            .insertOnConflictUpdate(
              SettingsCompanion.insert(
                key: 'corsProxyUrl',
                value: defaultProxyUrl,
              ),
            );
      }

      if (map.containsKey('corsProxyEnabled')) {
        _isEnabled = map['corsProxyEnabled'] == 'true';
      }
    } catch (e) {
      debugPrint('CorsProxyService init hatası: $e');
    }
    _initialized = true;
  }

  void updateProxyUrl(String? url) {
    _proxyUrl = (url != null && url.trim().isEmpty) ? null : url?.trim();
  }

  void updateProxyEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Uri wrapUrl(Uri original) {
    if (!kIsWeb || !_isEnabled) return original;
    final proxy = _proxyUrl;
    if (proxy == null || proxy.isEmpty) return original;

    final encoded = Uri.encodeComponent(original.toString());
    return Uri.parse('$proxy$encoded');
  }

  String wrapUrlString(String url) {
    if (!kIsWeb) return url;
    return wrapUrl(Uri.parse(url)).toString();
  }

  bool get isActive => kIsWeb && _isEnabled && (_proxyUrl?.isNotEmpty ?? false);
  bool get isEnabled => _isEnabled;
  String? get proxyUrl => _proxyUrl;
}
