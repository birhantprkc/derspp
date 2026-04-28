import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';

enum NavItemType { solution, tasks, review, subjects, settings }

class NavItem {
  final NavItemType type;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  bool isVisible;

  NavItem({
    required this.type,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {'type': type.index, 'isVisible': isVisible};

  factory NavItem.fromJson(Map<String, dynamic> json, NavItem defaultItem) {
    return NavItem(
      type: defaultItem.type,
      label: defaultItem.label,
      icon: defaultItem.icon,
      selectedIcon: defaultItem.selectedIcon,
      isVisible: json['isVisible'] ?? true,
    );
  }
}

class NavigationProvider extends ChangeNotifier {
  final AppDatabase _db;
  NavItemType _initialType = NavItemType.solution;

  NavItemType get initialType => _initialType;

  List<NavItem> _items = [
    NavItem(
      type: NavItemType.solution,
      label: 'Video Çözüm',
      icon: Icons.play_circle_outline,
      selectedIcon: Icons.play_circle,
    ),
    NavItem(
      type: NavItemType.tasks,
      label: 'Planlama',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
    ),
    NavItem(
      type: NavItemType.review,
      label: 'Kaydedilenler',
      icon: Icons.collections_bookmark_outlined,
      selectedIcon: Icons.collections_bookmark,
    ),
    NavItem(
      type: NavItemType.subjects,
      label: 'Konular',
      icon: Icons.checklist_rtl_rounded,
      selectedIcon: Icons.checklist_rtl_sharp,
    ),
    NavItem(
      type: NavItemType.settings,
      label: 'Ayarlar',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  List<NavItem> get allItems => _items;
  List<NavItem> get visibleItems => _items
      .where((i) => i.isVisible || i.type == NavItemType.settings)
      .toList();

  NavigationProvider(this._db) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final setting = await (_db.select(
        _db.settings,
      )..where((t) => t.key.equals('navigation_order'))).getSingleOrNull();
      if (setting != null) {
        final List<dynamic> decoded = jsonDecode(setting.value);
        List<NavItem> newOrder = [];

        final defaultItems = {
          NavItemType.solution: NavItem(
            type: NavItemType.solution,
            label: 'Video Çözüm',
            icon: Icons.play_circle_outline,
            selectedIcon: Icons.play_circle,
          ),
          NavItemType.tasks: NavItem(
            type: NavItemType.tasks,
            label: 'Planlama',
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_today,
          ),
          NavItemType.review: NavItem(
            type: NavItemType.review,
            label: 'Kaydedilenler',
            icon: Icons.collections_bookmark_outlined,
            selectedIcon: Icons.collections_bookmark,
          ),
          NavItemType.subjects: NavItem(
            type: NavItemType.subjects,
            label: 'Konular',
            icon: Icons.checklist_rtl_rounded,
            selectedIcon: Icons.checklist_rtl_sharp,
          ),
          NavItemType.settings: NavItem(
            type: NavItemType.settings,
            label: 'Ayarlar',
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
          ),
        };

        for (var itemJson in decoded) {
          final typeIndex = itemJson['type'] as int;
          if (typeIndex >= NavItemType.values.length) continue;
          final type = NavItemType.values[typeIndex];
          final defaultItem = defaultItems[type];
          if (defaultItem != null) {
            newOrder.add(NavItem.fromJson(itemJson, defaultItem));
          }
        }
        for (var entry in defaultItems.entries) {
          if (!newOrder.any((element) => element.type == entry.key)) {
            newOrder.add(entry.value);
          }
        }
        _items = newOrder;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Nav settings load error: $e');
    }
  }

  Future<void> updateOrder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> toggleVisibility(NavItemType type) async {
    if (type == NavItemType.settings) return;
    final index = _items.indexWhere((element) => element.type == type);
    if (index != -1) {
      _items[index].isVisible = !_items[index].isVisible;
      if (!_items[index].isVisible && _initialType == type) {
        _initialType = NavItemType.settings;
      }
      notifyListeners();
      await _saveSettings();
    }
  }

  Future<void> setInitialType(NavItemType type) async {
    _initialType = type;
    notifyListeners();
    await _db
        .into(_db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: 'navigation_initial_type',
            value: type.index.toString(),
          ),
        );
  }

  Future<void> _saveSettings() async {
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await _db
        .into(_db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: 'navigation_order', value: encoded),
        );
  }
}
