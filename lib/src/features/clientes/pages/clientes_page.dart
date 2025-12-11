import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/repositories/data_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dialogs/crear_cliente_dialog.dart';
import '../dialogs/editar_cliente_dialog.dart';
import '../dialogs/detalles_empresa_dialog.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage>
    with SingleTickerProviderStateMixin {
  late DataRepository _dataRepository;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();

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
        title: const Text('Clientes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoCrearCliente,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add_rounded),
      ),
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
                                  'Gestiona todos tus clientes registrados',
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
                    hintText: 'Buscar cliente por nombre, email o negocio...',
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
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _dataRepository.obtenerClientesAdmin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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

                    final clientes = snapshot.data ?? [];

                    // Filtrar clientes según búsqueda
                    final clientesFiltrados = clientes.where((cliente) {
                      final searchLower = _searchController.text.toLowerCase();
                      final nombre = (cliente['full_name'] as String? ?? '').toLowerCase();
                      final email = (cliente['email'] as String? ?? '').toLowerCase();
                      final razonSocial = (cliente['business_name'] as String? ?? '').toLowerCase();
                      
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = clientesFiltrados[index];
                        return _buildClienteCard(cliente);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoCrearCliente() {
    showDialog(
      context: context,
      builder: (dialogContext) => CrearClienteDialog(
        onClienteCreado: (nuevoCliente) async {
          try {
            // Crear usuario en Supabase Auth
            final response = await Supabase.instance.client.auth.signUp(
              email: nuevoCliente['email'],
              password: nuevoCliente['password'],
            );

            if (response.user != null) {
              // Actualizar perfil en tabla public.users
              await Supabase.instance.client
                  .from('users')
                  .update({
                    'full_name': nuevoCliente['full_name'],
                    'business_name': nuevoCliente['business_name'],
                    'role': 'admin',
                  })
                  .eq('id', response.user!.id);

              // Insertar en tabla empresas
              try {
                await Supabase.instance.client.from('empresas').insert({
                  'admin_id': response.user!.id,
                  'nombre_negocio': nuevoCliente['nombre_negocio'],
                  'nif': nuevoCliente['nif'],
                  'sector': nuevoCliente['sector'],
                  'telefono': nuevoCliente['telefono'],
                  'email_empresa': nuevoCliente['email_empresa'],
                  'direccion': nuevoCliente['direccion'],
                  'ciudad': nuevoCliente['ciudad'],
                  'provincia': nuevoCliente['provincia'],
                  'codigo_postal': nuevoCliente['codigo_postal'],
                  'estado': 'activa',
                });
              } catch (e) {
                print('Nota: Error al insertar en empresas: $e');
              }

              if (mounted) {
                // Solo cerrar el diálogo y mostrar mensaje - no hacer nada más
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ Cliente creado: ${nuevoCliente['email']}',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              Navigator.of(context).pop();
              
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
          child: Row(
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
                      cliente['full_name'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente['business_name'] ?? 'Sin empresa',
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
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    if (cliente['telefono'] != null)
                      Text(
                        cliente['telefono'] ?? 'Sin teléfono',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DetallesEmpresaDialog(cliente: cliente),
                      );
                    },
                    icon: const Icon(Icons.info_rounded),
                    color: Colors.white,
                    tooltip: 'Ver Detalles',
                    iconSize: 24,
                  ),
                  IconButton(
                    onPressed: () => _mostrarDialogoEditar(cliente),
                    icon: const Icon(Icons.edit_rounded),
                    color: Colors.white,
                    tooltip: 'Editar',
                    iconSize: 24,
                  ),
                  IconButton(
                    onPressed: () => _mostrarConfirmacionEliminar(cliente),
                    icon: const Icon(Icons.delete_rounded),
                    color: Colors.red.shade200,
                    tooltip: 'Eliminar',
                    iconSize: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoEditar(Map<String, dynamic> cliente) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return EditarClienteDialog(
          cliente: cliente,
          onClienteActualizado: (datosActualizados) async {
            try {
              // Actualizar usuario en tabla users
              await _dataRepository.actualizarUsuario(
                cliente['id'],
                datosActualizados,
              );

              // Actualizar empresa en tabla empresas si cambió el nombre del negocio
              if (datosActualizados['business_name'] != null) {
                try {
                  await Supabase.instance.client
                      .from('empresas')
                      .update({
                        'nombre_negocio': datosActualizados['business_name'],
                        'updated_at': DateTime.now().toIso8601String(),
                      })
                      .eq('admin_id', cliente['id']);
                } catch (e) {
                  print('Nota: Tabla empresas no encontrada o sin registros: $e');
                }
              }

              if (mounted) {
                // Cerrar el diálogo
                Navigator.of(context).pop();
                
                // Mostrar el mensaje
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Cliente y empresa actualizados'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      },
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
                      cliente['full_name'] ?? 'este cliente',
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
                await _dataRepository.eliminarUsuario(cliente['id']);
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
                  Navigator.pop(context);
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
