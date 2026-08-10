import 'dart:convert';

/// Formats de coordonnées proposés à l'utilisateur.
enum CoordinateFormat {
  wgs84Decimal,
  wgs84Dms,
  utmAuto,
  webMercator,
}

extension CoordinateFormatLabel on CoordinateFormat {
  String get label {
    switch (this) {
      case CoordinateFormat.wgs84Decimal:
        return 'WGS 84 — degrés décimaux';
      case CoordinateFormat.wgs84Dms:
        return 'WGS 84 — degrés, minutes, secondes';
      case CoordinateFormat.utmAuto:
        return 'UTM WGS 84 — zone automatique';
      case CoordinateFormat.webMercator:
        return 'Web Mercator — EPSG:3857';
    }
  }

  String get shortLabel {
    switch (this) {
      case CoordinateFormat.wgs84Decimal:
        return 'WGS84 DD';
      case CoordinateFormat.wgs84Dms:
        return 'WGS84 DMS';
      case CoordinateFormat.utmAuto:
        return 'UTM';
      case CoordinateFormat.webMercator:
        return 'EPSG:3857';
    }
  }
}

class CapturedPoint {
  const CapturedPoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.format,
    required this.createdAt,
    this.category = '',
    this.description = '',
    this.attributes = const <String, String>{},
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final CoordinateFormat format;
  final DateTime createdAt;
  final String category;
  final String description;
  final Map<String, String> attributes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'format': format.name,
        'createdAt': createdAt.toIso8601String(),
        'category': category,
        'description': description,
        'attributes': attributes,
      };

  factory CapturedPoint.fromJson(Map<String, dynamic> json) {
    final formatName = json['format'] as String?;
    final format = CoordinateFormat.values.firstWhere(
      (item) => item.name == formatName,
      orElse: () => CoordinateFormat.wgs84Decimal,
    );

    return CapturedPoint(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Point sans nom',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0,
      format: format,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      attributes: (json['attributes'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ) ??
          const <String, String>{},
    );
  }

  static String encodeList(List<CapturedPoint> points) =>
      jsonEncode(points.map((point) => point.toJson()).toList());

  static List<CapturedPoint> decodeList(String source) {
    final data = jsonDecode(source);
    if (data is! List) return <CapturedPoint>[];
    return data
        .whereType<Map>()
        .map((item) => CapturedPoint.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
