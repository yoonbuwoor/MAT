import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/brand_widgets.dart';
import 'topic_detail_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final topic = learningTopics[1];
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const AppBrandMark(showTitle: true),
              const SizedBox(height: 24),
              _HeroCard(controller: controller),
              const SizedBox(height: 26),
              const SectionTitle(
                title: 'À faire aujourd’hui',
                subtitle: 'Une petite action vaut mieux qu’un long programme oublié.',
              ),
              const SizedBox(height: 14),
              _DailyTopicCard(
                controller: controller,
                topicIndex: 1,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TopicDetailScreen(
                      controller: controller,
                      topic: topic,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ChallengeCard(controller: controller),
              const SizedBox(height: 26),
              const SectionTitle(title: 'Accès rapide'),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.42,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _QuickAction(
                    icon: Icons.menu_book_rounded,
                    title: 'Livre de poche',
                    subtitle: '${learningTopics.length} fiches essentielles',
                    color: AppTheme.coral,
                    onTap: () => controller.setTab(1),
                  ),
                  _QuickAction(
                    icon: Icons.psychology_alt_rounded,
                    title: 'Cas pratiques',
                    subtitle: 'Apprendre par la décision',
                    color: AppTheme.purple,
                    onTap: () => controller.setTab(2),
                  ),
                  _QuickAction(
                    icon: Icons.construction_rounded,
                    title: 'Atelier projet',
                    subtitle: 'Construire un workflow',
                    color: const Color(0xFF25858A),
                    onTap: () => controller.setTab(3),
                  ),
                  _QuickAction(
                    icon: Icons.badge_outlined,
                    title: 'Mon passeport',
                    subtitle: 'Compétences et progression',
                    color: const Color(0xFFB36A28),
                    onTap: () => controller.setTab(4),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const SectionTitle(
                title: 'Projet en cours',
                subtitle: 'Garde une vision claire de la prochaine étape.',
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SoftIcon(
                            icon: Icons.layers_outlined,
                            color: Color(0xFF25858A),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Carte d’occupation du sol',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 4),
                                const Text('Prochaine étape : contrôler la classification'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const LinearProgressIndicator(value: .65),
                      const SizedBox(height: 8),
                      const Text('65 % terminé'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: () => controller.setTab(3),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Continuer le projet'),
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.purple, AppTheme.coral],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.coral.withOpacity(.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bonjour, Géomaticien 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aujourd’hui, fais progresser une compétence.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Niveau',
                  value: '${controller.level}',
                  icon: Icons.auto_awesome,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  label: 'Expérience',
                  value: '${controller.xp} XP',
                  icon: Icons.bolt,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: controller.weeklyProgress,
              minHeight: 9,
              backgroundColor: Colors.white.withOpacity(.22),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.weeklyDone}/${controller.weeklyGoal} objectifs cette semaine',
            style: TextStyle(
              color: Colors.white.withOpacity(.88),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 11)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyTopicCard extends StatelessWidget {
  const _DailyTopicCard({
    required this.controller,
    required this.topicIndex,
    required this.onTap,
  });

  final AppController controller;
  final int topicIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topic = learningTopics[topicIndex];
    final done = controller.completedTopics.contains(topic.id);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              SoftIcon(icon: topic.icon, color: topic.color, size: 54),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notion du jour',
                      style: TextStyle(
                        color: topic.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      topic.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(topic.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Icon(done ? Icons.check_circle : Icons.chevron_right, color: done ? Colors.green : null),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final done = controller.completedMissions.contains('projection_choice');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const SoftIcon(
              icon: Icons.emoji_objects_outlined,
              color: Color(0xFFB36A28),
              size: 54,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Défi rapide',
                    style: TextStyle(
                      color: Color(0xFFB36A28),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Choisir la bonne projection',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(done ? 'Défi validé — 50 XP gagnés' : 'Une décision concrète en moins de 2 minutes'),
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.setTab(2),
              icon: Icon(done ? Icons.check_circle : Icons.play_circle_fill),
              color: done ? Colors.green : AppTheme.coral,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SoftIcon(icon: icon, color: color, size: 42),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
