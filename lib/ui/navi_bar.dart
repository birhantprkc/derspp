import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import 'screens/solution_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/review_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/subject_review_screen.dart';

class NaviBar extends StatefulWidget {
  const NaviBar({super.key});

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int _currentIndex = 0;
  NavItemType _currentType = NavItemType.solution;
  bool _isInitialized = false;

  Widget _getScreen(NavItemType type) {
    switch (type) {
      case NavItemType.solution:
        return const SolutionScreen();
      case NavItemType.tasks:
        return const TasksScreen();
      case NavItemType.review:
        return const ReviewScreen();
      case NavItemType.subjects:
        return const SubjectReviewScreen();
      case NavItemType.settings:
        return const SettingsScreen();
    }
  }

  bool get _isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 650;
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final visibleItems = navProvider.visibleItems;

    if (!_isInitialized) {
      _currentType = navProvider.initialType;
      _isInitialized = true;
    }

    final foundIndex = visibleItems.indexWhere(
      (item) => item.type == _currentType,
    );
    if (foundIndex != -1) {
      _currentIndex = foundIndex;
    } else {
      _currentIndex = 0;
      _currentType = visibleItems[0].type;
    }

    return _isTablet
        ? _buildTabletLayout(visibleItems)
        : _buildMobileLayout(visibleItems);
  }

  Widget _buildTabletLayout(List<NavItem> visibleItems) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRailTheme(
            data: NavigationRailThemeData(
              backgroundColor: Colors.transparent,
              indicatorColor: Theme.of(context).colorScheme.surfaceVariant,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: NavigationRail(
              extended: true,
              minExtendedWidth: 200,
              backgroundColor: Colors.transparent,
              useIndicator: true,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _currentType = visibleItems[index].type;
                });
              },
              destinations: visibleItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 0.5,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                key: ValueKey(visibleItems[_currentIndex].type),
                child: _getScreen(visibleItems[_currentIndex].type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(List<NavItem> visibleItems) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          key: ValueKey(visibleItems[_currentIndex].type),
          child: _getScreen(visibleItems[_currentIndex].type),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 0.5,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: NavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _currentType = visibleItems[index].type;
                });
              },
              destinations: visibleItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
