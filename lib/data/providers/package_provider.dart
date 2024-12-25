import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

final packageProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiService = ApiService();
  return await apiService.getAllPackages(); // Mengambil paket dari API
});

// Provider untuk mengambil daftar paket
final packagesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiService = ApiService();
  return await apiService.getPackages();
});
