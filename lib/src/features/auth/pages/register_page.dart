import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../shared/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nifController = TextEditingController();
  final _sectorController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailEmpresaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nifController.dispose();
    _sectorController.dispose();
    _telefonoController.dispose();
    _emailEmpresaController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        businessName: _businessNameController.text.trim(),
      );

      // Obtener el usuario actualmente autenticado
      final currentUser = Supabase.instance.client.auth.currentUser;

      if (currentUser != null) {
        // Insertar datos de empresa en Supabase
        try {
          await Supabase.instance.client.from('empresas').insert({
            'admin_id': currentUser.id,
            'nombre_negocio': _businessNameController.text.trim(),
            'nif': _nifController.text.trim(),
            'sector': _sectorController.text.trim(),
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
          // Continuar incluso si falla la inserción de empresa
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✅ Registro exitoso',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        // Manejo de errores de autenticación
        if (e.toString().contains('already registered') ||
            e.toString().contains('email')) {
          _errorMessage = 'Este email ya está registrado';
        } else if (e.toString().contains('Invalid credentials') ||
            e.toString().contains('invalid')) {
          _errorMessage = 'Credenciales inválidas';
        } else if (e.toString().contains('rate limit')) {
          _errorMessage = 'Demasiados intentos. Intenta más tarde';
        } else {
          _errorMessage = e.toString();
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF533483),
              Color(0xFF0f3460),
              Color(0xFF16213e),
              Color(0xFF1a1a2e),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24.0 : 48.0,
                vertical: 24.0,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withOpacity(
                                    0.5,
                                  ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_add_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            'Crear Cuenta',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Únete a MarketMove hoy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // Full Name field
                          TextFormField(
                            controller: _fullNameController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Juan Pérez',
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Business Name field
                          TextFormField(
                            controller: _businessNameController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Mi Negocio',
                              prefixIcon: const Icon(
                                Icons.business_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre del negocio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'tu@email.com',
                              prefixIcon: const Icon(
                                Icons.email_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su email';
                              }
                              if (!value.contains('@')) {
                                return 'Por favor ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(
                                Icons.lock_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColors.mediumGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm password field
                          TextFormField(
                            controller: _confirmPasswordController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColors.mediumGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            obscureText: _obscureConfirmPassword,
                            onFieldSubmitted: (_) {
                              if (!_isLoading) {
                                _handleRegister();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme su contraseña';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // NIF field
                          TextFormField(
                            controller: _nifController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: '12345678A',
                              prefixIcon: const Icon(
                                Icons.credit_card_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el NIF';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Sector field
                          TextFormField(
                            controller: _sectorController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ej: Tecnología, Retail, Servicios',
                              prefixIcon: const Icon(
                                Icons.category_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el sector';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Teléfono field
                          TextFormField(
                            controller: _telefonoController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: '(+34) 123-456-789',
                              prefixIcon: const Icon(
                                Icons.phone_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          // Email Empresa field
                          TextFormField(
                            controller: _emailEmpresaController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'empresa@email.com',
                              prefixIcon: const Icon(
                                Icons.mail_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!value.contains('@')) {
                                  return 'Por favor ingrese un email válido';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Dirección field
                          TextFormField(
                            controller: _direccionController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Calle Principal 123',
                              prefixIcon: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ciudad field (full width)
                          TextFormField(
                            controller: _ciudadController,
                            style: const TextStyle(
                              color: AppColors.almostBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ciudad',
                              prefixIcon: const Icon(
                                Icons.location_city_rounded,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row: Provincia, Código Postal
                          Row(
                            children: [
                              // Provincia
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _provinciaController,
                                  style: const TextStyle(
                                    color: AppColors.almostBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Provincia',
                                    prefixIcon: const Icon(
                                      Icons.map_rounded,
                                      color: Colors.green,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Código Postal
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _codigoPostalController,
                                  style: const TextStyle(
                                    color: AppColors.almostBlack,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Código Postal',
                                    prefixIcon: const Icon(
                                      Icons.mail_outline_rounded,
                                      color: Colors.green,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (_errorMessage != null) const SizedBox(height: 16),

                          // Register button
                          AnimatedGradientButton(
                            text: _isLoading
                                ? 'Creando cuenta...'
                                : 'Crear Cuenta',
                            onPressed: _isLoading
                                ? () {}
                                : () => _handleRegister(),
                            gradient: AppColors.primaryGradient,
                            icon: Icons.arrow_forward_rounded,
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'o',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Login link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  children: [
                                    const TextSpan(text: '¿Ya tienes cuenta? '),
                                    TextSpan(
                                      text: 'Inicia sesión',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
