import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

// Provider untuk mengambil data subscription status
final subscriptionStatusProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return await ApiService().getSubscriptionStatus();
});
