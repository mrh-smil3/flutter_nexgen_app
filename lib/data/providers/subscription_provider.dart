import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../models/subscription.dart';

// Provider untuk mengambil data subscription status
final subscriptionStatusProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return await ApiService().getSubscriptionStatus();
});

// Provider untuk mengambil semua subscription dari API
final subscriptionProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await ApiService()
      .getSubscriptions(); // Mengambil semua subscription dari API
});

// Provider untuk membuat subscription
final createSubscriptionProvider =
    FutureProvider.family<Map<String, dynamic>, Subscription>(
        (ref, subscription) async {
  final apiService = ApiService();
  return await apiService.createSubscription(subscription);
});
