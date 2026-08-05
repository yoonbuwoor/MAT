import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/brand_widgets.dart';

class QuickToolsScreen extends StatefulWidget {
  const QuickToolsScreen({super.key});

  @override
  State<QuickToolsScreen> createState() => _QuickToolsScreenState();
}

class _QuickToolsScreenState extends State<QuickToolsScreen> {
  final ddController = TextEditingController();
  final mapDistanceController = TextEditingController();
  final scaleController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
        children: [
          const PurposePanel(
            icon: Icons.calculate_outlined,
            title: 'À quoi servent ces outils ?',
            description:
                'À vérifier rapidement un calcul simple. Ils ne remplacent pas le contrôle dans un logiciel SIG ni une méthode de mesure professionnelle.',
            steps: ['Saisir', 'Calculer', 'Vérifier l’unité'],
            color: AppTheme.purple,
          ),
          const SizedBox(height: 18),
          _ToolCard(
            number: '01',
            title: 'Degrés décimaux vers DMS',
            usage:
                'Utile pour présenter une latitude ou une longitude sous la forme degrés, minutes et secondes.',
            icon: Icons.explore_outlined,
            child: Column(
              children: [
                TextField(
                  controller: ddController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valeur en degrés décimaux',
                    hintText: 'Ex. 14.7167',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _convertToDms,
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: const Text('Convertir en DMS'),
                  ),
                ),
                if (dmsResult.isNotEmpty) _ResultBox(text: dmsResult),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ToolCard(
            number: '02',
            title: 'Distance réelle selon l’échelle',
            usage:
                'Utile pour estimer au sol une distance mesurée en centimètres sur une carte papier.',
            icon: Icons.straighten_rounded,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mapDistanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Distance sur la carte',
                          hintText: 'Ex. 5',
                          suffixText: 'cm',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: scaleController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Dénominateur',
                          hintText: 'Ex. 50000',
                          prefixText: '1 : ',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _calculateDistance,
                    icon: const Icon(Icons.route_outlined),
                    label: const Text('Calculer la distance réelle'),
                  ),
                ),
                if (distanceResult.isNotEmpty)
                  _ResultBox(text: distanceResult),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ToolCard(
            number: '03',
            title: 'Superficie rectangulaire',
            usage:
                'Utile pour un contrôle rapide lorsqu’une zone peut être approximée par un rectangle. Pour une vraie parcelle, utilise sa géométrie.',
            icon: Icons.crop_square_rounded,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: lengthController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Longueur',
                          hintText: 'Ex. 120',
                          suffixText: 'm',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Largeur',
                          hintText: 'Ex. 80',
                          suffixText: 'm',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _calculateArea,
                    icon: const Icon(Icons.square_foot_rounded),
                    label: const Text('Calculer la superficie'),
                  ),
                ),
                if (areaResult.isNotEmpty) _ResultBox(text: areaResult),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _convertToDms() {
    final value = double.tryParse(ddController.text.replaceAll(',', '.'));
    if (value == null) {
      _showError('Saisis une valeur numérique, par exemple 14.7167.');
      return;
    }

    final absolute = value.abs();
    final degrees = absolute.floor();
    final minuteDecimal = (absolute - degrees) * 60;
    final minutes = minuteDecimal.floor();
    final seconds = (minuteDecimal - minutes) * 60;
    final sign = value < 0 ? '-' : '';

    setState(() {
      dmsResult =
          '$sign$degrees° $minutes′ ${seconds.toStringAsFixed(2)}″';
    });
  }

  void _calculateDistance() {
    final cm = double.tryParse(
      mapDistanceController.text.replaceAll(',', '.'),
    );
    final scale = double.tryParse(scaleController.text.replaceAll(',', '.'));
    if (cm == null || scale == null || cm < 0 || scale <= 0) {
      _showError('Saisis une distance et une échelle valides.');
      return;
    }

    final meters = cm * scale / 100;
    setState(() {
      distanceResult = meters >= 1000
          ? '${(meters / 1000).toStringAsFixed(2)} km'
          : '${meters.toStringAsFixed(2)} m';
    });
  }

  void _calculateArea() {
    final length = double.tryParse(lengthController.text.replaceAll(',', '.'));
    final width = double.tryParse(widthController.text.replaceAll(',', '.'));
    if (length == null || width == null || length < 0 || width < 0) {
      _showError('Saisis une longueur et une largeur valides.');
      return;
    }

    final squareMeters = length * width;
    final hectares = squareMeters / 10000;
    setState(() {
      areaResult =
          '${_formatNumber(squareMeters)} m²  •  ${hectares.toStringAsFixed(4)} ha';
    });
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    final decimals = math.min(2, 6);
    return value.toStringAsFixed(decimals);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.number,
    required this.title,
    required this.usage,
    required this.icon,
    required this.child,
  });

  final String number;
  final String title;
  final String usage;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIcon(icon: icon, color: AppTheme.coral),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OUTIL $number',
                        style: const TextStyle(
                          color: AppTheme.coral,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(title,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppTheme.coral.withOpacity(.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Quand l’utiliser ? $usage',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(height: 17),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.teal.withOpacity(.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.teal.withOpacity(.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
