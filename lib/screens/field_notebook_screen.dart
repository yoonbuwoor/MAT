import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';

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
            tooltip: 'Copier les observations en CSV',
            onPressed: controller.observations.isEmpty
                ? null
                : () async {
                    await Clipboard.setData(
                      ClipboardData(text: _buildCsv(controller.observations)),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Les observations CSV ont été copiées dans le presse-papiers.',
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.ink,
        foregroundColor: Colors.white,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => _ObservationForm(controller: controller),
        ),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text(
          'Nouvelle note',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          const PurposePanel(
            icon: Icons.location_on_outlined,
            title: 'À quoi sert ce carnet ?',
            description:
                'À enregistrer manuellement une observation avec son nom, sa catégorie, ses coordonnées et une note. Il ne récupère pas encore automatiquement le GPS du téléphone.',
            steps: ['Observer', 'Saisir les coordonnées', 'Exporter en CSV'],
            color: AppTheme.teal,
          ),
          const SizedBox(height: 20),
          if (controller.observations.isEmpty)
            EmptyStateCard(
              icon: Icons.pin_drop_outlined,
              title: 'Aucune observation enregistrée',
              message:
                  'Ajoute ton premier point terrain. Les champs sont vides pour éviter toute donnée fictive.',
              action: FilledButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => _ObservationForm(controller: controller),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Créer la première note'),
              ),
            )
          else ...[
            SectionTitle(
              title: '${controller.observations.length} observation(s)',
              subtitle:
                  'Appuie sur l’icône d’export pour copier un fichier CSV.',
            ),
            const SizedBox(height: 14),
            ...controller.observations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ObservationCard(item: item),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildCsv(List<FieldObservation> observations) {
    final rows = <String>[
      'nom,categorie,note,latitude,longitude,date',
      ...observations.map((item) {
        String escape(String value) => '"${value.replaceAll('"', '""')}"';
        return [
          escape(item.name),
          escape(item.category),
          escape(item.note),
          item.latitude,
          item.longitude,
          item.createdAt.toIso8601String(),
        ].join(',');
      }),
    ];
    return rows.join('\n');
  }
}

class _ObservationCard extends StatelessWidget {
  const _ObservationCard({required this.item});

  final FieldObservation item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(
              icon: Icons.place_rounded,
              color: AppTheme.teal,
              size: 50,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        item.category,
                        style: const TextStyle(
                          color: AppTheme.teal,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  if (item.note.trim().isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(item.note),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    '${item.latitude.toStringAsFixed(6)}, ${item.longitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(item.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} à ${two(date.hour)}:${two(date.minute)}';
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
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nouvelle observation',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Saisis uniquement ce que tu as réellement observé sur le terrain.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l’observation',
                hintText: 'Ex. Caniveau obstrué',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(labelText: 'Catégorie'),
              items: const [
                DropdownMenuItem(
                    value: 'Observation', child: Text('Observation générale')),
                DropdownMenuItem(
                    value: 'Équipement', child: Text('Équipement')),
                DropdownMenuItem(
                    value: 'Environnement', child: Text('Environnement')),
                DropdownMenuItem(
                    value: 'Infrastructure', child: Text('Infrastructure')),
                DropdownMenuItem(value: 'Anomalie', child: Text('Anomalie')),
              ],
              onChanged: (value) => setState(
                () => category = value ?? 'Observation',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Décris ce que tu vois et le contexte.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: 'Ex. 14.7167',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: 'Ex. -17.4677',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
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
    final latitude = double.tryParse(
      latitudeController.text.replaceAll(',', '.'),
    );
    final longitude = double.tryParse(
      longitudeController.text.replaceAll(',', '.'),
    );
    final name = nameController.text.trim();

    if (name.isEmpty ||
        latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Renseigne un nom et des coordonnées valides.',
          ),
        ),
      );
      return;
    }

    widget.controller.addObservation(
      FieldObservation(
        name: name,
        category: category,
        note: noteController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
      ),
    );
    Navigator.of(context).pop();
  }
}
