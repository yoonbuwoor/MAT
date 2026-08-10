import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import 'terrain_screen.dart';
import 'today_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      TodayScreen(controller: controller),
      LearnScreen(controller: controller),
      PracticeScreen(controller: controller),
      TerrainScreen(controller: controller),
      ProfileScreen(controller: controller),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: controller.currentTab,
          children: screens,
        ),
      ),
      bottomNavigationBar: _ClassyNavigation(
        selectedIndex: controller.currentTab,
        onSelected: controller.setTab,
      ),
    );
  }
}

class _ClassyNavigation extends StatelessWidget {
  const _ClassyNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const items = <_NavItem>[
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Accueil'),
    _NavItem(Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'Cours'),
    _NavItem(Icons.quiz_outlined, Icons.quiz_rounded, 'Quiz'),
    _NavItem(Icons.explore_outlined, Icons.explore_rounded, 'Terrain'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF241F26) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: dark
                ? Colors.white.withOpacity(.07)
                : AppTheme.ink.withOpacity(.07),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(dark ? .24 : .10),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == selectedIndex;
            return Expanded(
              child: Semantics(
                selected: selected,
                button: true,
                label: item.label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.ink : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected ? item.selectedIcon : item.icon,
                          size: 22,
                          color: selected
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.58),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.58),
                            fontSize: 10,
                            fontWeight:
                                selected ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
