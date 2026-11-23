import 'package:cv_flutter_levis/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cv_flutter_levis/models/family_member.dart';
import 'package:cv_flutter_levis/services/app_api.dart';

void main() {
  testWidgets('restaure la session sauvegardée au démarrage', (tester) async {
    await tester.pumpWidget(CvFlutterApp(api: _FakeApi(token: 'saved-token')));
    await tester.pumpAndSettle();

    expect(find.text('Levis BIBUYA\nTSIBIRA'), findsOneWidget);
    expect(find.text('Bienvenue sur mon CV'), findsNothing);
  });

  testWidgets('refuse les identifiants invalides', (tester) async {
    await tester.pumpWidget(CvFlutterApp(api: _FakeApi()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(0), 'invalide@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'incorrect');
    await tester.tap(find.text('Découvrir mon CV'));
    await tester.pump();

    expect(
      find.text('Identifiants incorrects - Vérifiés par le serveur'),
      findsOneWidget,
    );
    expect(find.text('Bienvenue sur mon CV'), findsOneWidget);
  });

  testWidgets('connecte, navigue vers la famille et se déconnecte',
      (tester) async {
    await tester.pumpWidget(CvFlutterApp(api: _FakeApi()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(0), 'lbibuya@gmail.com');
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

class _FakeApi implements AppApi {
  _FakeApi({this.token});

  final String? token;

  @override
  void Function()? onUnauthorized;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> login(String email, String password) async {
    if (email != 'lbibuya@gmail.com' || password != '123456' || token != null) {
      throw const AppApiException(
        'Identifiants incorrects - Vérifiés par le serveur',
        statusCode: 401,
      );
    }
  }

  @override
  void logout() {}

  @override
  Future<List<FamilyMember>> listFamily() async => const [
        FamilyMember(
          id: 1,
          name: 'Jamel',
          relationship: 'Frère',
          description: 'Mon frère.',
        ),
      ];

  @override
  Future<FamilyMember> createFamilyMember(FamilyMember member) async => member;

  @override
  Future<FamilyMember> updateFamilyMember(FamilyMember member) async => member;

  @override
  Future<void> deleteFamilyMember(int id) async {}
}
