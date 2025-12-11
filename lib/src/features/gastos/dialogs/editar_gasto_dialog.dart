import 'package:flutter/material.dart';
import '../../../core/models/gasto_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/repositories/data_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditarGastoDialog extends StatefulWidget {
  final Gasto gasto;
  final String userId;
  final Function(Gasto) onGastoActualizado;

  const EditarGastoDialog({
    super.key,
    required this.gasto,
    required this.userId,
    required this.onGastoActualizado,
  });

  @override
  State<EditarGastoDialog> createState() => _EditarGastoDialogState();
}

class _EditarGastoDialogState extends State<EditarGastoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  late TextEditingController _montoController;
  late TextEditingController _referenciaController;
  late String _categoria;
  late DataRepository _dataRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
    
    // Inicializar controllers con los valores actuales
    _descripcionController = TextEditingController(text: widget.gasto.descripcion);
    _montoController = TextEditingController(text: widget.gasto.monto.toStringAsFixed(2));
    _referenciaController = TextEditingController(text: widget.gasto.referencia ?? '');
    _categoria = widget.gasto.categoria;
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  void _actualizarGasto() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final gastoActualizado = Gasto(
          id: widget.gasto.id,
          userId: widget.userId,
          descripcion: _descripcionController.text,
          monto: double.parse(_montoController.text),
          categoria: _categoria,
          referencia: _referenciaController.text.isEmpty ? null : _referenciaController.text,
          fecha: widget.gasto.fecha,
          createdAt: widget.gasto.createdAt,
        );

        await _dataRepository.actualizarGasto(gastoActualizado);
        widget.onGastoActualizado(gastoActualizado);

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
                    '✏️ Editar Gasto',
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
                      borderSide: BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon: Icon(Icons.description_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _montoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Monto (€)',
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
                      borderSide: BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.euro_rounded, color: AppColors.error),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El monto es requerido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingresa un monto válido';
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
                      borderSide: BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.category_rounded, color: AppColors.error),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    'transporte',
                    'comida',
                    'alojamiento',
                    'entretenimiento',
                    'salud',
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
                      borderSide: BorderSide(color: AppColors.error, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.link_rounded, color: AppColors.primaryPurple),
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
                    onPressed: _isLoading ? null : _actualizarGasto,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Actualizar Gasto',
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
