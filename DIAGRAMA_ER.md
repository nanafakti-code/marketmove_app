# 📊 DIAGRAMA ENTIDAD-RELACIÓN (ER) - MarketMove Database

## Relaciones Entre Tablas

```
┌─────────────────────────────────────────────────────────────────┐
│                         users (Usuarios)                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ id (UUID) ⭐ PRIMARY KEY                                   │ │
│  │ email (VARCHAR) UNIQUE                                    │ │
│  │ full_name (VARCHAR)                                       │ │
│  │ business_name (VARCHAR)                                   │ │
│  │ phone (VARCHAR)                                           │ │
│  │ avatar_url (TEXT)                                         │ │
│  │ created_at (TIMESTAMP)                                    │ │
│  │ updated_at (TIMESTAMP)                                    │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
                 ┌─────────────┼─────────────┬──────────────┐
                 │             │             │              │
                 ▼             ▼             ▼              ▼
        ┌──────────────┐ ┌──────────┐ ┌──────────┐ ┌────────────────┐
        │  productos   │ │ ventas   │ │  gastos  │ │     resumen    │
        ├──────────────┤ ├──────────┤ ├──────────┤ ├────────────────┤
        │ id (UUID) ⭐ │ │ id ⭐    │ │ id ⭐   │ │ id ⭐         │
        │ user_id 🔑  │ │ user_id🔑│ │user_id🔑│ │ user_id 🔑    │
        │ nombre      │ │numero    │ │descrip  │ │total_ventas    │
        │ precio      │ │cliente   │ │monto    │ │total_gastos    │
        │ cantidad    │ │total     │ │categoria│ │ganancia_neta   │
        │ sku         │ │impuesto  │ │proveedor│ │cantidad_prod   │
        │ categoria   │ │descuento │ │metodo   │ │cantidad_clientes│
        │ imagen_url  │ │estado    │ │estado   │ │mes_anio        │
        │ activo      │ │metodo    │ │recibo   │ │created_at      │
        │ created_at  │ │notas     │ │fecha    │ │updated_at      │
        │ updated_at  │ │fecha     │ │updated  │ └────────────────┘
        └──────────────┘ │created   │ │at       │
                         │updated   │ └──────────┘
                         └──────────┘
                             │
                             ▼
                    ┌─────────────────────┐
                    │  venta_detalles     │
                    ├─────────────────────┤
                    │ id (UUID) ⭐       │
                    │ venta_id 🔑        │
                    │ producto_id 🔑     │
                    │ producto_nombre    │
                    │ cantidad           │
                    │ precio_unitario    │
                    │ subtotal           │
                    │ created_at         │
                    └─────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    audit_logs (Auditoría)                       │
├─────────────────────────────────────────────────────────────────┤
│ id (UUID) ⭐                                                    │
│ user_id 🔑  ────────────► vinculado con users para auditoría  │
│ accion (INSERT|UPDATE|DELETE)                                  │
│ tabla (nombre de tabla afectada)                               │
│ registro_id (ID del registro modificado)                       │
│ datos_anteriores (JSONB)                                       │
│ datos_nuevos (JSONB)                                           │
│ created_at (TIMESTAMP)                                         │
└─────────────────────────────────────────────────────────────────┘

Legend:
⭐ = Primary Key (Clave Primaria)
🔑 = Foreign Key (Clave Foránea)
```

---

## Descripción de Relaciones

### 1. **users** → **productos** (1:N)
- Un usuario puede tener MUCHOS productos
- Cada producto pertenece a UN usuario
- Relación: `user_id` en productos refiere a `users.id`
- Cascade Delete: Si el usuario se elimina, se eliminan sus productos

### 2. **users** → **ventas** (1:N)
- Un usuario puede realizar MUCHAS ventas
- Cada venta pertenece a UN usuario
- Relación: `user_id` en ventas refiere a `users.id`
- Cascade Delete: Si el usuario se elimina, se eliminan sus ventas

### 3. **ventas** → **venta_detalles** (1:N)
- Una venta puede tener MUCHOS detalles (líneas)
- Cada detalle pertenece a UNA venta
- Relación: `venta_id` en venta_detalles refiere a `ventas.id`
- Cascade Delete: Si la venta se elimina, se eliminan los detalles

### 4. **productos** → **venta_detalles** (1:N)
- Un producto puede aparecer en MUCHAS ventas
- Cada línea de venta referencia UN producto (opcional)
- Relación: `producto_id` en venta_detalles refiere a `productos.id`
- Set NULL: Si el producto se elimina, el detalle conserva el nombre pero producto_id = NULL

