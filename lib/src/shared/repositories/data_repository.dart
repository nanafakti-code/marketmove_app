import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/producto_model.dart';
import '../../core/models/venta_model.dart';
import '../../core/models/gasto_model.dart';
import '../services/pdf_service.dart';
import '../services/email_service.dart';

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

  Future<Producto> actualizarProducto(
    String productoId,
    Producto producto,
  ) async {
    try {
      final response = await supabase
          .from('productos')
          .update(producto.toMap())
          .eq('id', productoId)
          .select()
          .single();

      print('✅ Producto actualizado: $productoId');
      return Producto.fromMap(response);
    } catch (e) {
      print('❌ Error actualizando producto: $e');
      rethrow;
    }
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

  Future<Venta> crearVenta(Venta venta) async {
    try {
      // Primero, verificar y actualizar el stock del producto
      if (venta.productoId != null) {
        // Obtener el producto actual
        final productoResponse = await supabase
            .from('productos')
            .select('cantidad, nombre')
            .eq('id', venta.productoId!)
            .single();

        final stockActual = productoResponse['cantidad'] as int;

        // Verificar que hay stock disponible
        if (stockActual <= 0) {
          throw Exception('No hay stock disponible para este producto');
        }

        // Restar 1 del stock
        await supabase
            .from('productos')
            .update({'cantidad': stockActual - 1})
            .eq('id', venta.productoId!);
      }

      // Crear la venta
      final response = await supabase
          .from('ventas')
          .insert(venta.toMap())
          .select()
          .single();

      final ventaCreada = Venta.fromMap(response);
      
      // Intentar enviar email (sin bloquear la venta)
      _generarYEnviarFactura(venta: venta, ventaCreada: ventaCreada);
      
      return ventaCreada;
    } catch (e) {
      print('Error creando venta: $e');
      rethrow;
    }
  }

  // Generar PDF y enviar email (sin bloquear)
  void _generarYEnviarFactura({
    required Venta venta,
    required Venta ventaCreada,
  }) {
    // Fire and forget - no esperar respuesta
    Future.microtask(() async {
      try {
        print('[Factura] Intentando enviar a: ${venta.clienteEmail}');
        
        // 1. Generar PDF de la factura
        final pdfService = PdfService();
        final pdfBytes = await pdfService.generateInvoicePDF(
          saleNumber: ventaCreada.numeroVenta,
          clientName: venta.clienteNombre,
          clientEmail: venta.clienteEmail,
          productName: 'Producto',
          total: venta.total,
          tax: venta.impuesto,
          discount: venta.descuento,
          paymentMethod: venta.metodoPago,
          saleDate: venta.fecha ?? DateTime.now(),
          notes: venta.notas,
        );
        
        // 2. Enviar email con PDF adjunto
        final emailService = EmailService();
        await emailService.initialize();
        final success = await emailService.sendInvoiceEmail(
          clientEmail: venta.clienteEmail,
          clientName: venta.clienteNombre,
          saleNumber: ventaCreada.numeroVenta,
          total: venta.total,
          tax: venta.impuesto,
          discount: venta.descuento,
          paymentMethod: venta.metodoPago,
          saleDate: venta.fecha ?? DateTime.now(),
          notes: venta.notas,
          productName: 'Producto',
          pdfBytes: pdfBytes,
        );
        
        if (success) {
          print('[Factura] Email enviado exitosamente a ${venta.clienteEmail}');
        } else {
          print('[Factura] No se pudo enviar email a ${venta.clienteEmail}');
        }
      } catch (e) {
        print('[Factura] Error: $e');
      }
    });
  }

  Stream<List<Venta>> obtenerVentas(String userId) {
    return supabase
        .from('ventas')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => (data as List).map((v) => Venta.fromMap(v)).toList());
  }

  Future<Venta> actualizarVenta(String ventaId, Venta venta) async {
    try {
      final response = await supabase
          .from('ventas')
          .update(venta.toMap())
          .eq('id', ventaId)
          .select()
          .single();

      print('✅ Venta actualizada: $ventaId');
      return Venta.fromMap(response);
    } catch (e) {
      print('❌ Error actualizando venta: $e');
      rethrow;
    }
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

  Future<Gasto> actualizarGasto(Gasto gasto) async {
    try {
      if (gasto.id == null) {
        throw Exception('El ID del gasto es requerido para actualizar');
      }

      final response = await supabase
          .from('gastos')
          .update(gasto.toMap())
          .eq('id', gasto.id!)
          .select()
          .single();

      print('✅ Gasto actualizado: ${response['id']}');
      return Gasto.fromMap(response);
    } catch (e) {
      print('❌ Error actualizando gasto: $e');
      rethrow;
    }
  }

  // ==================== CLIENTES (ADMIN USERS) ====================
  Stream<List<Map<String, dynamic>>> obtenerClientesAdmin() {
    return supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('role', 'admin')
        .map((data) {
          print('📊 Datos recibidos de users: ${data.length} registros');
          final adminUsers = (data as List).cast<Map<String, dynamic>>().where((
            user,
          ) {
            final role = user['role'] as String?;
            print('👤 Usuario: ${user['email']}, role: $role');
            return role == 'admin';
          }).toList();
          print('✅ Clientes admin filtrados: ${adminUsers.length}');
          return adminUsers;
        });
  }

  // Obtener un usuario por ID (para superadmin)
  Future<Map<String, dynamic>?> obtenerUsuarioPorId(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return null;
    }
  }

  // Actualizar usuario (solo superadmin puede cambiar role de otros)
  Future<void> actualizarUsuario(
    String userId,
    Map<String, dynamic> datos,
  ) async {
    try {
      await supabase.from('users').update(datos).eq('id', userId);
      print('✅ Usuario actualizado: $userId');
    } catch (e) {
      print('❌ Error actualizando usuario: $e');
      rethrow;
    }
  }

  // Eliminar usuario (solo superadmin)
  Future<void> eliminarUsuario(String userId) async {
    try {
      await supabase.from('users').delete().eq('id', userId);
      print('✅ Usuario eliminado: $userId');
    } catch (e) {
      print('❌ Error eliminando usuario: $e');
      rethrow;
    }
  }

  // ==================== CLIENTES ====================
  Stream<List<Map<String, dynamic>>> obtenerClientes(String userId) {
    // Obtener clientes de la tabla clientes_empresa (disponibles para seleccionar)
    return supabase.from('clientes_empresa').stream(primaryKey: ['id']).map((
      data,
    ) {
      // Devolver todos los clientes disponibles (sin filtrar por user_id porque clientes_empresa no tiene ese campo)
      final clientes = (data as List).cast<Map<String, dynamic>>();
      print('✅ Clientes cargados: ${clientes.length}');
      return clientes;
    });
  }

  Future<String> crearCliente({
    required String userId,
    required String nombre,
    String? email,
    String? telefono,
    String? empresa,
    String? direccion,
  }) async {
    try {
      final response = await supabase.from('clientes_empresa').insert({
        'nombre_cliente': nombre,
        'email': email,
        'telefono': telefono,
        'razon_social': empresa,
        'direccion': direccion,
      }).select();

      return response[0]['id'] as String;
    } catch (e) {
      print('❌ Error creando cliente: $e');
      rethrow;
    }
  }

  Future<void> actualizarCliente({
    required String clienteId,
    required String nombre,
    String? email,
    String? telefono,
    String? empresa,
    String? direccion,
  }) async {
    try {
      await supabase
          .from('clientes_empresa')
          .update({
            'nombre_cliente': nombre,
            'email': email,
            'telefono': telefono,
            'razon_social': empresa,
            'direccion': direccion,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', clienteId);
    } catch (e) {
      print('❌ Error actualizando cliente: $e');
      rethrow;
    }
  }

  Future<void> eliminarCliente(String clienteId) async {
    try {
      // Primero obtener el nombre del cliente para buscar sus ventas
      final clienteData = await supabase
          .from('clientes_empresa')
          .select('nombre_cliente')
          .eq('id', clienteId)
          .single();

      final nombreCliente = clienteData['nombre_cliente'];

      // Eliminar todas las ventas asociadas a este cliente
      await supabase
          .from('ventas')
          .delete()
          .eq('cliente_nombre', nombreCliente);

      // Eliminar el cliente
      await supabase.from('clientes_empresa').delete().eq('id', clienteId);

      print('✅ Cliente y sus ventas eliminados correctamente');
    } catch (e) {
      print('❌ Error eliminando cliente: $e');
      rethrow;
    }
  }
}
