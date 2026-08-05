import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/brand_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final completedTopics = controller.completedTopics.length;
    final completedMissions = controller.completedMissions.length;
    final hasProgress = controller.xp > 0 ||
        completedTopics > 0 ||
        completedMissions > 0 ||
        controller.observations.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ScreenHeader(
                eyebrow: 'Mon parcours',
                title: 'Un profil basé sur ce que tu fais',
                subtitle:
                    'Aucun score inventé : les indicateurs évoluent uniquement quand tu termines une fiche, un exercice ou une observation.',
                trailing: IconButton(
                  tooltip: 'Réinitialiser le parcours',
                  onPressed: hasProgress
                      ? () => _confirmReset(context)
                      : null,
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ),
              const SizedBox(height: 22),
              _IdentityCard(controller: controller),
              const SizedBox(height: 24),
              const PurposePanel(
                icon: Icons.insights_rounded,
                title: 'Comment lire cette page ?',
                description:
                    'Elle montre ta progression réelle. Une fiche rapporte 25 XP, un exercice 50 XP et une observation terrain 10 XP.',
                steps: ['Apprendre', 'Valider', 'Voir progresser le profil'],
                color: AppTheme.purple,
              ),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Activité réelle',
                subtitle: 'Tous les compteurs ont été remis à zéro.',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '$completedTopics',
                      label: 'Fiches maîtrisées',
                      icon: Icons.auto_stories_rounded,
                      color: AppTheme.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: '$completedMissions',
                      label: 'Exercices terminés',
                      icon: Icons.task_alt_rounded,
                      color: AppTheme.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '${controller.observations.length}',
                      label: 'Notes terrain',
                      icon: Icons.location_on_outlined,
                      color: AppTheme.coral,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: '${controller.favoriteTopics.length}',
                      label: 'Fiches favorites',
                      icon: Icons.bookmark_rounded,
                      color: AppTheme.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Compétences',
                subtitle:
                    'Les domaines apparaîtront après tes premières validations.',
              ),
              const SizedBox(height: 14),
              if (!hasProgress)
                const EmptyStateCard(
                  icon: Icons.radar_rounded,
                  title: 'Aucune compétence évaluée pour le moment',
                  message:
                      'Lis une fiche ou termine un exercice. L’application construira ensuite un profil sans inventer de pourcentage.',
                )
              else
                _CompetenceSummary(controller: controller),
              const SizedBox(height: 28),
              const SectionTitle(title: 'Préférences'),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: controller.themeMode == ThemeMode.dark,
                      onChanged: controller.toggleTheme,
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text(
                        'Mode sombre',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: const Text(
                        'Modifie uniquement le confort visuel.',
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.offline_pin_outlined),
                      title: const Text(
                        'Contenus hors connexion',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(
                        '${learningTopics.length} fiches sont directement intégrées dans l’application.',
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.language_rounded),
                      title: Text(
                        'Langue',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text('Français — autres langues prévues plus tard.'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _AboutCard(),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remettre le parcours à zéro ?'),
        content: const Text(
          'Les fiches validées, les exercices, les favoris et les observations terrain seront supprimés de cette session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      controller.resetProgress();
    }
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.ink, AppTheme.plum],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset('assets/images/moi_geomaticien_logo.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Géomaticien en progression',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Niveau ${controller.level} • ${controller.xp} XP',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.70),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftIcon(icon: icon, color: color, size: 42),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _CompetenceSummary extends StatelessWidget {
  const _CompetenceSummary({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final topic in learningTopics) {
      if (controller.completedTopics.contains(topic.id)) {
        counts.update(topic.category, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    if (counts.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.pending_actions_rounded,
        title: 'Profil en construction',
        message:
            'Tes exercices sont enregistrés, mais valide aussi des fiches pour identifier tes domaines de connaissance.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: counts.entries.map((entry) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const SoftIcon(
                icon: Icons.check_rounded,
                color: AppTheme.teal,
                size: 42,
              ),
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text('${entry.value} fiche(s) maîtrisée(s)'),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.coral.withOpacity(.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.coral.withOpacity(.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/novateur221.png',
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Une application Novateur221',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  'Conçue comme un compagnon méthodologique pour les étudiants et professionnels de la géomatique.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
