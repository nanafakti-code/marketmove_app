class Producto {
  final String? id;
  final String userId;
  final String nombre;
  final double precio;
  final int cantidad;
  final String sku;
  final String categoria;
  final String? imagenUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Producto({
    this.id,
    required this.userId,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.sku,
    required this.categoria,
    this.imagenUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'sku': sku,
      'categoria': categoria,
      'imagen_url': imagenUrl,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      userId: map['user_id'],
      nombre: map['nombre'],
      precio: (map['precio'] as num).toDouble(),
      cantidad: map['cantidad'] as int,
      sku: map['sku'],
      categoria: map['categoria'],
      imagenUrl: map['imagen_url'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
