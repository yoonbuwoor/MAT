import 'package:flutter_test/flutter_test.dart';
import 'package:moi_geomaticien/models/geo_models.dart';
import 'package:moi_geomaticien/services/coordinate_service.dart';

void main() {
  group('CoordinateService', () {
    test('présente longitude X et latitude Y en WGS 84 décimal', () {
      final result = CoordinateService.present(
        latitude: 14.7167,
        longitude: -17.4677,
        format: CoordinateFormat.wgs84Decimal,
      );

      expect(result.system, contains('EPSG:4326'));
      expect(result.x, '-17.4677000');
      expect(result.y, '14.7167000');
    });

    test('détermine automatiquement la zone UTM de Dakar', () {
      final result = CoordinateService.present(
        latitude: 14.7167,
        longitude: -17.4677,
        format: CoordinateFormat.utmAuto,
      );

      expect(result.system, contains('zone 28N'));
      expect(result.detail, contains('EPSG:32628'));
      expect(double.parse(result.x), closeTo(234285.7, 2.0));
      expect(double.parse(result.y), closeTo(1628446.4, 2.0));
    });

    test('convertit l’origine WGS 84 en Web Mercator', () {
      final result = CoordinateService.present(
        latitude: 0,
        longitude: 0,
        format: CoordinateFormat.webMercator,
      );

      expect(double.parse(result.x), closeTo(0, 0.001));
      expect(double.parse(result.y), closeTo(0, 0.001));
    });
  });
}
