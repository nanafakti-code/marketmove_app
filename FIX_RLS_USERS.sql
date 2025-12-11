-- RLS Seguras para tabla users SIN RECURSIÓN
-- Superadmin puede hacer TODO (SELECT, INSERT, UPDATE, DELETE)
-- Admin solo pueden ver/editar su propio registro
-- Ejecutar esto en Supabase SQL Editor

-- 1. Primero DESHABILITAR RLS para limpiar
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- 2. Eliminar políticas antiguas si las hay
DROP POLICY IF EXISTS "users_select_policy" ON public.users;
DROP POLICY IF EXISTS "users_insert_policy" ON public.users;
DROP POLICY IF EXISTS "users_update_policy" ON public.users;
DROP POLICY IF EXISTS "users_delete_policy" ON public.users;
DROP POLICY IF EXISTS "Superadmin can view all users" ON public.users;
DROP POLICY IF EXISTS "Users can view themselves" ON public.users;
DROP POLICY IF EXISTS "Enable all for superadmin" ON public.users;
DROP POLICY IF EXISTS "Users view themselves" ON public.users;
DROP POLICY IF EXISTS "Users update themselves" ON public.users;

-- 3. Crear función auxiliar para obtener el rol del usuario actual
-- Esta función es más eficiente y evita recursión
CREATE OR REPLACE FUNCTION get_current_user_role() 
RETURNS TEXT AS $$
  SELECT role FROM public.users WHERE id = auth.uid()
$$ LANGUAGE SQL SECURITY DEFINER;

-- 4. Habilitar RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 5. POLÍTICA SELECT: Superadmin ve todos, Admin ven su propio registro
CREATE POLICY "users_select_policy"
  ON public.users
  FOR SELECT
  USING (
    auth.uid() = id 
    OR get_current_user_role() = 'superadmin'
  );

-- 6. POLÍTICA INSERT: Solo superadmin puede crear usuarios
CREATE POLICY "users_insert_policy"
  ON public.users
  FOR INSERT
  WITH CHECK (
    get_current_user_role() = 'superadmin'
  );

-- 7. POLÍTICA UPDATE: Superadmin puede editar todo, Admin solo su propio registro
CREATE POLICY "users_update_policy"
  ON public.users
  FOR UPDATE
  USING (
    auth.uid() = id 
    OR get_current_user_role() = 'superadmin'
  )
  WITH CHECK (
    auth.uid() = id 
    OR get_current_user_role() = 'superadmin'
  );

-- 8. POLÍTICA DELETE: Solo superadmin puede eliminar usuarios
CREATE POLICY "users_delete_policy"
  ON public.users
  FOR DELETE
  USING (
    get_current_user_role() = 'superadmin'
  );
