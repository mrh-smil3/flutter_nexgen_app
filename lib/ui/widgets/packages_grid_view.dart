import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PackageGridView extends StatelessWidget {
  final List<Map<String, dynamic>> packages;

  const PackageGridView({super.key, required this.packages});

  // Fungsi untuk memformat harga ke dalam format Rupiah
  String formatToRupiah(dynamic amount) {
    // Konversi ke double, lalu ke int untuk menghilangkan desimal jika ada
    final int amountInt = (amount is String)
        ? double.parse(amount).toInt()
        : (amount as num).toInt();

    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(amountInt);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dua kolom
        mainAxisSpacing: 16.0, // Jarak antar baris
        crossAxisSpacing: 16.0, // Jarak antar kolom
        childAspectRatio: 2, // Rasio aspek (lebar/tinggi) kartu lebih ramping
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final price =
            package['price'] ?? '0'; // Default ke '0' jika tidak ada harga

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.card_giftcard, // Ikon hadiah sebagai pengganti
                  size: 48,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  package['name'] ?? 'Unknown Package',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  formatToRupiah(price), // Panggil fungsi format
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${package['duration']}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Handle action for selecting package
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${package['name']} selected!'),
                      ),
                    );
                  },
                  child: const Text('Select Package'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
