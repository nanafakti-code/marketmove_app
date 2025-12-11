import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/services/email_service.dart';

class CrearClienteSuperadminDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onClienteCreado;

  const CrearClienteSuperadminDialog({
    required this.onClienteCreado,
    super.key,
  });

  @override
  State<CrearClienteSuperadminDialog> createState() => _CrearClienteSuperadminDialogState();
}

class _CrearClienteSuperadminDialogState extends State<CrearClienteSuperadminDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _businessNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nifController;
  late TextEditingController _telefonoController;
  late TextEditingController _emailEmpresaController;
  late TextEditingController _direccionController;
  late TextEditingController _ciudadController;
  late TextEditingController _provinciaController;
  late TextEditingController _codigoPostalController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _businessNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nifController = TextEditingController();
    _telefonoController = TextEditingController();
    _emailEmpresaController = TextEditingController();
    _direccionController = TextEditingController();
    _ciudadController = TextEditingController();
    _provinciaController = TextEditingController();
    _codigoPostalController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nifController.dispose();
    _telefonoController.dispose();
    _emailEmpresaController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final maxWidth = isSmallScreen ? screenSize.width * 0.9 : 600.0;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : screenSize.width * 0.1,
        vertical: 24,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: screenSize.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Crear Nuevo Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Información Personal
                      _buildSectionTitle('Información Personal'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Nombre Completo',
                        _fullNameController,
                        Icons.person_rounded,
                        'Ej: Juan Pérez',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Email',
                        _emailController,
                        Icons.email_rounded,
                        'Ej: juan@ejemplo.com',
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        'Contraseña',
                        _passwordController,
                        _obscurePassword,
                        (value) {
                          setState(() {
                            _obscurePassword = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        'Confirmar Contraseña',
                        _confirmPasswordController,
                        _obscureConfirmPassword,
                        (value) {
                          setState(() {
                            _obscureConfirmPassword = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Teléfono',
                        _telefonoController,
                        Icons.phone_rounded,
                        'Ej: +34 612 345 678',
                      ),
                      const SizedBox(height: 24),
                      // Información de Empresa
                      _buildSectionTitle('Información de Empresa'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Nombre de Empresa',
                        _businessNameController,
                        Icons.business_rounded,
                        'Ej: Empresa S.L.',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'NIF/CIF',
                        _nifController,
                        Icons.badge_rounded,
                        'Ej: 12345678A',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Email de Empresa',
                        _emailEmpresaController,
                        Icons.email_rounded,
                        'Ej: contacto@empresa.com',
                      ),
                      const SizedBox(height: 24),
                      // Dirección
                      _buildSectionTitle('Dirección'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Dirección',
                        _direccionController,
                        Icons.location_on_rounded,
                        'Ej: Calle Principal, 123',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Ciudad',
                        _ciudadController,
                        Icons.location_city_rounded,
                        'Ej: Madrid',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Provincia',
                        _provinciaController,
                        Icons.map_rounded,
                        'Ej: Madrid',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        'Código Postal',
                        _codigoPostalController,
                        Icons.pin_rounded,
                        'Ej: 28001',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _crearAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check_rounded, color: Colors.white),
                    label: Text(
                      _isLoading ? 'Creando...' : 'Crear',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true,
        fillColor: Colors.grey.shade50,
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
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label es requerido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    Function(bool) onToggle,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Ingresa tu contraseña',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primaryBlue),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => onToggle(!obscure),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
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
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label es requerida';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        if (controller == _confirmPasswordController &&
            value != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );
  }

  void _crearAdmin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear usuario usando signUp en lugar de adminAuth.createUser
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {
          'full_name': _fullNameController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'role': 'admin',
        },
      );

      final newUserId = response.user?.id;

      if (newUserId == null) {
        throw Exception('No se pudo crear el usuario');
      }

      // Crear registro en tabla users
      try {
        await Supabase.instance.client.from('users').insert({
          'id': newUserId,
          'email': _emailController.text.trim(),
          'full_name': _fullNameController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'role': 'admin',
        });
      } catch (usersError) {
        debugPrint('Error al insertar en tabla users: $usersError');
      }

      // Insertar datos de empresa
      try {
        await Supabase.instance.client.from('empresas').insert({
          'admin_id': newUserId,
          'nombre_negocio': _businessNameController.text.trim(),
          'nif': _nifController.text.trim(),
          'sector': '',
          'telefono': _telefonoController.text.trim(),
          'email_empresa': _emailEmpresaController.text.trim(),
          'direccion': _direccionController.text.trim(),
          'ciudad': _ciudadController.text.trim(),
          'provincia': _provinciaController.text.trim(),
          'codigo_postal': _codigoPostalController.text.trim(),
          'estado': 'activa',
        });
      } catch (empresasError) {
        debugPrint('Error al insertar en tabla empresas: $empresasError');
      }

      // Enviar email de bienvenida
      try {
        final emailService = EmailService();
        await emailService.initialize();
        await emailService.sendWelcomeEmail(
          userEmail: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          businessName: _businessNameController.text.trim(),
        );
      } catch (emailError) {
        debugPrint('[SuperadminDialog] Error al enviar email de bienvenida: $emailError');
        // Continuar aunque falle el email
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Admin creado correctamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error al crear admin';
        
        if (e.toString().contains('already registered') ||
            e.toString().contains('email') ||
            e.toString().contains('duplicate')) {
          errorMessage = 'Este email ya está registrado';
        } else if (e.toString().contains('Invalid credentials') ||
            e.toString().contains('invalid')) {
          errorMessage = 'Credenciales inválidas';
        } else if (e.toString().contains('rate limit')) {
          errorMessage = 'Demasiados intentos. Intenta más tarde';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
