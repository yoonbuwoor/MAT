import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/geo_models.dart';
import '../services/coordinate_service.dart';
import '../services/location_service.dart';
import '../widgets/brand_widgets.dart';

class PointCaptureScreen extends StatefulWidget {
  const PointCaptureScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<PointCaptureScreen> createState() => _PointCaptureScreenState();
}

class _PointCaptureScreenState extends State<PointCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<_AttributeDraft> _attributes = <_AttributeDraft>[];

  CoordinateFormat _format = CoordinateFormat.utmAuto;
  Position? _position;
  bool _locating = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    for (final attribute in _attributes) {
      attribute.dispose();
    }
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    try {
      final position = await LocationService.currentPosition();
      if (!mounted) return;
      setState(() => _position = position);
    } on LocationServiceException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Le signal GPS n’a pas pu être obtenu.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _savePoint() async {
    if (!_formKey.currentState!.validate()) return;
    if (_position == null) {
      setState(() => _error = 'Récupère d’abord la position du point.');
      return;
    }

    final attributes = <String, String>{};
    for (final item in _attributes) {
      final key = item.keyController.text.trim();
      if (key.isNotEmpty) {
        attributes[key] = item.valueController.text.trim();
      }
    }

    setState(() => _saving = true);
    final position = _position!;
    final point = CapturedPoint(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      format: _format,
      createdAt: DateTime.now(),
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      attributes: attributes,
    );

    try {
      await widget.controller.addGeoPoint(point);
      if (!mounted) return;

      _nameController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      for (final item in _attributes) {
        item.dispose();
      }
      setState(() {
        _attributes.clear();
        _position = null;
        _saving = false;
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Point enregistré sur le téléphone.')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Le point n’a pas pu être enregistré sur le téléphone.';
      });
    }
  }

  Future<void> _export() async {
    try {
      final path = await widget.controller.exportGeoPoints();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV créé : $path')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    final displayed = position == null
        ? null
        : CoordinateService.present(
            latitude: position.latitude,
            longitude: position.longitude,
            format: _format,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relever des points'),
        actions: [
          IconButton(
            tooltip: 'Exporter en CSV',
            onPressed: widget.controller.geoPoints.isEmpty ? null : _export,
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          const PurposePanel(
            icon: Icons.add_location_alt_rounded,
            title: 'Un module de relevé GPS',
            description:
                'Donne un nom au point, relève sa position, ajoute les attributs utiles puis exporte l’ensemble en CSV. Les coordonnées WGS 84 sont toujours conservées pour éviter toute perte.',
            steps: ['Nommer', 'Localiser', 'Enregistrer'],
            color: AppTheme.purple,
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nom du point *',
                    hintText: 'Ex. Borne 01, École A, Arbre remarquable',
                    prefixIcon: Icon(Icons.label_outline_rounded),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Donne un nom au point.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    hintText: 'Ex. équipement, voirie, environnement',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description ou remarque',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CoordinateFormat>(
                  value: _format,
                  decoration: const InputDecoration(
                    labelText: 'Format X / Y enregistré',
                    prefixIcon: Icon(Icons.layers_outlined),
                  ),
                  items: CoordinateFormat.values
                      .map(
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _format = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _GpsCaptureCard(
            loading: _locating,
            position: position,
            displayed: displayed,
            onLocate: _locate,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(
                color: AppTheme.coral,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Attributs supplémentaires',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(
                  () => _attributes.add(_AttributeDraft()),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Ajouter'),
              ),
            ],
          ),
          Text(
            'Exemples : état = bon, matériau = béton, responsable = mairie.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (_attributes.isEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.ink.withOpacity(.06)),
              ),
              child: const Text(
                'Aucun attribut personnalisé. Tu peux enregistrer le point tel quel.',
              ),
            )
          else
            ...List.generate(_attributes.length, (index) {
              final item = _attributes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: item.keyController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de l’attribut',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: item.valueController,
                        decoration: const InputDecoration(
                          labelText: 'Valeur',
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Supprimer',
                      onPressed: () {
                        item.dispose();
                        setState(() => _attributes.removeAt(index));
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _savePoint,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_saving ? 'ENREGISTREMENT…' : 'ENREGISTRER LE POINT'),
            ),
          ),
          const SizedBox(height: 32),
          _SavedPointsSection(controller: widget.controller, onExport: _export),
        ],
      ),
    );
  }
}

class _GpsCaptureCard extends StatelessWidget {
  const _GpsCaptureCard({
    required this.loading,
    required this.position,
    required this.displayed,
    required this.onLocate,
  });

  final bool loading;
  final Position? position;
  final CoordinatePresentation? displayed;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gps_fixed_rounded, color: AppTheme.orange),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Position du point',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              if (position != null)
                const Icon(Icons.verified_rounded, color: AppTheme.teal),
            ],
          ),
          const SizedBox(height: 14),
          if (displayed == null)
            Text(
              'Place-toi exactement sur le point puis lance la mesure.',
              style: TextStyle(color: Colors.white.withOpacity(.68)),
            )
          else ...[
            Text(
              displayed.system,
              style: const TextStyle(color: AppTheme.orange, fontSize: 11),
            ),
            const SizedBox(height: 8),
            SelectableText(
              'X : ${displayed.x}\nY : ${displayed.y}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.55,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Précision estimée : ±${position!.accuracy.toStringAsFixed(1)} m',
              style: TextStyle(color: Colors.white.withOpacity(.64)),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(.20)),
              ),
              onPressed: loading ? null : onLocate,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(loading ? 'MESURE EN COURS…' : 'PRENDRE LA POSITION'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedPointsSection extends StatelessWidget {
  const _SavedPointsSection({required this.controller, required this.onExport});
  final AppController controller;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final points = controller.geoPoints;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Points enregistrés',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('${points.length} point(s) conservé(s) sur ce téléphone.',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (points.isNotEmpty)
              IconButton.filledTonal(
                tooltip: 'Exporter le CSV',
                onPressed: onExport,
                icon: const Icon(Icons.download_rounded),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (controller.geoPointsLoading)
          const Center(child: CircularProgressIndicator())
        else if (points.isEmpty)
          const EmptyStateCard(
            icon: Icons.location_off_outlined,
            title: 'Aucun point enregistré',
            message: 'Ton premier relevé apparaîtra ici.',
          )
        else ...[
          ...points.map(
            (point) {
              final displayed = CoordinateService.present(
                latitude: point.latitude,
                longitude: point.longitude,
                format: point.format,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SoftIcon(
                          icon: Icons.place_rounded,
                          color: AppTheme.purple,
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(point.name,
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 5),
                              Text(
                                '${displayed.xLabel}: ${displayed.x}\n'
                                '${displayed.yLabel}: ${displayed.y}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (point.category.isNotEmpty) ...[
                                const SizedBox(height: 7),
                                Text(
                                  point.category,
                                  style: const TextStyle(
                                    color: AppTheme.purple,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Supprimer',
                          onPressed: () => controller.deleteGeoPoint(point.id),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Supprimer tous les points ?'),
                    content: const Text(
                      'Exporte d’abord le CSV si tu souhaites conserver les données.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Supprimer'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) await controller.clearGeoPoints();
              },
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Tout supprimer'),
            ),
          ),
        ],
      ],
    );
  }
}

class _AttributeDraft {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}
