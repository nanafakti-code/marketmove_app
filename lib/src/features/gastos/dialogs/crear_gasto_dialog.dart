import 'package:flutter/material.dart';
import '../../../core/models/gasto_model.dart';
import '../../../core/theme/app_colors.dart';

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
      backgroundColor: AppColors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título con gradient
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.errorGradient.createShader(bounds),
                  child: Text(
                    '💰 Registrar Gasto',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descripcionController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Descripción del Gasto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon: Icon(Icons.description_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _montoController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon: Icon(Icons.attach_money_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
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
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.category_rounded, color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    'transporte',
                    'alimentación',
                    'servicios',
                    'arriendo',
                    'salarios',
                    'otros'
                  ]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: TextStyle(color: AppColors.almostBlack)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _categoria = value ?? 'transporte');
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenciaController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Referencia (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon: Icon(Icons.link_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.errorGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _crearGasto,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
