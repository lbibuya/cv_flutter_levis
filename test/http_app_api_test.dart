import 'dart:convert';

import 'package:cv_flutter_levis/services/app_api.dart';
import 'package:cv_flutter_levis/services/http_app_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('envoie le jeton aux routes protégées et invalide la session', () async {
    SharedPreferences.setMockInitialValues({});
    final requests = <http.Request>[];
    var unauthorizedCount = 0;
    final client = MockClient((request) async {
      requests.add(request);
      if (request.url.path == '/api/auth/login') {
        return http.Response(
          jsonEncode({
            'token': 'test-token',
            'user': {'id': 1, 'email': 'test@example.com'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (request.url.path == '/api/famille' &&
          request.headers['authorization'] == 'Bearer test-token') {
        return http.Response('[]', 200);
      }
      return http.Response(
        jsonEncode({'detail': 'Authentification requise.'}),
        401,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = HttpAppApi(
      baseUri: Uri.parse('https://api.example/api/'),
      client: client,
      onUnauthorized: () => unauthorizedCount++,
    );
    addTearDown(() {
      api.logout();
      client.close();
    });

    await api.login(' test@example.com ', 'password');
    expect(await api.getToken(), 'test-token');
    expect(await api.listFamily(), isEmpty);
    expect(requests[0].url.path, '/api/auth/login');
    expect(requests[0].headers['authorization'], isNull);
    expect(requests[1].headers['authorization'], 'Bearer test-token');

    api.logout();
    await Future<void>.delayed(Duration.zero);
    await expectLater(
      api.listFamily(),
      throwsA(isA<AppApiException>()),
    );
    expect(unauthorizedCount, 1);
  });
}
