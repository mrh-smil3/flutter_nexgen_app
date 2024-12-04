import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';

// Untuk kIsWeb
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  // Periksa apakah aplikasi berjalan di platform web
  // if (kIsWeb) {
  //   // Setel URL strategy hanya untuk aplikasi web
  //   setUrlStrategy(PathUrlStrategy());
  // }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
