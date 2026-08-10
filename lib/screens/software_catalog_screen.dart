import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../data/software_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';

class SoftwareCatalogScreen extends StatefulWidget {
  const SoftwareCatalogScreen({super.key});

  @override
  State<SoftwareCatalogScreen> createState() => _SoftwareCatalogScreenState();
}

class _SoftwareCatalogScreenState extends State<SoftwareCatalogScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'Tous';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>{
      'Tous',
      for (final software in geomaticsSoftware) software.category,
    }.toList();
    final query = _query.trim().toLowerCase();
    final visible = geomaticsSoftware.where((software) {
      final categoryMatches =
          _category == 'Tous' || software.category == _category;
      final text = '${software.name} ${software.category} ${software.utility} '
              '${software.bestFor}'
          .toLowerCase();
      return categoryMatches && (query.isEmpty || text.contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Logiciels de géomatique')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: [
          const ScreenHeader(
            eyebrow: 'Boîte à outils',
            title: 'Choisir le bon logiciel pour la bonne mission',
            subtitle:
                'Compare les usages avant d’installer un outil : SIG, terrain, télédétection, web, bases spatiales, photogrammétrie ou LiDAR.',
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              labelText: 'Rechercher un logiciel ou un usage',
              hintText: 'Ex. orthophoto, QGIS, base de données…',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Effacer',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: _category == category,
                  onSelected: (_) => setState(() => _category = category),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          SectionTitle(
            title: '${visible.length} logiciel(s)',
            subtitle:
                'La licence et les plateformes peuvent évoluer : vérifie-les avant un achat ou un déploiement.',
          ),
          const SizedBox(height: 12),
          if (visible.isEmpty)
            const _EmptyResult()
          else
            ...visible.map(
              (software) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SoftwareCard(software: software),
              ),
            ),
        ],
      ),
    );
  }
}

class _SoftwareCard extends StatelessWidget {
  const _SoftwareCard({required this.software});

  final GeomaticsSoftware software;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIcon(icon: software.icon, color: software.color, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        software.category.toUpperCase(),
                        style: TextStyle(
                          color: software.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        software.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(software.utility),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: software.color.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Idéal pour : ${software.bestFor}',
                style: const TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  icon: Icons.verified_user_outlined,
                  label: software.license,
                ),
                _InfoPill(
                  icon: Icons.devices_rounded,
                  label: software.platforms,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 34, color: AppTheme.muted),
          SizedBox(height: 10),
          Text(
            'Aucun logiciel ne correspond à cette recherche.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
