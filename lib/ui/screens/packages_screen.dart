import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:
          AppBarWidget(title: 'Package'), // Gunakan AppBarWidget dengan judul
      body: Center(child: Text('Ini adalah halaman Package')),
    );
  }
}
