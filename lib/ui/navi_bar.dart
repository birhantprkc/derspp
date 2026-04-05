import 'package:flutter/material.dart';
import 'screens/solution_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/review_screen.dart';
import 'screens/tasks_screen.dart';

class NaviBar extends StatefulWidget {
  const NaviBar({super.key});

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SolutionScreen(),
    TasksScreen(),
    ReviewScreen(),
    SettingsScreen(),
  ];

  bool get _isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 650;
  }

  @override
  Widget build(BuildContext context) {
    return _isTablet ? _buildTabletLayout() : _buildMobileLayout();
  }

  Widget _buildTabletLayout() {
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
                setState(() => _currentIndex = index);
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.play_circle_outline),
                  selectedIcon: Icon(Icons.play_circle),
                  label: Text('Video Çözüm'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: Text('Planlama'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.collections_bookmark_outlined),
                  selectedIcon: Icon(Icons.collections_bookmark),
                  label: Text('Kaydedilenler'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Ayarlar'),
                ),
              ],
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
                key: ValueKey(_currentIndex),
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
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
                setState(() => _currentIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.play_circle_outline),
                  selectedIcon: Icon(Icons.play_circle),
                  label: 'Video Çözüm',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Planlama',
                ),
                NavigationDestination(
                  icon: Icon(Icons.collections_bookmark_outlined),
                  selectedIcon: Icon(Icons.collections_bookmark),
                  label: 'Kaydedilenler',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Ayarlar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
