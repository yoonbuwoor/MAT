import 'package:flutter_test/flutter_test.dart';
import 'package:moi_geomaticien/data/app_data.dart';
import 'package:moi_geomaticien/data/software_data.dart';

void main() {
  test('la bibliothèque contient un parcours pédagogique conséquent', () {
    expect(learningTopics.length, greaterThanOrEqualTo(30));
    expect(
      learningTopics.map((topic) => topic.id).toSet().length,
      learningTopics.length,
    );
  });

  test('les quiz sont complets, valides et uniques', () {
    expect(practiceMissions.length, greaterThanOrEqualTo(30));
    expect(
      practiceMissions.map((mission) => mission.id).toSet().length,
      practiceMissions.length,
    );
    for (final mission in practiceMissions) {
      expect(mission.options.length, 4, reason: mission.id);
      expect(mission.correctIndex, inInclusiveRange(0, 3), reason: mission.id);
      expect(mission.explanation.trim(), isNotEmpty, reason: mission.id);
    }
  });

  test('le catalogue présente de nombreux logiciels et usages', () {
    expect(geomaticsSoftware.length, greaterThanOrEqualTo(25));
    expect(
      geomaticsSoftware.map((software) => software.name).toSet().length,
      geomaticsSoftware.length,
    );
    for (final software in geomaticsSoftware) {
      expect(software.utility.trim(), isNotEmpty, reason: software.name);
      expect(software.bestFor.trim(), isNotEmpty, reason: software.name);
    }
  });
}
