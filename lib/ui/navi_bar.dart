import 'package:flutter/material.dart';
import 'screens/solution_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/review_screen.dart';

class NaviBar extends StatefulWidget {
  const NaviBar({super.key});

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SolutionScreen(),
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
          SizedBox(
            width: 96,
            child: NavigationRailTheme(
              data: NavigationRailThemeData(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                labelType: NavigationRailLabelType.all,
                useIndicator: true,
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.play_circle_outline),
                    selectedIcon: Icon(Icons.play_circle),
                    label: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Video Çözüm'),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.collections_bookmark_outlined),
                    selectedIcon: Icon(Icons.collections_bookmark),
                    label: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Kaydedilenler'),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Ayarlar'),
                    ),
                  ),
                ],
              ),
            ),
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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: NavigationBar(
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
    );
  }
}
