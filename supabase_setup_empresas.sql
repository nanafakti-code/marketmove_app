-- =====================================================
-- NOTA: Los usuarios admins deben crearse en Supabase Auth
-- =====================================================
-- 
-- Para crear los admins, sigue estos pasos:
-- 1. Ve a Supabase → Authentication → Users
-- 2. Haz clic en "Invite" y añade estos usuarios:
--    - admin1@example.com
--    - admin2@example.com
--    - admin3@example.com
-- 3. Después de crearlos en Auth, sus IDs aparecerán en auth.users
-- 4. Usa esos UUIDs en las inserciones de empresas abajo
--
-- Los datos de ejemplo usarán los emails para referenciar a los admins
-- mediante subconsultas en public.users (que está vinculado a auth.users)
--
-- =====================================================
-- TABLA: empresas
-- Descripción: Información detallada de cada empresa/cliente
-- =====================================================
CREATE TABLE IF NOT EXISTS public.empresas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Relación con el propietario (admin de users)
  admin_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  
  -- Información básica
  nombre_negocio VARCHAR(255) NOT NULL,
  nif VARCHAR(20) UNIQUE NOT NULL,
  sector VARCHAR(100),
  
  -- Contacto
  telefono VARCHAR(20),
  email_empresa VARCHAR(255),
  
  -- Ubicación
  direccion VARCHAR(255),
  ciudad VARCHAR(100),
  provincia VARCHAR(100),
  codigo_postal VARCHAR(10),
  
  -- Estado
  estado VARCHAR(50) DEFAULT 'activa' CHECK (estado IN ('activa', 'inactiva', 'suspendida')),
  
  -- Auditoría
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  created_by UUID REFERENCES public.users(id),
  updated_by UUID REFERENCES public.users(id),
  
  -- Metadata
  notas TEXT
);

-- Crear índices para mejorar performance
CREATE INDEX IF NOT EXISTS idx_empresas_admin_id ON public.empresas(admin_id);
CREATE INDEX IF NOT EXISTS idx_empresas_estado ON public.empresas(estado);
CREATE INDEX IF NOT EXISTS idx_empresas_nif ON public.empresas(nif);

-- =====================================================
-- TABLA: empleados_empresa
-- Descripción: Lista de empleados de cada empresa
-- =====================================================
CREATE TABLE IF NOT EXISTS public.empleados_empresa (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
  
  -- Información del empleado
  nombre_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  telefono VARCHAR(20),
  puesto VARCHAR(100),
  departamento VARCHAR(100),
  
  -- Estado
  estado VARCHAR(50) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo', 'baja')),
  
  -- Auditoría
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  
  -- Metadata
  notas TEXT
);

-- Crear índices
CREATE INDEX IF NOT EXISTS idx_empleados_empresa_id ON public.empleados_empresa(empresa_id);
CREATE INDEX IF NOT EXISTS idx_empleados_estado ON public.empleados_empresa(estado);

-- =====================================================
-- TABLA: clientes_empresa
-- Descripción: Clientes de cada empresa (sub-clientes)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.clientes_empresa (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
  
  -- Información del cliente
  nombre_cliente VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  telefono VARCHAR(20),
  contacto_principal VARCHAR(255),
  
  -- Información empresarial del cliente
  razon_social VARCHAR(255),
  nif_cliente VARCHAR(20),
  direccion VARCHAR(255),
  ciudad VARCHAR(100),
  provincia VARCHAR(100),
  codigo_postal VARCHAR(10),
  
  -- Relación comercial
  tipo_cliente VARCHAR(100), -- ej: mayorista, minorista, distribuidor
  fecha_inicio_relacion DATE,
  
  -- Estado
  estado VARCHAR(50) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo', 'potencial')),
  
  -- Auditoría
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  
  -- Metadata
  notas TEXT
);

-- Crear índices
CREATE INDEX IF NOT EXISTS idx_clientes_empresa_id ON public.clientes_empresa(empresa_id);
CREATE INDEX IF NOT EXISTS idx_clientes_estado ON public.clientes_empresa(estado);
CREATE INDEX IF NOT EXISTS idx_clientes_nif ON public.clientes_empresa(nif_cliente);

