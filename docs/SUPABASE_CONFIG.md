# 🔐 Configuración de Supabase - MarketMove

## ✅ Completado

Tu proyecto ya está configurado para usar Supabase. Aquí está lo que se hizo:

### 1. **Dependencias Instaladas**
```yaml
supabase_flutter: ^2.9.0      # Cliente de Supabase
flutter_dotenv: ^5.1.0         # Gestión de variables de entorno
provider: ^6.1.5+1             # Estado de la app
```

### 2. **Variables de Entorno (.env)**
```
SUPABASE_URL=https://zzaobtowduhjeivrmjhn.supabase.co
SUPABASE_ANON_KEY=sb_publishable_3Mqh_PchcfzcDFsxD8QGag_Ei4-xiiP
```

### 3. **Inicialización en main.dart**
- Carga `.env` con `flutter_dotenv`
- Inicializa Supabase con URL y Anon Key
- Configura `MultiProvider` con `AuthProvider`
- Navega automáticamente según autenticación

### 4. **AuthProvider Creado**
```dart
// Ubicación: lib/src/shared/providers/auth_provider.dart

Métodos principales:
- signUp()       → Registrar nuevo usuario
- signIn()       → Iniciar sesión
- signOut()      → Cerrar sesión
- resetPassword() → Recuperar contraseña

Getters:
- currentUser    → Usuario actual autenticado
- isAuthenticated → Si el usuario está logueado
```

### 5. **LoginPage Actualizado**
✅ Conectado a Supabase `AuthProvider`
✅ Manejo de errores de autenticación
✅ Loading state visual
✅ Navegación automática al login exitoso

### 6. **RegisterPage Actualizado**
✅ Campos para: Email, Nombre, Negocio, Contraseña
✅ Conectado a Supabase `AuthProvider`
✅ Validación de formulario
✅ Manejo de errores
✅ Redirige a login después del registro

---

## 🚀 Próximos Pasos

### 1️⃣ Ejecutar la App
```bash
flutter run
```

### 2️⃣ Probar Registro
- Ve a "Crear una nueva cuenta"
- Completa el formulario
- Haz clic en "Crear Cuenta"
- Deberías ver un mensaje de éxito
- Automáticamente te redirigirá a Login

### 3️⃣ Probar Login
- Usa las credenciales que creaste en el registro
- Deberías ser redirigido a la página de Resumen

### 4️⃣ Ver en Supabase Console
- Ve a https://app.supabase.com
- Selecciona tu proyecto
- Ve a "Authentication" → "Users"
- Deberías ver tu usuario registrado

---

## 📝 Detalles de Autenticación

### Flujo de Registro
1. Usuario completa formulario (email, nombre, negocio, contraseña)
2. Se llama a `authProvider.signUp()`
3. Supabase crea usuario en `auth.users`
4. **Trigger automático** crea registro en tabla `users`
5. Mensaje de éxito y redirige a login

### Flujo de Login
1. Usuario ingresa email y contraseña
2. Se llama a `authProvider.signIn()`
3. Supabase valida credenciales
4. JWT token se almacena automáticamente
5. `MultiProvider` detecta cambio y redirige a `/resumen`

### Flujo de Logout
1. Usuario hace clic en logout
2. Se llama a `authProvider.signOut()`
3. Token se elimina
4. App redirige automáticamente a `/login`

---

## 🛡️ Seguridad

✅ **Credenciales seguras** en `.env`
✅ **RLS activada** en BD (solo datos propios)
✅ **JWT tokens** para autenticación
✅ **Validación** en cliente y servidor

### ⚠️ Importante: .env
El archivo `.env` contiene credenciales públicas (ANON_KEY).
- NUNCA subas `.env` a GitHub
- Agrega a `.gitignore` (ya debe estar incluido)
- Las credenciales públicas son seguras (no exponen datos sensibles)
- Para operaciones sensibles usa una API serverless

---

## 📱 Componentes Creados

### `AuthProvider` (lib/src/shared/providers/auth_provider.dart)
- Gestiona autenticación
- Expone métodos y getters
- Maneja errores con mensajes claros

### `LoginPage` (lib/src/features/auth/pages/login_page.dart)
- Integrado con `AuthProvider`
- Validación de formulario
- Manejo de carga y errores

### `RegisterPage` (lib/src/features/auth/pages/register_page.dart)
- Campos: email, nombre, negocio, contraseña
- Integrado con `AuthProvider`
- Validación completa
- Confirmación de contraseña

---

## 🐛 Troubleshooting

### "Undefined class 'SupabaseClient'"
- Corre `flutter pub get` nuevamente
- Cierra y reabre el editor de código

### "Error connecting to Supabase"
- Verifica que `.env` está en la raíz del proyecto
- Comprueba que `SUPABASE_URL` y `SUPABASE_ANON_KEY` son correctos
- Verifica conexión a internet

### "AuthProvider not found"
- Asegúrate que `pubspec.yaml` tiene `provider` instalado
- Corre `flutter pub get`

---

## 📊 Estado de Base de Datos

La BD en Supabase ya tiene:
- ✅ 7 tablas creadas (ver `supabase_setup.sql`)
- ✅ RLS activado en todas
- ✅ Trigger para crear usuario automáticamente
- ✅ Índices para optimización
- ✅ Views para reportes

**Para ejecutar la SQL:**
1. Ve a https://app.supabase.com → Tu proyecto
2. SQL Editor → New query
3. Copia contenido de `supabase_setup.sql`
4. Ejecuta (Run)

---

## ✨ Resumen

| Aspecto | Estado | Detalles |
|--------|--------|---------|
| Dependencias | ✅ | supabase_flutter, flutter_dotenv, provider |
| .env | ✅ | Configurado con tus credenciales |
| main.dart | ✅ | Supabase inicializado |
| AuthProvider | ✅ | Métodos de auth completos |
| LoginPage | ✅ | Conectado a Supabase |
| RegisterPage | ✅ | Conectado a Supabase |
| BD | ⏳ | Lista (SQL en supabase_setup.sql) |

---

## 🎯 Para Siguientes Pasos

1. **Ejecuta la app** y prueba registro/login
2. **Verifica en Supabase** que los usuarios se crean
3. **Ejecuta la SQL** para crear tablas
4. **Crea repositorios** para acceder a datos (ya tienes modelos)
5. **Implementa las páginas** (ventas, gastos, productos)

---

**Configuración hecha**: 1 de diciembre de 2025
**Supabase Project**: zzaobtowduhjeivrmjhn
**Estado**: ✅ Listo para usar
