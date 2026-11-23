import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/family_member.dart';
import 'app_api.dart';

class HttpAppApi implements AppApi {
  static const _tokenKey = 'auth_token';

  HttpAppApi({
    Uri? baseUri,
    http.Client? client,
    this.onUnauthorized,
  })  : _baseUri = baseUri ??
            Uri.parse(
              '${const String.fromEnvironment(
                'API_BASE_URL',
                defaultValue: 'http://127.0.0.1:5000/api',
              ).replaceAll(RegExp(r'/+$'), '')}/',
            ),
        _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;
  String? _accessToken;
  Timer? _sessionTimer;

  VoidCallback? onUnauthorized;

  @override
  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    _accessToken = preferences.getString(_tokenKey);
    return _accessToken;
  }

  @override
  Future<void> login(String email, String password) async {
    final response = await _request(
      'POST',
      'auth/login',
      body: {'email': email.trim(), 'password': password},
      authenticated: false,
    ) as Map<String, dynamic>;
    final token = response['token'] as String;
    _accessToken = token;
    final preferences = await SharedPreferences.getInstance();
    final stored = await preferences.setString(_tokenKey, token);
    if (!stored) {
      _accessToken = null;
      throw const AppApiException(
        'Impossible de conserver la session sur cet appareil.',
      );
    }
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(hours: 24), () {
      logout();
      onUnauthorized?.call();
    });
  }

  @override
  void logout() {
    _accessToken = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;
    unawaited(_removeStoredToken());
  }

  Future<void> _removeStoredToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }

  Map<String, String> headers({bool authenticated = true}) {
    final result = <String, String>{'Accept': 'application/json'};
    if (authenticated && _accessToken != null) {
      result['Authorization'] = 'Bearer $_accessToken';
    }
    return result;
  }

  @override
  Future<List<FamilyMember>> listFamily() async {
    final response = await _request('GET', 'famille') as List<dynamic>;
    return response
        .map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FamilyMember> createFamilyMember(FamilyMember member) async {
    final response = await _request(
      'POST',
      'famille',
      body: member.toJson(),
    ) as Map<String, dynamic>;
    return FamilyMember.fromJson(response);
  }

  @override
  Future<FamilyMember> updateFamilyMember(FamilyMember member) async {
    final response = await _request(
      'PUT',
      'famille/${member.id}',
      body: member.toJson(),
    ) as Map<String, dynamic>;
    return FamilyMember.fromJson(response);
  }

  @override
  Future<void> deleteFamilyMember(int id) async {
    await _request('DELETE', 'famille/$id');
  }

  Future<List<FamilyMember>> getFamille() => listFamily();

  Future<FamilyMember> addFamille(FamilyMember member) =>
      createFamilyMember(member);

  Future<FamilyMember> updateFamille(FamilyMember member) =>
      updateFamilyMember(member);

  Future<void> deleteFamille(int id) => deleteFamilyMember(id);

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    final requestHeaders = headers();
    if (body != null) requestHeaders['Content-Type'] = 'application/json';
    if (!authenticated) requestHeaders.remove('Authorization');

    final uri = _baseUri.resolve(path);
    final encodedBody = body == null ? null : jsonEncode(body);
    late final http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: requestHeaders).timeout(
                const Duration(seconds: 15),
              );
        case 'POST':
          response = await _client
              .post(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: 15));
        case 'PUT':
          response = await _client
              .put(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: 15));
        case 'PATCH':
          response = await _client
              .patch(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: 15));
        case 'DELETE':
          response = await _client.delete(uri, headers: requestHeaders).timeout(
                const Duration(seconds: 15),
              );
        default:
          throw AppApiException('Méthode HTTP non prise en charge : $method');
      }
    } on http.ClientException {
      throw const AppApiException(
        'Impossible de joindre le serveur. Vérifiez votre connexion et '
        'l’adresse de l’API.',
      );
    } on TimeoutException {
      throw const AppApiException(
        'Le serveur met trop de temps à répondre. Réessayez.',
      );
    }

    if ((response.statusCode == 401 || response.statusCode == 403) &&
        authenticated) {
      logout();
      onUnauthorized?.call();
    }

    dynamic responseBody;
    if (response.body.isNotEmpty) {
      try {
        responseBody = jsonDecode(response.body);
      } on FormatException {
        throw const AppApiException(
            'Le serveur a renvoyé une réponse invalide.');
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final detail = responseBody is Map<String, dynamic>
          ? responseBody['message'] ?? responseBody['detail']
          : null;
      throw AppApiException(
        detail is String
            ? detail
            : 'Erreur du serveur (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
    return responseBody;
  }
}
