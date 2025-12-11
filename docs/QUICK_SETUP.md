# 🗄️ GUÍA RÁPIDA - Base de Datos MarketMove

## 📋 Resumen de lo Creado

He creado una base de datos completa para tu app con:

✅ **3 archivos principales**:
1. `supabase_setup.sql` - Script SQL para crear todas las tablas
2. `DATABASE_SETUP.md` - Guía completa de configuración
3. `lib/src/core/models/database_models.dart` - Modelos Dart

✅ **7 Tablas principales**:
- `users` - Perfiles de usuarios
- `productos` - Inventario
- `ventas` - Transacciones
- `venta_detalles` - Líneas de venta
- `gastos` - Gastos operativos
- `resumen` - Dashboard mensual
- `audit_logs` - Auditoría de cambios

✅ **Seguridad**:
- RLS (Row Level Security) activado en TODAS las tablas
- Políticas de seguridad por usuario
- Cada usuario solo ve sus propios datos

---

## 🚀 PASOS PARA IMPLEMENTAR

### 1️⃣ Crear Proyecto en Supabase

```
https://supabase.com
→ Crear nuevo proyecto
→ Nombre: "marketmove"
→ Guardar credenciales (URL y ANON_KEY)
```

### 2️⃣ Ejecutar Script SQL

En Supabase Dashboard:
```
SQL Editor → New Query
Pegar contenido de: supabase_setup.sql
Ejecutar (Ctrl + Enter)
✅ Verificar que no hay errores
```

### 3️⃣ Configurar Flutter

```bash
# Instalar dependencia
flutter pub add supabase
flutter pub add flutter_dotenv

# Crear archivo .env en raíz del proyecto
SUPABASE_URL=https://tuproject.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi...
```

### 4️⃣ Actualizar pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  flutter_dotenv: ^5.1.0
```

### 5️⃣ Usar en Flutter

```dart
// main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load();
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(const MyApp());
}
```

---

## 📊 TABLAS PRINCIPALES

### users
```sql
id, email, full_name, business_name, phone, avatar_url
```

### productos
```sql
id, user_id, nombre, precio, cantidad, sku, categoria, imagen_url
```

### ventas
```sql
id, user_id, numero_venta, cliente_nombre, total, estado, metodo_pago
```

### venta_detalles
```sql
id, venta_id, producto_id, producto_nombre, cantidad, precio_unitario
```

### gastos
```sql
id, user_id, descripcion, monto, categoria, proveedor, metodo_pago, estado
```

### resumen
```sql
id, user_id, total_ventas, total_gastos, ganancia_neta, mes_anio
```

### audit_logs
```sql
id, user_id, accion, tabla, registro_id, datos_anteriores, datos_nuevos
```

---

## 🔐 POLÍTICAS DE SEGURIDAD (RLS)

Cada usuario:
- ✅ VE solo sus propios datos
- ✅ CREA solo sus propios registros
- ✅ MODIFICA solo sus propios datos
- ✅ ELIMINA solo sus propios registros

❌ NO puede acceder a datos de otros usuarios

---

## 💾 EJEMPLOS DE CÓDIGO

### Obtener Productos
```dart
Future<List<Producto>> getProductos() async {
  final data = await Supabase.instance.client
    .from('productos')
    .select()
    .order('created_at', ascending: false);
  
  return (data as List).map((p) => Producto.fromJson(p)).toList();
}
```

### Crear Producto
```dart
Future<void> crearProducto(Producto producto) async {
  await Supabase.instance.client
    .from('productos')
    .insert(producto.toJson());
}
```

### Obtener Ventas del Mes
```dart
Future<List<Venta>> getVentasMes(int mes, int anio) async {
  final data = await Supabase.instance.client
    .from('ventas')
    .select()
    .gte('fecha', DateTime(anio, mes, 1).toIso8601String())
    .lt('fecha', DateTime(anio, mes + 1, 1).toIso8601String())
    .order('fecha', ascending: false);
  
  return (data as List).map((v) => Venta.fromJson(v)).toList();
}
```

### Registrar Gasto
```dart
Future<void> crearGasto(Gasto gasto) async {
  await Supabase.instance.client
    .from('gastos')
    .insert(gasto.toJson());
}
```

---

## ✅ CHECKLIST

- [ ] Proyecto Supabase creado
- [ ] Script SQL ejecutado
- [ ] Todas las tablas visibles en Supabase
- [ ] RLS habilitado en todas las tablas
- [ ] Credenciales obtenidas (URL + ANON_KEY)
- [ ] Archivo `.env` creado
- [ ] Dependencias instaladas
- [ ] Flutter configurado
- [ ] Modelos Dart importados

---

## 📁 ARCHIVOS GENERADOS

```
marketmove_app/
├── supabase_setup.sql          ← Script SQL
├── DATABASE_SETUP.md            ← Guía completa
├── QUICK_SETUP.md               ← Este archivo
├── .env                         ← Tu agregas esto
└── lib/
    └── src/
        └── core/
            └── models/
                └── database_models.dart  ← Modelos Dart
```

---

## 🆘 ERRORES COMUNES

### Error: "RLS denies access"
→ Las políticas no dan permiso
→ Verifica que `auth.uid()` sea el propietario

### Error: "Table not found"
→ El script SQL no se ejecutó bien
→ Vuelve a ejecutarlo en SQL Editor

### Error: "Connection refused"
→ Credenciales incorrectas en `.env`
→ Verifica URL y ANON_KEY

---

## 📚 PRÓXIMOS PASOS

1. Implementar autenticación (registro/login)
2. Crear repositorios para cada tabla
3. Implementar providers/state management
4. Conectar UI con base de datos
5. Agregar validaciones y error handling

---

## 🎯 ESTRUCTURA RECOMENDADA

```
lib/src/
├── core/
│   ├── models/
│   │   └── database_models.dart
│   ├── services/
│   │   └── supabase_service.dart
│   └── theme/
├── features/
│   ├── auth/
│   ├── productos/
│   ├── ventas/
│   ├── gastos/
│   └── resumen/
└── shared/
    ├── repositories/
    ├── providers/
    └── widgets/
```

---

**¡Tu base de datos está lista!** 🎉

Cualquier duda, revisa `DATABASE_SETUP.md` para la guía completa.
