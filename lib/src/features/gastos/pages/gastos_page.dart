import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import '../../../core/models/gasto_model.dart';
import '../dialogs/crear_gasto_dialog.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late DataRepository _dataRepository;
  List<Gasto> _gastos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Inicializar repositorio
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
  }

  void _mostrarDialogoCrearGasto() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error: Usuario no autenticado')),
      );
      return;
    }

    final pageContext = context; // Guardar contexto de la página
    
    showDialog(
      context: context,
      builder: (dialogContext) => CrearGastoDialog(
        userId: userId,
        onGastoCreado: (gasto) async {
          try {
            // Crear el gasto
            await _dataRepository.crearGasto(gasto);
            
            // Cerrar el diálogo
            if (mounted) Navigator.pop(dialogContext);
            
            // Mostrar mensaje usando contexto de la página (no del diálogo)
            if (mounted) {
              ScaffoldMessenger.of(pageContext).showSnackBar(
                const SnackBar(
                  content: Text('✅ Gasto registrado exitosamente'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {});
            }
          } catch (e) {
            // Cerrar el diálogo incluso si hay error
            if (mounted) Navigator.pop(dialogContext);
            
            if (mounted) {
              ScaffoldMessenger.of(pageContext).showSnackBar(
                SnackBar(
                  content: Text('❌ Error: $e'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gastos'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.errorGradient),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.error.withOpacity(0.1), AppColors.offWhite],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary cards
                  isSmallScreen
                      ? Column(
                          children: [
                            _buildSummaryCard(
                              'Total Gastos',
                              '\$0.00',
                              Icons.money_off_rounded,
                              AppColors.errorGradient,
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryCard(
                              'Gastos Hoy',
                              '0',
                              Icons.today_rounded,
                              AppColors.warningGradient,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Total Gastos',
                                '\$0.00',
                                Icons.money_off_rounded,
                                AppColors.errorGradient,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                'Gastos Hoy',
                                '0',
                                Icons.today_rounded,
                                AppColors.warningGradient,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 24),

                  // Add expense button
                  AnimatedGradientButton(
                    text: 'Registrar Nuevo Gasto',
                    onPressed: _mostrarDialogoCrearGasto,
                    gradient: AppColors.errorGradient,
                    icon: Icons.add_rounded,
                  ),
                  const SizedBox(height: 32),
                  // Expenses list header
                  Text(
                    'Historial de Gastos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.almostBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expenses list placeholder
                  Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: AppColors.errorGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.receipt_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No hay gastos registrados',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Comienza registrando tu primer gasto',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFef4444), Color(0xFFdc2626), Color(0xFFb91c1c)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: AppColors.errorGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'MarketMove',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              Icons.dashboard_rounded,
              'Resumen',
              false,
              () => Navigator.pushReplacementNamed(context, '/resumen'),
            ),
            _buildDrawerItem(
              Icons.attach_money_rounded,
              'Ventas',
              false,
              () => Navigator.pushReplacementNamed(context, '/ventas'),
            ),
            _buildDrawerItem(
              Icons.money_off_rounded,
              'Gastos',
              true,
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.inventory_rounded,
              'Productos',
              false,
              () => Navigator.pushReplacementNamed(context, '/productos'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            _buildDrawerItem(
              Icons.logout_rounded,
              'Cerrar Sesión',
              false,
              () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
