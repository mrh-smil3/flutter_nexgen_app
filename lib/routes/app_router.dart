import '../ui/screens/home_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/packages_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/transaction_screen.dart';
import '../ui/screens/home_screen_navigator.dart';
import '../ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login', // Start with the login page
  routes: [
    // Route untuk Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // ShellRoute untuk Bottom Navigation
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreenNavigator(
            child: child); // Menyertakan child di dalam HomeScreenNavigator
      },
      routes: [
        // Routes untuk setiap tab
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return SplashScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/packages',
          builder: (context, state) => const PackagesScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
