# 📦 ÍNDICE COMPLETO - Base de Datos MarketMove

## 📋 Resumen Ejecutivo

He creado una **base de datos profesional, segura y lista para producción** con:
- ✅ 7 tablas principales
- ✅ Row Level Security (RLS) en todas las tablas
- ✅ Modelos Dart completos
- ✅ Repositorios de acceso a datos
- ✅ Documentación exhaustiva
- ✅ Ejemplos prácticos de SQL y Flutter

---

## 📁 ARCHIVOS GENERADOS

### 1. **supabase_setup.sql** (600+ líneas)
**Ubicación**: `/supabase_setup.sql`

**Contenido**:
- ✅ 7 tablas con RLS habilitado
- ✅ Índices para optimizar performance
- ✅ Triggers automáticos
- ✅ Vistas útiles (vw_ventas_detalle, vw_resumen_diario)
- ✅ Comentarios de documentación

**Tablas creadas**:
```
users              - Perfiles de usuarios
productos          - Inventario
ventas             - Transacciones
venta_detalles     - Líneas de venta
gastos             - Gastos operativos
resumen            - Dashboard mensual
audit_logs         - Auditoría de cambios
```

**Cómo usar**:
1. Ir a Supabase Dashboard → SQL Editor
2. Crear nuevo query
3. Copiar y pegar todo el contenido
4. Ejecutar (Ctrl + Enter)

---

### 2. **DATABASE_SETUP.md** (Guía Completa)
**Ubicación**: `/DATABASE_SETUP.md`

**Secciones**:
- 📝 Paso 1: Crear Proyecto en Supabase
- 🔧 Paso 2: Ejecutar Script SQL
- 🔐 Paso 3: Verificar RLS y Políticas
- 📦 Paso 4: Configurar Flutter
- 🔌 Paso 5: Crear Servicio Supabase
- 📊 Descripción detallada de tablas
- 🛡️ Políticas de seguridad explicadas
- 🔌 Integración con Flutter
- ✅ Checklist de configuración
- 🚨 Solución de problemas

**Cuándo usarla**: Cuando necesites instrucciones paso a paso detalladas

---

### 3. **QUICK_SETUP.md** (Guía Rápida)
**Ubicación**: `/QUICK_SETUP.md`

**Secciones**:
- 📋 Resumen de lo creado
- 🚀 5 pasos principales
- 📊 Tablas principales (lista rápida)
- 🔐 Políticas de seguridad resumidas
- 💾 Ejemplos de código
- ✅ Checklist
- 🆘 Errores comunes

**Cuándo usarla**: Para una implementación rápida (10 minutos)

---

### 4. **RESUMEN_BD.md** (Resumen Ejecutivo)
**Ubicación**: `/RESUMEN_BD.md`

**Secciones**:
- ✅ Lo que se ha creado
- 📁 Archivos generados
- 🏗️ Estructura de tablas
- 🔐 Seguridad implementada
- 🚀 Próximos pasos
- 📊 Tablas principales
- 💻 Ejemplos de código
- 📞 Documentación de referencia

**Cuándo usarla**: Para una visión general de todo lo creado

---

### 5. **DIAGRAMA_ER.md** (Relaciones entre Tablas)
**Ubicación**: `/DIAGRAMA_ER.md`

**Contenido**:
- 📊 Diagrama visual de relaciones
- 📝 Descripción de relaciones (1:N, 1:1)
- 🔑 Foreign Keys (claves foráneas)
- 📈 Índices creados
- 🌊 Cascadas y comportamientos
- 📋 Queries típicas
- ✓ Constraints (restricciones)
- 📐 Normalización (3NF)
- 👀 Vistas creadas

**Cuándo usarla**: Para entender la estructura y relaciones de datos

---

### 6. **EJEMPLOS_SQL_FLUTTER.md** (Código Práctico)
**Ubicación**: `/EJEMPLOS_SQL_FLUTTER.md`

**Secciones**:
- 📖 Consultas SQL completas (usuarios, productos, ventas, gastos, resumen)
- 💻 Ejemplos Flutter (obtener datos, crear registros, escuchar cambios)
- 🎯 Casos de uso complejos (crear venta completa, dashboard)
- 📊 Servicio DashboardData

**Cuándo usarla**: Cuando necesites código para copiar y adaptar

---

### 7. **database_models.dart** (Modelos Dart)
**Ubicación**: `/lib/src/core/models/database_models.dart`

**Clases incluidas**:
- Usuario
- Producto
- Venta
- VentaDetalle
- Gasto
- Resumen
- AuditLog

