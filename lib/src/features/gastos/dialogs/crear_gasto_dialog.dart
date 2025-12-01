import 'package:flutter/material.dart';
import '../../../core/models/gasto_model.dart';

class CrearGastoDialog extends StatefulWidget {
  final String userId;
  final Function(Gasto) onGastoCreado;

  const CrearGastoDialog({
    super.key,
    required this.userId,
    required this.onGastoCreado,
  });

  @override
  State<CrearGastoDialog> createState() => _CrearGastoDialogState();
}

class _CrearGastoDialogState extends State<CrearGastoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _referenciaController = TextEditingController();
  String _categoria = 'transporte';

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  void _crearGasto() {
    if (_formKey.currentState!.validate()) {
      final gasto = Gasto(
        userId: widget.userId,
        descripcion: _descripcionController.text,
        monto: double.parse(_montoController.text),
        categoria: _categoria,
        referencia: _referenciaController.text.isEmpty ? null : _referenciaController.text,
        fecha: DateTime.now(),
      );

      widget.onGastoCreado(gasto);
      // NO cerrar el diálogo aquí - lo hace la página
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '💰 Registrar Gasto',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción del Gasto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description_rounded),
                  ),
                  maxLines: 2,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Campo requerido';
                    if (double.tryParse(value!) == null) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                  items: [
                    'transporte',
                    'alimentación',
                    'servicios',
                    'arriendo',
                    'salarios',
                    'otros'
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _categoria = value ?? 'transporte');
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenciaController,
                  decoration: InputDecoration(
                    labelText: 'Referencia (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.link_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _crearGasto,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Registrar Gasto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
