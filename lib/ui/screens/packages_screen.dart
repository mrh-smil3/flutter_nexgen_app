import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/package_grid_view.dart'; // Pastikan path ini benar
import '../../data/providers/package_provider.dart'; // Pastikan path ini benar

class PackagesScreen extends ConsumerWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mendengarkan perubahan state dari packageProvider
    final packageAsyncValue = ref.watch(packageProvider);

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Packages',
        actions: [],
      ), // Menggunakan AppBarWidget
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.7),
              Colors.blue.withOpacity(0.6)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: packageAsyncValue.when(
          // Loading state
          loading: () => const Center(child: CircularProgressIndicator()),
          // Error state
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 16),
                Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => ref.refresh(packageProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          // Data state
          data: (packages) {
            if (packages.isEmpty) {
              return const Center(
                child: Text(
                  'No packages available.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            return PackageGridView(packages: packages);
          },
        ),
      ),
    );
  }
}
