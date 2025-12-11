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
          'role': 'admin', // Asignar rol admin por defecto
        },
      );

      if (response.user != null) {
        // Crear registro en tabla users con rol admin
        try {
          await supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'business_name': businessName,
            'role': 'admin', // Rol por defecto para nuevos usuarios
          });
        } catch (e) {
          print(
            'Nota: Registro en users ya existe o fue creado por trigger: $e',
          );
        }

        notifyListeners();
      }
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
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

  // Obtener el rol del usuario actual
  Future<String> getUserRole() async {
    try {
      if (currentUser == null) return 'admin';

      final response = await supabase
          .from('users')
          .select('role')
          .eq('id', currentUser!.id)
          .single();

      return response['role'] ?? 'admin';
    } catch (e) {
      print('Error obteniendo rol: $e');
      return 'admin'; // Por defecto admin
    }
  }

  // Obtener el nombre de la empresa del usuario actual
  Future<String> getEmpresaNombre() async {
    try {
      if (currentUser == null) return 'Sin empresa';

      // Si es superadmin, retornar "Market Move"
      final userRole = await getUserRole();
      if (userRole == 'superadmin') {
        return 'Market Move';
      }

      final response = await supabase
          .from('empresas')
          .select('nombre_negocio')
          .eq('admin_id', currentUser!.id)
          .limit(1)
          .maybeSingle();

      return response?['nombre_negocio'] ?? 'Sin empresa';
    } catch (e) {
      print('Error obteniendo empresa: $e');
      return 'Sin empresa';
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
