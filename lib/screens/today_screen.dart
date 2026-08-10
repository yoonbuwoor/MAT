import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../data/software_data.dart';
import '../widgets/brand_widgets.dart';
import 'current_location_screen.dart';
import 'glossary_screen.dart';
import 'point_capture_screen.dart';
import 'software_catalog_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ScreenHeader(
                eyebrow: 'Moi, Géomaticien',
                title: 'Apprendre ici. Mesurer dehors.',
                subtitle:
                    'Des cours, des quiz, un guide des logiciels et deux outils terrain utiles : se localiser et relever des points.',
                trailing: const _AboutButton(),
              ),
              const SizedBox(height: 24),
              _HeroPanel(controller: controller),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Sur le terrain',
                subtitle:
                    'Le GPS du téléphone fournit une position indicative : vérifie toujours la précision affichée.',
              ),
              const SizedBox(height: 14),
              _FeatureDoor(
                icon: Icons.my_location_rounded,
                title: 'Afficher ma localisation',
                description:
                    'Obtenir X et Y dans le système choisi : WGS 84, DMS, UTM automatique ou Web Mercator.',
                label: 'LOCALISER MAINTENANT',
                color: AppTheme.teal,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CurrentLocationScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CompactDoor(
                      icon: Icons.add_location_alt_rounded,
                      title: 'Relever des points',
                      description:
                          'Nom, X, Y, précision et attributs personnalisés.',
                      color: AppTheme.purple,
                      badge: '${controller.geoPoints.length} point(s)',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PointCaptureScreen(
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CompactDoor(
                      icon: Icons.apps_rounded,
                      title: 'Logiciels SIG',
                      description:
                          'Comprendre l’utilité des principaux outils de géomatique.',
                      color: AppTheme.coral,
                      badge: '${geomaticsSoftware.length} outils',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SoftwareCatalogScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionTitle(
                title: 'Dans ta poche',
                subtitle:
                    '${learningTopics.length} cours et des quiz pour progresser du niveau débutant au niveau avancé.',
              ),
              const SizedBox(height: 14),
              _LearningStrip(controller: controller),
            ]),
          ),
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.ink, AppTheme.plum],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ink.withOpacity(.18),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TON ESPACE DÉMARRE À ZÉRO',
                  style: TextStyle(
                    color: AppTheme.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Pas de faux projet.\nPas de score inventé.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tes ${controller.geoPoints.length} point(s), tes cours et tes quiz construisent progressivement ton vrai parcours.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.70),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 78,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: Colors.white,
              size: 39,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureDoor extends StatelessWidget {
  const _FeatureDoor({
    required this.icon,
    required this.title,
    required this.description,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 92,
                decoration: BoxDecoration(
                  color: color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, color: color, size: 31),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 11),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactDoor extends StatelessWidget {
  const _CompactDoor({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          constraints: const BoxConstraints(minHeight: 210),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SoftIcon(icon: icon, color: color),
                  const Spacer(),
                  Icon(Icons.north_east_rounded, color: color, size: 19),
                ],
              ),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningStrip extends StatelessWidget {
  const _LearningStrip({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SmallAction(
            icon: Icons.auto_stories_rounded,
            title: 'Cours',
            subtitle: 'Comprendre une notion',
            onTap: () => controller.setTab(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SmallAction(
            icon: Icons.quiz_rounded,
            title: 'Quiz',
            subtitle: 'Tester ses acquis',
            onTap: () => controller.setTab(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SmallAction(
            icon: Icons.sort_by_alpha_rounded,
            title: 'Glossaire',
            subtitle: 'Définir un terme',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GlossaryScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        constraints: const BoxConstraints(minHeight: 122),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.ink.withOpacity(.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.coral),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutButton extends StatelessWidget {
  const _AboutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'À propos',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('À quoi sert Moi, Géomaticien ?',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              const Text(
                'À apprendre les notions essentielles, choisir un logiciel adapté et relever des points avec le GPS du téléphone. Pour les travaux de haute précision, utilise un récepteur GNSS professionnel.',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('J’ai compris'),
                ),
              ),
            ],
          ),
        ),
      ),
      icon: const Icon(Icons.info_outline_rounded),
    );
  }
}
