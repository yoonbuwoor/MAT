import 'dart:convert';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/geo_models.dart';
import 'coordinate_service.dart';

class PointImportResult {
  const PointImportResult({
    required this.points,
    required this.rejectedRows,
    required this.fileName,
    this.wasCancelled = false,
  });

  const PointImportResult.cancelled()
      : points = const <CapturedPoint>[],
        rejectedRows = 0,
        fileName = '',
        wasCancelled = true;

  final List<CapturedPoint> points;
  final int rejectedRows;
  final String fileName;
  final bool wasCancelled;
}

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

  Future<PointImportResult> pickAndReadCsv() async {
    final selection = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      allowMultiple: false,
      withData: true,
      dialogTitle: 'Choisir un fichier CSV de points',
    );
    if (selection == null || selection.files.isEmpty) {
      return const PointImportResult.cancelled();
    }

    final picked = selection.files.single;
    final bytes = picked.bytes ??
        (picked.path == null ? null : await File(picked.path!).readAsBytes());
    if (bytes == null || bytes.isEmpty) {
      throw const FormatException('Le fichier sélectionné est vide ou illisible.');
    }

    final source = utf8.decode(bytes, allowMalformed: true).replaceFirst('\uFEFF', '');
    final rows = _parseCsv(source);
    if (rows.length < 2) {
      throw const FormatException(
        'Le CSV doit contenir une ligne d’en-têtes et au moins un point.',
      );
    }

    final headers = rows.first.map(_normalizeHeader).toList();
    final headerIndex = <String, int>{
      for (var index = 0; index < headers.length; index++)
        if (headers[index].isNotEmpty) headers[index]: index,
    };

    final knownHeaders = <String>{
      'nom',
      'name',
      'point',
      'categorie',
      'category',
      'description',
      'remarque',
      'longitude_wgs84',
      'longitude',
      'lon',
      'lng',
      'x',
      'latitude_wgs84',
      'latitude',
      'lat',
      'y',
      'precision_m',
      'precision',
      'accuracy',
      'altitude_m',
      'altitude',
      'date_heure',
      'date',
      'created_at',
      'systeme_choisi',
      'systeme',
      'crs',
      'scr',
    };

    final imported = <CapturedPoint>[];
    var rejected = 0;
    for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      if (row.every((value) => value.trim().isEmpty)) continue;

      final system = _value(
        row,
        headerIndex,
        const ['systeme_choisi', 'systeme', 'crs', 'scr'],
      ).toLowerCase();
      final explicitLongitude = _value(
        row,
        headerIndex,
        const ['longitude_wgs84', 'longitude', 'lon', 'lng'],
      );
      final explicitLatitude = _value(
        row,
        headerIndex,
        const ['latitude_wgs84', 'latitude', 'lat'],
      );
      final xyMayBeWgs84 = system.isEmpty ||
          system.contains('4326') ||
          system.contains('wgs 84') ||
          system.contains('wgs84');
      final longitude = _number(
        explicitLongitude.trim().isNotEmpty
            ? explicitLongitude
            : xyMayBeWgs84
                ? _value(row, headerIndex, const ['x'])
                : '',
      );
      final latitude = _number(
        explicitLatitude.trim().isNotEmpty
            ? explicitLatitude
            : xyMayBeWgs84
                ? _value(row, headerIndex, const ['y'])
                : '',
      );

      if (latitude == null ||
          longitude == null ||
          latitude < -90 ||
          latitude > 90 ||
          longitude < -180 ||
          longitude > 180) {
        rejected++;
        continue;
      }

      final format = system.contains('3857')
          ? CoordinateFormat.webMercator
          : system.contains('utm')
              ? CoordinateFormat.utmAuto
              : CoordinateFormat.wgs84Decimal;
      final importedDate = DateTime.tryParse(
        _value(row, headerIndex, const ['date_heure', 'date', 'created_at']),
      );
      final attributes = <String, String>{};
      for (var column = 0; column < headers.length; column++) {
        final header = headers[column];
        if (header.isEmpty || knownHeaders.contains(header) || column >= row.length) {
          continue;
        }
        final value = row[column].trim();
        if (value.isNotEmpty) attributes[header] = value;
      }

      imported.add(
        CapturedPoint(
          id: '${DateTime.now().microsecondsSinceEpoch}_$rowIndex',
          name: _value(row, headerIndex, const ['nom', 'name', 'point']).trim().isEmpty
              ? 'Point importé $rowIndex'
              : _value(row, headerIndex, const ['nom', 'name', 'point']).trim(),
          latitude: latitude,
          longitude: longitude,
          accuracy: _number(
                _value(
                  row,
                  headerIndex,
                  const ['precision_m', 'precision', 'accuracy'],
                ),
              ) ??
              0,
          altitude: _number(
                _value(row, headerIndex, const ['altitude_m', 'altitude']),
              ) ??
              0,
          format: format,
          createdAt: importedDate ?? DateTime.now(),
          category:
              _value(row, headerIndex, const ['categorie', 'category']).trim(),
          description:
              _value(row, headerIndex, const ['description', 'remarque']).trim(),
          attributes: attributes,
        ),
      );
    }

    if (imported.isEmpty) {
      throw const FormatException(
        'Aucun point WGS 84 valide trouvé. Vérifie les colonnes longitude et latitude.',
      );
    }
    return PointImportResult(
      points: imported,
      rejectedRows: rejected,
      fileName: picked.name,
    );
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

    final directory = await getTemporaryDirectory();
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

  static String _normalizeHeader(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('ù', 'u')
        .replaceAll('ï', 'i')
        .replaceAll('ô', 'o')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  static String _value(
    List<String> row,
    Map<String, int> index,
    List<String> candidates,
  ) {
    for (final candidate in candidates) {
      final position = index[candidate];
      if (position != null && position < row.length) return row[position];
    }
    return '';
  }

  static double? _number(String value) {
    final normalized = value.trim().replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  static List<List<String>> _parseCsv(String source) {
    final firstLine = source.split(RegExp(r'\r?\n')).firstWhere(
          (line) => line.trim().isNotEmpty,
          orElse: () => '',
        );
    final commas = ','.allMatches(firstLine).length;
    final semicolons = ';'.allMatches(firstLine).length;
    final tabs = '\t'.allMatches(firstLine).length;
    final delimiter = tabs > commas && tabs > semicolons
        ? '\t'
        : semicolons > commas
            ? ';'
            : ',';

    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var inQuotes = false;

    for (var index = 0; index < source.length; index++) {
      final character = source[index];
      if (character == '"') {
        if (inQuotes && index + 1 < source.length && source[index + 1] == '"') {
          cell.write('"');
          index++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (character == delimiter && !inQuotes) {
        row.add(cell.toString());
        cell.clear();
      } else if ((character == '\n' || character == '\r') && !inQuotes) {
        if (character == '\r' &&
            index + 1 < source.length &&
            source[index + 1] == '\n') {
          index++;
        }
        row.add(cell.toString());
        cell.clear();
        rows.add(row);
        row = <String>[];
      } else {
        cell.write(character);
      }
    }

    if (cell.isNotEmpty || row.isNotEmpty) {
      row.add(cell.toString());
      rows.add(row);
    }
    return rows;
  }
}
