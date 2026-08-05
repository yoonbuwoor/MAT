import 'package:flutter_test/flutter_test.dart';
import 'package:moi_geomaticien/app.dart';

void main() {
  testWidgets('affiche le tableau de bord principal', (tester) async {
    await tester.pumpWidget(const MoiGeomaticienBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Moi, Géomaticien'), findsOneWidget);
    expect(find.text('À faire aujourd’hui'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
  });
}
