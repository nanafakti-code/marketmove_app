import 'package:flutter/material.dart';
import '../../../core/models/venta_model.dart' as venta_model;
import '../../../core/models/producto_model.dart' as producto_model;
import '../../../core/models/database_models.dart' as db_models;
import '../../../shared/repositories/data_repository.dart';
import '../../../core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrearVentaDialog extends StatefulWidget {
  final String userId;
  final Function(venta_model.Venta) onVentaCreada;

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
  final _numeroVentaController = TextEditingController(text: '000001');
  final _precioProductoController = TextEditingController();
  final _totalController = TextEditingController();
  final _impuestoController = TextEditingController(text: '0');
  final _descuentoController = TextEditingController(text: '0');
  final _notasController = TextEditingController();
  
  late DataRepository _dataRepository;
  List<producto_model.Producto> _productos = [];
  List<db_models.Cliente> _clientes = [];
  producto_model.Producto? _productoSeleccionado;
  db_models.Cliente? _clienteSeleccionado;
  String _estado = 'completada';
  String _metodoPago = 'efectivo';
  bool _cargandoProductos = true;
  bool _cargandoClientes = true;

  @override
  void initState() {
    super.initState();
    _dataRepository = DataRepository(supabase: Supabase.instance.client);
    
    // Añadir listeners para calcular total automáticamente
    _precioProductoController.addListener(_calcularTotal);
    _impuestoController.addListener(_calcularTotal);
    _descuentoController.addListener(_calcularTotal);
    
    _cargarDatos();
  }

  void _calcularTotal() {
    if (!mounted) return;
    
    try {
      final precio = double.tryParse(_precioProductoController.text) ?? 0.0;
      final impuesto = double.tryParse(_impuestoController.text) ?? 0.0;
      final descuento = double.tryParse(_descuentoController.text) ?? 0.0;
      
      // Fórmula: (Precio + Impuesto) - Descuento
      final total = (precio + impuesto) - descuento;
      
      setState(() {
        _totalController.text = total.toStringAsFixed(2);
      });
    } catch (e) {
      print('❌ Error calculando total: $e');
    }
  }

  Future<void> _cargarDatos() async {
    try {
      // Cargar productos del usuario
      final productosStream = _dataRepository.obtenerProductos(widget.userId);
      productosStream.listen((productos) {
        setState(() {
          _productos = productos;
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

      // Obtener el próximo número de venta (secuencial basado en conteo)
      final response = await Supabase.instance.client
          .from('ventas')
          .select('id')
          .eq('user_id', widget.userId);

      // El número de venta es secuencial: cantidad de ventas + 1
      final proximoNumero = (response as List).length + 1;
      setState(() {
        _numeroVentaController.text = proximoNumero.toString().padLeft(6, '0');
      });
    } catch (e) {
      print('❌ Error cargando datos: $e');
      // Si hay error, generar un número basado en timestamp
      final numero = DateTime.now().millisecondsSinceEpoch % 1000000;
      setState(() {
        _numeroVentaController.text = numero.toString().padLeft(6, '0');
        _cargandoProductos = false;
        _cargandoClientes = false;
      });
    }
  }

  void _onProductoSeleccionado(producto_model.Producto? producto) {
    setState(() {
      _productoSeleccionado = producto;
      if (producto != null) {
        _precioProductoController.text = producto.precio.toStringAsFixed(2);
        // Resetear impuesto y descuento a 0
        _impuestoController.text = '0';
        _descuentoController.text = '0';
        // Actualizar total solo con el precio del producto
        _totalController.text = producto.precio.toStringAsFixed(2);
      } else {
        _precioProductoController.clear();
        _totalController.clear();
        _impuestoController.text = '0';
        _descuentoController.text = '0';
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
    _numeroVentaController.dispose();
    _precioProductoController.dispose();
    _totalController.dispose();
    _impuestoController.dispose();
    _descuentoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _crearVenta() {
    if (_formKey.currentState!.validate()) {
      if (_productoSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Por favor selecciona un producto'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_clienteSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Por favor selecciona un cliente'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final venta = venta_model.Venta(
        userId: widget.userId,
        numeroVenta: _numeroVentaController.text,
        productoId: _productoSeleccionado!.id,
        clienteNombre: _clienteSeleccionado!.nombre,
        clienteEmail: _clienteSeleccionado!.email ?? '',
        clienteTelefono: _clienteSeleccionado!.telefono ?? '',
        total: double.parse(_totalController.text.isEmpty ? '0' : _totalController.text),
        impuesto: double.parse(_impuestoController.text.isEmpty ? '0' : _impuestoController.text),
        descuento: double.parse(_descuentoController.text.isEmpty ? '0' : _descuentoController.text),
        estado: _estado,
        metodoPago: _metodoPago,
        notas: _notasController.text.isEmpty ? null : _notasController.text,
        fecha: DateTime.now(),
      );

      widget.onVentaCreada(venta);
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
                    '🛒 Crear Venta',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20.0 : 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 20.0),
                // Número de venta (automático, no editable)
                TextFormField(
                  controller: _numeroVentaController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Número de Venta',
                    hintText: 'Auto-generado',
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
                          labelText: 'Selecciona Producto',
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
                            .map((producto) {
                              final sinStock = producto.cantidad <= 0;
                              final displayText = sinStock
                                  ? '${producto.nombre} (sin stock)'
                                  : producto.nombre;
                              return DropdownMenuItem(
                                value: producto,
                                enabled: !sinStock,
                                child: Text(
                                  displayText,
                                  style: TextStyle(
                                    color: sinStock
                                        ? AppColors.mediumGray
                                        : AppColors.almostBlack,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            })
                            .toList(),
                        onChanged: _onProductoSeleccionado,
                        validator: (value) => value == null
                            ? 'Selecciona un producto'
                            : null,
                      ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                // Precio del producto (automático, no editable)
                TextFormField(
                  controller: _precioProductoController,
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Precio del Producto',
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
                    prefixIcon: Icon(Icons.attach_money_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Selecciona un producto';
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
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
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                isSmallScreen
                    ? Column(
                        children: [
                          TextFormField(
                            controller: _impuestoController,
                            style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Impuesto',
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
                                borderSide: BorderSide(
                                    color: AppColors.success, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.percent_rounded,
                                  color: AppColors.primaryPurple),
                              labelStyle:
                                  TextStyle(color: AppColors.darkGray),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (double.tryParse(value) == null) {
                                  return 'Ingresa un número válido';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                          TextFormField(
                            controller: _descuentoController,
                            style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Descuento',
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
                                borderSide: BorderSide(
                                    color: AppColors.success, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.local_offer_rounded,
                                  color: AppColors.primaryPurple),
                              labelStyle:
                                  TextStyle(color: AppColors.darkGray),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (double.tryParse(value) == null) {
                                  return 'Ingresa un número válido';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _impuestoController,
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Impuesto',
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
                                  borderSide: BorderSide(
                                      color: AppColors.success, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.percent_rounded,
                                    color: AppColors.primaryPurple),
                                labelStyle:
                                    TextStyle(color: AppColors.darkGray),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'Número válido';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _descuentoController,
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Descuento',
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
                                  borderSide: BorderSide(
                                      color: AppColors.success, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.local_offer_rounded,
                                    color: AppColors.primaryPurple),
                                labelStyle:
                                    TextStyle(color: AppColors.darkGray),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'Número válido';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                DropdownButtonFormField<String>(
                  value: _estado,
                  decoration: InputDecoration(
                    labelText: 'Estado',
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
                    prefixIcon: Icon(Icons.check_circle_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                  ),
                  items: ['completada', 'pendiente', 'cancelada']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style:
                                    TextStyle(color: AppColors.almostBlack)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _estado = value ?? 'completada');
                  },
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                DropdownButtonFormField<String>(
                  value: _metodoPago,
                  decoration: InputDecoration(
                    labelText: 'Método de Pago',
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
                    prefixIcon: Icon(Icons.payment_rounded,
                        color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                  ),
                  items: ['efectivo', 'tarjeta', 'transferencia']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style:
                                    TextStyle(color: AppColors.almostBlack)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _metodoPago = value ?? 'efectivo');
                  },
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
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
                    prefixIcon:
                        Icon(Icons.note_rounded, color: AppColors.primaryPurple),
                    labelStyle: TextStyle(color: AppColors.darkGray),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.successGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _crearVenta,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12.0 : 16.0),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Crear Venta',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
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
