class Venta {
  final String? id;
  final String userId;
  final String numeroVenta;
  final String? productoId; // Producto vendido
  final String clienteNombre;
  final String clienteEmail;
  final String clienteTelefono;
  final double total;
  final double impuesto;
  final double descuento;
  final String estado;
  final String metodoPago;
  final String? notas;
  final DateTime? fecha;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Venta({
    this.id,
    required this.userId,
    required this.numeroVenta,
    this.productoId,
    required this.clienteNombre,
    required this.clienteEmail,
    required this.clienteTelefono,
    required this.total,
    required this.impuesto,
    required this.descuento,
    required this.estado,
    required this.metodoPago,
    this.notas,
    this.fecha,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'producto_id': productoId,
      'cliente_nombre': clienteNombre,
      'cliente_email': clienteEmail,
      'cliente_telefono': clienteTelefono,
      'total': total,
      'impuesto': impuesto,
      'descuento': descuento,
      'estado': estado,
      'metodo_pago': metodoPago,
      'notas': notas,
      'fecha': fecha?.toIso8601String(),
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      userId: map['user_id'],
      numeroVenta: map['id'] ?? '', // Usar el ID generado como número de venta
      productoId: map['producto_id'],
      clienteNombre: map['cliente_nombre'],
      clienteEmail: map['cliente_email'],
      clienteTelefono: map['cliente_telefono'],
      total: (map['total'] as num).toDouble(),
      impuesto: (map['impuesto'] as num).toDouble(),
      descuento: (map['descuento'] as num).toDouble(),
      estado: map['estado'],
      metodoPago: map['metodo_pago'],
      notas: map['notas'],
      fecha: map['fecha'] != null ? DateTime.parse(map['fecha']) : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
