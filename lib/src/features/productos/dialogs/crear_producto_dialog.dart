import 'package:flutter/material.dart';
import '../../../core/models/producto_model.dart';
import '../../../core/theme/app_colors.dart';

class CrearProductoDialog extends StatefulWidget {
  final String userId;
  final Function(Producto) onProductoCreado;

  const CrearProductoDialog({
    super.key,
    required this.userId,
    required this.onProductoCreado,
  });

  @override
  State<CrearProductoDialog> createState() => _CrearProductoDialogState();
}

class _CrearProductoDialogState extends State<CrearProductoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _skuController = TextEditingController();
  final _categoriaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _skuController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  void _crearProducto() {
    if (_formKey.currentState!.validate()) {
      final producto = Producto(
        userId: widget.userId,
        nombre: _nombreController.text,
        precio: double.parse(_precioController.text),
        cantidad: int.parse(_cantidadController.text),
        sku: _skuController.text,
        categoria: _categoriaController.text,
      );

      widget.onProductoCreado(producto);
      // NO cerrar el diálogo aquí - lo hace la página
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.all(isSmallScreen ? 12.0 : 24.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.9,
          maxWidth: isSmallScreen ? double.infinity : 600,
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
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
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.purpleGradient.createShader(bounds),
                  child: Text(
                    '➕ Crear Producto',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20.0 : 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 20.0),
                TextFormField(
                  controller: _nombreController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nombre del Producto',
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
                          BorderSide(color: AppColors.primaryPurple, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.inventory_2_rounded, color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                TextFormField(
                  controller: _precioController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Precio',
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
                          BorderSide(color: AppColors.primaryPurple, width: 2),
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
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                TextFormField(
                  controller: _cantidadController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Cantidad en Stock',
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
                          BorderSide(color: AppColors.primaryPurple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.inventory_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Campo requerido';
                    if (int.tryParse(value!) == null) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                TextFormField(
                  controller: _skuController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'SKU/Código',
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
                          BorderSide(color: AppColors.primaryPurple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.qr_code_2_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                TextFormField(
                  controller: _categoriaController,
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
                          BorderSide(color: AppColors.primaryPurple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.category_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _crearProducto,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Crear Producto',
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
