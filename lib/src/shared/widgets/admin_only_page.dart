import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AdminOnlyPage extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const AdminOnlyPage({
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return FutureBuilder<String>(
      future: authProvider.getUserRole(),
      builder: (context, roleSnapshot) {
        if (roleSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userRole = roleSnapshot.data ?? 'admin';

        // Si es superadmin, redirigir al panel principal
        if (userRole == 'superadmin') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/resumen');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return builder(context);
      },
    );
  }
}
