import 'package:flutter/material.dart';

class CrearClienteDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onClienteCreado;

  const CrearClienteDialog({
    required this.onClienteCreado,
    super.key,
  });

  @override
  State<CrearClienteDialog> createState() => _CrearClienteDialogState();
}

class _CrearClienteDialogState extends State<CrearClienteDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nombreController;
  late TextEditingController _negocioController;
  late TextEditingController _nifController;
  late TextEditingController _sectorController;
  late TextEditingController _telefonoController;
  late TextEditingController _emailEmpresaController;
  late TextEditingController _direccionController;
  late TextEditingController _ciudadController;
  late TextEditingController _provinciaController;
  late TextEditingController _codigoPostalController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nombreController = TextEditingController();
    _negocioController = TextEditingController();
    _nifController = TextEditingController();
    _sectorController = TextEditingController();
    _telefonoController = TextEditingController();
    _emailEmpresaController = TextEditingController();
    _direccionController = TextEditingController();
    _ciudadController = TextEditingController();
    _provinciaController = TextEditingController();
    _codigoPostalController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _negocioController.dispose();
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
                border: Border(bottom: BorderSide(color: Colors.blue.shade100, width: 2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_add_rounded, color: Colors.blue.shade600, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Crear Nuevo Cliente',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 16 : 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
              // Email field
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.email_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email requerido';
                  if (!value!.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Contraseña requerida';
                  if ((value?.length ?? 0) < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nombreController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.person_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Nombre requerido';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Nombre del Negocio field
              TextFormField(
                controller: _negocioController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Nombre del Negocio',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.business_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Negocio requerido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nifController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'NIF/CIF',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.badge_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sectorController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Sector',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.category_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefonoController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.phone_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailEmpresaController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Email Empresa',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.email_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _direccionController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),

              // Ciudad field (full width)
              TextFormField(
                controller: _ciudadController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Ciudad',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),

              // Row: Provincia, Código Postal
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _provinciaController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Provincia',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codigoPostalController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Código Postal',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
                ),
              ),
            ),
            // Footer with buttons
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: const Text('Cancelar', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _guardar,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      _isLoading ? 'Creando...' : 'Crear',
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  void _guardar() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      widget.onClienteCreado({
        // Datos de usuario (tabla users)
        'email': _emailController.text,
        'password': _passwordController.text,
        'full_name': _nombreController.text,
        'business_name': _negocioController.text,
        'role': 'admin',
        
        // Datos de empresa (tabla empresas)
        'nombre_negocio': _negocioController.text,
        'nif': _nifController.text.isNotEmpty ? _nifController.text : null,
        'sector': _sectorController.text.isNotEmpty ? _sectorController.text : null,
        'telefono': _telefonoController.text.isNotEmpty ? _telefonoController.text : null,
        'email_empresa': _emailEmpresaController.text.isNotEmpty ? _emailEmpresaController.text : null,
        'direccion': _direccionController.text.isNotEmpty ? _direccionController.text : null,
        'ciudad': _ciudadController.text.isNotEmpty ? _ciudadController.text : null,
        'provincia': _provinciaController.text.isNotEmpty ? _provinciaController.text : null,
        'codigo_postal': _codigoPostalController.text.isNotEmpty ? _codigoPostalController.text : null,
      });
      Navigator.pop(context);
    }
  }
}