### 5. **users** → **gastos** (1:N)
- Un usuario puede tener MUCHOS gastos
- Cada gasto pertenece a UN usuario
- Relación: `user_id` en gastos refiere a `users.id`
- Cascade Delete: Si el usuario se elimina, se eliminan sus gastos

### 6. **users** → **resumen** (1:1)
- Un usuario tiene UN resumen por mes
- Relación: `user_id` en resumen refiere a `users.id` (UNIQUE)
- Cascade Delete: Si el usuario se elimina, se elimina su resumen

### 7. **users** → **audit_logs** (1:N)
- Un usuario genera MUCHOS registros de auditoría
- Cada log registra cambios del usuario
- Relación: `user_id` en audit_logs refiere a `users.id`
- Cascade Delete: Si el usuario se elimina, se eliminan sus logs

---

## Integridad Referencial

### Foreign Keys (Claves Foráneas) Configuradas

```sql
-- productos
ALTER TABLE productos
ADD CONSTRAINT fk_productos_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- ventas
ALTER TABLE ventas
ADD CONSTRAINT fk_ventas_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- venta_detalles
ALTER TABLE venta_detalles
ADD CONSTRAINT fk_venta_detalles_venta_id
FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE;

ALTER TABLE venta_detalles
ADD CONSTRAINT fk_venta_detalles_producto_id
FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL;

-- gastos
ALTER TABLE gastos
ADD CONSTRAINT fk_gastos_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- resumen
ALTER TABLE resumen
ADD CONSTRAINT fk_resumen_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- audit_logs
ALTER TABLE audit_logs
ADD CONSTRAINT fk_audit_logs_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
```

---

## Índices Creados para Optimización

```sql
-- Búsqueda por usuario (más frecuente)
CREATE INDEX idx_productos_user_id ON productos(user_id);
CREATE INDEX idx_ventas_user_id ON ventas(user_id);
CREATE INDEX idx_gastos_user_id ON gastos(user_id);
CREATE INDEX idx_resumen_user_id ON resumen(user_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);

-- Búsqueda por fecha
CREATE INDEX idx_ventas_fecha ON ventas(fecha);
CREATE INDEX idx_gastos_fecha ON gastos(fecha);
CREATE INDEX idx_resumen_mes_anio ON resumen(mes_anio);
CREATE INDEX idx_audit_logs_fecha ON audit_logs(created_at);

-- Búsqueda por estado/categoría
CREATE INDEX idx_ventas_estado ON ventas(estado);
CREATE INDEX idx_productos_categoria ON productos(categoria);
CREATE INDEX idx_gastos_categoria ON gastos(categoria);
CREATE INDEX idx_gastos_proveedor ON gastos(proveedor);

-- Búsqueda por timestamp
CREATE INDEX idx_usuarios_created_at ON users(created_at);
CREATE INDEX idx_productos_created_at ON productos(created_at);
```

---

## Cascadas y Comportamientos

### ON DELETE CASCADE (Eliminar en cascada)
- **users** → productos: Eliminar usuario = Eliminar sus productos
- **users** → ventas: Eliminar usuario = Eliminar sus ventas
- **users** → gastos: Eliminar usuario = Eliminar sus gastos
- **users** → resumen: Eliminar usuario = Eliminar su resumen
- **users** → audit_logs: Eliminar usuario = Eliminar sus logs
- **ventas** → venta_detalles: Eliminar venta = Eliminar detalles

### ON DELETE SET NULL
- **productos** → venta_detalles: Eliminar producto = Mantener detalle (producto_id = NULL)
  - Razón: Queremos mantener el historial de ventas aunque el producto se elimine

---

## Queries Típicas y Relaciones

### Obtener todas las ventas de un usuario con detalles
```sql
SELECT v.*, vd.producto_nombre, vd.cantidad, vd.precio_unitario
FROM ventas v
LEFT JOIN venta_detalles vd ON v.id = vd.venta_id
WHERE v.user_id = 'uuid-usuario'
ORDER BY v.fecha DESC;
```

### Obtener resumen del mes con gastos y ventas
```sql
SELECT 
  r.total_ventas,
  r.total_gastos,
  r.ganancia_neta,
  COUNT(DISTINCT v.id) as num_ventas,
  COUNT(DISTINCT g.id) as num_gastos
FROM resumen r
LEFT JOIN ventas v ON v.user_id = r.user_id AND DATE_TRUNC('month', v.fecha) = r.mes_anio
LEFT JOIN gastos g ON g.user_id = r.user_id AND DATE_TRUNC('month', g.fecha) = r.mes_anio
WHERE r.user_id = 'uuid-usuario'
GROUP BY r.id;
```

