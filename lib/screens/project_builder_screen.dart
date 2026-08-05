import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';

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

  @override
  void dispose() {
    titleController.dispose();
    objectiveController.dispose();
    zoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.template.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.purple.withOpacity(.10),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Icon(widget.template.icon, color: AppTheme.purple, size: 42),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Construire mon projet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(widget.template.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Nom du projet',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: objectiveController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Objectif principal',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.flag_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: zoneController,
            decoration: const InputDecoration(
              labelText: 'Zone d’étude',
              prefixIcon: Icon(Icons.place_outlined),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Workflow recommandé',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(widget.template.steps.length, (index) {
            final done = doneSteps.contains(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: CheckboxListTile(
                  value: done,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        doneSteps.add(index);
                      } else {
                        doneSteps.remove(index);
                      }
                    });
                  },
                  secondary: CircleAvatar(
                    backgroundColor: AppTheme.coral.withOpacity(.12),
                    foregroundColor: AppTheme.coral,
                    child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  title: Text(widget.template.steps[index]),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              if (titleController.text.trim().isEmpty || objectiveController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Renseigne au moins le nom et l’objectif du projet.')),
                );
                return;
              }
              widget.controller.rewardProject();
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Projet préparé'),
                  content: Text(
                    '« ${titleController.text.trim()} » dispose maintenant d’un objectif, d’une zone et d’un workflow de ${widget.template.steps.length} étapes.',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continuer'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Enregistrer la structure'),
          ),
        ],
      ),
    );
  }
}
