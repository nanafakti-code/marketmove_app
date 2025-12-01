import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/producto_model.dart';
import '../../core/models/venta_model.dart';
import '../../core/models/gasto_model.dart';

class DataRepository {
  final SupabaseClient supabase;

  DataRepository({required this.supabase});

  // ==================== PRODUCTOS ====================
  Future<Producto> crearProducto(Producto producto) async {
    try {
      final response = await supabase
          .from('productos')
          .insert(producto.toMap())
          .select()
          .single();
      
      print('✅ Producto creado: ${response['id']}');
      return Producto.fromMap(response);
    } catch (e) {
      print('❌ Error creando producto: $e');
      rethrow;
    }
  }

  Stream<List<Producto>> obtenerProductos(String userId) {
    return supabase
        .from('productos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => (data as List).map((p) => Producto.fromMap(p)).toList());
  }

  Future<void> eliminarProducto(String productoId) async {
    try {
      await supabase.from('productos').delete().eq('id', productoId);
      print('✅ Producto eliminado: $productoId');
    } catch (e) {
      print('❌ Error eliminando producto: $e');
      rethrow;
    }
  }

  // ==================== VENTAS ====================
  Future<Venta> crearVenta(Venta venta) async {
    try {
      final response = await supabase
          .from('ventas')
          .insert(venta.toMap())
          .select()
          .single();
      
      print('✅ Venta creada: ${response['id']}');
      return Venta.fromMap(response);
    } catch (e) {
      print('❌ Error creando venta: $e');
      rethrow;
    }
  }

  Stream<List<Venta>> obtenerVentas(String userId) {
    return supabase
        .from('ventas')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => (data as List).map((v) => Venta.fromMap(v)).toList());
  }

  Future<void> eliminarVenta(String ventaId) async {
    try {
      await supabase.from('ventas').delete().eq('id', ventaId);
      print('✅ Venta eliminada: $ventaId');
    } catch (e) {
      print('❌ Error eliminando venta: $e');
      rethrow;
    }
  }

  // ==================== GASTOS ====================
  Future<Gasto> crearGasto(Gasto gasto) async {
    try {
      final response = await supabase
          .from('gastos')
          .insert(gasto.toMap())
          .select()
          .single();
      
      print('✅ Gasto creado: ${response['id']}');
      return Gasto.fromMap(response);
    } catch (e) {
      print('❌ Error creando gasto: $e');
      rethrow;
    }
  }

  Stream<List<Gasto>> obtenerGastos(String userId) {
    return supabase
        .from('gastos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => (data as List).map((g) => Gasto.fromMap(g)).toList());
  }

  Future<void> eliminarGasto(String gastoId) async {
    try {
      await supabase.from('gastos').delete().eq('id', gastoId);
      print('✅ Gasto eliminado: $gastoId');
    } catch (e) {
      print('❌ Error eliminando gasto: $e');
      rethrow;
    }
  }
}
