import 'package:flutter/material.dart';
import '../../../core/models/venta_model.dart';

class CrearVentaDialog extends StatefulWidget {
  final String userId;
  final Function(Venta) onVentaCreada;

  const CrearVentaDialog({
    super.key,
    required this.userId,
    required this.onVentaCreada,
  });

  @override
  State<CrearVentaDialog> createState() => _CrearVentaDialogState();
}

class _CrearVentaDialogState extends State<CrearVentaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _numeroVentaController = TextEditingController();
  final _clienteNombreController = TextEditingController();
  final _clienteEmailController = TextEditingController();
  final _clienteTelefonoController = TextEditingController();
  final _totalController = TextEditingController();
  final _impuestoController = TextEditingController(text: '0');
  final _descuentoController = TextEditingController(text: '0');
  final _notasController = TextEditingController();
  String _estado = 'completada';
  String _metodoPago = 'efectivo';

  @override
  void dispose() {
    _numeroVentaController.dispose();
    _clienteNombreController.dispose();
    _clienteEmailController.dispose();
    _clienteTelefonoController.dispose();
    _totalController.dispose();
    _impuestoController.dispose();
    _descuentoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _crearVenta() {
    if (_formKey.currentState!.validate()) {
      final venta = Venta(
        userId: widget.userId,
        numeroVenta: _numeroVentaController.text,
        clienteNombre: _clienteNombreController.text,
        clienteEmail: _clienteEmailController.text,
        clienteTelefono: _clienteTelefonoController.text,
        total: double.parse(_totalController.text),
        impuesto: double.parse(_impuestoController.text),
        descuento: double.parse(_descuentoController.text),
        estado: _estado,
        metodoPago: _metodoPago,
        notas: _notasController.text.isEmpty ? null : _notasController.text,
        fecha: DateTime.now(),
      );

      widget.onVentaCreada(venta);
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
                  '🛒 Crear Venta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numeroVentaController,
                  decoration: InputDecoration(
                    labelText: 'Número de Venta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.receipt_rounded),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _clienteNombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Cliente',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_rounded),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _clienteEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email del Cliente',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_rounded),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Campo requerido';
                    if (!value!.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _clienteTelefonoController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono del Cliente',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_rounded),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalController,
                  decoration: InputDecoration(
                    labelText: 'Total',
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _impuestoController,
                        decoration: InputDecoration(
                          labelText: 'Impuesto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.percent_rounded),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _descuentoController,
                        decoration: InputDecoration(
                          labelText: 'Descuento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.local_offer_rounded),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _estado,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.check_circle_rounded),
                  ),
                  items: ['completada', 'pendiente', 'cancelada']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _estado = value ?? 'completada');
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _metodoPago,
                  decoration: InputDecoration(
                    labelText: 'Método de Pago',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.payment_rounded),
                  ),
                  items: ['efectivo', 'tarjeta', 'transferencia']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _metodoPago = value ?? 'efectivo');
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notasController,
                  decoration: InputDecoration(
                    labelText: 'Notas (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.note_rounded),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _crearVenta,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Crear Venta',
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
