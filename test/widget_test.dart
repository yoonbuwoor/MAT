import 'package:flutter_test/flutter_test.dart';
import 'package:moi_geomaticien/app.dart';

void main() {
  testWidgets('affiche l’écran d’entrée de Moi, Géomaticien', (tester) async {
    await tester.pumpWidget(const MoiGeomaticienBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Moi, Géomaticien'), findsOneWidget);
    expect(
      find.text("Que nul n’entre ici\ns’il n’est Géomaticien."),
      findsOneWidget,
    );
    expect(find.text('ENTRER DANS L’APPLICATION'), findsOneWidget);
  });
}
