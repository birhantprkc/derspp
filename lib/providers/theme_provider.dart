import 'package:flutter/material.dart';
import '../database/database.dart';

class ThemeProvider extends ChangeNotifier {
  final AppDatabase _db;

  ThemeMode _themeMode = ThemeMode.system;
  Color _customSeedColor = Colors.blue;
  bool _useDynamicColor = false;
  bool _playerContentDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  Color get customSeedColor => _customSeedColor;
  bool get useDynamicColor => _useDynamicColor;
  bool get playerContentDarkMode => _playerContentDarkMode;

  ThemeProvider(this._db) {
    _init();
  }

  Future<void> _init() async {
    await _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    try {
      final settings = await _db.select(_db.settings).get();
      final map = {for (var s in settings) s.key: s.value};

      if (map.containsKey('themeMode')) {
        _themeMode = ThemeMode.values[int.parse(map['themeMode']!)];
      }
      if (map.containsKey('seedColor')) {
        _customSeedColor = Color(int.parse(map['seedColor']!));
      }
      if (map.containsKey('useDynamicColor')) {
        _useDynamicColor = map['useDynamicColor'] == 'true';
      }
      if (map.containsKey('playerContentDarkMode')) {
        _playerContentDarkMode = map['playerContentDarkMode'] == 'true';
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Tema ayarları yüklenirken hata: $e');
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    try {
      await _db
          .into(_db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(key: key, value: value),
          );
    } catch (e) {
      debugPrint('Tema ayarı kaydedilemedi ($key): $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _saveSetting('themeMode', mode.index.toString());
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _customSeedColor = color;
    _useDynamicColor = false;

    _saveSetting('seedColor', color.value.toString());
    _saveSetting('useDynamicColor', 'false');
    notifyListeners();
  }

  void setUseDynamicColor(bool value) {
    if (_useDynamicColor == value) return;
    _useDynamicColor = value;
    _saveSetting('useDynamicColor', value.toString());
    notifyListeners();
  }

  void setPlayerContentDarkMode(bool value) {
    if (_playerContentDarkMode == value) return;
    _playerContentDarkMode = value;
    _saveSetting('playerContentDarkMode', value.toString());
    notifyListeners();
  }

  ThemeData buildTheme(Brightness brightness, ColorScheme? systemScheme) {
    ColorScheme finalScheme;

    if (_useDynamicColor && systemScheme != null) {
      finalScheme = ColorScheme.fromSeed(
        seedColor: systemScheme.primary,
        brightness: brightness,
      );
    } else {
      finalScheme = ColorScheme.fromSeed(
        seedColor: _customSeedColor,
        brightness: brightness,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: finalScheme,

      scaffoldBackgroundColor: finalScheme.surface,

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: finalScheme.surfaceContainer,
        elevation: 0,
        indicatorColor: finalScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: finalScheme.surface,
        indicatorColor: finalScheme.secondaryContainer,
        selectedIconTheme: IconThemeData(
          color: finalScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: finalScheme.onSurfaceVariant),
        labelType: NavigationRailLabelType.all,
        groupAlignment: 0.0,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: finalScheme.surface,
        foregroundColor: finalScheme.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
    );
  }
}
