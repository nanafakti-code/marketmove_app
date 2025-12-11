# 📱 Guía para Compilar MarketMove en Móvil

## 🎯 Importante: Archivo `.env` en Assets

A partir de ahora, el archivo `.env` se encuentra en la carpeta `assets/` para que funcione correctamente en móvil.

```
📁 proyecto/
├── 📄 .env (raíz - para desarrollo local)
└── 📁 assets/
    └── 📄 .env (empaquetado en la app)
```

## 🔧 Pasos para Compilar en Android

### 1. Asegurar que los Archivos `.env` Están Correctamente Ubicados

```bash
# Desde la raíz del proyecto
# El archivo .env debe estar en:
# - c:\flutter_projects\marketmove_app\.env (para desarrollo local)
# - c:\flutter_projects\marketmove_app\assets\.env (empaquetado)

# Verificar que están sincronizados:
Copy-Item .env assets\.env -Force
```

### 2. Limpiar y Compilar

```bash
# Limpiar compilaciones anteriores
flutter clean

# Descargar dependencias
flutter pub get

# Compilar para Android
flutter build apk --release

# O para builds de debug:
flutter build apk --debug
```

### 3. El APK se generará en:
```
build/app/outputs/apk/release/app-release.apk
```

## 🍎 Pasos para Compilar en iOS

### 1. Actualizar Certificados (si es necesario)

```bash
cd ios
pod install
cd ..
```

### 2. Compilar

```bash
# Limpiar y descargar dependencias
flutter clean
flutter pub get

# Compilar para iOS
flutter build ios --release

# O para debug:
flutter build ios --debug
```

### 3. El archivo se generará en:
```
build/ios/iphoneos/Runner.app
```

## ✅ Verificación: Los Emails Funcionarán Correctamente Porque:

1. ✅ El archivo `assets/.env` se empaqueta en la APK/IPA
2. ✅ `main.dart` carga desde `assets/.env` (compatible con móvil)
3. ✅ `EmailService` usa `dotenv.env` (no intenta leer archivos del sistema)
4. ✅ Las credenciales de Brevo están en el `.env` empaquetado

## 🔐 Variables de Entorno Requeridas en `assets/.env`

```env
# Credenciales de Brevo (SMTP)
BREVO_SMTP_USER=9cff81001@smtp-brevo.com
BREVO_SMTP_PASSWORD=[TU_CLAVE_SMTP_AQUI]
BREVO_SMTP_SERVER=smtp-relay.brevo.com
BREVO_SMTP_PORT=587
BREVO_SENDER_EMAIL=marketmoverbv@gmail.com

# Credenciales de Supabase
SUPABASE_URL=https://zzaobtowduhjeivrmjhn.supabase.co
SUPABASE_ANON_KEY=[TU_ANON_KEY_AQUI]
```

## 🚀 Resumen

- **Windows**: Funciona perfectamente
- **Android**: Ejecutar `flutter build apk --release` (requiere Android SDK)
- **iOS**: Ejecutar `flutter build ios --release` (requiere Xcode en macOS)
- **Emails**: Funcionan en todas las plataformas gracias a que `.env` está empaquetado

## ⚠️ Nota de Seguridad

**NUNCA** comitees el archivo `.env` a GitHub con credenciales reales.
- Está en `.gitignore` automáticamente
- Las credenciales están protegidas
- Cada desenvolvedor debe tener su propio `.env` local
