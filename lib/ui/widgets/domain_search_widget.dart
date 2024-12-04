import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Import class DomainChecker

class DomainSearchWidget extends StatefulWidget {
  const DomainSearchWidget({super.key});

  @override
  _DomainSearchWidgetState createState() => _DomainSearchWidgetState();
}

class _DomainSearchWidgetState extends State<DomainSearchWidget> {
  final _domainController = TextEditingController();
  final _tldController = TextEditingController();
  String _resultMessage = '';

  // Fungsi untuk memulai pencarian domain
  void _checkDomain() async {
    final domainChecker = DomainChecker();
    String domain = _domainController.text;
    String tld = _tldController.text;

    if (domain.isNotEmpty && tld.isNotEmpty) {
      // Pastikan memanggil asinkron dengan await
      String result = await domainChecker.checkDomainAvailability(domain, tld);
      setState(() {
        _resultMessage = result;
      });
    } else {
      setState(() {
        _resultMessage = 'Silakan masukkan nama domain dan TLD.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _domainController,
            decoration: const InputDecoration(
              labelText: 'Nama Domain',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _tldController,
            decoration: const InputDecoration(
              labelText: 'TLD (misal: .com, .co.uk)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _checkDomain,
          child: const Text('Cek Ketersediaan Domain'),
        ),
        const SizedBox(height: 20),
        Text(
          _resultMessage,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
