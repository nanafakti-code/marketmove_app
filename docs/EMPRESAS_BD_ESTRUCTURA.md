# Estructura de Base de Datos - Gestión de Empresas

## 📋 Resumen

Se han creado **3 tablas principales** para gestionar la información completa de las empresas (clientes) y sus empleados:

---

## 🏢 Tabla: `empresas`

### Propósito
Almacenar la información completa de cada empresa/cliente registrada en el sistema.

### Campos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único (PK) |
| `admin_id` | UUID | ID del admin propietario (FK → users.id) |
| `nombre_negocio` | VARCHAR(255) | Nombre de la empresa |
| `nif` | VARCHAR(20) | NIF/CIF único de la empresa |
| `sector` | VARCHAR(100) | Sector industrial (ej: Tecnología) |
| `telefono` | VARCHAR(20) | Teléfono de contacto |
| `email_empresa` | VARCHAR(255) | Email corporativo |
| `direccion` | VARCHAR(255) | Calle y número |
| `ciudad` | VARCHAR(100) | Ciudad |
| `provincia` | VARCHAR(100) | Provincia/Estado |
| `codigo_postal` | VARCHAR(10) | Código postal |
| `estado` | VARCHAR(50) | Estado: `activa`, `inactiva`, `suspendida` |
| `created_at` | TIMESTAMP | Fecha de creación (auto) |
| `updated_at` | TIMESTAMP | Fecha de última actualización (auto) |
| `created_by` | UUID | Usuario que creó (FK → users.id) |
| `updated_by` | UUID | Usuario que editó (FK → users.id) |
| `notas` | TEXT | Notas adicionales |

### Relaciones
- **Admin propietario**: `admin_id` → `users.id` (Un admin tiene muchas empresas)
- **Índices**: admin_id, estado, nif

---

## 👥 Tabla: `empleados_empresa`

### Propósito
Almacenar la lista de empleados de cada empresa. **Una empresa puede tener múltiples empleados**.

### Campos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único (PK) |
| `empresa_id` | UUID | ID de la empresa (FK → empresas.id) |
| `nombre_completo` | VARCHAR(255) | Nombre del empleado |
| `email` | VARCHAR(255) | Email corporativo |
| `telefono` | VARCHAR(20) | Teléfono directo |
| `puesto` | VARCHAR(100) | Puesto (ej: Desarrollador) |
| `departamento` | VARCHAR(100) | Departamento (ej: IT) |
| `estado` | VARCHAR(50) | Estado: `activo`, `inactivo`, `baja` |
| `created_at` | TIMESTAMP | Fecha de creación (auto) |
| `updated_at` | TIMESTAMP | Fecha de última actualización (auto) |
| `notas` | TEXT | Notas adicionales |

### Relaciones
- **Empresa**: `empresa_id` → `empresas.id` (Una empresa tiene muchos empleados)
- **Índices**: empresa_id, estado

### Consulta útil: Contar empleados
```sql
SELECT COUNT(*) FROM empleados_empresa WHERE empresa_id = 'xxx-xxx-xxx';
```

---

## 📊 Tabla: `detalles_empresa_metadata`

### Propósito
Almacenar información adicional, estadísticas y datos opcionales de la empresa.

### Campos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único (PK) |
| `empresa_id` | UUID | ID de la empresa (FK, UNIQUE) |
| `forma_legal` | VARCHAR(100) | Forma legal (SL, SA, etc.) |
| `numero_empleados` | INT | Total de empleados |
| `fecha_constitucion` | DATE | Fecha de constitución |
| `actividad_principal` | TEXT | Descripción de actividad |
| `banco` | VARCHAR(100) | Nombre del banco |
| `iban` | VARCHAR(34) | IBAN (considerar cifrado) |
| `website` | VARCHAR(255) | Sitio web |
| `redes_sociales` | JSONB | JSON con redes (flexible) |
| `created_at` | TIMESTAMP | Fecha de creación (auto) |
| `updated_at` | TIMESTAMP | Fecha de última actualización (auto) |

### Relación
- **Empresa**: `empresa_id` → `empresas.id` (1:1)

---

## 👨‍💼 Tabla: `clientes_empresa`

### Propósito
Almacenar la lista de clientes de cada empresa (sub-clientes). **Una empresa puede tener múltiples clientes**.

### Campos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único (PK) |
| `empresa_id` | UUID | ID de la empresa (FK) |
| `nombre_cliente` | VARCHAR(255) | Nombre del cliente |
| `email` | VARCHAR(255) | Email del cliente |
| `telefono` | VARCHAR(20) | Teléfono del cliente |
| `contacto_principal` | VARCHAR(255) | Persona de contacto |
| `razon_social` | VARCHAR(255) | Razón social del cliente |
| `nif_cliente` | VARCHAR(20) | NIF/CIF del cliente |
| `direccion` | VARCHAR(255) | Dirección |
| `ciudad` | VARCHAR(100) | Ciudad |
| `provincia` | VARCHAR(100) | Provincia |
| `codigo_postal` | VARCHAR(10) | Código postal |
| `tipo_cliente` | VARCHAR(100) | Tipo (mayorista, minorista, etc.) |
| `fecha_inicio_relacion` | DATE | Cuándo comenzó la relación |
| `estado` | VARCHAR(50) | Estado: `activo`, `inactivo`, `potencial` |
| `created_at` | TIMESTAMP | Fecha de creación (auto) |
| `updated_at` | TIMESTAMP | Fecha de última actualización (auto) |
| `notas` | TEXT | Notas adicionales |

