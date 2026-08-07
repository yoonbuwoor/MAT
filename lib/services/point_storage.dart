import 'dart:convert';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/geo_models.dart';
import 'coordinate_service.dart';

class PointStorage {
  Future<File> _dataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/moi_geomaticien_points.json');
  }

  Future<List<CapturedPoint>> loadPoints() async {
    try {
      final file = await _dataFile();
      if (!await file.exists()) return <CapturedPoint>[];
      return CapturedPoint.decodeList(await file.readAsString());
    } catch (_) {
      return <CapturedPoint>[];
    }
  }

  Future<void> savePoints(List<CapturedPoint> points) async {
    final file = await _dataFile();
    await file.writeAsString(CapturedPoint.encodeList(points), flush: true);
  }

  Future<String> exportCsv(List<CapturedPoint> points) async {
    if (points.isEmpty) {
      throw StateError('Aucun point à exporter.');
    }

    final attributeNames = <String>{
      for (final point in points) ...point.attributes.keys,
    }.toList()
      ..sort();

    final headers = <String>[
      'nom',
      'categorie',
      'description',
      'longitude_wgs84',
      'latitude_wgs84',
      'systeme_choisi',
      'x',
      'y',
      'precision_m',
      'altitude_m',
      'date_heure',
      ...attributeNames,
    ];

    final rows = <List<String>>[headers];
    for (final point in points) {
      final displayed = CoordinateService.present(
        latitude: point.latitude,
        longitude: point.longitude,
        format: point.format,
      );
      rows.add(<String>[
        point.name,
        point.category,
        point.description,
        point.longitude.toStringAsFixed(8),
        point.latitude.toStringAsFixed(8),
        displayed.system,
        displayed.x,
        displayed.y,
        point.accuracy.toStringAsFixed(2),
        point.altitude.toStringAsFixed(2),
        point.createdAt.toIso8601String(),
        for (final name in attributeNames) point.attributes[name] ?? '',
      ]);
    }

    final csv = rows.map((row) => row.map(_escape).join(',')).join('\r\n');
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}_'
        '${_two(now.hour)}${_two(now.minute)}${_two(now.second)}';
    final fileName = 'moi_geomaticien_points_$stamp.csv';

    final directory =
        await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(<int>[0xEF, 0xBB, 0xBF, ...utf8.encode(csv)], flush: true);

    await SharePlus.instance.share(
      ShareParams(
        title: 'Exporter les points — Moi, Géomaticien',
        text: 'Jeu de coordonnées exporté depuis Moi, Géomaticien.',
        files: <XFile>[XFile(file.path, mimeType: 'text/csv')],
      ),
    );

    return file.path;
  }

  static String _escape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
