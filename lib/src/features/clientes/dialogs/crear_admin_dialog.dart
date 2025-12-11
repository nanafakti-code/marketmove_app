import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animated_button.dart';

class CrearAdminDialog extends StatefulWidget {
  const CrearAdminDialog({super.key});

  @override
  State<CrearAdminDialog> createState() => _CrearAdminDialogState();
}

class _CrearAdminDialogState extends State<CrearAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _nifController = TextEditingController();
  final _sectorController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailEmpresaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _businessNameController.dispose();
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

  Future<void> _handleCrearAdmin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Crear usuario usando signUp normal (no requiere permisos admin)
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {
          'full_name': _fullNameController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'role': 'admin',
        },
      );

      if (response.user != null) {
        // Insertar datos de empresa en Supabase
        try {
          await Supabase.instance.client.from('empresas').insert({
            'admin_id': response.user!.id,
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
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Administrador creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('already registered') ||
            e.toString().contains('email')) {
          _errorMessage = 'Este email ya está registrado';
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? size.width * 0.9 : 600,
          maxHeight: size.height * 0.9,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
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
                      'Crear Nuevo Administrador',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _fullNameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Campo requerido';
                          if (!value!.contains('@')) return 'Email inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.black87),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColors.primaryBlue,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Campo requerido';
                          if (value!.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Información de Empresa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _businessNameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Negocio',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.business,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nifController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'NIF/CIF',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.badge,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _sectorController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Sector',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.category,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _telefonoController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailEmpresaController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Email Empresa',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _direccionController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ciudadController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                labelText: 'Ciudad',
                                labelStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _provinciaController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                labelText: 'Provincia',
                                labelStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.map,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _codigoPostalController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          labelText: 'Código Postal',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.markunread_mailbox,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      AnimatedGradientButton(
                        text: _isLoading ? 'Creando...' : 'Crear Administrador',
                        onPressed: _isLoading ? () {} : _handleCrearAdmin,
                        gradient: AppColors.primaryGradient,
                        icon: Icons.person_add_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
