import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/subscription_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/packages_grid_view.dart';
import '../widgets/subscription_status_widget.dart';
import '../../data/providers/package_provider.dart';
import '../widgets/domain_search_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state dari packageProvider dan subscriptionStatusProvider
    final packageAsyncValue = ref.watch(packageProvider);
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Home',
        actions: [],
      ), // Menggunakan AppBarWidget
      body: Column(
        children: [
          const DomainSearchWidget(), // Widget pencarian domain
          SubscriptionStatusWidget(
              status: subscriptionStatus), // Status berlangganan
          Expanded(
            child: packageAsyncValue.when(
              // Loading state
              loading: () => const Center(child: CircularProgressIndicator()),
              // Error state
              error: (error, stackTrace) => ErrorWidgetWithReload(
                error: error,
                onRetry: () => ref.refresh(packageProvider),
              ),
              // Data state
              data: (packages) => PackageGridView(packages: packages),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorWidgetWithReload extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;

  const ErrorWidgetWithReload({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
