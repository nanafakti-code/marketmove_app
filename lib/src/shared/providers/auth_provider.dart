import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient supabase;
  
  AuthProvider({required this.supabase});

  User? get currentUser => supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String businessName,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'business_name': businessName,
        },
      );

      if (response.user != null) {
        // El trigger en BD creará el registro en users
        notifyListeners();
      }
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      notifyListeners();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is AuthException) {
      switch (error.statusCode) {
        case '422':
          return 'Este email ya está registrado';
        case '400':
          if (error.message.contains('Invalid credentials')) {
            return 'Email o contraseña incorrectos';
          }
          return error.message;
        case '429':
          return 'Demasiados intentos. Intenta más tarde';
        default:
          return error.message;
      }
    }
    return 'Error de autenticación';
  }
}
