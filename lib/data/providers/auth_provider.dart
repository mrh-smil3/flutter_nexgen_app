import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/local_storage.dart';
import '../../data/models/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  AuthState({this.status = AuthStatus.initial, this.user, this.error});

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await ApiService().post('/login', {
        'email': email,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      // Pastikan memanggil fungsi saveUserData dengan benar
      await saveUserData(token, user.id.toString(), user.name, user.email);

      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
          status: AuthStatus.unauthenticated, error: e.toString());
    }
  }

  Future<void> logout() async {
    // Hapus semua data pengguna
    await clearUserData(); // Panggil clearUserData untuk menghapus semua data
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
