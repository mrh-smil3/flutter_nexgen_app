import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menunggu beberapa detik untuk menampilkan splash screen
    Future.delayed(const Duration(seconds: 2), () {
      // Setelah splash screen, arahkan ke halaman utama
      context.go('/home'); // Ganti dengan halaman utama setelah splash
    });

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Ganti dengan path logo Anda
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const SpinKitFadingCircle(color: Colors.white), // Animasi loading
          ],
        ),
      ),
    );
  }
}
