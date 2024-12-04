import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
          title: 'Transaction'), // Gunakan AppBarWidget dengan judul
      body: Center(child: Text('Ini adalah halaman Transaksi')),
    );
  }
}
