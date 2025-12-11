# 🛠️ Setup de Gestión de Clientes

## 📋 Resumen de Cambios

Se ha implementado una página completa de gestión de clientes para superadmins con las siguientes características:

### ✨ Características Implementadas

1. **Página Clientes** (`/clientes`)
   - Solo accesible por superadmins
   - Lista en tiempo real de todos los usuarios con rol `admin`
   - Interfaz moderna con gradientes y animaciones

2. **Crear Clientes**
   - Botón flotante para crear nuevo cliente
   - Diálogo con validación de email
   - Integración con Supabase Auth (crea usuario automáticamente)
   - Contraseña temporal: `TempPassword123!`
   - Asignación automática de rol `admin`

3. **Editar Clientes**
   - Botón editar en cada tarjeta
   - Formulario para actualizar nombre completo y negocio
   - Email de solo lectura (identificación)
   - Actualización en tiempo real

4. **Eliminar Clientes**
   - Botón eliminar en cada tarjeta
   - Confirmación de eliminación
   - Eliminación de usuario de Supabase Auth

5. **UI/UX**
   - Tarjetas con gradiente y sombra
   - Iconos y botones de acción
   - Bottom sheet para opciones adicionales
   - Mensajes de éxito/error con SnackBar
   - Estados vacíos con mensajes descriptivos

---

## 🔐 Seguridad - Políticas RLS

### Problema Detectado
Los usuarios con rol `admin` no aparecían en la lista de clientes debido a que las políticas RLS estaban bloqueando el acceso.

### Solución Implementada
Se crearon políticas RLS seguras utilizando una función `SECURITY DEFINER` para evitar recursión infinita.

### 📝 Paso a Paso para Implementar

