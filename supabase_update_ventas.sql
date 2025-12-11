-- Agregar columna producto_id a la tabla ventas
-- NOTA: numero_venta NO se almacena en BD, se genera como secuencial en la app (001, 002, etc)
-- El ID de la venta es el UUID generado automáticamente por Supabase

ALTER TABLE ventas 
ADD COLUMN producto_id UUID REFERENCES productos(id) ON DELETE SET NULL;

-- Crear índice para mejorar rendimiento
CREATE INDEX idx_ventas_producto_id ON ventas(producto_id);
