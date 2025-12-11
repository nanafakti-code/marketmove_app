import 'package:flutter/material.dart';

class EditarClienteDialog extends StatefulWidget {
  final Map<String, dynamic> cliente;
  final Function(Map<String, dynamic>) onClienteActualizado;

  const EditarClienteDialog({
    required this.cliente,
    required this.onClienteActualizado,
    super.key,
  });

  @override
  State<EditarClienteDialog> createState() => _EditarClienteDialogState();
}

class _EditarClienteDialogState extends State<EditarClienteDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _negocioController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.cliente['full_name'] ?? '',
    );
    _negocioController = TextEditingController(
      text: widget.cliente['business_name'] ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _negocioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 8,
      title: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.blue.shade100, width: 2)),
        ),
        child: Row(
          children: [
            Icon(Icons.edit_rounded, color: Colors.blue.shade600, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Editar Cliente',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              enabled: false,
              initialValue: widget.cliente['email'] ?? '',
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Email (no editable)',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
                ),
                prefixIcon: const Icon(Icons.email_rounded, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
          ),
          child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _guardar,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check_rounded),
          label: Text(_isLoading ? 'Guardando...' : 'Guardar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _guardar() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      widget.onClienteActualizado({
        'full_name': _nombreController.text,
        'business_name': _negocioController.text,
      });
      // NO cerrar el diálogo aquí - dejarlo que lo cierre el callback de la página
    }
  }
}
