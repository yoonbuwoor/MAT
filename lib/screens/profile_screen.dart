import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../services/location_service.dart';
import '../widgets/brand_widgets.dart';
import 'point_capture_screen.dart';
import 'privacy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final completedTopics = controller.completedTopics.length;
    final completedMissions = controller.completedMissions.length;
    final hasProgress = controller.xp > 0 ||
        completedTopics > 0 ||
        completedMissions > 0;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Mon espace',
                title: 'Une progression qui correspond à tes actions',
                subtitle:
                    'Les cours validés et les quiz réussis alimentent ton parcours. Les points GPS restent des données terrain et ne créent pas de faux score.',
              ),
              const SizedBox(height: 22),
              _IdentityCard(controller: controller),
              const SizedBox(height: 22),
              const SectionTitle(
                title: 'Mon activité',
                subtitle: 'Tout commence réellement à zéro.',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      value: '$completedTopics',
                      label: 'Cours validés',
                      icon: Icons.auto_stories_rounded,
                      color: AppTheme.purple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      value: '$completedMissions',
                      label: 'Quiz réussis',
                      icon: Icons.quiz_rounded,
                      color: AppTheme.teal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      value: '${controller.geoPoints.length}',
                      label: 'Points terrain',
                      icon: Icons.place_rounded,
                      color: AppTheme.coral,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SettingsCard(controller: controller),
              const SizedBox(height: 12),
              _PermissionsCard(controller: controller),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  leading: const SoftIcon(
                    icon: Icons.privacy_tip_outlined,
                    color: AppTheme.purple,
                  ),
                  title: const Text(
                    'Politique de confidentialité',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: const Text(
                    'Localisation, fichiers, stockage et suppression.',
                  ),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (hasProgress)
                OutlinedButton.icon(
                  onPressed: () => _confirmReset(context),
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('REMETTRE LA PROGRESSION À ZÉRO'),
                ),
              const SizedBox(height: 24),
              const _AboutCard(),
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
        title: const Text('Remettre la progression à zéro ?'),
        content: const Text(
          'Les cours, quiz et XP seront réinitialisés. Les points GPS ne seront pas supprimés.',
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
    if (confirmed == true) controller.resetProgress();
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
          colors: [AppTheme.ink, AppTheme.plum],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
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
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${controller.xp} XP • Niveau ${controller.level}',
                  style: const TextStyle(
                    color: AppTheme.orange,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  controller.xp == 0
                      ? 'Le parcours est encore vierge.'
                      : 'Continue avec un cours ou un quiz.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.65),
                    fontSize: 12,
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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
    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppTheme.ink.withOpacity(.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final dark = controller.themeMode == ThemeMode.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: dark,
          onChanged: controller.toggleTheme,
          secondary: const SoftIcon(
            icon: Icons.dark_mode_outlined,
            color: AppTheme.purple,
          ),
          title: const Text(
            'Mode sombre',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: const Text('Adapter l’interface aux conditions de lecture.'),
        ),
      ),
    );
  }
}

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard({required this.controller});

  final AppController controller;

  Future<void> _requestLocation(BuildContext context) async {
    try {
      await LocationService.requestPermission();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localisation autorisée.')),
      );
    } on LocationServiceException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          action: SnackBarAction(
            label: 'PARAMÈTRES',
            onPressed: LocationService.openAppSettings,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Autorisations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const SoftIcon(
                icon: Icons.my_location_rounded,
                color: AppTheme.teal,
              ),
              title: const Text(
                'Localisation',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Nécessaire pour afficher la position et relever un point.',
              ),
              trailing: TextButton(
                onPressed: () => _requestLocation(context),
                child: const Text('Autoriser'),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const SoftIcon(
                icon: Icons.folder_open_rounded,
                color: AppTheme.coral,
              ),
              title: const Text(
                'Lecture de fichiers CSV',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Android demande l’accès uniquement au fichier choisi dans son sélecteur sécurisé.',
              ),
              trailing: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PointCaptureScreen(controller: controller),
                  ),
                ),
                child: const Text('Ouvrir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

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
                  'Moi, Géomaticien associe cours, quiz, guide des logiciels et relevé de points dans une interface claire.',
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
