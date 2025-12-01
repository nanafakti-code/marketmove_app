# 🚀 CÓMO EJECUTAR MARKETMOVE CON SUPABASE

## ✅ Estado Actual
Tu proyecto está **100% listo** para ejecutarse con Supabase.

---

## 📋 Requisitos Previos

- ✅ Flutter 3.35.7 instalado
- ✅ Dart 3.9.2 instalado
- ✅ Supabase CLI (opcional, pero recomendado)
- ✅ Conexión a internet
- ✅ El proyecto ya tiene todas las dependencias descargadas

---

## 🎯 Opción 1: Ejecutar sin BD (Solo Autenticación)

### Paso 1: Ejecutar la app
```bash
cd "c:\Users\rafae\Desktop\DAM 2º\Desarollo de Interfaces\marketmove_app"
flutter run
```

### Paso 2: Probar registro
1. Haz clic en **"Crear una nueva cuenta"**
2. Completa el formulario:
   - **Nombre completo**: Tu nombre
   - **Nombre del negocio**: Tu negocio
   - **Email**: tu@email.com
   - **Contraseña**: mínimo 6 caracteres
3. Haz clic en **"Crear Cuenta"**

### Paso 3: Probar login
1. Usa el email y contraseña que creaste
2. Deberías ver la página de **Resumen** (dashboard)

### Paso 4: Ver usuario en Supabase
1. Ve a https://app.supabase.com
2. Selecciona tu proyecto
3. Ve a **Authentication** → **Users**
4. Deberías ver tu usuario registrado con email y metadata

---

## 🎯 Opción 2: Ejecutar con BD Completa

### Paso 1: Crear las tablas en Supabase

#### 1.1 Ir a Supabase SQL Editor
```
https://app.supabase.com 
→ Tu proyecto
→ SQL Editor
→ New Query
```

#### 1.2 Ejecutar el script SQL
1. Abre el archivo `supabase_setup.sql` en tu proyecto
2. Copia TODO el contenido
3. Pégalo en el SQL Editor de Supabase
4. Haz clic en **"Run"** (botón verde arriba a la derecha)

#### 1.3 Verificar que se creó todo
```
Authentication (en el menú lateral)
  → Users (deberías ver tu usuario)

Database
  → Tables (deberías ver 7 tablas):
    - users
    - productos
    - ventas
    - venta_detalles
    - gastos
    - resumen
    - audit_logs
```

### Paso 2: Ejecutar la app
```bash
flutter run
```

### Paso 3: Probar flujo completo
1. **Registra** un usuario nuevo
2. **Inicia sesión**
3. Verás que puedes acceder a todas las páginas
4. Los datos se guardarán en Supabase

---

## 📱 Plataformas Disponibles

Ejecuta la app en:

### Windows (Desktop)
```bash
flutter run -d windows
```

### Android (Emulador o dispositivo)
```bash
flutter run -d android
```

### iOS (Simulador o dispositivo)
```bash
flutter run -d ios
```

### Web (Navegador)
```bash
flutter run -d web
```

---

## 🔍 Comandos Útiles

### Ver dispositivos disponibles
```bash
flutter devices
```

### Limpiar build
```bash
flutter clean
flutter pub get
flutter run
```

### Ver logs en tiempo real
```bash
flutter logs
```

### Build release (para producción)
```bash
flutter build apk        # Android
flutter build ipa        # iOS
flutter build windows    # Windows
```

---

## 🐛 Solucionar Problemas

### "flutter: command not found"
```bash
# Agrega Flutter a PATH (sigue la guía de instalación)
# O usa la ruta completa:
C:\flutter\bin\flutter run
```

### "pubspec.lock outdated"
```bash
flutter clean
flutter pub get
flutter run
```

### "Android SDK not found"
```bash
flutter doctor
# Sigue las instrucciones para instalar Android SDK
```

### "Supabase connection error"
- Verifica que `.env` está en la raíz del proyecto
- Comprueba que `SUPABASE_URL` es correcto
- Verifica tu conexión a internet
- Abre la consola de Supabase en navegador para verificar que el proyecto existe

### "Cannot find emulator"
```bash
# Lista emuladores disponibles
flutter emulators

# Ejecuta uno
flutter emulators --launch <emulator_name>
flutter run
```

---

## 📊 Estructura de Archivos Importantes

```
marketmove_app/
├── .env                              ← Variables de entorno (no subir a Git)
├── supabase_setup.sql                ← Script SQL para crear BD
├── SUPABASE_CONFIG.md                ← Documentación de configuración
├── pubspec.yaml                      ← Dependencias
├── lib/
│   ├── main.dart                     ← Inicialización con Supabase
│   └── src/
│       ├── shared/
│       │   └── providers/
│       │       └── auth_provider.dart  ← Lógica de autenticación
│       └── features/
│           └── auth/
│               └── pages/
│                   ├── login_page.dart    ← Página de login
│                   └── register_page.dart ← Página de registro
└── android/, ios/, windows/, web/   ← Código específico de plataforma
```

---

## 🎨 Personalización

### Cambiar tema
Archivo: `lib/src/core/theme/app_theme.dart`

### Cambiar rutas
Archivo: `lib/main.dart` (sección `routes`)

### Cambiar URL de Supabase
Archivo: `.env`

### Agregar nuevas páginas
```bash
# En lib/src/features/[feature]/pages/[page_name].dart
# Luego agregar ruta en main.dart
```

---

## 📦 Dependencias Instaladas

| Paquete | Versión | Para qué |
|---------|---------|---------|
| supabase_flutter | ^2.9.0 | Cliente de Supabase |
| flutter_dotenv | ^5.1.0 | Variables de entorno |
| provider | ^6.1.5+1 | Gestión de estado |
| google_fonts | ^6.3.2 | Fuentes de Google |

---

## 🔐 Seguridad

✅ `.env` está en `.gitignore` (no se sube a GitHub)
✅ Variables de entorno se cargan en tiempo de compilación
✅ RLS activado en la BD (solo datos propios del usuario)
✅ Tokens JWT se manejan automáticamente

---

## 📈 Próximos Pasos Después de Ejecutar

1. **Prueba registro/login** - Verifica que funciona
2. **Ejecuta la SQL** - Crea las 7 tablas en BD
3. **Implementa las páginas** - Usa los modelos y repositorios
4. **Prueba funcionalidades** - Ventas, gastos, productos
5. **Publica la app** - Play Store / App Store

---

## 📞 Contacto/Soporte

Si tienes problemas:

1. Verifica `SUPABASE_CONFIG.md` para detalles técnicos
2. Revisa la documentación de Supabase: https://supabase.com/docs
3. Revisa la documentación de Flutter: https://flutter.dev/docs
4. Abre un issue en GitHub con detalles del error

---

## ✨ Resumen Rápido

```bash
# 1. Asegurate de estar en el directorio correcto
cd "c:\Users\rafae\Desktop\DAM 2º\Desarollo de Interfaces\marketmove_app"

# 2. Ejecuta la app
flutter run

# 3. Prueba registro en la app
# 4. Verifica en Supabase console
# 5. ¡Disfruta!
```

---

**Hecho en**: 1 de diciembre de 2025
**Supabase Conectado**: ✅ Si
**BD Configurada**: ⏳ Lista (ejecuta supabase_setup.sql)
**Estado**: 🚀 Listo para volar
