import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/local_storage.dart' as LocalStorage;
import 'login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Fungsi untuk memuat data profil (misalnya dari LocalStorage atau API)
  Future<void> _loadProfile() async {
    final userData = await LocalStorage.getUserData();
    _nameController.text = userData['name'] ?? '';
    _emailController.text = userData['email'] ?? '';
  }

  // Fungsi untuk mengupdate profil
  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final userData = await LocalStorage.getUserData();
      final userId = userData['user_id'];

      // Panggil API untuk mengupdate profil
      final response = await _apiService.updateProfile(
          userId!, _nameController.text, _emailController.text);

      // Menyimpan data baru yang diterima dari API
      await LocalStorage.saveUserData(
        response['token'], // Token baru dari API
        response['user_id'].toString(), // user_id yang sudah di-update
        response['name'], // Nama yang sudah di-update
        response['email'], // Email yang sudah di-update
      );

      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      // Menampilkan error jika update gagal
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk logout
  Future<void> _logout() async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No token found, please log in again')));
      return;
    }

    try {
      final response = await _apiService.logout(token);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));

      await LocalStorage.clearUserData();

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to logout: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar pengguna
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/profile_picture.png'), // Ganti dengan path gambar profil pengguna
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),

              // Nama pengguna
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),

              // Email pengguna
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 30),

              // Tombol update profil
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 20),

              // Tombol logout
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 40.0),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Warna tombol logout
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
