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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Atelier de travail',
                title: 'Passer de l’idée au livrable',
                subtitle:
                    'Prépare une carte, une étude, une collecte ou un mémoire avec une méthode claire.',
              ),
              const SizedBox(height: 22),
              const PurposePanel(
                icon: Icons.architecture_rounded,
                title: 'À quoi sert cet atelier ?',
                description:
                    'À ne rien oublier avant de produire : objectif, données, méthode, contrôle qualité et restitution.',
                steps: ['Choisir un modèle', 'Adapter les étapes', 'Contrôler'],
                color: AppTheme.coral,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _ToolDoor(
                      icon: Icons.location_on_outlined,
                      title: 'Carnet de terrain',
                      description: 'Noter une observation avec coordonnées.',
                      color: AppTheme.teal,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FieldNotebookScreen(
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ToolDoor(
                      icon: Icons.calculate_outlined,
                      title: 'Outils de calcul',
                      description: 'Convertir ou vérifier rapidement.',
                      color: AppTheme.purple,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const QuickToolsScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionTitle(
                title: 'Choisir un type de travail',
                subtitle:
                    'Chaque modèle te donne une suite d’étapes modifiable, pas un résultat automatique.',
              ),
              const SizedBox(height: 14),
              ...projectTemplates.map(
                (template) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ProjectCard(
                    template: template,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProjectBuilderScreen(
                          controller: controller,
                          template: template,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SectionTitle(
                title: 'Contrôle avant export',
                subtitle:
                    'Utilise cette liste juste avant de remettre ou publier une carte.',
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

class _ToolDoor extends StatelessWidget {
  const _ToolDoor({
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
      borderRadius: BorderRadius.circular(27),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 174),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(27),
          border: Border.all(color: AppTheme.ink.withOpacity(.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftIcon(icon: icon, color: color),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.template, required this.onTap});

  final ProjectTemplate template;
  final VoidCallback onTap;

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
                width: 58,
                height: 84,
                decoration: BoxDecoration(
                  color: AppTheme.coral.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(template.icon, color: AppTheme.coral, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(template.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(template.description,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 9),
                    Text(
                      '${template.steps.length} étapes guidées',
                      style: const TextStyle(
                        color: AppTheme.coral,
                        fontSize: 11,
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
    'Le titre dit clairement ce que montre la carte': false,
    'La légende est ordonnée et compréhensible': false,
    'L’échelle et l’orientation sont présentes si nécessaires': false,
    'La source, la date et l’auteur sont indiqués': false,
    'Le système de coordonnées est adapté': false,
    'Les textes restent lisibles au format final': false,
  };

  @override
  Widget build(BuildContext context) {
    final done = items.values.where((value) => value).length;
    final progress = done / items.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qualité cartographique',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('$done élément(s) vérifié(s) sur ${items.length}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).round()} %',
                  style: const TextStyle(
                    color: AppTheme.coral,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppTheme.sand,
                color: AppTheme.coral,
              ),
            ),
            const SizedBox(height: 12),
            ...items.entries.map(
              (entry) => CheckboxListTile(
                value: entry.value,
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(entry.key),
                onChanged: (value) => setState(
                  () => items[entry.key] = value ?? false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
