import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storage = FlutterSecureStorage();

// Menyimpan token
Future<void> saveToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

// Mendapatkan token
Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

// Menyimpan data pengguna
Future<void> saveUserData(
    String token, String userId, String name, String email) async {
  await storage.write(key: 'auth_token', value: token);
  await storage.write(key: 'user_id', value: userId);
  await storage.write(key: 'user_name', value: name);
  await storage.write(key: 'user_email', value: email);
}

// Menghapus token dan data pengguna dari local storage
// Menghapus data pengguna
Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  // Hapus token dan data terkait pengguna
  await prefs.remove('auth_token');
  await prefs.remove('user_id');
  await prefs.remove('user_name');
  await prefs.remove('user_email'); // Jika ada data pengguna lainnya
}

// // Update data pengguna
// Future<void> updateProfile(String userId, name, String email) async {
//   await storage.write(key: 'user_name', value: name);
//   await storage.write(key: 'user_email', value: email);
// }

// Mendapatkan data pengguna
Future<Map<String, String>> getUserData() async {
  String? token = await storage.read(key: 'auth_token');
  String? userId = await storage.read(key: 'user_id');
  String? name = await storage.read(key: 'user_name');
  String? email = await storage.read(key: 'user_email');

  return {
    'token': token ?? '',
    'user_id': userId ?? '',
    'name': name ?? '',
    'email': email ?? '',
  };
}

class LocalStorage {
  static const _storage = FlutterSecureStorage();

  // Mendapatkan data pengguna dari penyimpanan lokal
  static Future<Map<String, String>> getUserData() async {
    String? token = await _storage.read(key: 'auth_token');
    String? userId = await _storage.read(key: 'user_id');
    String? name = await _storage.read(key: 'user_name');
    String? email = await _storage.read(key: 'user_email');

    return {
      'token': token ?? '',
      'user_id': userId ?? '', // Pastikan user_id ada di sini
      'name': name ?? '',
      'email': email ?? '',
    };
  }
}
