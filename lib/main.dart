import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/pages/login_page.dart';
import 'src/features/auth/pages/register_page.dart';
import 'src/features/ventas/pages/ventas_page.dart';
import 'src/features/gastos/pages/gastos_page.dart';
import 'src/features/productos/pages/productos_page.dart';
import 'src/features/resumen/pages/resumen_page.dart';
import 'src/features/perfil/pages/perfil_page.dart';
import 'src/features/clientes/pages/clientes_superadmin_page.dart';
import 'src/features/clientes/pages/clientes_admin_page.dart';
import 'src/shared/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String supabaseUrl = 'https://zzaobtowduhjeivrmjhn.supabase.co';
  String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6YW9idG93ZHVoamVpdnJtamhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1MjcxODMsImV4cCI6MjA4MDEwMzE4M30.f9dSOGXfuWS0VbV1LZGtEqQggGoKzFtRkQnKdbwv2nk';

  // Intentar cargar variables de entorno desde .env
  // Si falla, usar las credenciales hardcodeadas arriba
  try {
    await dotenv.load(fileName: ".env");
    final loadedUrl = dotenv.env['SUPABASE_URL'];
    final loadedKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (loadedUrl != null && loadedUrl.isNotEmpty) {
      supabaseUrl = loadedUrl;
    }
    if (loadedKey != null && loadedKey.isNotEmpty) {
      supabaseAnonKey = loadedKey;
    }
    print('[dotenv] Variables cargadas correctamente desde .env');
  } catch (e) {
    print('[dotenv] No se pudo cargar .env, usando credenciales predeterminadas');
    print('   Error: $e');
  }

  // Inicializar Supabase con las credenciales
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('[Supabase] Inicializado correctamente en: $supabaseUrl');
  } catch (e) {
    print('[Supabase] Error durante inicialización: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(supabase: Supabase.instance.client),
        ),
      ],
      child: MaterialApp(
        title: 'MarketMove',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const ResumenPage();
            }
            return const LoginPage();
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/resumen': (context) => const ResumenPage(),
          '/ventas': (context) => const VentasPage(),
          '/gastos': (context) => const GastosPage(),
          '/productos': (context) => const ProductosPage(),
          '/perfil': (context) => const PerfilPage(),
          '/clientes': (context) => const ClientesSuperadminPage(),
          '/clientes-admin': (context) => const ClientesAdminPage(),
        },
      ),
    );
  }
}