**Cada modelo incluye**:
- ✅ Constructor con parámetros requeridos y opcionales
- ✅ `fromJson()` - Convertir desde JSON de Supabase
- ✅ `toJson()` - Convertir a JSON para guardar
- ✅ `copyWith()` - Crear copia modificada (inmutabilidad)
- ✅ Tipado fuerte

**Cómo usarla**:
```dart
import 'package:marketmove_app/src/core/models/database_models.dart';

final producto = Producto.fromJson(jsonDeSupabase);
await supabase.from('productos').insert(producto.toJson());
```

---

### 8. **supabase_repository.dart** (Repositorios de Datos)
**Ubicación**: `/lib/src/shared/repositories/supabase_repository.dart`

**Clases incluidas**:
- `Repository<T>` - Interface abstracto
- `ProductoRepository` - CRUD de productos
- `VentaRepository` - CRUD de ventas
- `GastoRepository` - CRUD de gastos
- `UsuarioRepository` - Gestión de perfil
- `ResumenRepository` - Resumen mensual

**Métodos principales**:
```
getAll()              - Obtener todos los registros
getById(id)           - Obtener por ID
insert(item)          - Crear nuevo registro
update(id, item)      - Modificar registro
delete(id)            - Eliminar registro
Métodos específicos   - Búsquedas avanzadas
```

**Cómo usarla**:
```dart
final repo = ProductoRepository(supabaseClient);
final productos = await repo.getAll();
await repo.insert(nuevoProducto);
```

---

## 🔐 SEGURIDAD

### Row Level Security (RLS)

**Habilitado en todas las tablas**:
- ✅ users
- ✅ productos
- ✅ ventas
- ✅ venta_detalles
- ✅ gastos
- ✅ resumen
- ✅ audit_logs

**Políticas implementadas**:
- ✅ SELECT - Usuario ve solo sus datos
- ✅ INSERT - Usuario crea solo sus datos
- ✅ UPDATE - Usuario modifica solo sus datos
- ✅ DELETE - Usuario elimina solo sus datos

### Ejemplo de Política RLS
```sql
CREATE POLICY "Users can view own products"
    ON productos FOR SELECT
    USING (auth.uid() = user_id);
```

---

## 🚀 PASOS PARA IMPLEMENTAR (10 minutos)

### 1. Crear Proyecto Supabase
```
https://supabase.com → New Project
Nombre: marketmove
Región: Europa (más cercana a ti)
Guardar: URL y ANON_KEY
```

### 2. Ejecutar Script SQL
```
Supabase Dashboard
→ SQL Editor
→ New Query
→ Pegar: supabase_setup.sql
→ Ejecutar (Ctrl + Enter)
```

### 3. Instalar Dependencias Flutter
```bash
flutter pub add supabase_flutter
flutter pub add flutter_dotenv
```

### 4. Crear .env
```
SUPABASE_URL=https://tuproject.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi...
```

### 5. Inicializar en main.dart
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

## 📊 ESTRUCTURA DE DATOS

```
┌─────────────┐
│   USERS     │  ← Punto central
│  (auth.uuid)│
└──────┬──────┘
       │
  ┌────┼────┬──────┬────────┐
  │    │    │      │        │
  ▼    ▼    ▼      ▼        ▼
PROD VENT GAST RESUM AUDIT
  +     +    +    +    +
 SKU  DETL  CAT  MENS  LOG
```

---

## 💾 TABLAS PRINCIPALES

### users
```
id (UUID)          - Referencia a auth.users
email (VARCHAR)    - Correo único
full_name          - Nombre del usuario
business_name      - Nombre del negocio
phone              - Teléfono de contacto
avatar_url         - Foto de perfil
```

### productos
```
id (UUID)          - Identificador único
user_id (FK)       - Propietario del producto
nombre (VARCHAR)   - Nombre del producto
precio (DECIMAL)   - Precio unitario
cantidad (INT)     - Stock disponible
sku (VARCHAR)      - Código único
categoria          - Categoría del producto
imagen_url         - Foto del producto
activo (BOOLEAN)   - Disponible o no
```

### ventas
```
id (UUID)          - Identificador de venta
user_id (FK)       - Usuario que vendió
numero_venta       - Número de transacción
cliente_nombre     - Nombre del cliente
total (DECIMAL)    - Monto total
impuesto           - Impuestos (IVA, etc)
descuento          - Descuentos aplicados
estado             - completada/pendiente/cancelada
metodo_pago        - efectivo/tarjeta/transferencia
fecha (TIMESTAMP)  - Cuándo ocurrió
```

