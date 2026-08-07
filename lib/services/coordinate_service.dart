import 'dart:math' as math;
import '../models/geo_models.dart';

class CoordinatePresentation {
  const CoordinatePresentation({
    required this.system,
    required this.xLabel,
    required this.yLabel,
    required this.x,
    required this.y,
    this.detail = '',
  });

  final String system;
  final String xLabel;
  final String yLabel;
  final String x;
  final String y;
  final String detail;
}

class CoordinateService {
  static const double _a = 6378137.0;
  static const double _f = 1 / 298.257223563;

  static CoordinatePresentation present({
    required double latitude,
    required double longitude,
    required CoordinateFormat format,
  }) {
    switch (format) {
      case CoordinateFormat.wgs84Decimal:
        return CoordinatePresentation(
          system: 'WGS 84 — EPSG:4326',
          xLabel: 'X — Longitude',
          yLabel: 'Y — Latitude',
          x: longitude.toStringAsFixed(7),
          y: latitude.toStringAsFixed(7),
          detail: 'Unités : degrés décimaux',
        );
      case CoordinateFormat.wgs84Dms:
        return CoordinatePresentation(
          system: 'WGS 84 — DMS',
          xLabel: 'X — Longitude',
          yLabel: 'Y — Latitude',
          x: _toDms(longitude, isLatitude: false),
          y: _toDms(latitude, isLatitude: true),
          detail: 'Degrés, minutes et secondes',
        );
      case CoordinateFormat.utmAuto:
        final utm = _toUtm(latitude, longitude);
        return CoordinatePresentation(
          system: 'WGS 84 / UTM zone ${utm.zone}${utm.hemisphere}',
          xLabel: 'X — Est (Easting)',
          yLabel: 'Y — Nord (Northing)',
          x: utm.easting.toStringAsFixed(3),
          y: utm.northing.toStringAsFixed(3),
          detail: 'EPSG:${utm.epsg} • unités : mètres',
        );
      case CoordinateFormat.webMercator:
        final mercator = _toWebMercator(latitude, longitude);
        return CoordinatePresentation(
          system: 'WGS 84 / Pseudo-Mercator — EPSG:3857',
          xLabel: 'X — Est',
          yLabel: 'Y — Nord',
          x: mercator.$1.toStringAsFixed(3),
          y: mercator.$2.toStringAsFixed(3),
          detail: 'Unités : mètres • surtout utilisé pour les cartes web',
        );
    }
  }

  static String _toDms(double value, {required bool isLatitude}) {
    final direction = isLatitude
        ? (value >= 0 ? 'N' : 'S')
        : (value >= 0 ? 'E' : 'O');
    final absolute = value.abs();
    final degrees = absolute.floor();
    final minutesFull = (absolute - degrees) * 60;
    final minutes = minutesFull.floor();
    final seconds = (minutesFull - minutes) * 60;
    return '$degrees° ${minutes.toString().padLeft(2, '0')}′ '
        '${seconds.toStringAsFixed(3).padLeft(6, '0')}″ $direction';
  }

  static (double, double) _toWebMercator(double latitude, double longitude) {
    final safeLatitude = latitude.clamp(-85.05112878, 85.05112878).toDouble();
    final x = _a * _degreesToRadians(longitude);
    final y = _a * math.log(
      math.tan(math.pi / 4 + _degreesToRadians(safeLatitude) / 2),
    );
    return (x, y);
  }

  static _UtmResult _toUtm(double latitude, double longitude) {
    final zone = (((longitude + 180) / 6).floor() + 1).clamp(1, 60).toInt();
    final longitudeOrigin = (zone - 1) * 6 - 180 + 3;
    final latitudeRad = _degreesToRadians(latitude);
    final longitudeRad = _degreesToRadians(longitude);
    final originRad = _degreesToRadians(longitudeOrigin.toDouble());

    final eccentricitySquared = _f * (2 - _f);
    final secondEccentricitySquared =
        eccentricitySquared / (1 - eccentricitySquared);
    const scaleFactor = 0.9996;

    final sinLat = math.sin(latitudeRad);
    final cosLat = math.cos(latitudeRad);
    final tanLat = math.tan(latitudeRad);

    final n = _a / math.sqrt(1 - eccentricitySquared * sinLat * sinLat);
    final t = tanLat * tanLat;
    final c = secondEccentricitySquared * cosLat * cosLat;
    final aTerm = cosLat * (longitudeRad - originRad);

    final e2 = eccentricitySquared;
    final meridionalArc = _a *
        ((1 - e2 / 4 - 3 * e2 * e2 / 64 - 5 * e2 * e2 * e2 / 256) *
                latitudeRad -
            (3 * e2 / 8 + 3 * e2 * e2 / 32 + 45 * e2 * e2 * e2 / 1024) *
                math.sin(2 * latitudeRad) +
            (15 * e2 * e2 / 256 + 45 * e2 * e2 * e2 / 1024) *
                math.sin(4 * latitudeRad) -
            (35 * e2 * e2 * e2 / 3072) * math.sin(6 * latitudeRad));

    final easting = (scaleFactor *
            n *
            (aTerm +
                (1 - t + c) * math.pow(aTerm, 3) / 6 +
                (5 - 18 * t + t * t + 72 * c - 58 * secondEccentricitySquared) *
                    math.pow(aTerm, 5) /
                    120) +
        500000).toDouble();

    var northing = (scaleFactor *
        (meridionalArc +
            n *
                tanLat *
                (aTerm * aTerm / 2 +
                    (5 - t + 9 * c + 4 * c * c) * math.pow(aTerm, 4) / 24 +
                    (61 -
                            58 * t +
                            t * t +
                            600 * c -
                            330 * secondEccentricitySquared) *
                        math.pow(aTerm, 6) /
                        720))).toDouble();

    final northern = latitude >= 0;
    if (!northern) northing += 10000000;

    return _UtmResult(
      zone: zone,
      hemisphere: northern ? 'N' : 'S',
      easting: easting,
      northing: northing,
      epsg: (northern ? 32600 : 32700) + zone,
    );
  }

  static double _degreesToRadians(double value) => value * math.pi / 180;
}

class _UtmResult {
  const _UtmResult({
    required this.zone,
    required this.hemisphere,
    required this.easting,
    required this.northing,
    required this.epsg,
  });

  final int zone;
  final String hemisphere;
  final double easting;
  final double northing;
  final int epsg;
}
