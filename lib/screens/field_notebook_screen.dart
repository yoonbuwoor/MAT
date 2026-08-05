import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';

class FieldNotebookScreen extends StatelessWidget {
  const FieldNotebookScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carnet de terrain'),
        actions: [
          IconButton(
            tooltip: 'Copier en CSV',
            onPressed: controller.observations.isEmpty
                ? null
                : () {
                    final buffer = StringBuffer('nom,categorie,note,latitude,longitude,date\n');
                    for (final item in controller.observations) {
                      String safe(String value) => '"${value.replaceAll('"', '""')}"';
                      buffer.writeln(
                        '${safe(item.name)},${safe(item.category)},${safe(item.note)},${item.latitude},${item.longitude},${item.createdAt.toIso8601String()}',
                      );
                    }
                    Clipboard.setData(ClipboardData(text: buffer.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Données CSV copiées dans le presse-papiers.')),
                    );
                  },
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => _ObservationForm(controller: controller),
        ),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Ajouter'),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.observations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_location_alt_outlined, size: 74, color: AppTheme.coral.withOpacity(.7)),
                    const SizedBox(height: 18),
                    const Text(
                      'Aucune observation',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enregistre un point, une catégorie, des coordonnées et une note de terrain.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            itemCount: controller.observations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = controller.observations[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppTheme.coral,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.place),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 3),
                            Text(item.category, style: const TextStyle(color: AppTheme.coral, fontWeight: FontWeight.w700)),
                            if (item.note.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(item.note),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              '${item.latitude.toStringAsFixed(6)}, ${item.longitude.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ObservationForm extends StatefulWidget {
  const _ObservationForm({required this.controller});

  final AppController controller;

  @override
  State<_ObservationForm> createState() => _ObservationFormState();
}

class _ObservationFormState extends State<_ObservationForm> {
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final latitudeController = TextEditingController(text: '14.716677');
  final longitudeController = TextEditingController(text: '-17.467686');
  String category = 'Observation';

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(.35), borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 18),
            Text('Nouvelle observation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom de l’observation')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Catégorie'),
              items: const [
                DropdownMenuItem(value: 'Observation', child: Text('Observation')),
                DropdownMenuItem(value: 'Équipement', child: Text('Équipement')),
                DropdownMenuItem(value: 'Environnement', child: Text('Environnement')),
                DropdownMenuItem(value: 'Infrastructure', child: Text('Infrastructure')),
                DropdownMenuItem(value: 'Anomalie', child: Text('Anomalie')),
              ],
              onChanged: (value) => setState(() => category = value ?? category),
            ),
            const SizedBox(height: 10),
            TextField(controller: noteController, maxLines: 3, decoration: const InputDecoration(labelText: 'Note de terrain')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Latitude'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Longitude'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Enregistrer l’observation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final lat = double.tryParse(latitudeController.text.replaceAll(',', '.'));
    final lon = double.tryParse(longitudeController.text.replaceAll(',', '.'));
    if (nameController.text.trim().isEmpty || lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Renseigne un nom et des coordonnées valides.')),
      );
      return;
    }
    widget.controller.addObservation(
      FieldObservation(
        name: nameController.text.trim(),
        category: category,
        note: noteController.text.trim(),
        latitude: lat,
        longitude: lon,
        createdAt: DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }
}
