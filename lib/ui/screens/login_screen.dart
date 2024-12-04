import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/auth_provider.dart';

import 'package:go_router/go_router.dart'; // Mengimpor GoRouter

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan status autentikasi
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Menggunakan GoRouter untuk navigasi
        context.go('/home');
      } else if (next.status == AuthStatus.unauthenticated) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error ?? 'Login gagal')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan password' : null,
              ),
              const SizedBox(height: 24),
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.watch(authProvider);
                  return ElevatedButton(
                    onPressed:
                        authState.status == AuthStatus.loading ? null : _login,
                    child: authState.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
