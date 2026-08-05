import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/sos_sheet.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'produce_screen.dart';
import 'profile_screen.dart';
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
      ProduceScreen(controller: controller),
      ProfileScreen(controller: controller),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: controller.currentTab,
          children: screens,
        ),
      ),
      floatingActionButton: controller.currentTab == 4
          ? null
          : FloatingActionButton.extended(
              heroTag: 'sos',
              backgroundColor: AppTheme.purple,
              foregroundColor: Colors.white,
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: false,
                builder: (_) => const SosGeomaticienSheet(),
              ),
              icon: const Icon(Icons.support_agent),
              label: const Text(
                'SOS',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.currentTab,
        onDestinationSelected: controller.setTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: "Aujourd'hui",
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Comprendre',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_alt_outlined),
            selectedIcon: Icon(Icons.psychology_alt),
            label: 'Pratiquer',
          ),
          NavigationDestination(
            icon: Icon(Icons.construction_outlined),
            selectedIcon: Icon(Icons.construction),
            label: 'Produire',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Moi',
          ),
        ],
      ),
    );
  }
}
