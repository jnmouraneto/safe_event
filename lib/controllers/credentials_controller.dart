import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> saveLoginCredentials(String email, String password) async {
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
  }

  Future<Map<String, String>> getLoginCredentials() async {
    final email = await _secureStorage.read(key: 'email') ?? '';
    final password = await _secureStorage.read(key: 'password') ?? '';

    return {'email': email, 'password': password};
  }

  Future<void> removeLoginCredentials() async {
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'password');
  }
}
