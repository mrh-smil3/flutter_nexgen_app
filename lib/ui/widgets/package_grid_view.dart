import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PackageGridView extends StatelessWidget {
  final List<Map<String, dynamic>> packages;

  const PackageGridView({super.key, required this.packages});

  // Fungsi untuk memformat harga ke dalam format Rupiah
  String formatToRupiah(dynamic amount) {
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dua kolom
        mainAxisSpacing: 16.0, // Jarak antar baris
        crossAxisSpacing: 16.0, // Jarak antar kolom
        childAspectRatio: 0.5, // Rasio aspek (lebar/tinggi) kartu lebih menarik
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final price =
            package['price'] ?? '0'; // Default ke '0' jika tidak ada harga
        final description =
            package['description'] ?? 'No description available';

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16.0), // Menambahkan sudut lebih bulat
          ),
          elevation: 6, // Meningkatkan efek bayangan
          shadowColor: Colors.black.withOpacity(0.2), // Efek bayangan halus
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent
                        .withOpacity(0.1), // Background warna lembut
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard, // Ikon hadiah sebagai pengganti
                    size: 36,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  package['name'] ?? 'Unknown Package',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Warna teks lebih tegas
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  formatToRupiah(price), // Panggil fungsi format
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Duration: ${package['duration']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                // Menambahkan deskripsi paket dengan lebih banyak spasi
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                  maxLines:
                      2, // Membatasi panjang deskripsi agar tidak terlalu panjang
                  overflow: TextOverflow
                      .ellipsis, // Menambahkan elipsis jika deskripsi terlalu panjang
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blueAccent, // Warna tombol lebih cerah
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Sudut tombol melengkung
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
