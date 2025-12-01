    -- ============================================
    -- MarketMove App - Supabase Database Setup
    -- ============================================
    -- This SQL script sets up the database schema with RLS (Row Level Security) policies

    -- ============================================
    -- 1. USUARIOS (Users)
    -- ============================================
    CREATE TABLE IF NOT EXISTS users (
        id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
        email VARCHAR(255) NOT NULL UNIQUE,
        full_name VARCHAR(255),
        phone VARCHAR(20),
        business_name VARCHAR(255),
        avatar_url TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Enable RLS for users table
    ALTER TABLE users ENABLE ROW LEVEL SECURITY;

    -- RLS Policy: Users can only see their own profile
    CREATE POLICY "Users can view own profile"
        ON users FOR SELECT
        USING (auth.uid() = id);

    -- RLS Policy: Users can update their own profile
    CREATE POLICY "Users can update own profile"
        ON users FOR UPDATE
        USING (auth.uid() = id);

    -- RLS Policy: Users can insert their own profile (during registration)
    CREATE POLICY "Users can insert own profile"
        ON users FOR INSERT
        WITH CHECK (auth.uid() = id);

    -- ============================================
    -- 2. PRODUCTOS (Products)
    -- ============================================
    CREATE TABLE IF NOT EXISTS productos (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        nombre VARCHAR(255) NOT NULL,
        descripcion TEXT,
        precio DECIMAL(10, 2) NOT NULL,
        cantidad INT DEFAULT 0,
        sku VARCHAR(50),
        categoria VARCHAR(100),
        imagen_url TEXT,
        activo BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, sku)
    );

    -- Create index on user_id for better query performance
    CREATE INDEX IF NOT EXISTS idx_productos_user_id ON productos(user_id);

    -- Enable RLS for productos table
    ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

    -- RLS Policy: Users can only see their own products
    CREATE POLICY "Users can view own products"
        ON productos FOR SELECT
        USING (auth.uid() = user_id);

    -- RLS Policy: Users can insert their own products
    CREATE POLICY "Users can insert own products"
        ON productos FOR INSERT
        WITH CHECK (auth.uid() = user_id);

    -- RLS Policy: Users can update their own products
    CREATE POLICY "Users can update own products"
        ON productos FOR UPDATE
        USING (auth.uid() = user_id);

    -- RLS Policy: Users can delete their own products
    CREATE POLICY "Users can delete own products"
        ON productos FOR DELETE
        USING (auth.uid() = user_id);

    -- ============================================
    -- 3. VENTAS (Sales)
    -- ============================================
    CREATE TABLE IF NOT EXISTS ventas (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        numero_venta VARCHAR(50) UNIQUE,
        cliente_nombre VARCHAR(255),
        cliente_email VARCHAR(255),
        cliente_telefono VARCHAR(20),
        total DECIMAL(12, 2) NOT NULL,
        impuesto DECIMAL(10, 2) DEFAULT 0,
        descuento DECIMAL(10, 2) DEFAULT 0,
        estado VARCHAR(50) DEFAULT 'completada', -- pendiente, completada, cancelada
        metodo_pago VARCHAR(50), -- efectivo, tarjeta, transferencia, cheque
        notas TEXT,
        fecha TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create indexes
    CREATE INDEX IF NOT EXISTS idx_ventas_user_id ON ventas(user_id);
    CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);
    CREATE INDEX IF NOT EXISTS idx_ventas_estado ON ventas(estado);

    -- Enable RLS for ventas table
    ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;

    -- RLS Policies for ventas
    CREATE POLICY "Users can view own sales"
        ON ventas FOR SELECT
        USING (auth.uid() = user_id);

    CREATE POLICY "Users can insert own sales"
        ON ventas FOR INSERT
        WITH CHECK (auth.uid() = user_id);

    CREATE POLICY "Users can update own sales"
        ON ventas FOR UPDATE
        USING (auth.uid() = user_id);

    CREATE POLICY "Users can delete own sales"
        ON ventas FOR DELETE
        USING (auth.uid() = user_id);

    -- ============================================
    -- 4. DETALLES DE VENTAS (Sale Items)
    -- ============================================
    CREATE TABLE IF NOT EXISTS venta_detalles (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
        producto_id UUID REFERENCES productos(id) ON DELETE SET NULL,
        producto_nombre VARCHAR(255) NOT NULL,
        cantidad INT NOT NULL,
        precio_unitario DECIMAL(10, 2) NOT NULL,
        subtotal DECIMAL(12, 2) NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create index
    CREATE INDEX IF NOT EXISTS idx_venta_detalles_venta_id ON venta_detalles(venta_id);

    -- Enable RLS
    ALTER TABLE venta_detalles ENABLE ROW LEVEL SECURITY;

    -- RLS Policy: Access through parent venta
    CREATE POLICY "Users can view own sale items"
        ON venta_detalles FOR SELECT
        USING (
            venta_id IN (
                SELECT id FROM ventas WHERE user_id = auth.uid()
            )
        );

    CREATE POLICY "Users can insert own sale items"
        ON venta_detalles FOR INSERT
        WITH CHECK (
            venta_id IN (
                SELECT id FROM ventas WHERE user_id = auth.uid()
            )
        );

    CREATE POLICY "Users can update own sale items"
        ON venta_detalles FOR UPDATE
        USING (
            venta_id IN (
                SELECT id FROM ventas WHERE user_id = auth.uid()
            )
        );

    CREATE POLICY "Users can delete own sale items"
        ON venta_detalles FOR DELETE
        USING (
            venta_id IN (
                SELECT id FROM ventas WHERE user_id = auth.uid()
            )
        );

    -- ============================================
    -- 5. GASTOS (Expenses)
    -- ============================================
    CREATE TABLE IF NOT EXISTS gastos (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        descripcion VARCHAR(255) NOT NULL,
        monto DECIMAL(10, 2) NOT NULL,
        categoria VARCHAR(100), -- arriendo, servicios, proveedores, salarios, otros
        proveedor VARCHAR(255),
        referencia VARCHAR(100),
        metodo_pago VARCHAR(50), -- efectivo, tarjeta, transferencia, cheque
        estado VARCHAR(50) DEFAULT 'pagado', -- pagado, pendiente, cancelado
        notas TEXT,
        recibo_url TEXT,
        fecha TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create indexes
    CREATE INDEX IF NOT EXISTS idx_gastos_user_id ON gastos(user_id);
    CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON gastos(fecha);
    CREATE INDEX IF NOT EXISTS idx_gastos_categoria ON gastos(categoria);

    -- Enable RLS for gastos table
    ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;

    -- RLS Policies for gastos
    CREATE POLICY "Users can view own expenses"
        ON gastos FOR SELECT
        USING (auth.uid() = user_id);

    CREATE POLICY "Users can insert own expenses"
        ON gastos FOR INSERT
        WITH CHECK (auth.uid() = user_id);

    CREATE POLICY "Users can update own expenses"
        ON gastos FOR UPDATE
        USING (auth.uid() = user_id);

    CREATE POLICY "Users can delete own expenses"
        ON gastos FOR DELETE
        USING (auth.uid() = user_id);

    -- ============================================
    -- 6. RESUMEN (Dashboard Summary)
    -- ============================================
    CREATE TABLE IF NOT EXISTS resumen (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,
        total_ventas DECIMAL(12, 2) DEFAULT 0,
        total_gastos DECIMAL(12, 2) DEFAULT 0,
        ganancia_neta DECIMAL(12, 2) DEFAULT 0,
        cantidad_productos INT DEFAULT 0,
        cantidad_clientes INT DEFAULT 0,
        mes_anio DATE NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create indexes
    CREATE INDEX IF NOT EXISTS idx_resumen_user_id ON resumen(user_id);
    CREATE INDEX IF NOT EXISTS idx_resumen_mes_anio ON resumen(mes_anio);

    -- Enable RLS
    ALTER TABLE resumen ENABLE ROW LEVEL SECURITY;

    -- RLS Policies for resumen
    CREATE POLICY "Users can view own summary"
        ON resumen FOR SELECT
        USING (auth.uid() = user_id);

    CREATE POLICY "Users can insert own summary"
        ON resumen FOR INSERT
        WITH CHECK (auth.uid() = user_id);

    CREATE POLICY "Users can update own summary"
        ON resumen FOR UPDATE
        USING (auth.uid() = user_id);

    -- ============================================
    -- 7. AUDITORÍA (Audit Log)
    -- ============================================
    CREATE TABLE IF NOT EXISTS audit_logs (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        accion VARCHAR(50) NOT NULL, -- INSERT, UPDATE, DELETE
        tabla VARCHAR(100) NOT NULL,
        registro_id UUID,
        datos_anteriores JSONB,
        datos_nuevos JSONB,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create indexes
    CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
    CREATE INDEX IF NOT EXISTS idx_audit_logs_fecha ON audit_logs(created_at);

    -- Enable RLS
    ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

    -- RLS Policy: Users can only view their own audit logs
    CREATE POLICY "Users can view own audit logs"
        ON audit_logs FOR SELECT
        USING (auth.uid() = user_id);

    -- ============================================
    -- 8. CREAR USUARIO AL REGISTRARSE (Trigger)
    -- ============================================
    CREATE OR REPLACE FUNCTION public.handle_new_user()
    RETURNS TRIGGER AS $$
    BEGIN
    INSERT INTO public.users (id, email, full_name)
    VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name');
    RETURN new;
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

    -- Drop trigger if exists
    DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

    -- Create trigger
    CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

    -- ============================================
    -- 9. VISTAS ÚTILES
    -- ============================================

    -- Vista de ventas con detalles
    CREATE OR REPLACE VIEW vw_ventas_detalle AS
    SELECT
        v.id,
        v.user_id,
        v.numero_venta,
        v.cliente_nombre,
        v.total,
        v.estado,
        v.metodo_pago,
        v.fecha,
        COUNT(vd.id) as cantidad_items,
        STRING_AGG(vd.producto_nombre, ', ') as productos
    FROM ventas v
    LEFT JOIN venta_detalles vd ON v.id = vd.venta_id
    GROUP BY v.id, v.user_id, v.numero_venta, v.cliente_nombre, v.total, v.estado, v.metodo_pago, v.fecha;

    -- Vista de resumen diario
    CREATE OR REPLACE VIEW vw_resumen_diario AS
    SELECT
        auth.uid() as user_id,
        CURRENT_DATE as fecha,
        COALESCE(SUM(CASE WHEN v.estado = 'completada' THEN v.total ELSE 0 END), 0) as total_ventas,
        COALESCE(SUM(g.monto), 0) as total_gastos,
        COALESCE(SUM(CASE WHEN v.estado = 'completada' THEN v.total ELSE 0 END), 0) - COALESCE(SUM(g.monto), 0) as ganancia_neta,
        COUNT(DISTINCT v.id) as num_ventas,
        COUNT(DISTINCT g.id) as num_gastos
    FROM ventas v
    FULL OUTER JOIN gastos g ON DATE(v.fecha) = DATE(g.fecha) AND v.user_id = g.user_id
    WHERE v.user_id = auth.uid() OR g.user_id = auth.uid()
    GROUP BY CURRENT_DATE;

    -- ============================================
    -- 10. CONFIGURACIÓN FINAL
    -- ============================================

    -- Crear índices adicionales para mejorar rendimiento
    CREATE INDEX IF NOT EXISTS idx_usuarios_created_at ON users(created_at);
    CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria);
    CREATE INDEX IF NOT EXISTS idx_gastos_proveedor ON gastos(proveedor);

    -- Crear comentarios sobre las tablas
    COMMENT ON TABLE users IS 'Tabla de usuarios del sistema';
    COMMENT ON TABLE productos IS 'Inventario de productos disponibles';
    COMMENT ON TABLE ventas IS 'Registro de todas las ventas realizadas';
    COMMENT ON TABLE venta_detalles IS 'Detalles individuales de cada venta';
    COMMENT ON TABLE gastos IS 'Registro de gastos operativos';
    COMMENT ON TABLE resumen IS 'Resumen mensual de ventas, gastos y ganancias';
    COMMENT ON TABLE audit_logs IS 'Log de auditoría de todos los cambios en el sistema';

    -- ============================================
    -- 11. DATOS DE EJEMPLO (OPCIONAL)
    -- ============================================
    -- Descomenta esto para insertar datos de prueba

    /*
    -- Insertar usuario de ejemplo (requiere crear el usuario en auth primero)
    -- INSERT INTO productos (user_id, nombre, descripcion, precio, cantidad, sku, categoria) 
    -- VALUES (
    --     'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
    --     'Producto de ejemplo',
    --     'Este es un producto de prueba',
    --     10.99,
    --     50,
    --     'SKU-001',
    --     'Electrónica'
    -- );
    */

    -- ============================================
    -- FIN DEL SCRIPT
    -- ============================================
