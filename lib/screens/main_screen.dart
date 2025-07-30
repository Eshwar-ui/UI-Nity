// ignore_for_file: unused_local_variable

import 'package:design_editor_app/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'education_screen.dart';
import 'profile_screen.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const EducationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final homeIcon = Image.asset(
      'assets/icons/home-fill.png',
      width: 24,
      height: 24,
      // Use theme color for icons to support dark mode
      color: colorScheme.onSurface,
    );
    final educationIcon = Image.asset(
      'assets/icons/graduation-cap-fill.png',
      width: 24,
      height: 24,
      color: colorScheme.onSurface,
    );
    final profileIcon = Image.asset(
      'assets/icons/user-4-fill.png',
      width: 24,
      height: 24,
      color: colorScheme.onSurface,
    );

    // Make sure we can access ComponentProvider
    final componentProvider = Provider.of<ComponentService>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        return Scaffold(
          body: isWide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.selected,
                      destinations: [
                        NavigationRailDestination(
                          icon: homeIcon,
                          selectedIcon: homeIcon,
                          label: const Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: educationIcon,
                          selectedIcon: educationIcon,
                          label: const Text('Education'),
                        ),
                        NavigationRailDestination(
                          icon: profileIcon,
                          selectedIcon: profileIcon,
                          label: const Text('Profile'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex,
                        children: _screens,
                      ),
                    ),
                  ],
                )
              : IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  indicatorColor: theme.brightness == Brightness.light
                      ? Colors.grey.shade100
                      : Colors.grey.shade800,
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: colorScheme.onSurface, width: 2),
                  ),
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  backgroundColor: colorScheme.surface,
                  elevation: 0,
                  destinations: [
                    NavigationDestination(
                      icon: homeIcon,
                      selectedIcon: homeIcon,
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: educationIcon,
                      selectedIcon: educationIcon,
                      label: 'Education',
                    ),
                    NavigationDestination(
                      icon: profileIcon,
                      selectedIcon: profileIcon,
                      label: 'Profile',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