-- =====================================================
-- TABLA: detalles_empresa_metadata
-- Descripción: Información adicional y estadísticas de la empresa
-- =====================================================
CREATE TABLE IF NOT EXISTS public.detalles_empresa_metadata (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL UNIQUE REFERENCES public.empresas(id) ON DELETE CASCADE,
  
  -- Información legal/fiscal
  forma_legal VARCHAR(100),
  numero_empleados INT DEFAULT 0,
  fecha_constitucion DATE,
  actividad_principal TEXT,
  
  -- Información bancaria (opcional, cifrada recomendado)
  banco VARCHAR(100),
  iban VARCHAR(34),
  
  -- Información adicional
  website VARCHAR(255),
  redes_sociales JSONB,
  
  -- Auditoría
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices
CREATE INDEX IF NOT EXISTS idx_detalles_empresa_id ON public.detalles_empresa_metadata(empresa_id);

-- =====================================================
-- FUNCIONES: Actualizar updated_at automáticamente
-- =====================================================
CREATE OR REPLACE FUNCTION update_empresas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_empleados_empresa_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_detalles_empresa_metadata_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_clientes_empresa_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS: Ejecutar funciones de actualización
-- =====================================================
DROP TRIGGER IF EXISTS trigger_empresas_updated_at ON public.empresas;
CREATE TRIGGER trigger_empresas_updated_at
BEFORE UPDATE ON public.empresas
FOR EACH ROW
EXECUTE FUNCTION update_empresas_updated_at();

DROP TRIGGER IF EXISTS trigger_empleados_empresa_updated_at ON public.empleados_empresa;
CREATE TRIGGER trigger_empleados_empresa_updated_at
BEFORE UPDATE ON public.empleados_empresa
FOR EACH ROW
EXECUTE FUNCTION update_empleados_empresa_updated_at();

DROP TRIGGER IF EXISTS trigger_detalles_empresa_metadata_updated_at ON public.detalles_empresa_metadata;
CREATE TRIGGER trigger_detalles_empresa_metadata_updated_at
BEFORE UPDATE ON public.detalles_empresa_metadata
FOR EACH ROW
EXECUTE FUNCTION update_detalles_empresa_metadata_updated_at();

DROP TRIGGER IF EXISTS trigger_clientes_empresa_updated_at ON public.clientes_empresa;
CREATE TRIGGER trigger_clientes_empresa_updated_at
BEFORE UPDATE ON public.clientes_empresa
FOR EACH ROW
EXECUTE FUNCTION update_clientes_empresa_updated_at();

-- =====================================================
-- ROW LEVEL SECURITY (RLS): Proteger datos por rol
-- =====================================================

-- Habilitar RLS en empresas
ALTER TABLE public.empresas ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes (si existen)
DROP POLICY IF EXISTS "superadmin_all_empresas" ON public.empresas;
DROP POLICY IF EXISTS "admin_own_empresas" ON public.empresas;

-- Política: Superadmin ve todas las empresas
CREATE POLICY "superadmin_all_empresas" ON public.empresas
  FOR ALL
  USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'superadmin'
  );

-- Política: Admin ve solo sus propias empresas
CREATE POLICY "admin_own_empresas" ON public.empresas
  FOR ALL
  USING (admin_id = auth.uid())
  WITH CHECK (admin_id = auth.uid());

-- Habilitar RLS en empleados_empresa
ALTER TABLE public.empleados_empresa ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes
DROP POLICY IF EXISTS "superadmin_all_empleados" ON public.empleados_empresa;
DROP POLICY IF EXISTS "admin_own_empleados" ON public.empleados_empresa;

-- Política: Superadmin ve todos los empleados
CREATE POLICY "superadmin_all_empleados" ON public.empleados_empresa
  FOR ALL
  USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'superadmin'
  );

-- Política: Admin ve empleados de sus empresas
CREATE POLICY "admin_own_empleados" ON public.empleados_empresa
  FOR ALL
  USING (
    empresa_id IN (
      SELECT id FROM public.empresas WHERE admin_id = auth.uid()
    )
  );

-- Habilitar RLS en detalles_empresa_metadata
ALTER TABLE public.detalles_empresa_metadata ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes
DROP POLICY IF EXISTS "superadmin_all_detalles_metadata" ON public.detalles_empresa_metadata;
DROP POLICY IF EXISTS "admin_own_detalles_metadata" ON public.detalles_empresa_metadata;

-- Política: Superadmin ve todos los detalles
CREATE POLICY "superadmin_all_detalles_metadata" ON public.detalles_empresa_metadata
  FOR ALL
  USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'superadmin'
  );

