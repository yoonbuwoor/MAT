import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/brand_widgets.dart';
import 'current_location_screen.dart';
import 'point_capture_screen.dart';

class TerrainScreen extends StatelessWidget {
  const TerrainScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Terrain',
                title: 'Se localiser et relever',
                subtitle:
                    'Deux fonctions fiables autour de la position du téléphone, sans prétendre remplacer un récepteur GNSS professionnel.',
              ),
              const SizedBox(height: 22),
              const PurposePanel(
                icon: Icons.explore_rounded,
                title: 'À quoi sert cet espace ?',
                description:
                    'À afficher une position dans plusieurs systèmes et constituer un jeu de points documentés que tu peux importer ou exporter en CSV.',
                steps: ['Localiser', 'Documenter', 'Importer ou exporter'],
                color: AppTheme.teal,
              ),
              const SizedBox(height: 24),
              _TerrainDoor(
                number: '01',
                icon: Icons.my_location_rounded,
                title: 'Ma localisation',
                description:
                    'Affiche X et Y en WGS 84 décimal, DMS, UTM automatique ou EPSG:3857.',
                color: AppTheme.teal,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CurrentLocationScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _TerrainDoor(
                number: '02',
                icon: Icons.add_location_alt_rounded,
                title: 'Relever des points',
                description:
                    'Enregistre nom, X, Y, précision, altitude et attributs. Exporte tout en CSV.',
                color: AppTheme.purple,
                trailing: '${controller.geoPoints.length} point(s)',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PointCaptureScreen(controller: controller),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.orange.withOpacity(.10),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.orange.withOpacity(.18)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.gps_fixed_rounded,
                        color: AppTheme.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Avant d’enregistrer, attends la stabilisation du GPS et vérifie la précision affichée. Une position de téléphone reste indicative.',
                        style: TextStyle(fontSize: 12.5, height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TerrainDoor extends StatelessWidget {
  const _TerrainDoor({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.trailing,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 98,
                decoration: BoxDecoration(
                  color: color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        color: color.withOpacity(.65),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(icon, color: color, size: 30),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                    if (trailing != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        trailing!,
                        style: TextStyle(
                          color: color,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
