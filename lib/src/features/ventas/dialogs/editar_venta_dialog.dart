import 'package:flutter/material.dart';
import '../../../core/models/venta_model.dart' as venta_model;
import '../../../core/models/producto_model.dart' as producto_model;
import '../../../core/models/database_models.dart' as db_models;
import '../../../shared/repositories/data_repository.dart';
import '../../../core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditarVentaDialog extends StatefulWidget {
  final venta_model.Venta venta;
  final String userId;
  final Function(venta_model.Venta) onVentaActualizada;

  const EditarVentaDialog({
    super.key,
    required this.venta,
    required this.userId,
    required this.onVentaActualizada,
  });

  @override
  State<EditarVentaDialog> createState() => _EditarVentaDialogState();
}

class _EditarVentaDialogState extends State<EditarVentaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _totalController;
  late TextEditingController _impuestoController;
  late TextEditingController _descuentoController;
  late TextEditingController _notasController;
  
  late DataRepository _dataRepository;
  List<producto_model.Producto> _productos = [];
  List<db_models.Cliente> _clientes = [];
  producto_model.Producto? _productoSeleccionado;
  db_models.Cliente? _clienteSeleccionado;
  late String _estado;
  late String _metodoPago;
  bool _cargandoProductos = true;
  bool _cargandoClientes = true;

  @override
  void initState() {
    super.initState();
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
    
    // Inicializar controllers con los valores actuales
    _totalController = TextEditingController(text: widget.venta.total.toStringAsFixed(2));
    _impuestoController = TextEditingController(text: widget.venta.impuesto.toStringAsFixed(2));
    _descuentoController = TextEditingController(text: widget.venta.descuento.toStringAsFixed(2));
    _notasController = TextEditingController(text: widget.venta.notas ?? '');
    _estado = widget.venta.estado;
    _metodoPago = widget.venta.metodoPago;
    
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final productosStream = _dataRepository.obtenerProductos(widget.userId);
      productosStream.listen((productos) {
        setState(() {
          _productos = productos;
          // Seleccionar el producto actual si existe
          if (widget.venta.productoId != null) {
            _productoSeleccionado = productos.firstWhere(
              (p) => p.id == widget.venta.productoId,
              orElse: () => productos.isNotEmpty ? productos.first : productos.last,
            );
          } else if (productos.isNotEmpty) {
            _productoSeleccionado = productos.first;
          }
          _cargandoProductos = false;
        });
      });

      // Cargar clientes del usuario
      final clientesStream = _dataRepository.obtenerClientes(widget.userId);
      clientesStream.listen((clientesData) {
        setState(() {
          _clientes = clientesData
              .map((data) => db_models.Cliente.fromJson(data))
              .toList();
          _cargandoClientes = false;
        });
      });
    } catch (e) {
      print('❌ Error cargando datos: $e');
      setState(() {
        _cargandoProductos = false;
        _cargandoClientes = false;
      });
    }
  }

  void _onProductoSeleccionado(producto_model.Producto? producto) {
    setState(() {
      _productoSeleccionado = producto;
      if (producto != null) {
        _totalController.text = producto.precio.toStringAsFixed(2);
      }
    });
  }

  void _onClienteSeleccionado(db_models.Cliente? cliente) {
    setState(() {
      _clienteSeleccionado = cliente;
    });
  }

  @override
  void dispose() {
    _totalController.dispose();
    _impuestoController.dispose();
    _descuentoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _actualizarVenta() {
    if (_formKey.currentState!.validate()) {
      if (_clienteSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un cliente')),
        );
        return;
      }

      final ventaActualizada = venta_model.Venta(
        id: widget.venta.id,
        userId: widget.userId,
        numeroVenta: widget.venta.numeroVenta,
        productoId: _productoSeleccionado?.id,
        clienteNombre: _clienteSeleccionado!.nombre,
        clienteEmail: _clienteSeleccionado!.email ?? '',
        clienteTelefono: _clienteSeleccionado!.telefono ?? '',
        total: double.parse(_totalController.text),
        impuesto: double.parse(_impuestoController.text),
        descuento: double.parse(_descuentoController.text),
        estado: _estado,
        metodoPago: _metodoPago,
        notas: _notasController.text.isEmpty ? null : _notasController.text,
        fecha: widget.venta.fecha,
        createdAt: widget.venta.createdAt,
        updatedAt: DateTime.now(),
      );

      widget.onVentaActualizada(ventaActualizada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withOpacity(0.2),
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
                      AppColors.successGradient.createShader(bounds),
                  child: Text(
                    '✏️ Editar Venta',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20.0 : 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 20.0),
                // Número de venta (solo lectura)
                TextFormField(
                  initialValue: 'Venta #${widget.venta.numeroVenta}',
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Número de Venta',
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
                          BorderSide(color: AppColors.success, width: 2),
                    ),
                    prefixIcon: Icon(Icons.receipt_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  readOnly: true,
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                // Selector de producto
                _cargandoProductos
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGray),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButtonFormField<producto_model.Producto>(
                        value: _productoSeleccionado,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Producto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColors.lightGray, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColors.lightGray, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppColors.success, width: 2),
                          ),
                          prefixIcon: Icon(Icons.shopping_bag_rounded,
                              color: AppColors.primaryPurple),
                          labelStyle: TextStyle(color: AppColors.darkGray),
                        ),
                        items: _productos
                            .map((producto) => DropdownMenuItem(
                                  value: producto,
                                  child: Text(
                                    producto.nombre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: AppColors.almostBlack),
                                  ),
                                ))
                            .toList(),
                        onChanged: _onProductoSeleccionado,
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
                // Selector de cliente
                _cargandoClientes
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGray),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButtonFormField<db_models.Cliente>(
                        value: _clienteSeleccionado,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Selecciona Cliente',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColors.lightGray, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColors.lightGray, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppColors.success, width: 2),
                          ),
                          prefixIcon: Icon(Icons.person_rounded,
                              color: AppColors.primaryPurple),
                          labelStyle: TextStyle(color: AppColors.darkGray),
                        ),
                        items: _clientes
                            .map((cliente) => DropdownMenuItem(
                                  value: cliente,
                                  child: Text(
                                    cliente.nombre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: AppColors.almostBlack),
                                  ),
                                ))
                            .toList(),
                        onChanged: _onClienteSeleccionado,
                        validator: (value) => value == null
                            ? 'Selecciona un cliente'
                            : null,
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
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Notas (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightGray, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.success, width: 2),
                    ),
                    prefixIcon: Icon(Icons.note_rounded, color: AppColors.primaryPurple),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _actualizarVenta,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Guardar Cambios',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