-- Política: Admin ve detalles de sus empresas
CREATE POLICY "admin_own_detalles_metadata" ON public.detalles_empresa_metadata
  FOR ALL
  USING (
    empresa_id IN (
      SELECT id FROM public.empresas WHERE admin_id = auth.uid()
    )
  );

-- Habilitar RLS en clientes_empresa
ALTER TABLE public.clientes_empresa ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes
DROP POLICY IF EXISTS "superadmin_all_clientes" ON public.clientes_empresa;
DROP POLICY IF EXISTS "admin_own_clientes" ON public.clientes_empresa;

-- Política: Superadmin ve todos los clientes
CREATE POLICY "superadmin_all_clientes" ON public.clientes_empresa
  FOR ALL
  USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'superadmin'
  );

-- Política: Admin ve clientes de sus empresas
CREATE POLICY "admin_own_clientes" ON public.clientes_empresa
  FOR ALL
  USING (
    empresa_id IN (
      SELECT id FROM public.empresas WHERE admin_id = auth.uid()
    )
  );

-- =====================================================
-- VISTAS: Información combinada (opcional)
-- =====================================================

-- Vista: Empresa con información completa del admin
CREATE OR REPLACE VIEW public.vw_empresas_completa AS
SELECT
  e.id,
  e.admin_id,
  u.full_name AS nombre_admin,
  u.email AS email_admin,
  u.role,
  e.nombre_negocio,
  e.nif,
  e.sector,
  e.telefono,
  e.email_empresa,
  e.direccion,
  e.ciudad,
  e.provincia,
  e.codigo_postal,
  e.estado,
  (SELECT COUNT(*) FROM public.empleados_empresa WHERE empresa_id = e.id) AS numero_empleados,
  e.created_at,
  e.updated_at,
  e.notas
FROM public.empresas e
LEFT JOIN public.users u ON e.admin_id = u.id;

-- Vista: Empleados con información de empresa
CREATE OR REPLACE VIEW public.vw_empleados_empresa_completa AS
SELECT
  ee.id,
  ee.empresa_id,
  e.nombre_negocio,
  e.admin_id,
  u.full_name AS nombre_admin,
  ee.nombre_completo,
  ee.email,
  ee.telefono,
  ee.puesto,
  ee.departamento,
  ee.estado,
  ee.created_at,
  ee.updated_at
FROM public.empleados_empresa ee
LEFT JOIN public.empresas e ON ee.empresa_id = e.id
LEFT JOIN public.users u ON e.admin_id = u.id;

-- Vista: Clientes de empresa con información completa
CREATE OR REPLACE VIEW public.vw_clientes_empresa_completa AS
SELECT
  ce.id,
  ce.empresa_id,
  e.nombre_negocio,
  e.admin_id,
  u.full_name AS nombre_admin,
  u.email AS email_admin,
  ce.nombre_cliente,
  ce.email,
  ce.telefono,
  ce.contacto_principal,
  ce.razon_social,
  ce.nif_cliente,
  ce.direccion,
  ce.ciudad,
  ce.provincia,
  ce.codigo_postal,
  ce.tipo_cliente,
  ce.fecha_inicio_relacion,
  ce.estado,
  ce.created_at,
  ce.updated_at
FROM public.clientes_empresa ce
LEFT JOIN public.empresas e ON ce.empresa_id = e.id
LEFT JOIN public.users u ON e.admin_id = u.id;

-- =====================================================
-- DATOS DE EJEMPLO - DATOS DE PRUEBA
-- =====================================================
-- 
-- ⚠️ IMPORTANTE: Debes crear al menos 1 usuario admin en Supabase Auth ANTES de ejecutar esto
-- 
-- Pasos:
-- 1. Ve a Supabase → Authentication → Users
-- 2. Haz clic en "Invite" y crea estos usuarios:
--    - admin1@example.com
--    - admin2@example.com  
--    - admin3@example.com
-- 3. Espera a que se creen los usuarios
-- 4. Luego ejecuta este script SQL
--
-- Si tienes poco tiempo, crea al menos 1 usuario y todas las empresas 
-- se asignarán a ese admin. Puedes cambiarlas después.
--

