# 🗄️ Configuración de Base de Datos - MarketMove App

## 📋 Descripción General

Este documento proporciona instrucciones paso a paso para configurar la base de datos en Supabase con:
- ✅ Tablas completas para el sistema
- ✅ Row Level Security (RLS) activado en todas las tablas
- ✅ Políticas de seguridad por usuario
- ✅ Índices para optimizar rendimiento
- ✅ Triggers automáticos
- ✅ Vistas útiles para consultas

---

## 🚀 Paso 1: Crear Proyecto en Supabase

1. **Ir a Supabase**: https://supabase.com
2. **Crear Nueva Cuenta** (si no tienes una)
3. **Crear Nuevo Proyecto**:
   - Nombre: `marketmove`
   - Región: Europa (elige la más cercana a ti)
   - Base de datos: PostgreSQL
   - Contraseña: Guarda en lugar seguro

---

## 📝 Paso 2: Ejecutar el Script SQL

1. **En el Dashboard de Supabase**:
   - Ir a **SQL Editor** en el panel izquierdo
   - Hacer clic en **+ New Query**

2. **Copiar y pegar todo el contenido de** `supabase_setup.sql`

3. **Ejecutar el script**:
   - Presionar **Ctrl + Enter** o hacer clic en **Run**
   - Esperar a que se complete (debería tomar unos segundos)
   - Verificar que no hay errores en rojo

---

## 🔐 Paso 3: Verificar RLS y Políticas

Para confirmar que todo está correctamente configurado:

1. **Tablas con RLS Habilitado**:
   ```
   Ir a Authentication → Policies
   ```
   Deberías ver todas las tablas con políticas activas:
   - users
   - productos
   - ventas
   - venta_detalles
   - gastos
   - resumen
   - audit_logs

2. **Cada tabla debe tener estas políticas**:
   - SELECT: Usuarios ven solo sus datos
   - INSERT: Usuarios insertan solo sus datos
   - UPDATE: Usuarios actualizan solo sus datos
   - DELETE: Usuarios eliminan solo sus datos

---

## 📦 Paso 4: Configurar Flutter

1. **Instalar dependencia Supabase**:
```bash
flutter pub add supabase
```

2. **Actualizar pubspec.yaml** (verificar versión compatible):
```yaml
dependencies:
  supabase: ^2.0.0
  flutter_dotenv: ^5.1.0
```

3. **Crear archivo `.env` en la raíz del proyecto**:
```
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> **Nota**: Obtén estas credenciales de Supabase Dashboard → Settings → API

---

## 🔧 Paso 5: Crear Servicio Supabase en Flutter

Crear archivo: `lib/src/core/services/supabase_service.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static late final SupabaseClient _client;

  static Future<void> initialize() async {
    await dotenv.load();
    
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _client = Supabase.instance.client;
  }

  static SupabaseClient get client => _client;

  // Métodos helper
  static Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }

  static Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentUser => _client.auth.currentUser;

  static bool get isAuthenticated => _client.auth.currentUser != null;
}
```

---

## 📊 Descripción de Tablas

### 1. **users** - Perfiles de Usuarios
```
- id: UUID (enlazado con auth.users)
- email: Correo único
- full_name: Nombre completo
- business_name: Nombre del negocio
- phone: Teléfono
- avatar_url: Foto de perfil
```

### 2. **productos** - Inventario
```
- id: UUID (clave primaria)
- user_id: Usuario propietario
- nombre: Nombre del producto
- precio: Precio de venta
- cantidad: Stock disponible
- sku: Código único del producto
- categoria: Categoría del producto
- imagen_url: Foto del producto
```

### 3. **ventas** - Transacciones
```
- id: UUID
- user_id: Usuario que realizó la venta
- numero_venta: Número único de transacción
- cliente_nombre: Nombre del cliente
- total: Monto total
- estado: completada, pendiente, cancelada
- metodo_pago: Forma de pago
- fecha: Timestamp de la venta
```

### 4. **venta_detalles** - Líneas de Venta
```
- id: UUID
- venta_id: Referencia a ventas
- producto_id: Referencia a productos
- producto_nombre: Nombre del producto vendido
- cantidad: Cantidad vendida
- precio_unitario: Precio en ese momento
- subtotal: cantidad × precio_unitario
```

### 5. **gastos** - Gastos Operativos
```
- id: UUID
- user_id: Usuario propietario
- descripcion: Descripción del gasto
- monto: Cantidad gastada
- categoria: Tipo de gasto
- proveedor: De dónde vino el gasto
- metodo_pago: Cómo se pagó
- estado: pagado, pendiente
- recibo_url: Foto del recibo
```

### 6. **resumen** - Dashboard Mensual
```
- id: UUID
- user_id: Usuario propietario
- total_ventas: Suma de ventas del mes
- total_gastos: Suma de gastos del mes
- ganancia_neta: ventas - gastos
- mes_anio: Mes y año del resumen
```

### 7. **audit_logs** - Auditoría
```
- id: UUID
- user_id: Quién hizo el cambio
- accion: INSERT, UPDATE, DELETE
- tabla: Tabla afectada
- datos_anteriores: JSONB de antes
- datos_nuevos: JSONB de después
- created_at: Cuándo sucedió
```

---

## 🛡️ Políticas de Seguridad Explicadas

### Row Level Security (RLS)
Está habilitado en TODAS las tablas. Significa que:

**✅ Un usuario PUEDE**:
- Ver solo sus propios datos
- Insertar datos que le pertenecen
- Modificar sus propios datos
- Eliminar sus propios datos

**❌ Un usuario NO PUEDE**:
- Ver datos de otros usuarios
- Modificar datos ajenos
- Acceder a información confidencial

### Ejemplo de Política RLS
```sql
-- Los usuarios solo ven sus propias ventas
CREATE POLICY "Users can view own sales"
    ON ventas FOR SELECT
    USING (auth.uid() = user_id);
