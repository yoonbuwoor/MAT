import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_theme.dart';
import '../models/geo_models.dart';
import '../services/coordinate_service.dart';
import '../services/location_service.dart';
import '../widgets/brand_widgets.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  CoordinateFormat _format = CoordinateFormat.wgs84Decimal;
  Position? _position;
  bool _loading = false;
  String? _error;

  Future<void> _locate() async {
    setState(() {
      _loading = true;
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
      setState(() => _error =
          'Impossible d’obtenir la position. Place-toi à l’extérieur et réessaie.');
    } finally {
      if (mounted) setState(() => _loading = false);
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
      appBar: AppBar(title: const Text('Ma localisation')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const PurposePanel(
            icon: Icons.my_location_rounded,
            title: 'Ce que fait cet outil',
            description:
                'Il lit la position GPS du téléphone puis convertit la même position dans le type de coordonnées choisi. X correspond à l’axe Est-Ouest et Y à l’axe Nord-Sud.',
            steps: ['Choisir le système', 'Activer le GPS', 'Lire X et Y'],
            color: AppTheme.teal,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<CoordinateFormat>(
            value: _format,
            decoration: const InputDecoration(
              labelText: 'Type de coordonnées',
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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _locate,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.gps_fixed_rounded),
              label: Text(_loading ? 'RECHERCHE DU SIGNAL…' : 'AFFICHER MA POSITION'),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _ErrorPanel(message: _error!),
          ],
          if (displayed != null && position != null) ...[
            const SizedBox(height: 22),
            _PositionPanel(displayed: displayed, position: position),
          ],
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.orange.withOpacity(.10),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppTheme.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'La précision d’un téléphone varie selon le ciel, les bâtiments et le matériel. N’utilise pas ce résultat pour une implantation cadastrale ou un travail centimétrique.',
                    style: TextStyle(fontSize: 12.5, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionPanel extends StatelessWidget {
  const _PositionPanel({required this.displayed, required this.position});

  final CoordinatePresentation displayed;
  final Position position;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppTheme.teal),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayed.system,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _CoordinateValue(label: displayed.xLabel, value: displayed.x),
          const SizedBox(height: 12),
          _CoordinateValue(label: displayed.yLabel, value: displayed.y),
          const SizedBox(height: 15),
          Text(
            displayed.detail,
            style: TextStyle(
              color: Colors.white.withOpacity(.62),
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(
                icon: Icons.gps_fixed_rounded,
                label: 'Précision ±${position.accuracy.toStringAsFixed(1)} m',
              ),
              _MetricChip(
                icon: Icons.height_rounded,
                label: 'Altitude ${position.altitude.toStringAsFixed(1)} m',
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(.22)),
              ),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: '${displayed.system}\n${displayed.xLabel}: ${displayed.x}\n'
                        '${displayed.yLabel}: ${displayed.y}\n'
                        'Précision: ±${position.accuracy.toStringAsFixed(1)} m',
                  ),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coordonnées copiées.')),
                );
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('COPIER X ET Y'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordinateValue extends StatelessWidget {
  const _CoordinateValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.orange,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 7),
          SelectableText(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.coral.withOpacity(.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.coral.withOpacity(.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: LocationService.openLocationSettings,
                child: const Text('Activer le GPS'),
              ),
              TextButton(
                onPressed: LocationService.openAppSettings,
                child: const Text('Permissions'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