-- EMPRESA 1: Tech Solutions Spain
INSERT INTO public.empresas (
  admin_id, 
  nombre_negocio, nif, sector, 
  telefono, email_empresa, 
  direccion, ciudad, provincia, codigo_postal, 
  estado, notas
)
SELECT 
  (SELECT id FROM public.users WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1),
  'Tech Solutions Spain',
  'A12345678',
  'Tecnología e Informática',
  '+34 912 345 678',
  'info@techsolutions.es',
  'Calle Principal 123, Edificio A',
  'Madrid',
  'Madrid',
  '28001',
  'activa',
  'Empresa especializada en consultoría tecnológica'
WHERE EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' LIMIT 1);

-- EMPRESA 2: Distribuciones del Norte
INSERT INTO public.empresas (
  admin_id, 
  nombre_negocio, nif, sector, 
  telefono, email_empresa, 
  direccion, ciudad, provincia, codigo_postal, 
  estado, notas
)
SELECT 
  (SELECT id FROM public.users WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1 OFFSET 1),
  'Distribuciones del Norte',
  'B87654321',
  'Distribución y Logística',
  '+34 934 567 890',
  'info@distrinorte.es',
  'Polígono Industrial Norte, Nave 45',
  'Barcelona',
  'Barcelona',
  '08002',
  'activa',
  'Distribuidor mayorista de productos de tecnología'
WHERE EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' OFFSET 1 LIMIT 1);

-- Si no hay 2 admins, usa el primero para la empresa 2
INSERT INTO public.empresas (
  admin_id, 
  nombre_negocio, nif, sector, 
  telefono, email_empresa, 
  direccion, ciudad, provincia, codigo_postal, 
  estado, notas
)
SELECT 
  (SELECT id FROM public.users WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1),
  'Distribuciones del Norte',
  'B87654321',
  'Distribución y Logística',
  '+34 934 567 890',
  'info@distrinorte.es',
  'Polígono Industrial Norte, Nave 45',
  'Barcelona',
  'Barcelona',
  '08002',
  'activa',
  'Distribuidor mayorista de productos de tecnología'
WHERE NOT EXISTS (SELECT 1 FROM public.empresas WHERE nif = 'B87654321')
  AND NOT EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' OFFSET 1 LIMIT 1)
  AND EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' LIMIT 1);

-- EMPRESA 3: Consultora Empresarial Premium
INSERT INTO public.empresas (
  admin_id, 
  nombre_negocio, nif, sector, 
  telefono, email_empresa, 
  direccion, ciudad, provincia, codigo_postal, 
  estado, notas
)
SELECT 
  (SELECT id FROM public.users WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1 OFFSET 2),
  'Consultora Empresarial Premium',
  'C11223344',
  'Consultoría Empresarial',
  '+34 957 234 567',
  'info@consultpremium.es',
  'Avenida de la República 456',
  'Sevilla',
  'Sevilla',
  '41004',
  'activa',
  'Consultoría especializada en transformación digital'
WHERE EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' OFFSET 2 LIMIT 1);

-- Si no hay 3 admins, usa el primero para la empresa 3
INSERT INTO public.empresas (
  admin_id, 
  nombre_negocio, nif, sector, 
  telefono, email_empresa, 
  direccion, ciudad, provincia, codigo_postal, 
  estado, notas
)
SELECT 
  (SELECT id FROM public.users WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1),
  'Consultora Empresarial Premium',
  'C11223344',
  'Consultoría Empresarial',
  '+34 957 234 567',
  'info@consultpremium.es',
  'Avenida de la República 456',
  'Sevilla',
  'Sevilla',
  '41004',
  'activa',
  'Consultoría especializada en transformación digital'
WHERE NOT EXISTS (SELECT 1 FROM public.empresas WHERE nif = 'C11223344')
  AND NOT EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' OFFSET 2 LIMIT 1)
  AND EXISTS (SELECT 1 FROM public.users WHERE role = 'admin' LIMIT 1);

-- =====================================================
-- EMPLEADOS PARA TECH SOLUTIONS SPAIN (Admin 1)
-- =====================================================

-- Empleado 1: Tech Solutions - Desarrollador
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Juan García López',
  'juan.garcia@techsolutions.es',
  '+34 912 345 679',
  'Desarrollador Senior',
  'Tecnología',
  'activo',
  'Especialista en backend y bases de datos'
);

-- Empleado 2: Tech Solutions - Diseñadora
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Sofia Martínez García',
  'sofia.martinez@techsolutions.es',
  '+34 912 345 680',
  'Diseñadora UX/UI',
  'Diseño',
  'activo',
  'Experta en diseño de interfaces modernas'
);

