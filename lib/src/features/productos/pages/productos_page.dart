import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/widgets/admin_only_page.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import '../../../core/models/producto_model.dart';
import '../dialogs/crear_producto_dialog.dart';
import '../dialogs/editar_producto_dialog.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage>
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

  void _mostrarDialogoCrearProducto() {
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
      builder: (dialogContext) => CrearProductoDialog(
        userId: userId,
        onProductoCreado: (producto) async {
          try {
            // Crear el producto
            await _dataRepository.crearProducto(producto);

            // Cerrar el diálogo
            if (mounted) Navigator.pop(dialogContext);

            // Mostrar mensaje usando contexto de la página (no del diálogo)
            if (mounted) {
              ScaffoldMessenger.of(pageContext).showSnackBar(
                const SnackBar(
                  content: Text('✅ Producto creado exitosamente'),
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

  void _mostrarDialogoEditarProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditarProductoDialog(
        producto: producto,
        onProductoActualizado: (productoActualizado) async {
          try {
            // Actualizar el producto
            await _dataRepository.actualizarProducto(
              productoActualizado.id!,
              productoActualizado,
            );

            // Cerrar el diálogo primero
            if (mounted) Navigator.pop(context);

            // Mostrar mensaje después
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Producto actualizado exitosamente'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {});
            }
          } catch (e) {
            // Cerrar el diálogo incluso si hay error
            if (mounted) Navigator.pop(context);

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
      ),
    );
  }

  void _mostrarDialogoConfirmarEliminacion(Producto producto) {
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
              'Eliminar Producto',
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
                'Vas a eliminar permanentemente el producto',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                producto.nombre,
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
                if (producto.id != null) {
                  await _dataRepository.eliminarProducto(producto.id!);

                  if (mounted) Navigator.pop(dialogContext);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Producto eliminado exitosamente'),
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
    return AdminOnlyPage(builder: (context) => _buildProductosContent(context));
  }

  Widget _buildProductosContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Productos / Stock'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda en desarrollo')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary cards with dynamic data
                  StreamBuilder<List<Producto>>(
                    stream: _dataRepository.obtenerProductos(userId),
                    builder: (context, snapshot) {
                      final productos = snapshot.data ?? [];
                      final totalProductos = productos.length;
                      final stockBajo = productos
                          .where((p) => p.cantidad < 10)
                          .length;

                      return isSmallScreen
                          ? Column(
                              children: [
                                _buildLargeFinancialCard(
                                  'Total Productos',
                                  totalProductos.toString(),
                                  Icons.inventory_2_rounded,
                                  AppColors.purpleGradient,
                                  isSmallScreen,
                                ),
                                const SizedBox(height: 16),
                                _buildLargeFinancialCard(
                                  'Stock Bajo',
                                  stockBajo.toString(),
                                  Icons.warning_rounded,
                                  AppColors.warningGradient,
                                  isSmallScreen,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _buildLargeFinancialCard(
                                    'Total Productos',
                                    totalProductos.toString(),
                                    Icons.inventory_2_rounded,
                                    AppColors.purpleGradient,
                                    isSmallScreen,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildLargeFinancialCard(
                                    'Stock Bajo',
                                    stockBajo.toString(),
                                    Icons.warning_rounded,
                                    AppColors.warningGradient,
                                    isSmallScreen,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Add product button
                  AnimatedGradientButton(
                    text: 'Agregar Nuevo Producto',
                    onPressed: _mostrarDialogoCrearProducto,
                    gradient: AppColors.purpleGradient,
                    icon: Icons.add_rounded,
                  ),
                  const SizedBox(height: 32),

                  // Products list header
                  Text(
                    'Inventario',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.almostBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Products list
                  StreamBuilder<List<Producto>>(
                    stream: _dataRepository.obtenerProductos(userId),
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

                      final productos = snapshot.data ?? [];

                      if (productos.isEmpty) {
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
                                    gradient: AppColors.purpleGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.inventory_rounded,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No hay productos registrados',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Comienza agregando tu primer producto',
                                  style: TextStyle(
                                    fontSize: 14,
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
                          itemCount: productos.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final producto = productos[index];
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.purpleGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.inventory_2_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                producto.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.almostBlack,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'SKU: ${producto.sku}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Stock: ${producto.cantidad} | Precio: ${producto.precio.toStringAsFixed(2)}€',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: AppColors.primaryCyan,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _mostrarDialogoEditarProducto(producto);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _mostrarDialogoConfirmarEliminacion(
                                        producto,
                                      );
                                    },
                                  ),
                                ],
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
          Expanded(
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
              decoration: BoxDecoration(gradient: AppColors.primaryGradient),
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
              false,
              () => Navigator.pushReplacementNamed(context, '/gastos'),
            ),
            _buildDrawerItem(
              Icons.inventory_rounded,
              'Productos',
              true,
              () => Navigator.pop(context),
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
              () => Navigator.pushReplacementNamed(context, '/resumen'),
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
