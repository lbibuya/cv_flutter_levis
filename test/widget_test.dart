import 'package:cv_flutter_levis/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('refuse les identifiants invalides', (tester) async {
    await tester.pumpWidget(const CvFlutterApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'invalide');
    await tester.enterText(find.byType(TextFormField).at(1), 'incorrect');
    await tester.tap(find.text('Découvrir mon CV'));
    await tester.pump();

    expect(find.text('Identifiant ou mot de passe incorrect.'), findsOneWidget);
    expect(find.text('Bienvenue sur mon CV'), findsOneWidget);
  });

  testWidgets('connecte, navigue vers la famille et se déconnecte',
      (tester) async {
    await tester.pumpWidget(const CvFlutterApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'levis');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Découvrir mon CV'));
    await tester.pumpAndSettle();

    expect(find.text('Levis BIBUYA\nTSIBIRA'), findsOneWidget);
    await tester.tap(find.text('Famille').last);
    await tester.pumpAndSettle();
    expect(find.text('Mes proches'), findsOneWidget);

    await tester.tap(find.byTooltip('Se déconnecter'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenue sur mon CV'), findsOneWidget);
  });
}