-- =====================================================
-- EMPLEADOS PARA DISTRIBUCIONES DEL NORTE (Admin 2)
-- =====================================================

-- Empleado 1: Distribuciones - Gestor de Almacén
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Miguel Torres Ruiz',
  'miguel.torres@distrinorte.es',
  '+34 934 567 891',
  'Gestor de Almacén',
  'Logística',
  'activo',
  'Responsable del almacén principal'
);

-- Empleado 2: Distribuciones - Comercial
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Laura Pérez Domínguez',
  'laura.perez@distrinorte.es',
  '+34 934 567 892',
  'Comercial',
  'Ventas',
  'activo',
  'Especialista en clientes corporativos'
);

-- =====================================================
-- EMPLEADOS PARA CONSULTORA EMPRESARIAL PREMIUM (Admin 3)
-- =====================================================

-- Empleado 1: Consultora - Consultor Senior
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Roberto Sánchez Flores',
  'roberto.sanchez@consultpremium.es',
  '+34 957 234 568',
  'Consultor Senior',
  'Consultoría',
  'activo',
  'Especialista en transformación digital'
);

-- Empleado 2: Consultora - Analista de Procesos
INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Carmen Jiménez Moreno',
  'carmen.jimenez@consultpremium.es',
  '+34 957 234 569',
  'Analista de Procesos',
  'Análisis',
  'activo',
  'Especialista en optimización de procesos'
);

-- =====================================================
-- CLIENTES PARA TECH SOLUTIONS SPAIN
-- =====================================================

-- Cliente 1: Banco Internacional
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Banco Internacional',
  'contacto@bancointernacional.es',
  '+34 912 999 111',
  'Director de Tecnología - José García',
  'Banco Internacional SA',
  'D12345678',
  'Paseo de la Castellana 200',
  'Madrid',
  'Madrid',
  '28046',
  'cliente-corporativo',
  '2022-03-15',
  'activo',
  'Cliente estratégico - Proyectos a largo plazo'
);

-- Cliente 2: Retail Solutions
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Retail Solutions',
  'info@retailsolutions.com',
  '+34 912 888 222',
  'Gerente General - María López',
  'Retail Solutions SL',
  'E87654321',
  'Plaza Mayor 50',
  'Madrid',
  'Madrid',
  '28012',
  'cliente-mediano',
  '2023-06-20',
  'activo',
  'Soluciones de punto de venta'
);

-- Cliente 3: Startup Innova
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Startup Innova',
  'team@startupinnova.io',
  '+34 912 777 333',
  'CEO - David Ruiz',
  'Innova Digital SL',
  'F99887766',
  'Calle Alcalá 123',
  'Madrid',
  'Madrid',
  '28028',
  'cliente-startup',
  '2024-01-10',
  'activo',
  'Empresa joven en fase de crecimiento'
);

-- Cliente 4: Empresa Industrial
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'A12345678' LIMIT 1),
  'Empresa Industrial Moderna',
  'contacto@empindust.es',
  '+34 912 666 444',
  'Director de TI - Carlos Martín',
  'Empresa Industrial Moderna SA',
  'G55443322',
  'Polígono Industrial Sur 78',
  'Getafe',
  'Madrid',
  '28905',
  'cliente-industrial',
  '2023-09-05',
  'potencial',
  'Negociación en fase avanzada'
);

-- =====================================================
-- CLIENTES PARA DISTRIBUCIONES DEL NORTE
-- =====================================================

-- Cliente 1: Cadena Comercial XYZ
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Cadena Comercial XYZ',
  'compras@cadxyz.es',
  '+34 934 111 222',
  'Jefe de Compras - María Núñez',
  'Cadena Comercial XYZ SL',
  'H11223344',
  'Avenida Diagonal 500',
  'Barcelona',
  'Barcelona',
  '08013',
  'mayorista',
  '2021-05-12',
  'activo',
  'Principal cliente mayorista'
);

-- Cliente 2: Tiendas Especializadas
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Tiendas Especializadas del Centro',
  'ventas@tiesecespecial.com',
  '+34 934 222 333',
  'Responsable de Logística - Antonio López',
  'Tiendas Especializadas SL',
  'I99887755',
  'Ramblas 200',
  'Barcelona',
  'Barcelona',
  '08002',
  'distribuidor',
  '2022-07-18',
  'activo',
  'Cadena de tiendas especializadas'
);

