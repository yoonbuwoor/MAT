import 'package:flutter_test/flutter_test.dart';
import 'package:moi_geomaticien/app.dart';
import 'package:moi_geomaticien/screens/main_shell.dart';

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

  testWidgets(
    'ouvre l’accueil avant toute réponse du service de localisation',
    (tester) async {
      await tester.pumpWidget(const MoiGeomaticienBootstrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('ENTRER DANS L’APPLICATION'));
      await tester.pumpAndSettle();
      if (find.text('Pas maintenant').evaluate().isNotEmpty) {
        await tester.tap(find.text('Pas maintenant'));
        await tester.pumpAndSettle();
      }

      expect(find.byType(MainShell), findsOneWidget);
      expect(find.text('Accueil'), findsOneWidget);
    },
  );
}
