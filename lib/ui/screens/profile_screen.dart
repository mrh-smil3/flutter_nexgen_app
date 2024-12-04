import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/local_storage.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

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
      final userData = await LocalStorage.getUserData();
      final userId = userData['user_id'];

      // Panggil API untuk mengupdate profil
      final response = await ApiService()
          .updateProfile(userId!, _nameController.text, _emailController.text);

      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));
    } catch (e) {
      // Menampilkan error jika update gagal
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
