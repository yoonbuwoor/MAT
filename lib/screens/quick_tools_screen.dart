import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class QuickToolsScreen extends StatefulWidget {
  const QuickToolsScreen({super.key});

  @override
  State<QuickToolsScreen> createState() => _QuickToolsScreenState();
}

class _QuickToolsScreenState extends State<QuickToolsScreen> {
  final ddController = TextEditingController(text: '14.7167');
  final mapDistanceController = TextEditingController(text: '5');
  final scaleController = TextEditingController(text: '50000');
  final lengthController = TextEditingController(text: '120');
  final widthController = TextEditingController(text: '80');

  String dmsResult = '';
  String distanceResult = '';
  String areaResult = '';

  @override
  void dispose() {
    ddController.dispose();
    mapDistanceController.dispose();
    scaleController.dispose();
    lengthController.dispose();
    widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outils rapides')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _ToolCard(
            title: 'Degrés décimaux vers DMS',
            subtitle: 'Convertir une latitude ou une longitude.',
            icon: Icons.explore_outlined,
            child: Column(
              children: [
                TextField(
                  controller: ddController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(labelText: 'Valeur en degrés décimaux'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _convertToDms,
                    child: const Text('Convertir'),
                  ),
                ),
                if (dmsResult.isNotEmpty) _ResultBox(text: dmsResult),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ToolCard(
            title: 'Distance réelle selon l’échelle',
            subtitle: 'Exemple : 5 cm sur une carte au 1:50 000.',
            icon: Icons.straighten,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mapDistanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Distance carte (cm)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: scaleController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Dénominateur'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _calculateDistance,
                    child: const Text('Calculer'),
                  ),
                ),
                if (distanceResult.isNotEmpty) _ResultBox(text: distanceResult),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ToolCard(
            title: 'Surface rectangulaire',
            subtitle: 'Calcul rapide en m² et hectares.',
            icon: Icons.crop_square,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: lengthController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Longueur (m)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Largeur (m)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _calculateArea,
                    child: const Text('Calculer'),
                  ),
                ),
                if (areaResult.isNotEmpty) _ResultBox(text: areaResult),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.purple.withOpacity(.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppTheme.purple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ces outils servent à la vérification rapide. Pour une étude officielle, documente les unités, la projection et la précision des données.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _convertToDms() {
    final value = double.tryParse(ddController.text.replaceAll(',', '.'));
    if (value == null) return _showError();
    final absolute = value.abs();
    final degrees = absolute.floor();
    final minutesFull = (absolute - degrees) * 60;
    final minutes = minutesFull.floor();
    final seconds = (minutesFull - minutes) * 60;
    final sign = value < 0 ? '−' : '';
    setState(() => dmsResult = '$sign$degrees° $minutes′ ${seconds.toStringAsFixed(2)}″');
  }

  void _calculateDistance() {
    final mapCm = double.tryParse(mapDistanceController.text.replaceAll(',', '.'));
    final scale = double.tryParse(scaleController.text.replaceAll(' ', ''));
    if (mapCm == null || scale == null || scale <= 0) return _showError();
    final meters = mapCm * scale / 100;
    final km = meters / 1000;
    setState(() {
      distanceResult = km >= 1
          ? '${km.toStringAsFixed(2)} km (${meters.toStringAsFixed(0)} m)'
          : '${meters.toStringAsFixed(2)} m';
    });
  }

  void _calculateArea() {
    final length = double.tryParse(lengthController.text.replaceAll(',', '.'));
    final width = double.tryParse(widthController.text.replaceAll(',', '.'));
    if (length == null || width == null || length < 0 || width < 0) return _showError();
    final squareMeters = math.max(0, length * width);
    final hectares = squareMeters / 10000;
    setState(() => areaResult = '${squareMeters.toStringAsFixed(2)} m² — ${hectares.toStringAsFixed(4)} ha');
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saisis des valeurs numériques valides.')),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.coral.withOpacity(.12),
                  foregroundColor: AppTheme.coral,
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.09),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
    );
  }
}
