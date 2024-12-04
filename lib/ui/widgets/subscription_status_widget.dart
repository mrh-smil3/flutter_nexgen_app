import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/subscription_provider.dart';
import 'package:intl/intl.dart';

class SubscriptionStatusWidget extends ConsumerWidget {
  const SubscriptionStatusWidget(
      {super.key, required AsyncValue<Map<String, dynamic>> status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStatusAsync = ref.watch(subscriptionStatusProvider);

    return subscriptionStatusAsync.when(
      data: (subscriptionStatus) {
        // Cek apakah langganan ditemukan
        if (subscriptionStatus['message'] == 'Subscription not found') {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.redAccent,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You do not have an active subscription.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please subscribe to continue.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
// Cek apakah status subscription aktif
        String status = subscriptionStatus['status'] ?? 'Unknown';
        String endDate = subscriptionStatus['end_date'] ?? 'N/A';

        // Format tanggal dari 'YYYY-MM-DD' menjadi 'Day, Month, Year'
        DateTime dateTime = DateTime.parse(endDate);
        String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

        return Card(
          margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 15), // Menggunakan margin simetris
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Menambahkan sudut melengkung
          ),
          color: Colors.blue,
          child: Container(
            width: double.infinity, // Card akan mengisi lebar layar
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subscription Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontSize: 16,
                    color: status == 'Active' ? Colors.green : Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Expiry Date: $formattedDate',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
