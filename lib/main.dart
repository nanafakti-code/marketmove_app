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

  // Cargar variables de entorno (si existen)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('⚠️ Archivo .env no encontrado. Usando valores por defecto o variables del sistema.');
    print('   Copia .env.example a .env y configura los valores.');
  }

  // Obtener valores de Supabase (con fallback a strings vacíos)
  final supabaseUrl = dotenv.maybeGet('SUPABASE_URL') ?? '';
  final supabaseAnonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

  // Inicializar Supabase (siempre, incluso con valores vacíos para demo)
  try {
    await Supabase.initialize(
      url: supabaseUrl.isEmpty ? 'https://example.supabase.co' : supabaseUrl,
      anonKey: supabaseAnonKey.isEmpty ? 'example-key' : supabaseAnonKey,
    );
  } catch (e) {
    print('⚠️ Error inicializando Supabase: $e');
    print('   La app funcionará en modo demo sin conexión a base de datos');
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
