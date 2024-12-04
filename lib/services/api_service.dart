import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'local_storage.dart';

class ApiService {
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // Ubah dengan URL API Laravel Anda

  // Method untuk melakukan request PUT update profile
  Future<Map<String, dynamic>> updateProfile(
      String userId, String name, String email) async {
    final url =
        Uri.parse('$baseUrl/users/$userId'); // URL endpoint update profil
    String? token =
        await storage.read(key: 'auth_token'); // Ambil token dari penyimpanan
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Kirim token jika diperlukan
        },
        body: json.encode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return json
            .decode(response.body); // Mengembalikan data response jika sukses
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error during profile update: $e');
    }
  }

  // Fungsi untuk mengambil token dari storage
  Future<String?> getAuthToken() async {
    // Misalnya menggunakan Flutter Secure Storage untuk mendapatkan token
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  // Method untuk melakukan request POST Login
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final url =
        Uri.parse('$baseUrl$endpoint'); // Gabungkan base URL dengan endpoint
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data), // Konversi body ke format JSON
      );

      if (response.statusCode == 200) {
        return json.decode(response
            .body); // Mengembalikan response dalam bentuk JSON jika berhasil
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error during login: $e'); // Menangani error jika ada masalah
    }
  }

  // Method untuk mengambil data paket dari API
  Future<List<Map<String, dynamic>>> getAllPackages() async {
    final url = Uri.parse('$baseUrl/packages'); // Endpoint API untuk paket
    String? token =
        await storage.read(key: 'auth_token'); // Ambil token dari storage

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Mengirimkan token untuk otentikasi
        },
      );

      if (response.statusCode == 200) {
        // Parse response body ke dalam bentuk List
        List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((package) => package as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      throw Exception('Error fetching packages: $e');
    }
  }

  // Method untuk mendapatkan status berlangganan
  Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final url = Uri.parse(
        '$baseUrl/subscriptions'); // URL endpoint untuk status berlangganan
    String? token = await const FlutterSecureStorage()
        .read(key: 'auth_token'); // Ambil token

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Kirim token jika diperlukan
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        // Tangani 404 sebagai respons valid untuk pengguna tanpa langganan
        return {'status': 'Not Found', 'message': 'Subscription not found'};
      } else {
        throw Exception(
            'Failed to load subscription status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscription status: $e');
    }
  }
}

class DomainChecker {
  static const String apiUrl =
      'https://domainstatus.p.rapidapi.com/v1/domain/available';
  static const String apiKey =
      '6beabd5809msh48693314fa90032p1ac0c2jsn1c0a76bfc6ee';
  static const String host = 'domainstatus.p.rapidapi.com';

  // Fungsi untuk memeriksa ketersediaan domain
  Future<String> checkDomainAvailability(String domainName, String tld) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'X-Rapidapi-Key': apiKey,
          'X-Rapidapi-Host': host,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': domainName,
          'tld': tld,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['available'] == true) {
          return 'Domain tersedia';
        } else {
          return 'Domain sudah terdaftar';
        }
      } else {
        // Menangani error jika API gagal memberikan respon
        return 'Terjadi kesalahan, coba lagi nanti';
      }
    } catch (e) {
      print('Error during request: $e');
      return 'Terjadi kesalahan, coba lagi nanti';
    }
  }
}
