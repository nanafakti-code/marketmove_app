class Gasto {
  final String? id;
  final String userId;
  final String descripcion;
  final double monto;
  final String categoria;
  final String? referencia;
  final DateTime? fecha;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Gasto({
    this.id,
    required this.userId,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    this.referencia,
    this.fecha,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'descripcion': descripcion,
      'monto': monto,
      'categoria': categoria,
      'referencia': referencia,
      'fecha': fecha?.toIso8601String(),
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      userId: map['user_id'],
      descripcion: map['descripcion'],
      monto: (map['monto'] as num).toDouble(),
      categoria: map['categoria'],
      referencia: map['referencia'],
      fecha: map['fecha'] != null ? DateTime.parse(map['fecha']) : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
