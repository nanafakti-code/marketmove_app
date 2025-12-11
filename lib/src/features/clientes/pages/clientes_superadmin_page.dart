import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import '../dialogs/crear_cliente_superadmin_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientesSuperadminPage extends StatefulWidget {
  const ClientesSuperadminPage({super.key});

  @override
  State<ClientesSuperadminPage> createState() => _ClientesSuperadminPageState();
}

class _ClientesSuperadminPageState extends State<ClientesSuperadminPage>
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
  Stream<List<Map<String, dynamic>>> _getClientesStream() {
    return _dataRepository.obtenerClientesAdmin()
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Usuarios Admin'),
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
                                const Text(
                                  'Usuarios Administrativos',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gestiona los usuarios administradores',
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
                    hintText: 'Buscar usuario por nombre, email o empresa...',
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
                
                // Botón para crear nuevo admin
                AnimatedGradientButton(
                  text: 'Crear Nuevo Admin',
                  onPressed: () {
                    _mostrarDialogoCrearAdmin();
                  },
                  gradient: AppColors.primaryGradient,
                  icon: Icons.person_add_rounded,
                ),
                const SizedBox(height: 24),
                RepaintBoundary(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getClientesStream(),
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

                      // Filtrar usuarios según búsqueda
                      final clientesFiltrados = clientes.where((usuario) {
                        final searchLower = _searchController.text.toLowerCase();
                        final nombre = (usuario['full_name'] as String? ?? '').toLowerCase();
                        final email = (usuario['email'] as String? ?? '').toLowerCase();
                        final empresa = (usuario['business_name'] as String? ?? '').toLowerCase();
                        
                        return nombre.contains(searchLower) || 
                               email.contains(searchLower) || 
                               empresa.contains(searchLower);
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
                                'No hay usuarios administrativos',
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
                        key: ValueKey('usuarios-list-${clientesFiltrados.length}'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final usuario = clientesFiltrados[index];
                          return KeyedSubtree(
                            key: ValueKey('usuario-${usuario['id']}'),
                            child: _buildClienteCard(usuario),
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

  Widget _buildClienteCard(Map<String, dynamic> usuario) {
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
                          usuario['full_name'] ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          usuario['business_name'] ?? 'Sin empresa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (usuario['email'] != null)
                          Text(
                            usuario['email'] ?? 'Sin email',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (usuario['phone'] != null)
                          Text(
                            usuario['phone'] ?? 'Sin teléfono',
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
                            _mostrarDetallesUsuario(usuario);
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
                            _mostrarDialogoEditarCliente(usuario);
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
                            _mostrarConfirmacionEliminar(usuario);
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

  void _mostrarDetallesUsuario(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = screenSize.width < 500;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 24,
            vertical: 24,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header - Fixed
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 20,
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2), width: 2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primaryBlue,
                          size: isSmallScreen ? 22 : 26,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalles Completos',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              usuario['full_name'] ?? 'Sin nombre',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content - Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información Personal
                        _buildDetailSection('👤 Información Personal', [
                          _buildDetailRowResponsive('Nombre Completo', usuario['full_name'] ?? 'No disponible', isSmallScreen),
                          _buildDetailRowResponsive('Email', usuario['email'] ?? 'No disponible', isSmallScreen),
                          _buildDetailRowResponsive('Teléfono', usuario['phone'] ?? 'No disponible', isSmallScreen),
                          _buildDetailRowResponsive('Rol', usuario['role']?.toString().toUpperCase() ?? 'No disponible', isSmallScreen),
                        ]),
                        const SizedBox(height: 12),
                        // Información de Empresa
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: Supabase.instance.client
                              .from('empresas')
                              .select()
                              .eq('admin_id', usuario['id'] as String),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return _buildDetailSection('🏢 Información de Empresa', [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('No hay empresa registrada', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                                )
                              ]);
                            }

                            final empresa = snapshot.data!.first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailSection('🏢 Información de Empresa', [
                                  _buildDetailRowResponsive('Nombre Negocio', empresa['nombre_negocio'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('NIF', empresa['nif'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Sector', empresa['sector'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Teléfono Empresa', empresa['telefono'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Email Empresa', empresa['email_empresa'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Dirección', empresa['direccion'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Ciudad', empresa['ciudad'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Provincia', empresa['provincia'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Código Postal', empresa['codigo_postal'] ?? 'No disponible', isSmallScreen),
                                  _buildDetailRowResponsive('Estado', empresa['estado'] ?? 'No disponible', isSmallScreen),
                                ]),
                                const SizedBox(height: 12),
                                // Clientes de esta empresa
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: Supabase.instance.client
                                      .from('clientes_empresa')
                                      .select()
                                      .eq('empresa_id', empresa['id'] as String),
                                  builder: (context, clientesSnapshot) {
                                    if (!clientesSnapshot.hasData) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: SizedBox(
                                          height: 40,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    final clientes = clientesSnapshot.data ?? [];
                                    return _buildDetailSection(
                                      '👥 Clientes (${clientes.length})',
                                      clientes.isEmpty
                                          ? [
                                              const Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text('Sin clientes registrados', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                                              )
                                            ]
                                          : [
                                              Container(
                                                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    clientes.length,
                                                    (index) {
                                                      final cliente = clientes[index];
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          if (index > 0)
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                                              child: Divider(height: 1, color: Colors.grey.shade300),
                                                            ),
                                                          if (index > 0) const SizedBox(height: 8),
                                                          Text(
                                                            cliente['nombre_cliente'] ?? 'Sin nombre',
                                                            style: TextStyle(
                                                              fontSize: isSmallScreen ? 12 : 13,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black87,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                          const SizedBox(height: 3),
                                                          Text(
                                                            '📧 ${cliente['email'] ?? 'No disponible'}',
                                                            style: TextStyle(
                                                              fontSize: isSmallScreen ? 10 : 11,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            '☎️ ${cliente['telefono'] ?? 'No disponible'}',
                                                            style: TextStyle(
                                                              fontSize: isSmallScreen ? 10 : 11,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            '🏢 ${cliente['razon_social'] ?? 'No disponible'}',
                                                            style: TextStyle(
                                                              fontSize: isSmallScreen ? 10 : 11,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildDetailRowResponsive(String label, dynamic value, bool isSmallScreen) {
    final hasValue = value != null && (value as String).trim().isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 13,
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
                fontSize: isSmallScreen ? 12 : 13,
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
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
              context,
              'Panel Principal',
              Icons.dashboard_rounded,
              '/resumen',
            ),
            _buildDrawerItem(
              context,
              'Clientes',
              Icons.people_rounded,
              '/clientes',
            ),
            _buildDrawerItem(
              context,
              'Perfil',
              Icons.person_rounded,
              '/perfil',
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

  void _mostrarDialogoCrearAdmin() {
    showDialog(
      context: context,
      builder: (context) => CrearClienteSuperadminDialog(
        onClienteCreado: (cliente) {
          // Aquí se puede manejar la creación del cliente
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Cliente creado correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogoEditarCliente(Map<String, dynamic> usuario) {
    final nombreController = TextEditingController(text: usuario['full_name'] ?? '');
    final empresaController = TextEditingController(text: usuario['business_name'] ?? '');
    final emailController = TextEditingController(text: usuario['email'] ?? '');
    final telefonoController = TextEditingController(text: usuario['phone'] ?? '');

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
                'Editar Usuario',
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
                _buildEditTextField('Nombre de Empresa', empresaController),
                _buildEditTextField('Email', emailController),
                _buildEditTextField('Teléfono', telefonoController),
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
                await Supabase.instance.client
                    .from('users')
                    .update({
                      'full_name': nombreController.text,
                      'business_name': empresaController.text,
                      'phone': telefonoController.text,
                    })
                    .eq('id', usuario['id']);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Usuario actualizado correctamente'),
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

  void _mostrarConfirmacionEliminar(Map<String, dynamic> usuario) {
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
                  'Eliminar Usuario',
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
                      usuario['full_name'] ?? 'este usuario',
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
                await Supabase.instance.client
                    .from('users')
                    .delete()
                    .eq('id', usuario['id']);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ Usuario eliminado correctamente'),
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
