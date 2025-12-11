import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientesAdminPage extends StatefulWidget {
  const ClientesAdminPage({super.key});

  @override
  State<ClientesAdminPage> createState() => _ClientesAdminPageState();
}

class _ClientesAdminPageState extends State<ClientesAdminPage>
    with SingleTickerProviderStateMixin {
  late DataRepository _dataRepository;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  
  // Variables para actualización sin parpadeo
  List<Map<String, dynamic>>? _ultimosClientes;

  @override
  void initState() {
    super.initState();
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _controller.forward();
  }

  // Stream que siempre devuelve datos actualizados
  Stream<List<Map<String, dynamic>>> _getClientesStream(String userId) {
    return _dataRepository.obtenerClientes(userId)
        .map((clientes) {
          // Cachear los últimos datos conocidos para evitar parpadeos
          _ultimosClientes = clientes;
          return clientes;
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.currentUser?.id ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mis Clientes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.people_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mis Clientes',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gestiona tus clientes registrados',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
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
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    setState(() {
                      // El filtrado se hace en el builder
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar cliente por nombre, email o empresa...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryBlue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botón para crear nuevo cliente
                AnimatedGradientButton(
                  text: 'Registrar Nuevo Cliente',
                  onPressed: _mostrarDialogoCrearCliente,
                  gradient: AppColors.primaryGradient,
                  icon: Icons.add_rounded,
                ),
                const SizedBox(height: 24),

                RepaintBoundary(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getClientesStream(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && _ultimosClientes == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final clientes = snapshot.data ?? _ultimosClientes ?? [];

                    // Filtrar clientes según búsqueda
                    final clientesFiltrados = clientes.where((cliente) {
                      final searchLower = _searchController.text.toLowerCase();
                      final nombre = (cliente['nombre_cliente'] as String? ?? '').toLowerCase();
                      final email = (cliente['email'] as String? ?? '').toLowerCase();
                      final razonSocial = (cliente['razon_social'] as String? ?? '').toLowerCase();
                      
                      return nombre.contains(searchLower) || 
                             email.contains(searchLower) || 
                             razonSocial.contains(searchLower);
                    }).toList();

                    if (clientes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 80,
                              color: AppColors.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay clientes registrados',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.mediumGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Presiona el + para crear uno',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (clientesFiltrados.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 80,
                              color: AppColors.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No encontramos resultados',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.mediumGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Intenta con otro término de búsqueda',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      key: ValueKey('clientes-list-${clientesFiltrados.length}'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = clientesFiltrados[index];
                        return KeyedSubtree(
                          key: ValueKey('cliente-${cliente['id']}'),
                          child: _buildClienteCard(cliente),
                        );
                      },
                    );
                  },
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoCrearCliente() {
    final nombreController = TextEditingController();
    final razonSocialController = TextEditingController();
    final emailController = TextEditingController();
    final telefonoController = TextEditingController();
    final nifController = TextEditingController();
    final direccionController = TextEditingController();
    final ciudadController = TextEditingController();
    final provinciaController = TextEditingController();
    final codigoPostalController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        title: Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2), width: 2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Crear Cliente',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditTextField('Nombre Completo', nombreController),
                _buildEditTextField('Razón Social', razonSocialController),
                _buildEditTextField('Email', emailController),
                _buildEditTextField('Teléfono', telefonoController),
                _buildEditTextField('NIF/CIF', nifController),
                _buildEditTextField('Dirección', direccionController),
                _buildEditTextField('Ciudad', ciudadController),
                _buildEditTextField('Provincia', provinciaController),
                _buildEditTextField('Código Postal', codigoPostalController),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.id;

              if (userId == null) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Error: Usuario no autenticado'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Validar que todos los campos estén completos
              if (nombreController.text.isEmpty ||
                  razonSocialController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  telefonoController.text.isEmpty ||
                  nifController.text.isEmpty ||
                  direccionController.text.isEmpty ||
                  ciudadController.text.isEmpty ||
                  provinciaController.text.isEmpty ||
                  codigoPostalController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Por favor completa todos los campos'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                // Obtener el empresa_id del usuario actual
                final empresaResponse = await Supabase.instance.client
                    .from('empresas')
                    .select('id')
                    .eq('admin_id', userId)
                    .single();

                final empresaId = empresaResponse['id'] as String;

                await Supabase.instance.client
                    .from('clientes_empresa')
                    .insert({
                      'empresa_id': empresaId,
                      'nombre_cliente': nombreController.text,
                      'razon_social': razonSocialController.text,
                      'email': emailController.text,
                      'telefono': telefonoController.text,
                      'nif_cliente': nifController.text,
                      'direccion': direccionController.text,
                      'ciudad': ciudadController.text,
                      'provincia': provinciaController.text,
                      'codigo_postal': codigoPostalController.text,
                      'tipo_cliente': 'empresa',
                      'estado': 'activo',
                    });

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Cliente creado correctamente'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
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
            icon: const Icon(Icons.check_rounded),
            label: const Text('Crear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClienteCard(Map<String, dynamic> cliente) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                      Icons.person_rounded,
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
                          cliente['nombre_cliente'] ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cliente['razon_social'] ?? 'Sin empresa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (cliente['email'] != null)
                          Text(
                            cliente['email'] ?? 'Sin email',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (cliente['telefono'] != null)
                          Text(
                            cliente['telefono'] ?? 'Sin teléfono',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _mostrarDetallesCliente(cliente);
                          },
                          icon: const Icon(Icons.info_rounded),
                          color: Colors.white,
                          tooltip: 'Ver Detalles',
                          iconSize: 22,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        IconButton(
                          onPressed: () {
                            _mostrarDialogoEditarCliente(cliente);
                          },
                          icon: const Icon(Icons.edit_rounded),
                          color: Colors.white,
                          tooltip: 'Editar',
                          iconSize: 22,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        IconButton(
                          onPressed: () {
                            _mostrarConfirmacionEliminar(cliente);
                          },
                          icon: const Icon(Icons.delete_rounded),
                          color: Colors.red.shade200,
                          tooltip: 'Eliminar',
                          iconSize: 22,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
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
    );
  }

  void _mostrarDetallesCliente(Map<String, dynamic> cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        title: Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2), width: 2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del Cliente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente['nombre_cliente'] ?? 'Sin nombre',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailSection('Información Personal', [
                  _buildDetailRow('Nombre Completo', cliente['nombre_cliente'] ?? 'No disponible'),
                  _buildDetailRow('Email', cliente['email'] ?? 'No disponible'),
                  _buildDetailRow('Teléfono', cliente['telefono'] ?? 'No disponible'),
                ]),
                const SizedBox(height: 12),
                _buildDetailSection('Información de Negocio', [
                  _buildDetailRow('Razón Social', cliente['razon_social'] ?? 'No disponible'),
                  _buildDetailRow('NIF/CIF', cliente['nif_cliente'] ?? 'No disponible'),
                  _buildDetailRow('Tipo de Cliente', cliente['tipo_cliente'] ?? 'No disponible'),
                ]),
                const SizedBox(height: 12),
                _buildDetailSection('Ubicación', [
                  _buildDetailRow('Dirección', cliente['direccion'] ?? 'No disponible'),
                  _buildDetailRow('Ciudad', cliente['ciudad'] ?? 'No disponible'),
                  _buildDetailRow('Provincia', cliente['provincia'] ?? 'No disponible'),
                  _buildDetailRow('Código Postal', cliente['codigo_postal'] ?? 'No disponible'),
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: const Text('Cerrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(left: BorderSide(color: AppColors.primaryBlue, width: 3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    final hasValue = value != null && (value as String).trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              hasValue ? value.toString() : 'No disponible',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: hasValue ? Colors.black87 : Colors.grey.shade400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
              context,
              'Resumen',
              Icons.dashboard_rounded,
              '/resumen',
            ),
            _buildDrawerItem(
              context,
              'Ventas',
              Icons.attach_money_rounded,
              '/ventas',
            ),
            _buildDrawerItem(
              context,
              'Gastos',
              Icons.money_off_rounded,
              '/gastos',
            ),
            _buildDrawerItem(
              context,
              'Productos',
              Icons.inventory_rounded,
              '/productos',
            ),
            _buildDrawerItem(
              context,
              'Clientes',
              Icons.people_rounded,
              '/clientes-admin',
            ),
            _buildDrawerItem(
              context,
              'Perfil',
              Icons.person_rounded,
              '/perfil',
            ),
            _buildDrawerItem(
              context,
              'Informe Diario',
              Icons.assessment_rounded,
              '/resumen',
            ),
            const Divider(color: Colors.white24),
            _buildDrawerItem(
              context,
              'Cerrar Sesión',
              Icons.logout_rounded,
              null,
              onTap: () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoEditarCliente(Map<String, dynamic> cliente) {
    final nombreController = TextEditingController(text: cliente['nombre_cliente'] ?? '');
    final razonSocialController = TextEditingController(text: cliente['razon_social'] ?? '');
    final emailController = TextEditingController(text: cliente['email'] ?? '');
    final telefonoController = TextEditingController(text: cliente['telefono'] ?? '');
    final nifController = TextEditingController(text: cliente['nif_cliente'] ?? '');
    final direccionController = TextEditingController(text: cliente['direccion'] ?? '');
    final ciudadController = TextEditingController(text: cliente['ciudad'] ?? '');
    final provinciaController = TextEditingController(text: cliente['provincia'] ?? '');
    final codigoPostalController = TextEditingController(text: cliente['codigo_postal'] ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        title: Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2), width: 2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Editar Cliente',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditTextField('Nombre Completo', nombreController),
                _buildEditTextField('Razón Social', razonSocialController),
                _buildEditTextField('Email', emailController),
                _buildEditTextField('Teléfono', telefonoController),
                _buildEditTextField('NIF/CIF', nifController),
                _buildEditTextField('Dirección', direccionController),
                _buildEditTextField('Ciudad', ciudadController),
                _buildEditTextField('Provincia', provinciaController),
                _buildEditTextField('Código Postal', codigoPostalController),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _dataRepository.actualizarCliente(
                  clienteId: cliente['id'],
                  nombre: nombreController.text,
                  email: emailController.text,
                  telefono: telefonoController.text,
                  empresa: razonSocialController.text,
                  direccion: direccionController.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Cliente actualizado correctamente'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
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
            icon: const Icon(Icons.check_rounded),
            label: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          hintText: 'Ingresa $label',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  void _mostrarConfirmacionEliminar(Map<String, dynamic> cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 8,
        title: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red.shade100, width: 2)),
          ),
          child: Row(
            children: [
              Icon(Icons.delete_forever_rounded, color: Colors.red.shade600, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Eliminar Cliente',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.red.shade600,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¿Estás seguro?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vas a eliminar permanentemente a',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente['nombre_cliente'] ?? 'este cliente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade600,
                      ),
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
                          Icon(Icons.info_rounded, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Esta acción no se puede deshacer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade700,
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _dataRepository.eliminarCliente(cliente['id']);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ Cliente eliminado correctamente'),
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: $e'),
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.delete_rounded),
            label: const Text('Eliminar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    String? route, {
    VoidCallback? onTap,
  }) {
    final isSelected = ModalRoute.of(context)?.settings.name == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryCyan : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap ?? (route != null ? () => Navigator.pushNamed(context, route) : null),
    );
  }
}