### Auditar cambios de un usuario
```sql
SELECT 
  al.accion,
  al.tabla,
  al.registro_id,
  al.datos_anteriores,
  al.datos_nuevos,
  al.created_at
FROM audit_logs al
WHERE al.user_id = 'uuid-usuario'
ORDER BY al.created_at DESC;
```

---

## Constraints (Restricciones)

### UNIQUE Constraints
```sql
-- Un usuario no puede tener dos productos con el mismo SKU
UNIQUE(user_id, sku) en productos

-- Un usuario no puede tener dos emails iguales
UNIQUE(email) en users

-- Un resumen único por usuario y mes
UNIQUE(user_id) en resumen (combinada con mes_anio)
```

### NOT NULL Constraints
```sql
-- Campos obligatorios
users.id, email
productos.user_id, nombre, precio, cantidad
ventas.user_id, total, fecha
venta_detalles.venta_id, producto_nombre, cantidad, precio_unitario
gastos.user_id, descripcion, monto, fecha
```

### DEFAULT Values
```sql
productos.activo = TRUE
ventas.estado = 'completada'
ventas.impuesto = 0
ventas.descuento = 0
gastos.estado = 'pagado'
gastos.monto = 0
resumen.total_ventas = 0
resumen.total_gastos = 0
```

---

## Normalization (Normalización)

La base de datos sigue **3rd Normal Form (3NF)**:

### 1NF: Atomic Values ✅
- Cada celda contiene un único valor
- No hay arrays o objetos anidados

### 2NF: No Partial Dependencies ✅
- Cada columna no-clave depende completamente de la clave primaria
- `producto_nombre` en `venta_detalles` duplica el nombre porque puede cambiar

### 3NF: No Transitive Dependencies ✅
- No hay dependencias entre columnas no-clave
- Ejemplo: `ganancia_neta` en `resumen` se calcula pero se almacena para performance

---

## Ejemplo Completo: Una Venta

```
users (id: U1)
  │ user_id = U1
  └─────────► ventas (id: V1)
               │ numero_venta: "V-001"
               │ cliente_nombre: "Juan"
               │ total: 150.00
               │
               └─────────► venta_detalles (id: VD1)
                            │ producto_id: P1
                            │ producto_nombre: "Laptop"
                            │ cantidad: 1
                            │ precio_unitario: 100.00
                            │ subtotal: 100.00
                            │
                            └─────────► productos (id: P1)
                                         │ nombre: "Laptop"
                                         │ precio: 100.00
                                         │ cantidad (stock): 5
                            
                           venta_detalles (id: VD2)
                            │ producto_id: P2
                            │ producto_nombre: "Mouse"
                            │ cantidad: 1
                            │ precio_unitario: 50.00
                            │ subtotal: 50.00
                            │
                            └─────────► productos (id: P2)
                                         │ nombre: "Mouse"
                                         │ precio: 50.00
                                         │ cantidad (stock): 20
```

---

## Vistas Creadas

### vw_ventas_detalle
```sql
SELECT
  v.id, v.user_id, v.numero_venta, v.cliente_nombre,
  v.total, v.estado, v.metodo_pago, v.fecha,
  COUNT(vd.id) as cantidad_items,
  STRING_AGG(vd.producto_nombre, ', ') as productos
FROM ventas v
LEFT JOIN venta_detalles vd ON v.id = vd.venta_id
GROUP BY v.id...
```

**Uso**: Ver ventas completas con listado de productos

### vw_resumen_diario
```sql
SELECT
  auth.uid() as user_id,
  CURRENT_DATE as fecha,
  SUM(v.total) as total_ventas,
  SUM(g.monto) as total_gastos,
  SUM(v.total) - SUM(g.monto) as ganancia_neta
```

**Uso**: Dashboard con resumen del día

---

## Consistencia de Datos

### Triggers Automáticos

1. **Crear usuario al registrarse** (after insert en auth.users)
   ```
   auth.users → inserta registro en users
   ```

2. **Actualizar timestamp** (before update)
   ```
   Cada tabla tiene updated_at que se actualiza automáticamente
   ```

3. **Validar integridad** (antes de insert/update)
   ```
   - precio > 0
   - cantidad >= 0
   - total > 0
   - estado en valores permitidos
   ```

---

Esta es la estructura completa y profesional de tu base de datos. ¡Lista para producción! 🚀