-- Cliente 3: Almacén Regional
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Almacén Regional Tarragona',
  'info@almacenregional.es',
  '+34 977 555 666',
  'Director - Juan Fernández',
  'Almacén Regional SL',
  'J33221100',
  'Polígono Industrial La Canonja',
  'Tarragona',
  'Tarragona',
  '43392',
  'minorista',
  '2023-02-28',
  'activo',
  'Distribuidor regional'
);

-- Cliente 4: Supermercados del Este
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'B87654321' LIMIT 1),
  'Supermercados del Este',
  'compras@supereste.es',
  '+34 934 333 444',
  'Jefa de Compras - Patricia Gómez',
  'Supermercados del Este SA',
  'K77665544',
  'Calle Sagrera 450',
  'Barcelona',
  'Barcelona',
  '08014',
  'mayorista',
  '2023-11-10',
  'inactivo',
  'Cliente en pausa - Reevaluación en Q2 2025'
);

-- =====================================================
-- CLIENTES PARA CONSULTORA EMPRESARIAL PREMIUM
-- =====================================================

-- Cliente 1: Empresa Textil Andaluza
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Empresa Textil Andaluza',
  'direccion@textilandaluz.es',
  '+34 957 888 999',
  'Director General - Miguel Ruiz',
  'Textil Andaluz SA',
  'L55443311',
  'Calle Industrial 789',
  'Córdoba',
  'Córdoba',
  '14008',
  'cliente-industrial',
  '2022-09-20',
  'activo',
  'Proyecto de transformación digital en curso'
);

-- Cliente 2: Hostelería Prestige
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Hostelería Prestige',
  'reservas@hosteleriaprestige.es',
  '+34 954 999 888',
  'Gerente - Isabel Martínez',
  'Hostelería Prestige SL',
  'M66554433',
  'Plaza Santa Cruz 100',
  'Sevilla',
  'Sevilla',
  '41004',
  'cliente-servicios',
  '2023-04-15',
  'activo',
  'Cadena de hoteles - Consultoría de procesos'
);

-- Cliente 3: Farmacéutica del Sur
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Farmacéutica del Sur',
  'contacto@farmasur.es',
  '+34 957 444 555',
  'Director de Operaciones - Francisco López',
  'Farmacéutica del Sur SA',
  'N88776655',
  'Parque Tecnológico Andaluz',
  'Málaga',
  'Málaga',
  '29590',
  'cliente-farmaceutico',
  '2024-02-01',
  'activo',
  'Consultoría regulatoria y compliance'
);

-- Cliente 4: Constructora Regional
INSERT INTO public.clientes_empresa (empresa_id, nombre_cliente, email, telefono, contacto_principal, razon_social, nif_cliente, direccion, ciudad, provincia, codigo_postal, tipo_cliente, fecha_inicio_relacion, estado, notas)
VALUES (
  (SELECT id FROM public.empresas WHERE nif = 'C11223344' LIMIT 1),
  'Constructora Regional Andaluza',
  'proyectos@construregional.es',
  '+34 955 666 777',
  'Jefe de Proyecto - Eduardo Rojas',
  'Constructora Regional Andaluza SA',
  'O11223399',
  'Edificio Corporativo, Calle Principal 300',
  'Sevilla',
  'Sevilla',
  '41010',
  'cliente-construccion',
  '2024-08-10',
  'potencial',
  'Prospecto caliente - Presentación próxima semana'
);

-- =====================================================
-- COMENTARIOS: Datos de ejemplo antiguos (mantener referencia)
-- =====================================================


-- INSERT INTO public.empresas (admin_id, nombre_negocio, nif, sector, telefono, email_empresa, direccion, ciudad, provincia, codigo_postal, estado)
-- VALUES (
--   (SELECT id FROM public.users WHERE role = 'admin' LIMIT 1),
--   'Mi Empresa SL',
--   'A12345678',
--   'Tecnología',
--   '+34 912 345 678',
--   'info@miempresa.com',
--   'Calle Principal 123',
--   'Madrid',
--   'Madrid',
--   '28001',
--   'activa'
-- );

-- Insertar empleado de ejemplo
-- INSERT INTO public.empleados_empresa (empresa_id, nombre_completo, email, telefono, puesto, departamento, estado)
-- VALUES (
--   (SELECT id FROM public.empresas LIMIT 1),
--   'Juan García López',
--   'juan@miempresa.com',
--   '+34 912 345 679',
--   'Desarrollador',
--   'IT',
--   'activo'
-- );
