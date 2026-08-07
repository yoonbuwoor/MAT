import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/geo_models.dart';
import '../services/location_service.dart';
import '../widgets/brand_widgets.dart';

enum _TargetMode { savedPoint, manual, current }

class GeocachingScreen extends StatefulWidget {
  const GeocachingScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<GeocachingScreen> createState() => _GeocachingScreenState();
}

class _GeocachingScreenState extends State<GeocachingScreen> {
  final _titleController = TextEditingController(text: 'Le point secret');
  final _clueController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  _TargetMode _mode = _TargetMode.savedPoint;
  CapturedPoint? _selectedPoint;
  Position? _capturedTarget;
  GeocacheChallenge? _challenge;
  StreamSubscription<Position>? _subscription;
  Position? _hunterPosition;
  double _radius = 100;
  double? _distance;
  double? _bearing;
  bool _creatingTarget = false;
  bool _hunting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.controller.geoPoints.isNotEmpty) {
      _selectedPoint = widget.controller.geoPoints.first;
    } else {
      _mode = _TargetMode.manual;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _titleController.dispose();
    _clueController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _captureTarget() async {
    setState(() {
      _creatingTarget = true;
      _error = null;
    });
    try {
      final position = await LocationService.currentPosition();
      if (!mounted) return;
      setState(() => _capturedTarget = position);
    } on LocationServiceException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Impossible de capturer le point secret.');
    } finally {
      if (mounted) setState(() => _creatingTarget = false);
    }
  }

  void _createChallenge() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Donne un nom au défi.');
      return;
    }

    double? latitude;
    double? longitude;

    switch (_mode) {
      case _TargetMode.savedPoint:
        latitude = _selectedPoint?.latitude;
        longitude = _selectedPoint?.longitude;
        break;
      case _TargetMode.manual:
        latitude = double.tryParse(
          _latitudeController.text.trim().replaceAll(',', '.'),
        );
        longitude = double.tryParse(
          _longitudeController.text.trim().replaceAll(',', '.'),
        );
        break;
      case _TargetMode.current:
        latitude = _capturedTarget?.latitude;
        longitude = _capturedTarget?.longitude;
        break;
    }

    if (latitude == null || longitude == null) {
      setState(() => _error = 'Définis correctement le point secret.');
      return;
    }
    if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
      setState(() => _error = 'Les coordonnées du point secret sont invalides.');
      return;
    }

    setState(() {
      _challenge = GeocacheChallenge(
        title: title,
        latitude: latitude!,
        longitude: longitude!,
        radius: _radius,
        clue: _clueController.text.trim(),
      );
      _error = null;
      _distance = null;
      _bearing = null;
      _hunterPosition = null;
    });
  }

  Future<void> _startHunt() async {
    final challenge = _challenge;
    if (challenge == null) return;

    setState(() {
      _hunting = true;
      _error = null;
    });

    try {
      final current = await LocationService.currentPosition();
      _updateHunter(current);
      await _subscription?.cancel();
      _subscription = LocationService.positionStream().listen(
        _updateHunter,
        onError: (_) {
          if (mounted) {
            setState(() => _error = 'Le suivi GPS a été interrompu.');
          }
        },
      );
    } on LocationServiceException catch (error) {
      if (!mounted) return;
      setState(() {
        _hunting = false;
        _error = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hunting = false;
        _error = 'Impossible de démarrer la chasse.';
      });
    }
  }

  void _updateHunter(Position position) {
    final challenge = _challenge;
    if (challenge == null || !mounted) return;

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      challenge.latitude,
      challenge.longitude,
    );
    final bearing = Geolocator.bearingBetween(
      position.latitude,
      position.longitude,
      challenge.latitude,
      challenge.longitude,
    );

    setState(() {
      _hunterPosition = position;
      _distance = distance;
      _bearing = bearing < 0 ? bearing + 360 : bearing;
    });
  }

  Future<void> _stopHunt() async {
    await _subscription?.cancel();
    _subscription = null;
    if (mounted) setState(() => _hunting = false);
  }

  Future<void> _resetChallenge() async {
    await _stopHunt();
    if (!mounted) return;
    setState(() {
      _challenge = null;
      _distance = null;
      _bearing = null;
      _hunterPosition = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final challenge = _challenge;

    return Scaffold(
      appBar: AppBar(title: const Text('GéoChasse')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          const PurposePanel(
            icon: Icons.radar_rounded,
            title: 'Un géocaching simple et créatif',
            description:
                'Une personne définit un point secret et un rayon de réussite. Le joueur suit la distance, le cap et l’indicateur chaud-froid sans voir les coordonnées du but.',
            steps: ['Cacher', 'Chercher', 'Entrer dans le rayon'],
            color: AppTheme.coral,
          ),
          const SizedBox(height: 20),
          if (challenge == null)
            _buildCreator(context)
          else
            _buildHunt(context, challenge),
        ],
      ),
    );
  }

  Widget _buildCreator(BuildContext context) {
    final points = widget.controller.geoPoints;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1. Préparer le point secret',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Le rayon est de 100 m par défaut et ne peut jamais dépasser 500 m.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Nom du défi',
            prefixIcon: Icon(Icons.flag_outlined),
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<_TargetMode>(
          segments: const [
            ButtonSegment(
              value: _TargetMode.savedPoint,
              icon: Icon(Icons.bookmark_rounded),
              label: Text('Point'),
            ),
            ButtonSegment(
              value: _TargetMode.manual,
              icon: Icon(Icons.edit_location_alt_outlined),
              label: Text('Manuel'),
            ),
            ButtonSegment(
              value: _TargetMode.current,
              icon: Icon(Icons.my_location_rounded),
              label: Text('Ici'),
            ),
          ],
          selected: <_TargetMode>{_mode},
          onSelectionChanged: (values) {
            final value = values.first;
            if (value == _TargetMode.savedPoint && points.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enregistre d’abord un point terrain.'),
                ),
              );
              return;
            }
            setState(() => _mode = value);
          },
        ),
        const SizedBox(height: 14),
        if (_mode == _TargetMode.savedPoint)
          DropdownButtonFormField<CapturedPoint>(
            value: _selectedPoint,
            decoration: const InputDecoration(
              labelText: 'Point enregistré à retrouver',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            items: points
                .map(
                  (point) => DropdownMenuItem(
                    value: point,
                    child: Text(point.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedPoint = value),
          )
        else if (_mode == _TargetMode.manual)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _longitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Longitude X',
                    hintText: '-17.45',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _latitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Latitude Y',
                    hintText: '14.69',
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.teal.withOpacity(.09),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _capturedTarget == null
                        ? 'Place-toi au point à cacher puis enregistre sa position.'
                        : 'Point secret capturé avec une précision de ±${_capturedTarget!.accuracy.toStringAsFixed(1)} m.',
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  tooltip: 'Capturer ce lieu',
                  onPressed: _creatingTarget ? null : _captureTarget,
                  icon: _creatingTarget
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.gps_fixed_rounded),
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppTheme.ink.withOpacity(.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.adjust_rounded, color: AppTheme.coral),
                  const SizedBox(width: 10),
                  Text('Rayon de réussite',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Text(
                    '${_radius.round()} m',
                    style: const TextStyle(
                      color: AppTheme.coral,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _radius,
                min: 20,
                max: 500,
                divisions: 24,
                label: '${_radius.round()} m',
                onChanged: (value) => setState(() => _radius = value),
              ),
              const Text(
                'Le joueur gagne dès qu’il entre dans ce rayon autour du point secret.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _clueController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Indice facultatif',
            hintText: 'Ex. Regarde près du grand arbre, sans quitter le chemin.',
            prefixIcon: Icon(Icons.lightbulb_outline_rounded),
          ),
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
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _createChallenge,
            icon: const Icon(Icons.lock_rounded),
            label: const Text('CRÉER LE POINT SECRET'),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Sécurité : ne place pas un défi sur une route, dans une propriété privée, dans l’eau ou dans une zone dangereuse.',
          style: TextStyle(
            color: AppTheme.muted,
            fontSize: 11.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildHunt(BuildContext context, GeocacheChallenge challenge) {
    final distance = _distance;
    final found = distance != null && distance <= challenge.radius;
    final status = _status(distance, challenge.radius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.coral.withOpacity(.18),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'COORDONNÉES MASQUÉES',
                      style: TextStyle(
                        color: AppTheme.orange,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Modifier le défi',
                    color: Colors.white,
                    onPressed: _resetChallenge,
                    icon: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                challenge.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Entre dans un rayon de ${challenge.radius.round()} m pour gagner.',
                style: TextStyle(color: Colors.white.withOpacity(.68)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: found
                ? AppTheme.teal.withOpacity(.12)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: found
                  ? AppTheme.teal.withOpacity(.35)
                  : AppTheme.ink.withOpacity(.06),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 230,
                height: 230,
                child: CustomPaint(
                  painter: _RadarPainter(
                    distance: distance,
                    radius: challenge.radius,
                    bearing: _bearing,
                    found: found,
                    dark: Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                found
                    ? 'CACHE TROUVÉE !'
                    : distance == null
                        ? 'PRÊT POUR LA CHASSE'
                        : '${distance.round()} MÈTRES',
                style: TextStyle(
                  color: found ? AppTheme.teal : AppTheme.coral,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                found
                    ? 'Tu es entré dans le rayon défini.'
                    : status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (_bearing != null && !found) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.coral.withOpacity(.09),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Cap indicatif : ${_bearing!.round()}°',
                    style: const TextStyle(
                      color: AppTheme.coral,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (found && challenge.clue.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.orange.withOpacity(.11),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text('Indice final : ${challenge.clue}'),
          ),
        ],
        if (_hunterPosition != null) ...[
          const SizedBox(height: 12),
          Text(
            'Précision GPS actuelle : ±${_hunterPosition!.accuracy.toStringAsFixed(1)} m',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
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
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: found
                ? _resetChallenge
                : (_hunting ? _stopHunt : _startHunt),
            icon: Icon(
              found
                  ? Icons.replay_rounded
                  : _hunting
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
            ),
            label: Text(
              found
                  ? 'CRÉER UNE NOUVELLE CHASSE'
                  : _hunting
                      ? 'METTRE EN PAUSE'
                      : 'COMMENCER LA CHASSE',
            ),
          ),
        ),
      ],
    );
  }

  String _status(double? distance, double radius) {
    if (distance == null) return 'Le GPS affichera la distance et le cap.';
    if (distance <= radius) return 'Trouvé';
    if (distance <= radius * 1.5) return 'Brûlant : le point est tout proche.';
    if (distance <= radius * 3) return 'Très chaud : continue dans cette direction.';
    if (distance <= radius * 6) return 'Tu chauffes : la distance diminue.';
    return 'Encore loin : suis le cap et surveille la précision GPS.';
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.distance,
    required this.radius,
    required this.bearing,
    required this.found,
    required this.dark,
  });

  final double? distance;
  final double radius;
  final double? bearing;
  final bool found;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2 - 12;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = (dark ? Colors.white : AppTheme.ink).withOpacity(.12);

    for (final factor in <double>[.25, .5, .75, 1]) {
      canvas.drawCircle(center, maxRadius * factor, ringPaint);
    }

    final axesPaint = Paint()
      ..strokeWidth = 1
      ..color = (dark ? Colors.white : AppTheme.ink).withOpacity(.08);
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      axesPaint,
    );
    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      axesPaint,
    );

    final labelPainter = TextPainter(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: dark ? Colors.white70 : AppTheme.muted,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset(center.dx - labelPainter.width / 2, 2),
    );

    final centerPaint = Paint()..color = AppTheme.teal;
    canvas.drawCircle(center, 7, centerPaint);
    canvas.drawCircle(
      center,
      13,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppTheme.teal.withOpacity(.25),
    );

    if (distance == null || bearing == null) return;

    final ratio = (distance! / (radius * 6)).clamp(0.0, 1.0).toDouble();
    final angle = (bearing! - 90) * math.pi / 180;
    final pointRadius = found ? 0.0 : math.max(25.0, maxRadius * ratio);
    final target = Offset(
      center.dx + math.cos(angle) * pointRadius,
      center.dy + math.sin(angle) * pointRadius,
    );

    canvas.drawLine(
      center,
      target,
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = AppTheme.coral.withOpacity(.42),
    );
    canvas.drawCircle(
      target,
      found ? 18 : 11,
      Paint()..color = found ? AppTheme.teal : AppTheme.coral,
    );
    canvas.drawCircle(
      target,
      found ? 29 : 19,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = (found ? AppTheme.teal : AppTheme.coral).withOpacity(.22),
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.distance != distance ||
        oldDelegate.radius != radius ||
        oldDelegate.bearing != bearing ||
        oldDelegate.found != found ||
        oldDelegate.dark != dark;
  }
}
