import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'field_notebook_screen.dart';
import 'project_builder_screen.dart';
import 'quick_tools_screen.dart';

class ProduceScreen extends StatelessWidget {
  const ProduceScreen({super.key, required this.controller});

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
                title: 'Produire',
                subtitle: 'Passer d’une idée à un résultat propre et justifiable.',
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.calculate_outlined,
                      title: 'Outils rapides',
                      subtitle: 'Coordonnées, échelle, surface',
                      color: AppTheme.coral,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const QuickToolsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.edit_location_alt_outlined,
                      title: 'Carnet terrain',
                      subtitle: '${controller.observations.length} observation(s)',
                      color: const Color(0xFF25858A),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FieldNotebookScreen(controller: controller),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const SectionTitle(
                title: 'Atelier de projet',
                subtitle: 'Choisis un point de départ et adapte le workflow.',
              ),
              const SizedBox(height: 14),
              ...projectTemplates.map((template) => _ProjectCard(
                    template: template,
                    controller: controller,
                  )),
              const SizedBox(height: 24),
              const SectionTitle(
                title: 'Contrôle qualité avant export',
                subtitle: 'La carte est terminée lorsque le message est clair et vérifiable.',
              ),
              const SizedBox(height: 14),
              const _QualityChecklist(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
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
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SoftIcon(icon: icon, color: color, size: 48),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.template, required this.controller});

  final ProjectTemplate template;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProjectBuilderScreen(
                controller: controller,
                template: template,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                SoftIcon(icon: template.icon, color: AppTheme.purple, size: 54),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(template.description),
                      const SizedBox(height: 8),
                      Text(
                        '${template.steps.length} étapes guidées',
                        style: const TextStyle(
                          color: AppTheme.coral,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
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

class _QualityChecklist extends StatefulWidget {
  const _QualityChecklist();

  @override
  State<_QualityChecklist> createState() => _QualityChecklistState();
}

class _QualityChecklistState extends State<_QualityChecklist> {
  final items = <String, bool>{
    'Le titre exprime clairement le sujet': false,
    'La légende est compréhensible et ordonnée': false,
    'La source et la date des données sont indiquées': false,
    'L’échelle et la projection sont adaptées': false,
    'La hiérarchie visuelle guide la lecture': false,
    'L’orthographe et les unités sont vérifiées': false,
  };

  @override
  Widget build(BuildContext context) {
    final done = items.values.where((value) => value).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$done/${items.length} contrôles validés',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Text('${((done / items.length) * 100).round()} %'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: done / items.length),
            const SizedBox(height: 10),
            ...items.entries.map((entry) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: entry.value,
                  title: Text(entry.key),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) => setState(() => items[entry.key] = value ?? false),
                )),
          ],
        ),
      ),
    );
  }
}
