import '../models/family_member.dart';

abstract interface class AppApi {
  set onUnauthorized(void Function()? callback);

  Future<String?> getToken();

  Future<void> login(String email, String password);

  void logout();

  Future<List<FamilyMember>> listFamily();

  Future<FamilyMember> createFamilyMember(FamilyMember member);

  Future<FamilyMember> updateFamilyMember(FamilyMember member);

  Future<void> deleteFamilyMember(int id);
}

class AppApiException implements Exception {
  const AppApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
