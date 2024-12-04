import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Tambahkan parameter opsional untuk actions

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions, // Default null jika tidak diisi
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // Judul halaman
      actions: [
        if (actions != null) ...actions!, // Gunakan actions jika diberikan
        IconButton(
          icon: const Icon(Icons.notifications), // Ikon notifikasi
          onPressed: () {
            // Tindakan saat ikon notifikasi ditekan
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifikasi diklik!')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