#### 1. Acceder a Supabase
- Entra a [supabase.com](https://supabase.com)
- Accede a tu proyecto MarketMove

#### 2. Abre la Consola SQL
- Ve a `SQL Editor`
- Haz clic en `New Query`

#### 3. Copia y Ejecuta el Script
Usa el contenido de `FIX_RLS_USERS.sql`:

```sql
-- Deshabilitar RLS temporalmente para configurar
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- Eliminar políticas antiguas
DROP POLICY IF EXISTS "Users can read their own data" ON public.users;
DROP POLICY IF EXISTS "Users can update their own data" ON public.users;
DROP POLICY IF EXISTS "Admins can see own data" ON public.users;
DROP POLICY IF EXISTS "Superadmins can see all users" ON public.users;
DROP POLICY IF EXISTS "superadmin_view_all_users" ON public.users;
DROP POLICY IF EXISTS "superadmin_insert_users" ON public.users;
DROP POLICY IF EXISTS "superadmin_update_users" ON public.users;
DROP POLICY IF EXISTS "superadmin_delete_users" ON public.users;
DROP POLICY IF EXISTS "admin_view_self" ON public.users;
DROP POLICY IF EXISTS "admin_update_self" ON public.users;

-- Crear función para obtener rol del usuario actual
CREATE OR REPLACE FUNCTION public.get_current_user_role() 
RETURNS text AS $$
DECLARE
  role_value text;
BEGIN
  SELECT role INTO role_value 
  FROM public.users 
  WHERE id = auth.uid()
  LIMIT 1;
  RETURN COALESCE(role_value, 'user');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Habilitar RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Política: Superadmin ve todos los usuarios
CREATE POLICY "superadmin_view_all_users" ON public.users
FOR SELECT
USING (public.get_current_user_role() = 'superadmin');

-- Política: Admin ve solo su propio usuario
CREATE POLICY "admin_view_self" ON public.users
FOR SELECT
USING (auth.uid() = id AND public.get_current_user_role() = 'admin');

-- Política: Solo superadmin puede insertar usuarios
CREATE POLICY "superadmin_insert_users" ON public.users
FOR INSERT
WITH CHECK (public.get_current_user_role() = 'superadmin');

-- Política: Superadmin puede actualizar cualquier usuario
CREATE POLICY "superadmin_update_users" ON public.users
FOR UPDATE
USING (public.get_current_user_role() = 'superadmin')
WITH CHECK (public.get_current_user_role() = 'superadmin');

-- Política: Admin puede actualizar solo su propio usuario
CREATE POLICY "admin_update_self" ON public.users
FOR UPDATE
USING (auth.uid() = id AND public.get_current_user_role() = 'admin')
WITH CHECK (auth.uid() = id AND public.get_current_user_role() = 'admin');

-- Política: Solo superadmin puede eliminar usuarios
CREATE POLICY "superadmin_delete_users" ON public.users
FOR DELETE
USING (public.get_current_user_role() = 'superadmin');
```

#### 4. Verifica el Resultado
Deberías ver:
- ✅ Función `get_current_user_role()` creada
- ✅ 6 políticas RLS creadas en la tabla `users`

---

## 🧪 Pruebas Recomendadas

### Test 1: Superadmin ve clientes
1. Inicia sesión como superadmin
2. Navega a `/clientes`
3. Deberías ver la lista de todos los usuarios con rol `admin`

### Test 2: Crear cliente
1. Haz clic en el botón `+` flotante
2. Ingresa:
   - Email: `cliente@example.com`
   - Nombre: `Juan Pérez`
   - Negocio: `Negocio de Juan`
3. Deberías ver un SnackBar con la contraseña temporal

### Test 3: Editar cliente
1. Haz clic en el botón ✏️ de un cliente
2. Cambia el nombre o negocio
3. Guarda los cambios
4. Verifica que se actualicen en tiempo real

### Test 4: Eliminar cliente
1. Haz clic en el botón 🗑️ de un cliente
2. Confirma la eliminación
3. El cliente debe desaparecer de la lista

### Test 5: Admin no puede acceder a `/clientes`
1. Inicia sesión como admin
2. Intenta navegar a `/clientes`
3. Deberías ser redirigido a `/resumen`

---

## 📱 Flujo de Acceso

```
Superadmin (rol='superadmin')
  ├─ Dashboard Principal (/resumen)
  │  └─ Vista: Número de clientes, link a gestión
  ├─ Gestión de Clientes (/clientes) ✅
  │  ├─ Ver todos los usuarios admin
  │  ├─ Crear nuevo cliente
  │  ├─ Editar cliente
  │  └─ Eliminar cliente
  └─ Cerrar Sesión

Admin (rol='admin')
  ├─ Dashboard Financiero (/resumen)
  │  ├─ Ventas
  │  ├─ Gastos
  │  └─ Productos
  ├─ ❌ NO puede acceder a /clientes
  ├─ ❌ NO puede acceder a /ventas, /gastos, /productos (si intenta como superadmin)
  └─ Cerrar Sesión
```

---

## 🔧 Integración Técnica

### Archivos Modificados

1. **lib/src/features/clientes/pages/clientes_page.dart**
   - Reemplazó el método `_buildClienteCard` con versión mejorada
   - Agregó `_mostrarOpciones()` para bottom sheet
   - Agregó `_mostrarDialogoEditar()` para edición
   - Agregó `_mostrarConfirmacionEliminar()` para confirmación de delete
   - Conectó `_mostrarDialogoCrearCliente()` a Supabase Auth

2. **lib/src/features/clientes/dialogs/crear_cliente_dialog.dart** (NUEVO)
   - Diálogo con formulario para crear clientes
   - Validación de email y campos requeridos

3. **lib/src/features/clientes/dialogs/editar_cliente_dialog.dart** (NUEVO)
   - Diálogo con formulario para editar clientes
   - Email de solo lectura

4. **lib/src/shared/repositories/data_repository.dart**
   - `obtenerClientesAdmin()` - Stream de usuarios con rol admin
   - `actualizarUsuario(userId, datos)` - Actualiza usuario
   - `eliminarUsuario(userId)` - Elimina usuario

5. **lib/src/shared/widgets/admin_only_page.dart** (NUEVO)
   - Wrapper que protege páginas de acceso por superadmin
   - Usado en: VentasPage, GastosPage, ProductosPage

6. **lib/main.dart**
   - Agregó ruta `/clientes` => `ClientesPage()`

---

## ⚠️ Consideraciones Importantes

### Contraseñas Temporales
- **Actual**: Todos los clientes reciben `TempPassword123!`
- **Mejora recomendada**: Generar contraseña aleatoria por cliente
- **Opción**: Enviar enlace de reset de contraseña en lugar de mostrar contraseña

### Confirmación de Email
- Supabase puede requerir confirmación de email
- Los usuarios nuevos pueden necesitar confirmar antes de usar la cuenta
- Verifica las configuraciones de autenticación en Supabase

### Roles y Permisos
- `superadmin` (rol actual) - Acceso total
- `admin` (clientes) - Acceso limitado a su propio dashboard
- Podría extenderse con más roles en el futuro

---

## 📞 Soporte

Si encuentras problemas:

1. **Comprueba la consola del navegador** (F12)
2. **Verifica los logs de Supabase** (SQL Editor → Logs)
3. **Ejecuta nuevamente el script RLS** si no se aplicó correctamente
4. **Cierra sesión y vuelve a iniciar** para refrescar el token

---

**Última actualización**: 2024
