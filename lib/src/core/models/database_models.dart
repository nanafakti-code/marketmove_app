// Modelos Dart para MarketMove App - Entidades de Base de Datos

// ============================================
// USUARIO
// ============================================
class Usuario {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? businessName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Usuario({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.businessName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String?,
    phone: json['phone'] as String?,
    businessName: json['business_name'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
    'phone': phone,
    'business_name': businessName,
    'avatar_url': avatarUrl,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Usuario copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? businessName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Usuario(
    id: id ?? this.id,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    businessName: businessName ?? this.businessName,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

// ============================================
// PRODUCTO
// ============================================
class Producto {
  final String id;
  final String userId;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int cantidad;
  final String? sku;
  final String? categoria;
  final String? imagenUrl;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Producto({
    required this.id,
    required this.userId,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.cantidad,
    this.sku,
    this.categoria,
    this.imagenUrl,
    this.activo = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    nombre: json['nombre'] as String,
    descripcion: json['descripcion'] as String?,
    precio: (json['precio'] as num).toDouble(),
    cantidad: json['cantidad'] as int,
    sku: json['sku'] as String?,
    categoria: json['categoria'] as String?,
    imagenUrl: json['imagen_url'] as String?,
    activo: json['activo'] as bool? ?? true,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'cantidad': cantidad,
    'sku': sku,
    'categoria': categoria,
    'imagen_url': imagenUrl,
    'activo': activo,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Producto copyWith({
    String? id,
    String? userId,
    String? nombre,
    String? descripcion,
    double? precio,
    int? cantidad,
    String? sku,
    String? categoria,
    String? imagenUrl,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Producto(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    precio: precio ?? this.precio,
    cantidad: cantidad ?? this.cantidad,
    sku: sku ?? this.sku,
    categoria: categoria ?? this.categoria,
    imagenUrl: imagenUrl ?? this.imagenUrl,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

// ============================================
// VENTA
// ============================================
class Venta {
  final String id;
  final String userId;
  final String? numeroVenta;
  final String? clienteNombre;
  final String? clienteEmail;
  final String? clienteTelefono;
  final double total;
  final double impuesto;
  final double descuento;
  final String estado; // completada, pendiente, cancelada
  final String? metodoPago; // efectivo, tarjeta, transferencia, cheque
  final String? notas;
  final DateTime fecha;
  final DateTime createdAt;
  final DateTime updatedAt;

  Venta({
    required this.id,
    required this.userId,
    this.numeroVenta,
    this.clienteNombre,
    this.clienteEmail,
    this.clienteTelefono,
    required this.total,
    this.impuesto = 0,
    this.descuento = 0,
    this.estado = 'completada',
    this.metodoPago,
    this.notas,
    required this.fecha,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    numeroVenta: json['numero_venta'] as String?,
    clienteNombre: json['cliente_nombre'] as String?,
    clienteEmail: json['cliente_email'] as String?,
    clienteTelefono: json['cliente_telefono'] as String?,
    total: (json['total'] as num).toDouble(),
    impuesto: (json['impuesto'] as num?)?.toDouble() ?? 0,
    descuento: (json['descuento'] as num?)?.toDouble() ?? 0,
    estado: json['estado'] as String? ?? 'completada',
    metodoPago: json['metodo_pago'] as String?,
    notas: json['notas'] as String?,
    fecha: DateTime.parse(json['fecha'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'numero_venta': numeroVenta,
    'cliente_nombre': clienteNombre,
    'cliente_email': clienteEmail,
    'cliente_telefono': clienteTelefono,
    'total': total,
    'impuesto': impuesto,
    'descuento': descuento,
    'estado': estado,
    'metodo_pago': metodoPago,
    'notas': notas,
    'fecha': fecha.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

// ============================================
// DETALLE DE VENTA
// ============================================
class VentaDetalle {
  final String id;
  final String ventaId;
  final String? productoId;
  final String productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final DateTime createdAt;

  VentaDetalle({
    required this.id,
    required this.ventaId,
    this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.createdAt,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) => VentaDetalle(
    id: json['id'] as String,
    ventaId: json['venta_id'] as String,
    productoId: json['producto_id'] as String?,
    productoNombre: json['producto_nombre'] as String,
    cantidad: json['cantidad'] as int,
    precioUnitario: (json['precio_unitario'] as num).toDouble(),
    subtotal: (json['subtotal'] as num).toDouble(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'venta_id': ventaId,
    'producto_id': productoId,
    'producto_nombre': productoNombre,
    'cantidad': cantidad,
    'precio_unitario': precioUnitario,
    'subtotal': subtotal,
    'created_at': createdAt.toIso8601String(),
  };
}

// ============================================
// GASTO
// ============================================
class Gasto {
  final String id;
  final String userId;
  final String descripcion;
  final double monto;
  final String? categoria;
  final String? proveedor;
  final String? referencia;
  final String? metodoPago;
  final String estado; // pagado, pendiente, cancelado
  final String? notas;
  final String? reciboUrl;
  final DateTime fecha;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gasto({
    required this.id,
    required this.userId,
    required this.descripcion,
    required this.monto,
    this.categoria,
    this.proveedor,
    this.referencia,
    this.metodoPago,
    this.estado = 'pagado',
    this.notas,
    this.reciboUrl,
    required this.fecha,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gasto.fromJson(Map<String, dynamic> json) => Gasto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    descripcion: json['descripcion'] as String,
    monto: (json['monto'] as num).toDouble(),
    categoria: json['categoria'] as String?,
    proveedor: json['proveedor'] as String?,
    referencia: json['referencia'] as String?,
    metodoPago: json['metodo_pago'] as String?,
    estado: json['estado'] as String? ?? 'pagado',
    notas: json['notas'] as String?,
    reciboUrl: json['recibo_url'] as String?,
    fecha: DateTime.parse(json['fecha'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'descripcion': descripcion,
    'monto': monto,
    'categoria': categoria,
    'proveedor': proveedor,
    'referencia': referencia,
    'metodo_pago': metodoPago,
    'estado': estado,
    'notas': notas,
    'recibo_url': reciboUrl,
    'fecha': fecha.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

// ============================================
// RESUMEN
// ============================================
class Resumen {
  final String id;
  final String userId;
  final double totalVentas;
  final double totalGastos;
  final double gananciaNeta;
  final int cantidadProductos;
  final int cantidadClientes;
  final DateTime mesAnio;
  final DateTime createdAt;
  final DateTime updatedAt;

  Resumen({
    required this.id,
    required this.userId,
    this.totalVentas = 0,
    this.totalGastos = 0,
    this.gananciaNeta = 0,
    this.cantidadProductos = 0,
    this.cantidadClientes = 0,
    required this.mesAnio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resumen.fromJson(Map<String, dynamic> json) => Resumen(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    totalVentas: (json['total_ventas'] as num?)?.toDouble() ?? 0,
    totalGastos: (json['total_gastos'] as num?)?.toDouble() ?? 0,
    gananciaNeta: (json['ganancia_neta'] as num?)?.toDouble() ?? 0,
    cantidadProductos: json['cantidad_productos'] as int? ?? 0,
    cantidadClientes: json['cantidad_clientes'] as int? ?? 0,
    mesAnio: DateTime.parse(json['mes_anio'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'total_ventas': totalVentas,
    'total_gastos': totalGastos,
    'ganancia_neta': gananciaNeta,
    'cantidad_productos': cantidadProductos,
    'cantidad_clientes': cantidadClientes,
    'mes_anio': mesAnio.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

// ============================================
// AUDIT LOG
// ============================================
class AuditLog {
  final String id;
  final String userId;
  final String accion; // INSERT, UPDATE, DELETE
  final String tabla;
  final String? registroId;
  final Map<String, dynamic>? datosAnteriores;
  final Map<String, dynamic>? datosNuevos;
  final DateTime createdAt;

  AuditLog({
    required this.id,
    required this.userId,
    required this.accion,
    required this.tabla,
    this.registroId,
    this.datosAnteriores,
    this.datosNuevos,
    required this.createdAt,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    accion: json['accion'] as String,
    tabla: json['tabla'] as String,
    registroId: json['registro_id'] as String?,
    datosAnteriores: json['datos_anteriores'] as Map<String, dynamic>?,
    datosNuevos: json['datos_nuevos'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'accion': accion,
    'tabla': tabla,
    'registro_id': registroId,
    'datos_anteriores': datosAnteriores,
    'datos_nuevos': datosNuevos,
    'created_at': createdAt.toIso8601String(),
  };
}