```

---

## 🔌 Integración con Flutter

### Ejemplo: Obtener Productos del Usuario

```dart
Future<List<Producto>> obtenerProductos() async {
  final response = await Supabase.instance.client
    .from('productos')
    .select()
    .order('created_at', ascending: false);
  
  return (response as List)
    .map((p) => Producto.fromJson(p))
    .toList();
}
```

### Ejemplo: Crear Nueva Venta

```dart
Future<void> crearVenta(Venta venta) async {
  await Supabase.instance.client
    .from('ventas')
    .insert(venta.toJson());
}
```

---

## 📊 Vistas Creadas

### 1. `vw_ventas_detalle`
Muestra ventas con:
- Número de items
- Listado de productos vendidos
- Total y estado

**Uso**:
```dart
final ventas = await Supabase.instance.client
  .from('vw_ventas_detalle')
  .select();
```

### 2. `vw_resumen_diario`
Resumen del día actual con:
- Total de ventas
- Total de gastos
- Ganancia neta

---

## ✅ Checklist de Configuración

- [ ] Proyecto creado en Supabase
- [ ] Script SQL ejecutado sin errores
- [ ] Todas las tablas creadas
- [ ] RLS habilitado en todas las tablas
- [ ] Políticas de seguridad activas
- [ ] Obtuve las credenciales (URL y ANON_KEY)
- [ ] Archivo `.env` creado en Flutter
- [ ] Dependencia `supabase` añadida
- [ ] Servicio SupabaseService implementado
- [ ] Inicialización de Supabase en main.dart

---

## 🚨 Solución de Problemas

### "RLS denied" Error
**Causa**: Las políticas no permiten la acción  
**Solución**: Verifica que `auth.uid()` coincida con `user_id`

### "Unknown table" Error
**Causa**: El script SQL no se ejecutó correctamente  
**Solución**: Revisa los errores en SQL Editor y vuelve a ejecutar

### "Connection refused" en Flutter
**Causa**: Credenciales incorrectas o red  
**Solución**: Verifica URL y ANON_KEY en `.env`

### Datos de otros usuarios visibles
**Causa**: RLS no está habilitado  
**Solución**: Ejecuta `ALTER TABLE tabla_name ENABLE ROW LEVEL SECURITY;`

---

## 📚 Referencias

- [Documentación Supabase](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL RLS](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

---

## 📞 Soporte

Si tienes problemas:

1. Revisa los logs en Supabase Dashboard → Logs
2. Verifica que RLS esté habilitado: `ALTER TABLE tabla ENABLE ROW LEVEL SECURITY`
3. Consulta las políticas: `SELECT * FROM pg_policies`
4. Abre un issue en GitHub con los detalles del error

---

**¡Tu base de datos está lista para producción!** 🎉
