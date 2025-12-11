import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/venta_model.dart';
import '../../../core/models/gasto_model.dart';
import '../../../shared/repositories/data_repository.dart';
import '../../../shared/providers/auth_provider.dart';

class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key});

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late DataRepository _dataRepository;

  @override
  void initState() {
    super.initState();
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index * 0.08).clamp(0.0, 1.0),
            ((index * 0.08) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      6,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                (index * 0.08).clamp(0.0, 1.0),
                ((index * 0.08) + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOut,
              ),
            ),
          ),
    );

    _controller.forward();
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
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';
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

        // Si es superadmin, mostrar dashboard diferente
        if (userRole == 'superadmin') {
          return _buildSuperadminDashboard(context, size, isSmallScreen);
        }

        // Si es admin, mostrar dashboard normal
        return _buildAdminDashboard(
          context,
          size,
          isSmallScreen,
          isMediumScreen,
          userId,
        );
      },
    );
  }

  String _getClientesRoute(String userRole) {
    return userRole == 'superadmin' ? '/clientes' : '/clientes-admin';
  }

  Widget _buildSuperadminDashboard(
    BuildContext context,
    Size size,
    bool isSmallScreen,
  ) {
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final clientesRoute = _getClientesRoute('superadmin');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Panel SuperAdmin'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      drawer: _buildSuperadminDrawer(context, clientesRoute),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryPurple.withOpacity(0.1),
              AppColors.offWhite,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12.0 : (isMediumScreen ? 24.0 : 32.0),
              vertical: isSmallScreen ? 12.0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome card
                FadeTransition(
                  opacity: _cardAnimations[0],
                  child: SlideTransition(
                    position: _slideAnimations[0],
                    child: Container(
                      padding: EdgeInsets.all(
                        isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0),
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 10.0 : 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.admin_panel_settings_rounded,
                                  color: Colors.white,
                                  size: isSmallScreen ? 28.0 : 32.0,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido SuperAdmin',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 16.0 : 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 2.0 : 4.0),
                                    Text(
                                      'Panel de administración',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12.0 : 14.0,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                // Estadísticas generales
                Text(
                  'Estadísticas Generales',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.almostBlack,
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                // Total de clientes
                FadeTransition(
                  opacity: _cardAnimations[1],
                  child: SlideTransition(
                    position: _slideAnimations[1],
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _dataRepository.obtenerClientesAdmin(),
                      builder: (context, snapshot) {
                        final totalClientes = snapshot.data?.length ?? 0;
                        return _buildStatCard(
                          'Clientes Registrados',
                          totalClientes.toString(),
                          Icons.people_rounded,
                          AppColors.primaryGradient,
                          isSmallScreen: isSmallScreen,
                          isMediumScreen: isMediumScreen,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                // Acciones rápidas
                Text(
                  'Acciones',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.almostBlack,
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmallScreen ? 2 : (isMediumScreen ? 3 : 4),
                  crossAxisSpacing: isSmallScreen ? 12.0 : 16.0,
                  mainAxisSpacing: isSmallScreen ? 12.0 : 16.0,
                  children: [
                    FadeTransition(
                      opacity: _cardAnimations[2],
                      child: _buildQuickActionCard(
                        context,
                        'Clientes',
                        Icons.people_rounded,
                        AppColors.primaryGradient,
                        clientesRoute,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    FadeTransition(
                      opacity: _cardAnimations[3],
                      child: _buildQuickActionCard(
                        context,
                        'Mi Perfil',
                        Icons.person_rounded,
                        AppColors.primaryGradient,
                        '/perfil',
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(
    BuildContext context,
    Size size,
    bool isSmallScreen,
    bool isMediumScreen,
    String userId,
  ) {
    final clientesRoute = _getClientesRoute('admin');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Panel de Resumen'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      drawer: _buildAdminDrawer(context, clientesRoute),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryPurple.withOpacity(0.1),
              AppColors.offWhite,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome card
                FadeTransition(
                  opacity: _cardAnimations[0],
                  child: SlideTransition(
                    position: _slideAnimations[0],
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.dashboard_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido a MarketMove',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Gestiona tu negocio de forma eficiente',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Financial summary title
                Text(
                  'Resumen Financiero',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.almostBlack,
                  ),
                ),
                const SizedBox(height: 16),

                // Financial cards
                StreamBuilder<List<Venta>>(
                  stream: _dataRepository.obtenerVentas(userId),
                  builder: (context, snapshotVentas) {
                    double totalVentas = 0.0;
                    if (snapshotVentas.hasData && snapshotVentas.data != null) {
                      totalVentas = snapshotVentas.data!.fold(
                        0.0,
                        (sum, venta) => sum + venta.total,
                      );
                    }

                    return StreamBuilder<List<Gasto>>(
                      stream: _dataRepository.obtenerGastos(userId),
                      builder: (context, snapshotGastos) {
                        double totalGastos = 0.0;
                        if (snapshotGastos.hasData &&
                            snapshotGastos.data != null) {
                          totalGastos = snapshotGastos.data!.fold(
                            0.0,
                            (sum, gasto) => sum + gasto.monto,
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            if (isSmallScreen) {
                              return Column(
                                children: [
                                  FadeTransition(
                                    opacity: _cardAnimations[1],
                                    child: SlideTransition(
                                      position: _slideAnimations[1],
                                      child: _buildFinancialCard(
                                        'Ventas',
                                        '€${totalVentas.toStringAsFixed(2)}',
                                        Icons.trending_up_rounded,
                                        AppColors.successGradient,
                                        '',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FadeTransition(
                                    opacity: _cardAnimations[2],
                                    child: SlideTransition(
                                      position: _slideAnimations[2],
                                      child: _buildFinancialCard(
                                        'Gastos',
                                        '€${totalGastos.toStringAsFixed(2)}',
                                        Icons.trending_down_rounded,
                                        AppColors.errorGradient,
                                        '',
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: FadeTransition(
                                      opacity: _cardAnimations[1],
                                      child: SlideTransition(
                                        position: _slideAnimations[1],
                                        child: _buildFinancialCard(
                                          'Ventas',
                                          '${totalVentas.toStringAsFixed(2)}€',
                                          Icons.trending_up_rounded,
                                          AppColors.successGradient,
                                          '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FadeTransition(
                                      opacity: _cardAnimations[2],
                                      child: SlideTransition(
                                        position: _slideAnimations[2],
                                        child: _buildFinancialCard(
                                          'Gastos',
                                          '${totalGastos.toStringAsFixed(2)}€',
                                          Icons.trending_down_rounded,
                                          AppColors.errorGradient,
                                          '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Balance card with dynamic calculation
                StreamBuilder<List<Venta>>(
                  stream: _dataRepository.obtenerVentas(userId),
                  builder: (context, ventasSnapshot) {
                    return StreamBuilder<List<Gasto>>(
                      stream: _dataRepository.obtenerGastos(userId),
                      builder: (context, gastosSnapshot) {
                        if (!ventasSnapshot.hasData ||
                            !gastosSnapshot.hasData) {
                          return FadeTransition(
                            opacity: _cardAnimations[3],
                            child: SlideTransition(
                              position: _slideAnimations[3],
                              child: _buildFinancialCard(
                                'Balance',
                                '0.00€',
                                Icons.account_balance_wallet_rounded,
                                AppColors.primaryGradient,
                                '0%',
                              ),
                            ),
                          );
                        }

                        final ventas = ventasSnapshot.data ?? [];
                        final gastos = gastosSnapshot.data ?? [];

                        final totalVentas = ventas.fold(
                          0.0,
                          (sum, venta) => sum + venta.total,
                        );
                        final totalGastos = gastos.fold(
                          0.0,
                          (sum, gasto) => sum + gasto.monto,
                        );
                        final balance = totalVentas - totalGastos;

                        return FadeTransition(
                          opacity: _cardAnimations[3],
                          child: SlideTransition(
                            position: _slideAnimations[3],
                            child: _buildFinancialCard(
                              'Balance',
                              '${balance.toStringAsFixed(2)}€',
                              Icons.account_balance_wallet_rounded,
                              AppColors.primaryGradient,
                              balance >= 0 ? '+' : '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Quick actions title
                Text(
                  'Acciones Rápidas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.almostBlack,
                  ),
                ),
                const SizedBox(height: 16),

                // Quick actions grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmallScreen ? 2 : (isMediumScreen ? 3 : 4),
                  crossAxisSpacing: isSmallScreen ? 12.0 : 16.0,
                  mainAxisSpacing: isSmallScreen ? 12.0 : 16.0,
                  children: [
                    FadeTransition(
                      opacity: _cardAnimations[4],
                      child: _buildQuickActionCard(
                        context,
                        'Ventas',
                        Icons.attach_money_rounded,
                        AppColors.successGradient,
                        '/ventas',
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    FadeTransition(
                      opacity: _cardAnimations[4],
                      child: _buildQuickActionCard(
                        context,
                        'Gastos',
                        Icons.money_off_rounded,
                        AppColors.errorGradient,
                        '/gastos',
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    FadeTransition(
                      opacity: _cardAnimations[5],
                      child: _buildQuickActionCard(
                        context,
                        'Productos',
                        Icons.inventory_rounded,
                        AppColors.purpleGradient,
                        '/productos',
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    FadeTransition(
                      opacity: _cardAnimations[5],
                      child: _buildQuickActionCard(
                        context,
                        'Clientes',
                        Icons.people_rounded,
                        AppColors.primaryGradient,
                        clientesRoute,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ],
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

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    String? route, {
    bool isSmallScreen = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            if (route != null) {
              Navigator.pushNamed(context, route);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad en desarrollo')),
              );
            }
          },
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: isSmallScreen ? 28.0 : 32.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient, {
    bool isSmallScreen = false,
    bool isMediumScreen = false,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0),
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isSmallScreen ? 24.0 : 28.0,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12.0 : 14.0,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 24.0 : 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuperadminDrawer(BuildContext context, String clientesRoute) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
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
                      Icons.admin_panel_settings_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SuperAdmin',
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
              'Panel Principal',
              true,
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.people_rounded,
              'Clientes',
              false,
              () => Navigator.pushReplacementNamed(context, clientesRoute),
            ),
            _buildDrawerItem(
              Icons.person_rounded,
              'Perfil',
              false,
              () => Navigator.pushReplacementNamed(context, '/perfil'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            _buildDrawerItem(Icons.logout_rounded, 'Cerrar Sesión', false, () {
              context.read<AuthProvider>().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            }),
          ],
        ),
      ),
    );
  }




  Widget _buildAdminDrawer(BuildContext context, String clientesRoute) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
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
              true,
              () => Navigator.pop(context),
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
              false,
              () => Navigator.pushReplacementNamed(context, '/gastos'),
            ),
            _buildDrawerItem(
              Icons.inventory_rounded,
              'Productos',
              false,
              () => Navigator.pushReplacementNamed(context, '/productos'),
            ),
            _buildDrawerItem(
              Icons.people_rounded,
              'Clientes',
              false,
              () => Navigator.pushReplacementNamed(context, clientesRoute),
            ),
            _buildDrawerItem(
              Icons.person_rounded,
              'Perfil',
              false,
              () => Navigator.pushReplacementNamed(context, '/perfil'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            _buildDrawerItem(Icons.logout_rounded, 'Cerrar Sesión', false, () {
              context.read<AuthProvider>().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            }),
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
      leading: Icon(
        icon,
        color: selected ? AppColors.primaryCyan : Colors.white70,
      ),
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
