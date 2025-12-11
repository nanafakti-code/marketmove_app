// lib/src/shared/repositories/supabase_repository.dart
// Repositorio base para operaciones comunes en Supabase

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:marketmove_app/src/core/models/database_models.dart';

abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<String> insert(T item);
  Future<void> update(String id, T item);
  Future<void> delete(String id);
}

// ============================================
// REPOSITORIO DE PRODUCTOS
// ============================================
class ProductoRepository implements Repository<Producto> {
  final SupabaseClient _client;
  static const String _table = 'productos';

  ProductoRepository(this._client);

  @override
  Future<List<Producto>> getAll() async {
    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('activo', true)
        .order('created_at', ascending: false);
      
      return (response as List)
        .map((p) => Producto.fromJson(p as Map<String, dynamic>))
        .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Producto?> getById(String id) async {
    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .single();
      
      return Producto.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Producto>> getByCategoria(String categoria) async {
    final response = await _client
      .from(_table)
      .select()
      .eq('categoria', categoria)
      .eq('activo', true)
      .order('nombre');
    
    return (response as List)
      .map((p) => Producto.fromJson(p as Map<String, dynamic>))
      .toList();
  }

  Future<List<Producto>> buscar(String query) async {
    final response = await _client
      .from(_table)
      .select()
      .ilike('nombre', '%$query%')
      .eq('activo', true);
    
    return (response as List)
      .map((p) => Producto.fromJson(p as Map<String, dynamic>))
      .toList();
  }

  @override
  Future<String> insert(Producto item) async {
    final response = await _client
      .from(_table)
      .insert(item.toJson())
      .select();
    
    return response[0]['id'] as String;
  }

  @override
  Future<void> update(String id, Producto item) async {
    await _client
      .from(_table)
      .update(item.toJson())
      .eq('id', id);
  }

  @override
  Future<void> delete(String id) async {
    await _client
      .from(_table)
      .delete()
      .eq('id', id);
  }

  Future<void> desactivar(String id) async {
    await _client
      .from(_table)
      .update({'activo': false})
      .eq('id', id);
  }
}

// ============================================
// REPOSITORIO DE VENTAS
// ============================================
class VentaRepository implements Repository<Venta> {
  final SupabaseClient _client;
  static const String _table = 'ventas';

  VentaRepository(this._client);

  @override
  Future<List<Venta>> getAll() async {
    final response = await _client
      .from(_table)
      .select()
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((v) => Venta.fromJson(v as Map<String, dynamic>))
      .toList();
  }

  @override
  Future<Venta?> getById(String id) async {
    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .single();
      
      return Venta.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Venta>> getVentasMes(int mes, int anio) async {
    final inicio = DateTime(anio, mes, 1).toIso8601String();
    final fin = DateTime(anio, mes + 1, 1).toIso8601String();

    final response = await _client
      .from(_table)
      .select()
      .gte('fecha', inicio)
      .lt('fecha', fin)
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((v) => Venta.fromJson(v as Map<String, dynamic>))
      .toList();
  }

  Future<List<Venta>> getVentasPorEstado(String estado) async {
    final response = await _client
      .from(_table)
      .select()
      .eq('estado', estado)
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((v) => Venta.fromJson(v as Map<String, dynamic>))
      .toList();
  }

  Future<double> getTotalVentasMes(int mes, int anio) async {
    final inicio = DateTime(anio, mes, 1).toIso8601String();
    final fin = DateTime(anio, mes + 1, 1).toIso8601String();

    final response = await _client
      .from(_table)
      .select('total')
      .gte('fecha', inicio)
      .lt('fecha', fin)
      .eq('estado', 'completada');
    
    double total = 0;
    for (var venta in response as List) {
      total += (venta['total'] as num).toDouble();
    }
    return total;
  }

  @override
  Future<String> insert(Venta item) async {
    final response = await _client
      .from(_table)
      .insert(item.toJson())
      .select();
    
    return response[0]['id'] as String;
  }

  @override
  Future<void> update(String id, Venta item) async {
    await _client
      .from(_table)
      .update(item.toJson())
      .eq('id', id);
  }

  @override
  Future<void> delete(String id) async {
    await _client
      .from(_table)
      .delete()
      .eq('id', id);
  }

  Future<void> cancelarVenta(String id) async {
    await _client
      .from(_table)
      .update({'estado': 'cancelada'})
      .eq('id', id);
  }
}

// ============================================
// REPOSITORIO DE GASTOS
// ============================================
class GastoRepository implements Repository<Gasto> {
  final SupabaseClient _client;
  static const String _table = 'gastos';

  GastoRepository(this._client);

  @override
  Future<List<Gasto>> getAll() async {
    final response = await _client
      .from(_table)
      .select()
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((g) => Gasto.fromJson(g as Map<String, dynamic>))
      .toList();
  }

  @override
  Future<Gasto?> getById(String id) async {
    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .single();
      
      return Gasto.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Gasto>> getGastosMes(int mes, int anio) async {
    final inicio = DateTime(anio, mes, 1).toIso8601String();
    final fin = DateTime(anio, mes + 1, 1).toIso8601String();

    final response = await _client
      .from(_table)
      .select()
      .gte('fecha', inicio)
      .lt('fecha', fin)
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((g) => Gasto.fromJson(g as Map<String, dynamic>))
      .toList();
  }

  Future<List<Gasto>> getGastosPorCategoria(String categoria) async {
    final response = await _client
      .from(_table)
      .select()
      .eq('categoria', categoria)
      .order('fecha', ascending: false);
    
    return (response as List)
      .map((g) => Gasto.fromJson(g as Map<String, dynamic>))
      .toList();
  }

  Future<double> getTotalGastosMes(int mes, int anio) async {
    final inicio = DateTime(anio, mes, 1).toIso8601String();
    final fin = DateTime(anio, mes + 1, 1).toIso8601String();

    final response = await _client
      .from(_table)
      .select('monto')
      .gte('fecha', inicio)
      .lt('fecha', fin)
      .eq('estado', 'pagado');
    
    double total = 0;
    for (var gasto in response as List) {
      total += (gasto['monto'] as num).toDouble();
    }
    return total;
  }

  @override
  Future<String> insert(Gasto item) async {
    final response = await _client
      .from(_table)
      .insert(item.toJson())
      .select();
    
    return response[0]['id'] as String;
  }

  @override
  Future<void> update(String id, Gasto item) async {
    await _client
      .from(_table)
      .update(item.toJson())
      .eq('id', id);
  }

  @override
  Future<void> delete(String id) async {
    await _client
      .from(_table)
      .delete()
      .eq('id', id);
  }
}

// ============================================
// REPOSITORIO DE USUARIO
// ============================================
class UsuarioRepository {
  final SupabaseClient _client;
  static const String _table = 'users';

  UsuarioRepository(this._client);

  Future<Usuario?> getUsuarioActual() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('id', user.id)
        .single();
      
      return Usuario.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> actualizarPerfil(Usuario usuario) async {
    await _client
      .from(_table)
      .update(usuario.toJson())
      .eq('id', usuario.id);
  }

  Future<void> actualizarAvatar(String userId, String avatarUrl) async {
    await _client
      .from(_table)
      .update({'avatar_url': avatarUrl})
      .eq('id', userId);
  }
}

// ============================================
// REPOSITORIO DE RESUMEN
// ============================================
class ResumenRepository {
  final SupabaseClient _client;
  static const String _table = 'resumen';

  ResumenRepository(this._client);

  Future<Resumen?> getResumenMes(int mes, int anio) async {
    final fecha = DateTime(anio, mes, 1).toIso8601String();

    try {
      final response = await _client
        .from(_table)
        .select()
        .eq('mes_anio', fecha)
        .single();
      
      return Resumen.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> actualizarResumen(Resumen resumen) async {
    await _client
      .from(_table)
      .upsert(resumen.toJson());
  }

  Future<List<Resumen>> getResumenesAnio(int anio) async {
    final inicio = DateTime(anio, 1, 1).toIso8601String();
    final fin = DateTime(anio + 1, 1, 1).toIso8601String();

    final response = await _client
      .from(_table)
      .select()
      .gte('mes_anio', inicio)
      .lt('mes_anio', fin)
      .order('mes_anio');
    
    return (response as List)
      .map((r) => Resumen.fromJson(r as Map<String, dynamic>))
      .toList();
  }
}
