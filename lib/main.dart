import 'package:flutter/material.dart';
import 'package:marketmove_app/src/features/auth/pages/login_page.dart';
import 'package:marketmove_app/src/features/auth/pages/register_page.dart';
import 'package:marketmove_app/src/features/ventas/pages/ventas_page.dart';
import 'package:marketmove_app/src/features/gastos/pages/gastos_page.dart';
import 'package:marketmove_app/src/features/productos/pages/productos_page.dart';
import 'package:marketmove_app/src/features/resumen/pages/resumen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarketMove',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/resumen': (context) => const ResumenPage(),
        '/ventas': (context) => const VentasPage(),
        '/gastos': (context) => const GastosPage(),
        '/productos': (context) => const ProductosPage(),
      },
    );
  }
}
