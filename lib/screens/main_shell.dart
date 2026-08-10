import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../services/location_service.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import 'terrain_screen.dart';
import 'today_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_offerLocationPermission());
    });
  }

  Future<void> _offerLocationPermission() async {
    try {
      final permission = await LocationService.permissionStatus().timeout(
        const Duration(seconds: 4),
      );
      if (!mounted || permission != LocationPermission.denied) return;

      final shouldRequestLocation = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              icon: const Icon(
                Icons.my_location_rounded,
                color: AppTheme.teal,
                size: 34,
              ),
              title: const Text('Autoriser la localisation ?'),
              content: const Text(
                'Moi, Géomaticien utilise ta position précise uniquement lorsque l’application est ouverte, pour afficher X/Y et enregistrer les points que tu décides. Les positions restent sur ton téléphone et ne sont pas transmises à Novateur221.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Pas maintenant'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  icon: const Icon(Icons.location_on_rounded),
                  label: const Text('Autoriser'),
                ),
              ],
            ),
          ) ??
          false;
      if (!mounted || !shouldRequestLocation) return;

      await LocationService.requestPermission().timeout(
        const Duration(seconds: 20),
      );
    } catch (_) {
      // L’accueil reste utilisable même si le service GPS échoue ou est lent.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      TodayScreen(controller: widget.controller),
      LearnScreen(controller: widget.controller),
      PracticeScreen(controller: widget.controller),
      TerrainScreen(controller: widget.controller),
      ProfileScreen(controller: widget.controller),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: widget.controller.currentTab,
          children: screens,
        ),
      ),
      bottomNavigationBar: _ClassyNavigation(
        selectedIndex: widget.controller.currentTab,
        onSelected: widget.controller.setTab,
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
