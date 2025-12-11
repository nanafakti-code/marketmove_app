# Instrucciones de Migración - Tabla de Clientes

## Descripción
Esta migración agrega la tabla `clientes` a la base de datos Supabase. Esta tabla permite guardar clientes específicos por usuario y hace más fácil seleccionar clientes al crear ventas.

## Cambios principales:
1. ✅ Tabla `clientes` creada con estructura completa
2. ✅ Modelo `Cliente` agregado a `database_models.dart`
3. ✅ Métodos en `DataRepository` para gestionar clientes
4. ✅ Diálogos de ventas actualizados con dropdown de clientes
5. ✅ Los campos de cliente se auto-rellenan al seleccionar un cliente

## Pasos para ejecutar la migración:

### 1. En Supabase Console:
- Ve a tu proyecto en https://app.supabase.com
- Ve a "SQL Editor"
- Crea una nueva query
- Copia el contenido de `migrations_clientes.sql`
- Ejecuta la query

### 2. Alternativa: CLI de Supabase
```bash
supabase db push
```

## Estructura de la tabla `clientes`:
```
- id: UUID (primary key)
- user_id: UUID (foreign key a users)
- nombre: VARCHAR(255) - Nombre del cliente
- email: VARCHAR(255) - Email único por usuario
- telefono: VARCHAR(20) - Número de teléfono
- empresa: VARCHAR(255) - Nombre de la empresa
- direccion: TEXT - Dirección del cliente
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

## RLS Policies:
- Los usuarios solo pueden ver sus propios clientes
- Los usuarios solo pueden crear, editar y eliminar sus propios clientes

## Cambios en la interfaz:

### En diálogos de ventas (crear y editar):
- **Antes**: Campos manuales para nombre, email y teléfono
- **Ahora**: Dropdown para seleccionar cliente, y los campos se auto-rellenan

### Carga de datos:
- Al abrir el diálogo, se cargan automáticamente los clientes del usuario
- Los campos de cliente son read-only (no editables)

## Notas:
- La migración incluye una vista `cliente_resumen` que muestra estadísticas de clientes
- Los datos existentes en ventas se mantienen intactos
- Se puede agregar más funcionalidad de gestión de clientes en el futuro
