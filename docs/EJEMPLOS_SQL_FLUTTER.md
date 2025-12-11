# 📖 EJEMPLOS PRÁCTICOS - Consultas SQL y Flutter

## Índice
1. [Consultas SQL](#consultas-sql)
2. [Ejemplos Flutter](#ejemplos-flutter)
3. [Casos de Uso](#casos-de-uso)

---

## CONSULTAS SQL

### USUARIOS

#### Obtener perfil del usuario actual
```sql
SELECT * FROM users WHERE id = current_user_id;
```

#### Contar clientes únicos en el mes
```sql
SELECT COUNT(DISTINCT cliente_nombre) as clientes
FROM ventas
WHERE user_id = 'user-id' 
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW());
```

#### Obtener datos de perfil para editar
```sql
SELECT 
  email, 
  full_name, 
  business_name, 
  phone, 
  avatar_url,
  created_at
FROM users
WHERE id = 'user-id';
```

---

### PRODUCTOS

#### Listar todos los productos activos
```sql
SELECT 
  id, 
  nombre, 
  precio, 
  cantidad, 
  categoria, 
  imagen_url
FROM productos
WHERE user_id = 'user-id' 
  AND activo = TRUE
ORDER BY nombre ASC;
```

#### Buscar producto por nombre
```sql
SELECT * FROM productos
WHERE user_id = 'user-id'
  AND nombre ILIKE '%laptop%'
  AND activo = TRUE;
```

#### Productos con bajo stock (< 10)
```sql
SELECT 
  id, 
  nombre, 
  cantidad, 
  categoria
FROM productos
WHERE user_id = 'user-id'
  AND cantidad < 10
  AND activo = TRUE
ORDER BY cantidad ASC;
```

#### Productos por categoría
```sql
SELECT 
  id, 
  nombre, 
  precio, 
  cantidad
FROM productos
WHERE user_id = 'user-id'
  AND categoria = 'Electrónica'
  AND activo = TRUE
ORDER BY nombre;
```

#### Productos más vendidos
```sql
SELECT 
  p.id,
  p.nombre,
  COUNT(vd.id) as veces_vendido,
  SUM(vd.cantidad) as total_vendido
FROM productos p
LEFT JOIN venta_detalles vd ON p.id = vd.producto_id
LEFT JOIN ventas v ON vd.venta_id = v.id
WHERE p.user_id = 'user-id'
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC
LIMIT 10;
```

#### Valor total del inventario
```sql
SELECT SUM(precio * cantidad) as valor_inventario
FROM productos
WHERE user_id = 'user-id'
  AND activo = TRUE;
```

---

### VENTAS

#### Todas las ventas del usuario
```sql
SELECT 
  id,
  numero_venta,
  cliente_nombre,
  total,
  estado,
  metodo_pago,
  fecha
FROM ventas
WHERE user_id = 'user-id'
ORDER BY fecha DESC;
```

#### Ventas del mes actual
```sql
SELECT 
  id,
  numero_venta,
  cliente_nombre,
  total,
  estado,
  fecha
FROM ventas
WHERE user_id = 'user-id'
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())
ORDER BY fecha DESC;
```

#### Ventas entre dos fechas
```sql
SELECT 
  numero_venta,
  cliente_nombre,
  total,
  estado,
  fecha
FROM ventas
WHERE user_id = 'user-id'
  AND fecha >= '2025-01-01'
  AND fecha <= '2025-01-31'
ORDER BY fecha DESC;
```

#### Ventas completadas solamente
```sql
SELECT 
  id,
  numero_venta,
  cliente_nombre,
  total,
  fecha
FROM ventas
WHERE user_id = 'user-id'
  AND estado = 'completada'
ORDER BY fecha DESC;
```

#### Venta con todos sus detalles
```sql
SELECT 
  v.id,
  v.numero_venta,
  v.cliente_nombre,
  v.total,
  v.impuesto,
  v.descuento,
  v.fecha,
  vd.producto_nombre,
  vd.cantidad,
  vd.precio_unitario,
  vd.subtotal
FROM ventas v
LEFT JOIN venta_detalles vd ON v.id = vd.venta_id
WHERE v.id = 'venta-id'
ORDER BY vd.id;
```

#### Total de ventas por día
```sql
SELECT 
  DATE(fecha) as fecha,
  COUNT(*) as num_ventas,
  SUM(total) as total_dia
FROM ventas
WHERE user_id = 'user-id'
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())
GROUP BY DATE(fecha)
ORDER BY fecha DESC;
```

#### Total de ventas por método de pago
```sql
SELECT 
  metodo_pago,
  COUNT(*) as num_ventas,
  SUM(total) as total
FROM ventas
WHERE user_id = 'user-id'
  AND estado = 'completada'
GROUP BY metodo_pago;
```

#### Venta más reciente
```sql
SELECT 
  id,
  numero_venta,
  cliente_nombre,
  total,
  fecha
FROM ventas
WHERE user_id = 'user-id'
ORDER BY fecha DESC
LIMIT 1;
```

#### Total de ventas del mes
```sql
SELECT 
  SUM(total) as total_mes,
  COUNT(*) as numero_ventas,
  AVG(total) as promedio_venta
FROM ventas
WHERE user_id = 'user-id'
  AND estado = 'completada'
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW());
```

---

### GASTOS

#### Todos los gastos
```sql
SELECT 
  id,
  descripcion,
  monto,
  categoria,
  proveedor,
  estado,
  fecha
FROM gastos
WHERE user_id = 'user-id'
ORDER BY fecha DESC;
```

#### Gastos del mes actual
```sql
SELECT 
  descripcion,
  monto,
  categoria,
  proveedor,
  estado,
  fecha
FROM gastos
WHERE user_id = 'user-id'
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())
ORDER BY fecha DESC;
```

#### Gastos por categoría
```sql
SELECT 
  categoria,
  COUNT(*) as cantidad,
  SUM(monto) as total_categoria
FROM gastos
WHERE user_id = 'user-id'
  AND estado = 'pagado'
GROUP BY categoria
ORDER BY total_categoria DESC;
```

#### Gastos pendientes de pago
```sql
SELECT 
  id,
  descripcion,
  monto,
  proveedor,
  fecha
FROM gastos
WHERE user_id = 'user-id'
  AND estado = 'pendiente'
ORDER BY fecha ASC;
```

#### Total de gastos del mes
```sql
SELECT 
  SUM(monto) as total_gastos,
  COUNT(*) as numero_gastos,
  AVG(monto) as promedio_gasto
FROM gastos
WHERE user_id = 'user-id'
  AND estado = 'pagado'
  AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW());
```

#### Gasto mayor
```sql
SELECT 
  id,
  descripcion,
  monto,
  categoria,
  fecha
FROM gastos
WHERE user_id = 'user-id'
ORDER BY monto DESC
LIMIT 1;
```

#### Gastos por proveedor
```sql
SELECT 
  proveedor,
  COUNT(*) as numero_compras,
  SUM(monto) as total_gasto
FROM gastos
WHERE user_id = 'user-id'
  AND proveedor IS NOT NULL
GROUP BY proveedor
ORDER BY total_gasto DESC;
```

---

### RESUMEN Y ANÁLISIS

#### Resumen del mes
```sql
SELECT 
  total_ventas,
  total_gastos,
  ganancia_neta,
  cantidad_productos,
  cantidad_clientes
FROM resumen
WHERE user_id = 'user-id'
  AND mes_anio = DATE_TRUNC('month', NOW())::date;
```

#### Comparar meses
```sql
SELECT 
  r1.mes_anio as mes_actual,
  r1.total_ventas as ventas_actual,
  r2.total_ventas as ventas_anterior,
  ((r1.total_ventas - r2.total_ventas) / r2.total_ventas * 100) as porcentaje_cambio
FROM resumen r1
LEFT JOIN resumen r2 
  ON r1.user_id = r2.user_id 
  AND r2.mes_anio = (r1.mes_anio - INTERVAL '1 month')::date
WHERE r1.user_id = 'user-id'
  AND r1.mes_anio = DATE_TRUNC('month', NOW())::date;
```

#### Dashboard principal
```sql
SELECT 
  (SELECT COUNT(*) FROM productos 
   WHERE user_id = 'user-id' AND activo = TRUE) as productos_activos,
  (SELECT COUNT(*) FROM ventas 
   WHERE user_id = 'user-id' 
   AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())) as ventas_mes,
  (SELECT SUM(total) FROM ventas 
   WHERE user_id = 'user-id' 
   AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())) as total_ventas_mes,
  (SELECT SUM(monto) FROM gastos 
   WHERE user_id = 'user-id' 
   AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())) as total_gastos_mes;
```

#### Ganancia neta del mes
```sql
SELECT 
  COALESCE((SELECT SUM(total) FROM ventas 
    WHERE user_id = 'user-id' 
    AND estado = 'completada'
    AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())), 0)
  -
  COALESCE((SELECT SUM(monto) FROM gastos 
    WHERE user_id = 'user-id' 
    AND estado = 'pagado'
    AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', NOW())), 0)
  as ganancia_neta;
```

---

## EJEMPLOS FLUTTER

### Obtener Productos
```dart
Future<List<Producto>> obtenerProductos() async {
  final response = await Supabase.instance.client
    .from('productos')
    .select()
    .eq('activo', true)
    .order('created_at', ascending: false);

  return (response as List)
    .map((p) => Producto.fromJson(p as Map<String, dynamic>))
    .toList();
}
```

### Crear Venta
```dart
Future<void> crearVenta(
  List<ItemVenta> items,
  String clienteNombre,
  double total
) async {
  // 1. Insertar venta
  final ventaResponse = await Supabase.instance.client
    .from('ventas')
    .insert({
      'numero_venta': _generarNumeroVenta(),
      'cliente_nombre': clienteNombre,
      'total': total,
      'estado': 'completada',
      'metodo_pago': 'efectivo',
    })
    .select();

  final ventaId = ventaResponse[0]['id'];

  // 2. Insertar detalles
  for (var item in items) {
    await Supabase.instance.client
      .from('venta_detalles')
      .insert({
        'venta_id': ventaId,
        'producto_id': item.productoId,
        'producto_nombre': item.nombre,
        'cantidad': item.cantidad,
        'precio_unitario': item.precio,
        'subtotal': item.cantidad * item.precio,
      });
  }

  // 3. Actualizar stock
  for (var item in items) {
    final producto = await obtenerProducto(item.productoId);
    await Supabase.instance.client
      .from('productos')
      .update({
        'cantidad': (producto.cantidad - item.cantidad),
      })
      .eq('id', item.productoId);
  }
}
```

### Obtener Ventas del Mes
```dart
Future<List<Venta>> obtenerVentasMes() async {
  final ahora = DateTime.now();
  final inicio = DateTime(ahora.year, ahora.month, 1);
  final fin = DateTime(ahora.year, ahora.month + 1, 1);

  final response = await Supabase.instance.client
    .from('ventas')
    .select()
    .gte('fecha', inicio.toIso8601String())
    .lt('fecha', fin.toIso8601String())
    .order('fecha', ascending: false);

  return (response as List)
    .map((v) => Venta.fromJson(v as Map<String, dynamic>))
    .toList();
}
```

### Obtener Total Ventas del Mes
```dart
Future<double> obtenerTotalVentasMes() async {
  final ahora = DateTime.now();
  final inicio = DateTime(ahora.year, ahora.month, 1);
  final fin = DateTime(ahora.year, ahora.month + 1, 1);

  final response = await Supabase.instance.client
    .from('ventas')
    .select('total')
    .gte('fecha', inicio.toIso8601String())
    .lt('fecha', fin.toIso8601String())
    .eq('estado', 'completada');

  double total = 0;
  for (var venta in response as List) {
    total += (venta['total'] as num).toDouble();
  }
  return total;
}
```

### Registrar Gasto
```dart
Future<void> registrarGasto({
  required String descripcion,
  required double monto,
  required String categoria,
  String? proveedor,
}) async {
  await Supabase.instance.client
    .from('gastos')
    .insert({
      'descripcion': descripcion,
      'monto': monto,
      'categoria': categoria,
      'proveedor': proveedor,
      'estado': 'pagado',
      'fecha': DateTime.now().toIso8601String(),
    });
}
```

### Dashboard del Mes
```dart
Future<Map<String, double>> obtenerDashboardMes() async {
  final ahora = DateTime.now();
  final inicio = DateTime(ahora.year, ahora.month, 1);
  final fin = DateTime(ahora.year, ahora.month + 1, 1);

  // Ventas
  final ventasResponse = await Supabase.instance.client
    .from('ventas')
    .select('total')
    .gte('fecha', inicio.toIso8601String())
    .lt('fecha', fin.toIso8601String())
    .eq('estado', 'completada');

  double totalVentas = 0;
  for (var v in ventasResponse as List) {
    totalVentas += (v['total'] as num).toDouble();
  }

  // Gastos
  final gastosResponse = await Supabase.instance.client
    .from('gastos')
    .select('monto')
    .gte('fecha', inicio.toIso8601String())
    .lt('fecha', fin.toIso8601String())
    .eq('estado', 'pagado');

  double totalGastos = 0;
  for (var g in gastosResponse as List) {
    totalGastos += (g['monto'] as num).toDouble();
  }

  return {
    'ventas': totalVentas,
    'gastos': totalGastos,
    'ganancia': totalVentas - totalGastos,
  };
}
```

### Buscar Productos
```dart
Future<List<Producto>> buscarProductos(String query) async {
  final response = await Supabase.instance.client
    .from('productos')
    .select()
    .ilike('nombre', '%$query%')
    .eq('activo', true);

  return (response as List)
    .map((p) => Producto.fromJson(p as Map<String, dynamic>))
    .toList();
}
```

### Obtener Venta con Detalles
```dart
Future<Map<String, dynamic>?> obtenerVentaCompleta(String ventaId) async {
  final response = await Supabase.instance.client
    .from('ventas')
    .select('''
      *,
      venta_detalles (
        id,
        producto_nombre,
        cantidad,
        precio_unitario,
        subtotal
      )
    ''')
    .eq('id', ventaId)
    .single();

  return response as Map<String, dynamic>;
}
```

### Listeners en Tiempo Real
```dart
void escucharVentas() {
  Supabase.instance.client
    .from('ventas')
    .on(RealtimeListenTypes.postgresChanges,
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'ventas',
      callback: (payload) {
        final venta = Venta.fromJson(payload.newRecord);
        print('Nueva venta: ${venta.numeroVenta}');
      },
    )
    .subscribe();
}
```

---

## CASOS DE USO

### Caso 1: Crear una Venta Completa

```dart
class VentaService {
  Future<void> crearVentaCompleta({
    required String clienteNombre,
    required List<CarritoItem> items,
    required double impuesto,
    required double descuento,
    required String metodoPago,
  }) async {
    try {
      // 1. Generar número de venta único
      final numeroVenta = 'V-${DateTime.now().millisecondsSinceEpoch}';

      // 2. Calcular totales
      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + (item.precio * item.cantidad),
      );
      final total = subtotal + impuesto - descuento;

      // 3. Crear venta
      final ventaResponse = await Supabase.instance.client
        .from('ventas')
        .insert({
          'numero_venta': numeroVenta,
          'cliente_nombre': clienteNombre,
          'total': total,
          'impuesto': impuesto,
          'descuento': descuento,
          'estado': 'completada',
          'metodo_pago': metodoPago,
        })
        .select();

      final ventaId = ventaResponse[0]['id'];

      // 4. Crear detalles
      for (var item in items) {
        await Supabase.instance.client
          .from('venta_detalles')
          .insert({
            'venta_id': ventaId,
            'producto_id': item.id,
            'producto_nombre': item.nombre,
            'cantidad': item.cantidad,
            'precio_unitario': item.precio,
            'subtotal': item.precio * item.cantidad,
          });

        // 5. Actualizar stock
        await Supabase.instance.client
          .from('productos')
          .update({
            'cantidad': item.cantidadActual - item.cantidad,
          })
          .eq('id', item.id);
      }

      print('Venta creada: $numeroVenta');
    } catch (e) {
      print('Error al crear venta: $e');
      rethrow;
    }
  }
}
```

### Caso 2: Dashboard del Mes

```dart
class DashboardService {
  Future<DashboardData> obtenerDashboard() async {
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month, 1);
    final fin = DateTime(ahora.year, ahora.month + 1, 1);

    // Parallelizar todas las consultas
    final results = await Future.wait([
      _totalVentas(inicio, fin),
      _totalGastos(inicio, fin),
      _numeroVentas(inicio, fin),
      _productosActivos(),
      _ventasHoy(),
    ]);

    return DashboardData(
      totalVentas: results[0] as double,
      totalGastos: results[1] as double,
      numeroVentas: results[2] as int,
      productosActivos: results[3] as int,
      ventasHoy: results[4] as int,
      gananciaNeta: (results[0] as double) - (results[1] as double),
    );
  }

  Future<double> _totalVentas(DateTime inicio, DateTime fin) async {
    final response = await Supabase.instance.client
      .from('ventas')
      .select('total')
      .gte('fecha', inicio.toIso8601String())
      .lt('fecha', fin.toIso8601String())
      .eq('estado', 'completada');

    return (response as List).fold<double>(
      0,
      (sum, v) => sum + (v['total'] as num).toDouble(),
    );
  }

  Future<double> _totalGastos(DateTime inicio, DateTime fin) async {
    final response = await Supabase.instance.client
      .from('gastos')
      .select('monto')
      .gte('fecha', inicio.toIso8601String())
      .lt('fecha', fin.toIso8601String())
      .eq('estado', 'pagado');

    return (response as List).fold<double>(
      0,
      (sum, g) => sum + (g['monto'] as num).toDouble(),
    );
  }

  Future<int> _numeroVentas(DateTime inicio, DateTime fin) async {
    final response = await Supabase.instance.client
      .from('ventas')
      .select('id')
      .gte('fecha', inicio.toIso8601String())
      .lt('fecha', fin.toIso8601String())
      .eq('estado', 'completada');

    return (response as List).length;
  }

  Future<int> _productosActivos() async {
    final response = await Supabase.instance.client
      .from('productos')
      .select('id')
      .eq('activo', true);

    return (response as List).length;
  }

  Future<int> _ventasHoy() async {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month, hoy.day);
    final fin = DateTime(hoy.year, hoy.month, hoy.day + 1);

    final response = await Supabase.instance.client
      .from('ventas')
      .select('id')
      .gte('fecha', inicio.toIso8601String())
      .lt('fecha', fin.toIso8601String());

    return (response as List).length;
  }
}

class DashboardData {
  final double totalVentas;
  final double totalGastos;
  final double gananciaNeta;
  final int numeroVentas;
  final int productosActivos;
  final int ventasHoy;

  DashboardData({
    required this.totalVentas,
    required this.totalGastos,
    required this.gananciaNeta,
    required this.numeroVentas,
    required this.productosActivos,
    required this.ventasHoy,
  });
}
```

---

**¡Estos ejemplos te permiten empezar inmediatamente!** 🚀
