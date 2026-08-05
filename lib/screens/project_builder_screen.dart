import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';

class ProjectBuilderScreen extends StatefulWidget {
  const ProjectBuilderScreen({
    super.key,
    required this.controller,
    required this.template,
  });

  final AppController controller;
  final ProjectTemplate template;

  @override
  State<ProjectBuilderScreen> createState() => _ProjectBuilderScreenState();
}

class _ProjectBuilderScreenState extends State<ProjectBuilderScreen> {
  final titleController = TextEditingController();
  final objectiveController = TextEditingController();
  final zoneController = TextEditingController();
  final Set<int> doneSteps = <int>{};
  bool saved = false;

  @override
  void dispose() {
    titleController.dispose();
    objectiveController.dispose();
    zoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.template.steps.isEmpty
        ? 0.0
        : doneSteps.length / widget.template.steps.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.template.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
        children: [
          PurposePanel(
            icon: widget.template.icon,
            title: 'Ce modèle sert à quoi ?',
            description: widget.template.description,
            steps: const ['Définir', 'Planifier', 'Contrôler'],
            color: AppTheme.coral,
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Cadrer le travail',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(
                    'Ces trois champs t’obligent à préciser ce que tu veux produire avant de choisir les outils.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du projet',
                      hintText: 'Ex. Accessibilité aux centres de santé',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: objectiveController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Objectif principal',
                      hintText:
                          'Ex. Mesurer les temps d’accès de la population aux structures de santé.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: zoneController,
                    decoration: const InputDecoration(
                      labelText: 'Zone d’étude',
                      hintText: 'Ex. Département, commune ou bassin versant',
                      prefixIcon: Icon(Icons.place_outlined),
                    ),
                  ),
                ],
              ),
            ),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('2. Suivre le workflow',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              '${doneSteps.length} étape(s) cochée(s) sur ${widget.template.steps.length}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
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
                  const SizedBox(height: 13),
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
                  ...List.generate(widget.template.steps.length, (index) {
                    final done = doneSteps.contains(index);
                    return CheckboxListTile(
                      value: done,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: CircleAvatar(
                        radius: 17,
                        backgroundColor: AppTheme.coral.withOpacity(.10),
                        foregroundColor: AppTheme.coral,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      title: Text(widget.template.steps[index]),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            doneSteps.add(index);
                          } else {
                            doneSteps.remove(index);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: saved ? null : _saveProject,
              icon: Icon(saved ? Icons.verified_rounded : Icons.save_outlined),
              label: Text(
                saved ? 'Structure déjà enregistrée' : 'Enregistrer la structure',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cette version enregistre la progression dans la session en cours. Elle ne crée pas encore un fichier de projet.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _saveProject() {
    if (titleController.text.trim().isEmpty ||
        objectiveController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Renseigne au moins le nom et l’objectif du projet.',
          ),
        ),
      );
      return;
    }

    widget.controller.rewardProject();
    setState(() => saved = true);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Structure enregistrée'),
        content: Text(
          '« ${titleController.text.trim()} » possède maintenant un objectif et un workflow de ${widget.template.steps.length} étapes. +20 XP',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }
}
