import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/brand_widgets.dart';
import '../widgets/sos_sheet.dart';
import 'glossary_screen.dart';
import 'quick_tools_screen.dart';

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
                eyebrow: 'Ton compagnon de poche',
                title: 'De quoi as-tu besoin aujourd’hui ?',
                subtitle:
                    'Choisis une action précise. Chaque espace explique clairement ce qu’il apporte avant de commencer.',
                trailing: const _HelpButton(),
              ),
              const SizedBox(height: 24),
              _SignaturePanel(controller: controller),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Choisir une action',
                subtitle: 'Pas de menu compliqué : pars directement de ton besoin.',
              ),
              const SizedBox(height: 14),
              _PrimaryAction(
                icon: Icons.auto_stories_rounded,
                title: 'Comprendre une notion',
                description:
                    'Définition courte, exemple concret et erreur fréquente à éviter.',
                label: 'Ouvrir les fiches',
                color: AppTheme.purple,
                onTap: () => controller.setTab(1),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CompactAction(
                      icon: Icons.task_alt_rounded,
                      title: 'M’entraîner',
                      description: 'Résoudre un cas et comprendre la correction.',
                      color: AppTheme.teal,
                      onTap: () => controller.setTab(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CompactAction(
                      icon: Icons.architecture_rounded,
                      title: 'Préparer un projet',
                      description: 'Structurer une carte, une étude ou un mémoire.',
                      color: AppTheme.coral,
                      onTap: () => controller.setTab(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SlimAction(
                      icon: Icons.calculate_outlined,
                      title: 'Outils rapides',
                      subtitle: 'Coordonnées, échelle, distance',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const QuickToolsScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SlimAction(
                      icon: Icons.menu_book_outlined,
                      title: 'Glossaire',
                      subtitle: 'Retrouver un terme technique',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GlossaryScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Comment utiliser l’application',
                subtitle: 'Une méthode simple en quatre temps.',
              ),
              const SizedBox(height: 14),
              const _MethodTimeline(),
              const SizedBox(height: 28),
              _SosCard(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _SosCard() {
    return Builder(
      builder: (context) => InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: false,
          builder: (_) => const SosGeomaticienSheet(),
        ),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.ink,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.support_agent_rounded,
                    color: AppTheme.orange),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SOS Géomaticien',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Diagnostiquer une couche décalée, une distance fausse ou une carte illisible.',
                      style: TextStyle(
                        color: Color(0xFFD7CED8),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'À propos de l’application',
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
                'L’application ne remplace pas un logiciel SIG. Elle t’aide à comprendre les notions, choisir une méthode, préparer un travail et éviter les erreurs courantes.',
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

class _SignaturePanel extends StatelessWidget {
  const _SignaturePanel({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final hasStarted = controller.xp > 0;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'PARCOURS PERSONNEL',
                  style: TextStyle(
                    color: AppTheme.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${controller.xp} XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Text(
            hasStarted
                ? 'Poursuis là où tu progresses.'
                : 'Ton espace est prêt. Tout commence à zéro.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w900,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            hasStarted
                ? 'Chaque fiche et exercice validé construit ton profil de compétences.'
                : 'Aucun faux score, aucun projet fictif. Tes résultats apparaîtront au fur et à mesure.',
            style: TextStyle(
              color: Colors.white.withOpacity(.72),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
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
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.ink.withOpacity(.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 84,
              decoration: BoxDecoration(
                color: color.withOpacity(.11),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(description, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}

class _CompactAction extends StatelessWidget {
  const _CompactAction({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 184),
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.16),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(.78),
                fontSize: 11.5,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlimAction extends StatelessWidget {
  const _SlimAction({
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
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.ink.withOpacity(.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.coral),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MethodTimeline extends StatelessWidget {
  const _MethodTimeline();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('01', 'Comprendre', 'Lire une fiche courte et contextualisée.'),
      ('02', 'Pratiquer', 'Prendre une décision dans un cas concret.'),
      ('03', 'Produire', 'Structurer ton propre travail géomatique.'),
      ('04', 'Progresser', 'Construire un profil basé sur tes résultats réels.'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
        child: Column(
          children: [
            for (var index = 0; index < steps.length; index++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index].$1,
                      style: const TextStyle(
                        color: AppTheme.coral,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[index].$2,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            steps[index].$3,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index != steps.length - 1) const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}
