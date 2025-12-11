-- Migración: Crear tabla de clientes
-- Descripción: Crea la tabla de clientes para permitir la selección de clientes en ventas

-- ============================================
-- CLIENTES (Clients)
-- ============================================
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telefono VARCHAR(20),
    empresa VARCHAR(255),
    direccion TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, email)
);

-- Create index on user_id for better query performance
CREATE INDEX IF NOT EXISTS idx_clientes_user_id ON clientes(user_id);

-- Enable RLS for clientes table
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own clients
CREATE POLICY "Users can view own clients"
    ON clientes FOR SELECT
    USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own clients
CREATE POLICY "Users can insert own clients"
    ON clientes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can update their own clients
CREATE POLICY "Users can update own clients"
    ON clientes FOR UPDATE
    USING (auth.uid() = user_id);

-- RLS Policy: Users can delete their own clients
CREATE POLICY "Users can delete own clients"
    ON clientes FOR DELETE
    USING (auth.uid() = user_id);

-- Crear vista para resumen de clientes
CREATE VIEW cliente_resumen AS
SELECT 
    c.id,
    c.user_id,
    c.nombre,
    c.email,
    c.telefono,
    COUNT(v.id) as cantidad_ventas,
    COALESCE(SUM(v.total), 0) as total_gastado
FROM clientes c
LEFT JOIN ventas v ON c.user_id = v.user_id AND c.nombre = v.cliente_nombre
GROUP BY c.id, c.user_id, c.nombre, c.email, c.telefono;
