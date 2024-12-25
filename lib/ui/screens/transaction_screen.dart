import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/subscription_provider.dart';
import 'create_subscription_screen.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsyncValue = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.blueAccent, // Menambahkan warna app bar
      ),
      body: subscriptionAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        data: (subscriptions) {
          if (subscriptions.isEmpty) {
            return const Center(child: Text('No subscriptions found.'));
          }

          // Urutkan berdasarkan created_at descending
          subscriptions.sort((a, b) {
            final dateA = DateTime.parse(a['created_at']);
            final dateB = DateTime.parse(b['created_at']);
            return dateB.compareTo(dateA); // Descending order
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final subscription = subscriptions[index];
              final packageName =
                  subscription['package']?['name'] ?? 'Unknown Package';

              // Format tanggal dengan menggunakan intl
              final startDate = DateTime.parse(subscription['start_date']);
              final endDate = DateTime.parse(subscription['end_date']);
              final createdDate = DateTime.parse(subscription['created_at']);
              final formattedStartDate =
                  DateFormat('MMM dd, yyyy').format(startDate);
              final formattedEndDate =
                  DateFormat('MMM dd, yyyy').format(endDate);
              final formattedCreatedDate =
                  DateFormat('MMM dd, yyyy').format(createdDate);

              return Card(
                elevation: 8, // Menambahkan efek shadow pada card
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    'Transaction ID: ${subscription['transaction_id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Package: $packageName',
                        style:
                            TextStyle(fontSize: 14, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${subscription['status']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start Date: $formattedStartDate',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'End Date: $formattedEndDate',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: Text(
                    formattedCreatedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
      // FloatingActionButton untuk menambahkan subscription baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSubscriptionScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28), // Ikon untuk tombol add
        tooltip: 'Add Subscription',
        backgroundColor: Colors.blueAccent, // Warna tombol FAB
      ),
    );
  }
}