### Relaciones
- **Empresa**: `empresa_id` → `empresas.id` (Una empresa tiene muchos clientes)
- **Índices**: empresa_id, estado, nif_cliente

---

## 🔐 Row Level Security (RLS)

### Políticas

#### Empresas
1. **Superadmin**: Ve todas las empresas
2. **Admin**: Ve solo sus propias empresas

#### Empleados
1. **Superadmin**: Ve todos los empleados
2. **Admin**: Ve empleados de sus empresas

#### Clientes
1. **Superadmin**: Ve todos los clientes
2. **Admin**: Ve clientes de sus empresas

#### Metadata
1. **Superadmin**: Ve todos los detalles
2. **Admin**: Ve detalles de sus empresas

---

## 📈 Vistas (Views)

### `vw_empresas_completa`
Combinación de empresas con información del admin propietario:
- Nombre del admin
- Email del admin
- Rol del admin
- Información completa de la empresa
- Conteo automático de empleados

### `vw_empleados_empresa_completa`
Combinación de empleados con información de empresa y admin:
- Nombre de la empresa
- Nombre del admin
- Información completa del empleado

### `vw_clientes_empresa_completa`
Combinación de clientes con información de empresa y admin:
- Nombre de la empresa propietaria
- Nombre del admin propietario
- Información completa del cliente
- Estado y tipo de cliente

---

## 🔄 Triggers Automáticos

Se actualizan automáticamente los campos `updated_at`:
- Cuando se modifica una empresa
- Cuando se modifica un empleado
- Cuando se modifica metadata

---

## 💡 Ejemplo de Uso

### Crear una empresa
```sql
INSERT INTO empresas (admin_id, nombre_negocio, nif, sector, telefono, email_empresa, direccion, ciudad, provincia, codigo_postal, estado)
VALUES (
  'uuid-del-admin',
  'Tech Solutions SL',
  'A12345678',
  'Tecnología',
  '+34 912 345 678',
  'info@techsolutions.com',
  'Calle Principal 123',
  'Madrid',
  'Madrid',
  '28001',
  'activa'
);
```

### Agregar empleado a empresa
```sql
INSERT INTO empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado)
VALUES (
  'uuid-de-empresa',
  'María García López',
  'maria@techsolutions.com',
  '+34 912 345 679',
  'Desarrolladora',
  'IT',
  'activo'
);
```

### Agregar cliente a empresa
```sql
INSERT INTO clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado)
VALUES (
  'uuid-de-empresa',
  'Distribuidora ABC',
  'contacto@distribuidora.com',
  '+34 934 567 890',
  'Carlos Pérez',
  'Distribuidora ABC SL',
  'B87654321',
  'Avenida Secundaria 456',
  'Barcelona',
  'Barcelona',
  '08002',
  'mayorista',
  CURRENT_DATE,
  'activo'
);
```

### Obtener empresa con todos sus empleados
```sql
SELECT 
  e.*,
  COUNT(ee.id) AS numero_empleados
FROM empresas e
LEFT JOIN empleados_empresa ee ON e.id = ee.empresa_id
WHERE e.id = 'uuid-de-empresa'
GROUP BY e.id;
```

### Obtener clientes de una empresa
```sql
SELECT * FROM vw_clientes_empresa_completa
WHERE empresa_id = 'uuid-de-empresa'
ORDER BY created_at DESC;
```

### Obtener todas las empresas de un admin con empleados
```sql
SELECT *
FROM vw_empresas_completa
WHERE admin_id = 'uuid-del-admin'
ORDER BY created_at DESC;
```

---

## 🚀 Pasos para Implementar

1. **Copiar el SQL** del archivo `supabase_setup_empresas.sql`
2. **Ir a Supabase** → SQL Editor
3. **Crear nuevo query** y pegar el contenido
4. **Ejecutar** el script
5. **Verificar** que se hayan creado todas las tablas

---

## ⚠️ Notas Importantes

- **IBAN**: Se recomienda cifrar antes de guardar en producción
- **NIF**: Es UNIQUE, no se pueden duplicar
- **Estado**: Usar valores permitidos (activa, inactiva, suspendida)
- **RLS activo**: Los datos están protegidos por rol
- **Auto-timestamps**: No pasar created_at/updated_at, se generan automáticamente

---

## 🔍 Consultas Útiles

### Total de empresas activas
```sql
SELECT COUNT(*) FROM empresas WHERE estado = 'activa';
```

### Empresas sin empleados
```sql
SELECT e.* FROM empresas e
LEFT JOIN empleados_empresa ee ON e.id = ee.empresa_id
WHERE ee.id IS NULL;
```

### Empleados por empresa
```sql
SELECT empresa_id, COUNT(*) as total_empleados
FROM empleados_empresa
GROUP BY empresa_id
ORDER BY total_empleados DESC;
```

### Última actualización
```sql
SELECT nombre_negocio, updated_at
FROM empresas
ORDER BY updated_at DESC
LIMIT 10;
```
