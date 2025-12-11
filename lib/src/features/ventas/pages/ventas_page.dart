import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/widgets/admin_only_page.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import '../../../core/models/venta_model.dart';
import '../dialogs/crear_venta_dialog.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late DataRepository _dataRepository;

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

  void _mostrarDialogoCrearVenta() {
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
      builder: (dialogContext) => CrearVentaDialog(
        userId: userId,
        onVentaCreada: (venta) async {
          try {
            // Crear la venta
            await _dataRepository.crearVenta(venta);

            // Cerrar el diálogo
            if (mounted) Navigator.pop(dialogContext);

            // Mostrar mensaje usando contexto de la página (no del diálogo)
            if (mounted) {
              ScaffoldMessenger.of(pageContext).showSnackBar(
                const SnackBar(
                  content: Text('✅ Venta creada exitosamente'),
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

  void _mostrarDialogoConfirmarEliminacion(Venta venta) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Eliminar Venta',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.all(20),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(
              color: Colors.red.shade200,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Estás seguro?',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vas a eliminar permanentemente la venta',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '#${venta.numeroVenta}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Esta acción no se puede deshacer',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (venta.id != null) {
                  await _dataRepository.eliminarVenta(venta.id!);

                  if (mounted) Navigator.pop(dialogContext);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Venta eliminada exitosamente'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {});
                  }
                }
              } catch (e) {
                if (mounted) Navigator.pop(dialogContext);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_rounded, size: 18),
                SizedBox(width: 8),
                Text(
                  'Eliminar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(20),
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
    return AdminOnlyPage(builder: (context) => _buildVentasContent(context));
  }

  Widget _buildVentasContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Ventas'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.successGradient),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.success.withOpacity(0.1), AppColors.offWhite],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen
                    ? 12.0
                    : (isMediumScreen ? 20.0 : 32.0),
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary cards - responsive like gastos_page
                  StreamBuilder<List<Venta>>(
                    stream: _dataRepository.obtenerVentas(userId),
                    builder: (context, snapshotVentas) {
                      double totalVentas = 0.0;
                      double ventasHoy = 0.0;

                      if (snapshotVentas.hasData &&
                          snapshotVentas.data != null) {
                        final ventas = snapshotVentas.data!;
                        final hoy = DateTime.now();
                        final inicioHoy = DateTime(
                          hoy.year,
                          hoy.month,
                          hoy.day,
                        );
                        final finHoy = DateTime(
                          hoy.year,
                          hoy.month,
                          hoy.day,
                          23,
                          59,
                          59,
                        );

                        // Calcular total de todas las ventas
                        totalVentas = ventas.fold(
                          0.0,
                          (sum, venta) => sum + venta.total,
                        );

                        // Calcular ventas de hoy
                        ventasHoy = ventas
                            .where((venta) {
                              final ventaDate = venta.fecha ?? DateTime.now();
                              return ventaDate.isAfter(inicioHoy) &&
                                  ventaDate.isBefore(finHoy);
                            })
                            .fold(
                              0.0,
                              (sum, venta) => sum + venta.total,
                            );
                      }

                      return isSmallScreen
                          ? Column(
                              children: [
                                _buildLargeFinancialCard(
                                  'Total Ventas',
                                  '€${totalVentas.toStringAsFixed(2)}',
                                  Icons.attach_money_rounded,
                                  AppColors.successGradient,
                                  isSmallScreen,
                                ),
                                const SizedBox(height: 16),
                                _buildLargeFinancialCard(
                                  'Ventas Hoy',
                                  '€${ventasHoy.toStringAsFixed(2)}',
                                  Icons.today_rounded,
                                  AppColors.primaryGradient,
                                  isSmallScreen,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _buildLargeFinancialCard(
                                    'Total Ventas',
                                    '${totalVentas.toStringAsFixed(2)}€',
                                    Icons.attach_money_rounded,
                                    AppColors.successGradient,
                                    isSmallScreen,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildLargeFinancialCard(
                                    'Ventas Hoy',
                                    '${ventasHoy.toStringAsFixed(2)}€',
                                    Icons.today_rounded,
                                    AppColors.primaryGradient,
                                    isSmallScreen,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 20.0 : 24.0),

                  // Add sale button
                  AnimatedGradientButton(
                    text: 'Registrar Nueva Venta',
                    onPressed: _mostrarDialogoCrearVenta,
                    gradient: AppColors.successGradient,
                    icon: Icons.add_rounded,
                  ),
                  SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                  // Sales list header
                  Text(
                    'Historial de Ventas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.almostBlack,
                      fontSize: isSmallScreen ? 18.0 : 20.0,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                  // Sales list
                  StreamBuilder<List<Venta>>(
                    stream: _dataRepository.obtenerVentas(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
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
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Container(
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
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      }

                      final ventas = snapshot.data ?? [];

                      if (ventas.isEmpty) {
                        return Container(
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
                                    gradient: AppColors.successGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_rounded,
                                    size: isSmallScreen ? 48.0 : 64.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                                Text(
                                  'No hay ventas registradas',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16.0 : 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Comienza registrando tu primera venta',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12.0 : 14.0,
                                    color: AppColors.mediumGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Container(
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
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ventas.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final venta = ventas[index];
                            return Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.successGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  venta.clienteNombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Venta #${venta.numeroVenta}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Total: ${venta.total.toStringAsFixed(2)}€ | Estado: ${venta.estado}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _mostrarDialogoConfirmarEliminacion(
                                      venta,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeFinancialCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient,
    bool isSmallScreen,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon, title, and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
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
              false,
              () => Navigator.pushReplacementNamed(context, '/resumen'),
            ),
            _buildDrawerItem(
              Icons.attach_money_rounded,
              'Ventas',
              true,
              () => Navigator.pop(context),
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
              () => Navigator.pushReplacementNamed(context, '/clientes-admin'),
            ),
            _buildDrawerItem(
              Icons.person_rounded,
              'Perfil',
              false,
              () => Navigator.pushReplacementNamed(context, '/perfil'),
            ),
            _buildDrawerItem(
              Icons.assessment_rounded,
              'Informe Diario',
              false,
              () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/resumen');
              },
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
