import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:marketmove_app/src/core/theme/app_theme.dart';
import 'package:marketmove_app/src/features/auth/pages/login_page.dart';
import 'package:marketmove_app/src/features/auth/pages/register_page.dart';
import 'package:marketmove_app/src/features/ventas/pages/ventas_page.dart';
import 'package:marketmove_app/src/features/gastos/pages/gastos_page.dart';
import 'package:marketmove_app/src/features/productos/pages/productos_page.dart';
import 'package:marketmove_app/src/features/resumen/pages/resumen_page.dart';
import 'package:marketmove_app/src/shared/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inicializar Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthProvider>(
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
        },
      ),
    );
  }
}