### venta_detalles
```
id (UUID)          - Identificador del detalle
venta_id (FK)      - Referencia a venta
producto_id (FK)   - Referencia a producto
producto_nombre    - Nombre al momento de venta
cantidad (INT)     - Unidades vendidas
precio_unitario    - Precio en ese momento
subtotal           - cantidad × precio_unitario
```

### gastos
```
id (UUID)          - Identificador de gasto
user_id (FK)       - Usuario propietario
descripcion        - Qué fue el gasto
monto (DECIMAL)    - Cantidad gastada
categoria          - arriendo/servicios/proveedores/salarios/otros
proveedor          - De dónde vino el gasto
metodo_pago        - Cómo se pagó
estado             - pagado/pendiente/cancelado
recibo_url         - Foto del recibo
fecha (TIMESTAMP)  - Cuándo ocurrió
```

### resumen
```
id (UUID)          - Identificador único
user_id (FK)       - Usuario propietario
total_ventas       - Suma de ventas del mes
total_gastos       - Suma de gastos del mes
ganancia_neta      - ventas - gastos
cantidad_productos - Productos únicos
cantidad_clientes  - Clientes únicos
mes_anio (DATE)    - Mes y año del resumen
```

### audit_logs
```
id (UUID)          - Identificador del log
user_id (FK)       - Quién hizo el cambio
accion             - INSERT/UPDATE/DELETE
tabla              - Tabla afectada
registro_id        - Registro afectado
datos_anteriores   - Estado anterior (JSON)
datos_nuevos       - Estado nuevo (JSON)
created_at         - Cuándo ocurrió
```

---

## 📚 DOCUMENTACIÓN

| Archivo | Propósito | Cuándo usar |
|---------|-----------|-------------|
| supabase_setup.sql | Script SQL completo | Crear BD en Supabase |
| DATABASE_SETUP.md | Guía detallada paso a paso | Configuración completa |
| QUICK_SETUP.md | Guía rápida | Implementación rápida |
| RESUMEN_BD.md | Resumen ejecutivo | Visión general |
| DIAGRAMA_ER.md | Relaciones entre tablas | Entender estructura |
| EJEMPLOS_SQL_FLUTTER.md | Código práctico | Copiar y adaptar |
| database_models.dart | Modelos Dart | Importar en proyecto |
| supabase_repository.dart | Repositorios | Acceso a datos |

---

## ✅ CHECKLIST FINAL

- [ ] Proyecto Supabase creado y credenciales guardadas
- [ ] Script SQL ejecutado sin errores
- [ ] 7 tablas creadas y visibles
- [ ] RLS habilitado en todas las tablas
- [ ] Políticas de seguridad activas
- [ ] Dependencias Flutter instaladas (supabase_flutter, flutter_dotenv)
- [ ] Archivo .env creado con credenciales
- [ ] Supabase.initialize() en main.dart
- [ ] Modelos importados correctamente
- [ ] Repositorios listos para usar
- [ ] Base de datos en versión control de git
- [ ] Documentación guardada para referencia

---

## 🚨 ERRORES COMUNES Y SOLUCIONES

| Error | Causa | Solución |
|-------|-------|----------|
| "Unknown table" | Script no ejecutado | Vuelve a ejecutar en SQL Editor |
| "RLS denies access" | Políticas incorrectas | Verifica auth.uid() = user_id |
| "Connection refused" | Credenciales incorrectas | Revisa .env |
| "Field not found" | Tabla diferente | Verifica exactamente el nombre |
| Datos de otros usuarios | RLS no habilitado | Ejecuta ALTER TABLE ENABLE RLS |

---

## 📞 RECURSOS

- **Supabase Docs**: https://supabase.com/docs
- **Supabase Flutter**: https://pub.dev/packages/supabase_flutter
- **PostgreSQL RLS**: https://www.postgresql.org/docs/current/ddl-rowsecurity.html
- **Dart Modeling**: Ejemplos en database_models.dart

---

## 🎉 ¡LISTO!

Tu base de datos está completamente lista para producción con:
- ✅ 7 tablas profesionales
- ✅ Seguridad implementada
- ✅ Modelos Dart tipados
- ✅ Repositorios de datos
- ✅ Documentación exhaustiva
- ✅ Ejemplos prácticos

**Próximo paso**: 
1. Lee `QUICK_SETUP.md` (5 min)
2. Crea proyecto en Supabase (2 min)
3. Ejecuta script SQL (1 min)
4. Configura Flutter (2 min)

**¡Total: 10 minutos para tener todo listo!**

---

**Creado**: 1 de diciembre de 2025
**Versión**: 1.0
**Estado**: ✅ Listo para Producción
**Autor**: AI Assistant (GitHub Copilot)
