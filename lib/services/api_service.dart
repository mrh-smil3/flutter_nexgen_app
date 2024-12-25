import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/subscription.dart';
import 'local_storage.dart';

class ApiService {
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // Ubah dengan URL API Laravel Anda
  // 'https://app.nex-gen.id/api';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  // Method untuk melakukan request PUT update profile
  Future<Map<String, dynamic>> updateProfile(
      String userId, String name, String email) async {
    final url = Uri.parse('$baseUrl/users/$userId'); // Endpoint update profile
    String? token = await storage.read(key: 'auth_token'); // Ambil token

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Kirim token
        },
        body: json.encode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Perbarui token jika diperlukan
        if (data['token'] != null) {
          await storage.write(key: 'auth_token', value: data['token']);
        }

        return data; // Kembalikan seluruh data
      } else {
        throw Exception(
            'Failed to update profile: ${response.body}'); // Error detail
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

  // Fungsi untuk mendapatkan data packages
  Future<List<Map<String, dynamic>>> getPackages() async {
    final url = Uri.parse('$baseUrl/packages');
    String? token = await const FlutterSecureStorage().read(key: 'auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Berhasil mendapatkan daftar paket
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk mendapatkan status berlangganan
  Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final url = Uri.parse('$baseUrl/subscriptions');
    String? token = await const FlutterSecureStorage().read(key: 'auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode JSON dan cek apakah respons berupa List
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          // Ambil elemen pertama jika data adalah List
          return data.first as Map<String, dynamic>;
        } else {
          // Tangani kasus List kosong
          return {'status': 'Not Found', 'message': 'Subscription not found'};
        }
      } else if (response.statusCode == 404) {
        // Jika endpoint mengembalikan 404
        return {'status': 'Not Found', 'message': 'Subscription not found'};
      } else {
        throw Exception(
            'Failed to load subscription status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscription status: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSubscriptions() async {
    final url = Uri.parse('$baseUrl/subscriptions');
    String? token = await const FlutterSecureStorage().read(key: 'auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode JSON dan pastikan data berupa List
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((e) => e as Map<String, dynamic>)
              .toList(); // Mengembalikan seluruh list data
        } else {
          return []; // Jika data kosong
        }
      } else {
        throw Exception('Failed to load subscriptions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }

  // Fungsi untuk membuat subscription baru
  Future<Map<String, dynamic>> createSubscription(
      Subscription subscription) async {
    final url = Uri.parse('$baseUrl/subscriptions');
    final token = await const FlutterSecureStorage()
        .read(key: 'auth_token'); // Simpan token di secure storage

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(subscription.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk logout
  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout'); // Endpoint logout

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token di header
        },
      );

      if (response.statusCode == 200) {
        return json
            .decode(response.body); // Mengembalikan response jika berhasil
      } else {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during logout: $e'); // Menangani error
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
