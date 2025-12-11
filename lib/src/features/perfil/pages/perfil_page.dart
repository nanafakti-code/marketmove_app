import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/providers/auth_provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  late TextEditingController _nombreController;
  late TextEditingController _negocioController;
  
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorMessage;

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

    _nombreController = TextEditingController();
    _negocioController = TextEditingController();
    
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user != null) {
      final userData = user.userMetadata;
      _nombreController.text = userData?['full_name'] as String? ?? '';
      _negocioController.text = userData?['business_name'] as String? ?? '';
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;
      
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Actualizar metadata del usuario
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': _nombreController.text,
            'business_name': _negocioController.text,
          },
        ),
      );

      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Perfil actualizado exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: $e';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _cancelEdit() {
    _loadUserData();
    setState(() {
      _isEditing = false;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nombreController.dispose();
    _negocioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    return FutureBuilder<String>(
      future: authProvider.getUserRole(),
      builder: (context, roleSnapshot) {
        final userRole = roleSnapshot.data ?? 'admin';
        
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Perfil'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            ),
          ),
          drawer: userRole == 'superadmin' 
            ? _buildSuperadminDrawer(context)
            : _buildAdminDrawer(context),
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
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : (isMediumScreen ? 32.0 : 48.0),
                vertical: isSmallScreen ? 12.0 : 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile header
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0)),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: isSmallScreen ? 48.0 : (isMediumScreen ? 56.0 : 64.0),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                        Text(
                          _nombreController.text.isNotEmpty
                              ? _nombreController.text
                              : 'Usuario',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18.0 : (isMediumScreen ? 22.0 : 24.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isSmallScreen ? 4.0 : 8.0),
                        Text(
                          user?.email ?? 'email@ejemplo.com',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 14.0),
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                  // Form section
                  if (!_isEditing)
                    // View mode
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nombre field - view only
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nombre Completo',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11.0 : 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mediumGray,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
                              Text(
                                _nombreController.text.isNotEmpty
                                    ? _nombreController.text
                                    : 'No especificado',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14.0 : 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.almostBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                        // Negocio field - view only (from empresas table)
                        FutureBuilder<String>(
                          future: authProvider.getEmpresaNombre(),
                          builder: (context, snapshot) {
                            final nombreEmpresa = snapshot.data ?? 'Cargando...';
                            return Container(
                              padding: EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre del Negocio',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11.0 : 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mediumGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 6.0 : 8.0),
                                  Text(
                                    nombreEmpresa.isNotEmpty
                                        ? nombreEmpresa
                                        : 'No especificado',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14.0 : 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.almostBlack,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                        // Email field - view only, non-editable
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0)),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email (No editable)',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11.0 : 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mediumGray,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
                              Text(
                                user?.email ?? 'email@ejemplo.com',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14.0 : 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.almostBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                        // Edit button
                        AnimatedGradientButton(
                          text: 'Editar Perfil',
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          gradient: AppColors.primaryGradient,
                          icon: Icons.edit_rounded,
                        ),
                      ],
                    )
                  else
                    // Edit mode
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nombre field - editable
                        TextFormField(
                          controller: _nombreController,
                          style: TextStyle(
                            color: AppColors.almostBlack,
                            fontSize: isSmallScreen ? 14.0 : 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tu nombre completo',
                            hintStyle: TextStyle(fontSize: isSmallScreen ? 13.0 : 14.0),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                              padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: isSmallScreen ? 16.0 : 20.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.95),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12.0 : 16.0,
                              vertical: isSmallScreen ? 12.0 : 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                        // Negocio field - editable
                        TextFormField(
                          controller: _negocioController,
                          style: TextStyle(
                            color: AppColors.almostBlack,
                            fontSize: isSmallScreen ? 14.0 : 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nombre de tu negocio',
                            hintStyle: TextStyle(fontSize: isSmallScreen ? 13.0 : 14.0),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                              padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.business_rounded,
                                color: Colors.white,
                                size: isSmallScreen ? 16.0 : 20.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.95),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12.0 : 16.0,
                              vertical: isSmallScreen ? 12.0 : 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                        // Email field - disabled, view only
                        TextFormField(
                          initialValue: user?.email ?? 'email@ejemplo.com',
                          style: TextStyle(
                            color: AppColors.mediumGray,
                            fontSize: isSmallScreen ? 14.0 : 16.0,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Email (No editable)',
                            hintStyle: TextStyle(fontSize: isSmallScreen ? 13.0 : 14.0),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                              padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.email_rounded,
                                color: Colors.white,
                                size: isSmallScreen ? 16.0 : 20.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12.0 : 16.0,
                              vertical: isSmallScreen ? 12.0 : 16.0,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12.0 : 16.0),

                        // Error message
                        if (_errorMessage != null)
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isSmallScreen ? 12.0 : 14.0,
                              ),
                            ),
                          ),
                        if (_errorMessage != null) SizedBox(height: isSmallScreen ? 16.0 : 24.0),

                        // Buttons
                        isSmallScreen
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isSaving ? null : _cancelEdit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: AppColors.almostBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen ? 13.0 : 14.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  AnimatedGradientButton(
                                    text: _isSaving ? 'Guardando...' : 'Guardar',
                                    onPressed: _isSaving ? () {} : _updateProfile,
                                    gradient: AppColors.primaryGradient,
                                    icon: Icons.save_rounded,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isSaving ? null : _cancelEdit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          color: AppColors.almostBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: isSmallScreen ? 12.0 : 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isMediumScreen ? 8.0 : 12.0),
                                  Expanded(
                                    child: AnimatedGradientButton(
                                      text: _isSaving ? 'Guardando...' : 'Guardar Cambios',
                                      onPressed: _isSaving ? () {} : _updateProfile,
                                      gradient: AppColors.primaryGradient,
                                      icon: Icons.save_rounded,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildSuperadminDrawer(BuildContext context) {
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
              false,
              () => Navigator.pushReplacementNamed(context, '/resumen'),
            ),
            _buildDrawerItem(
              Icons.people_rounded,
              'Clientes',
              false,
              () => Navigator.pushReplacementNamed(context, '/clientes'),
            ),
            _buildDrawerItem(
              Icons.person_rounded,
              'Perfil',
              true,
              () => Navigator.pop(context),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            _buildDrawerItem(
              Icons.logout_rounded,
              'Cerrar Sesión',
              false,
              () {
                context.read<AuthProvider>().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
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
              true,
              () => Navigator.pop(context),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            _buildDrawerItem(
              Icons.logout_rounded,
              'Cerrar Sesión',
              false,
              () {
                context.read<AuthProvider>().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.primaryCyan : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
