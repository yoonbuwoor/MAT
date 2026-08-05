import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'practice_detail_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SectionTitle(
                title: 'Pratiquer',
                subtitle: 'Résoudre des situations proches du travail réel.',
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.purple,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.psychology_alt, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Compétence par la décision',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.completedMissions.length}/${practiceMissions.length} missions validées',
                            style: TextStyle(color: Colors.white.withOpacity(.82)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(
                title: 'Missions disponibles',
                subtitle: 'Chaque correction explique la logique, pas seulement la réponse.',
              ),
              const SizedBox(height: 14),
              ...practiceMissions.map((mission) => _MissionCard(
                    mission: mission,
                    controller: controller,
                  )),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SoftIcon(
                        icon: Icons.upcoming_outlined,
                        color: AppTheme.coral,
                        size: 52,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prochain module',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Corriger une carte interactive : légende, couleurs, hiérarchie et mise en page.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission, required this.controller});

  final PracticeMission mission;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final done = controller.completedMissions.contains(mission.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PracticeDetailScreen(
                controller: controller,
                mission: mission,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                SoftIcon(
                  icon: mission.icon,
                  color: done ? Colors.green : AppTheme.coral,
                  size: 54,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.coral.withOpacity(.10),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              mission.level,
                              style: const TextStyle(
                                color: AppTheme.coral,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (done) ...[
                            const SizedBox(width: 7),
                            const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mission.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.scenario,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
