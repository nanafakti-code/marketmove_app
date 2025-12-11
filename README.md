# � MarketMove – App Inteligente de Análisis de Ventas y Gestión Empresarial

![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue?style=flat-square&logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?style=flat-square&logo=supabase)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

---

## 🎯 Descripción General

**MarketMove** es una aplicación multiplataforma desarrollada con **Flutter** que proporciona soluciones inteligentes para la gestión integral de empresas y análisis de ventas. Diseñada para emprendedores, pequeñas y medianas empresas (PyMEs), administradores y superadministradores, MarketMove integra funcionalidades avanzadas de control de inventario, seguimiento de ventas, gestión de gastos y análisis de mercado en una interfaz moderna y responsiva.

### ✨ Valor Principal

- **Gestión centralizada**: Control total sobre productos, ventas, gastos y clientes en una sola plataforma
- **Análisis inteligente**: Dashboard con métricas clave y análisis de rendimiento
- **Generación automática de facturas**: PDF profesionales enviados automáticamente por email
- **Gestión de usuarios**: Roles diferenciados (Superadmin, Admin, Usuario) con permisos granulares
- **Sincronización en tiempo real**: Datos actualizados instantáneamente gracias a Supabase
- **Experiencia multiplataforma**: Funciona en Windows, macOS, iOS, Android y Web

---

## ✨ Características Principales

### 📈 Dashboard Inteligente
- Visualización de métricas clave en tiempo real
- Gráficos interactivos de ventas, gastos e ingresos
- Análisis de tendencias y patrones de venta
- Resumen ejecutivo personalizable

### 💰 Gestión de Ventas
- Registro de ventas con datos de cliente y producto
- Cálculo automático de impuestos y descuentos
- Generación automática de facturas en PDF
- Envío de facturas por email a clientes
- Edición y eliminación de ventas
- Historial completo de transacciones

### 📦 Control de Inventario
- Gestión de productos y stock
- Actualización automática de inventario con cada venta
- Alertas de stock bajo
- Gestión de categorías y variantes

### 💵 Seguimiento de Gastos
- Registro categorizado de gastos operacionales
- Análisis de gasto por categoría y período
- Comparativa de gastos vs. ingresos
- Proyecciones de flujo de efectivo

### 👥 Gestión de Clientes y Usuarios
- Registro de clientes con información detallada
- Gestión de múltiples usuarios con roles diferenciados
- Creación de cuentas de administrador por superadministrador
- Perfiles de usuario personalizables
- Información de contacto y dirección de facturación

### 🎨 Interfaz Moderna
- **Diseño Gradient**: Interfaz visual con tonos azules degradados (#0f3460 a tonos más claros)
- **Responsiva**: Adaptable a cualquier tamaño de pantalla
- **Animaciones suaves**: Transiciones fluidas y botones animados
- **Tema consistente**: Colores, tipografía y componentes unificados

### 📧 Integración de Emails
- Envío automático de facturas por Gmail (usando mailer)
- Notificaciones por email
- Plantillas de email personalizables

### 🔐 Seguridad y Autenticación
- Autenticación con Supabase
- RLS (Row Level Security) para protección de datos
- Roles y permisos granulares
- Sesiones seguras

---

## 🏗️ Estructura del Proyecto

```
marketmove_app/
│
├── lib/
│   ├── main.dart                          # Punto de entrada de la aplicación
│   ├── src/
│   │   ├── core/
│   │   │   ├── models/                    # Modelos de datos (Producto, Venta, Gasto, etc.)
│   │   │   └── theme/                     # Tema global, colores y estilos
│   │   │
│   │   ├── features/                      # Características principales
│   │   │   ├── auth/                      # Autenticación (Login, Register)
│   │   │   ├── resumen/                   # Dashboard principal
│   │   │   ├── ventas/                    # Gestión de ventas
│   │   │   ├── productos/                 # Gestión de productos
│   │   │   ├── gastos/                    # Gestión de gastos
│   │   │   ├── clientes/                  # Gestión de clientes y usuarios
│   │   │   └── perfil/                    # Perfil de usuario
│   │   │
│   │   └── shared/
│   │       ├── services/                  # Servicios compartidos
│   │       │   ├── email_service.dart     # Servicio de emails (Gmail SMTP con mailer)
│   │       │   └── pdf_service.dart       # Generación de PDFs
│   │       ├── repositories/              # Acceso a datos (Supabase)
│   │       │   └── data_repository.dart   # Operaciones CRUD
│   │       ├── providers/                 # Providers de estado (Auth)
│   │       └── widgets/                   # Widgets reutilizables
│
├── assets/
│   ├── icons/                             # Iconos de la aplicación
│   └── images/                            # Imágenes y recursos gráficos
│
├── android/                               # Código nativo Android
├── ios/                                   # Código nativo iOS
├── windows/                               # Código nativo Windows
├── macos/                                 # Código nativo macOS
├── web/                                   # Código web
├── linux/                                 # Código nativo Linux
│
├── docs/                                  # Documentación del proyecto
│   ├── DATABASE_SETUP.md                  # Configuración de base de datos
│   ├── ARQUITECTURA_DIAGRAMA.md           # Diagrama de arquitectura
│   └── ...                                # Otros archivos de documentación
│
├── pubspec.yaml                           # Dependencias del proyecto
├── pubspec.lock                           # Bloqueo de versiones
├── analysis_options.yaml                  # Configuración de análisis Dart
├── .env.example                           # Ejemplo de variables de entorno
├── .gitignore                             # Archivo de ignorados de Git
└── README.md                              # Este archivo

```

---

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Flutter 3.35.7** - Framework multiplataforma para UI
- **Dart 3.9.2** - Lenguaje de programación
- **Provider 6.1.5+1** - Gestión de estado

### Backend
- **Supabase** - Backend como servicio (BaaS)
  - **PostgreSQL** - Base de datos relacional
  - **Authentication** - Sistema de autenticación
  - **Realtime** - Sincronización en tiempo real
  - **RLS (Row Level Security)** - Control de acceso a nivel de fila

### Servicios Externos
- **Gmail SMTP** - Envío de emails mediante mailer
- **Google Fonts** - Tipografía web

### Librerías Principales
- **supabase_flutter 2.9.0** - Cliente oficial de Supabase
- **flutter_dotenv 5.2.1** - Variables de entorno
- **mailer 6.6.0** - Envío de emails con Gmail
- **pdf 3.11.1** - Generación de PDFs
- **path_provider** - Acceso a rutas del sistema
- **shared_preferences** - Almacenamiento local
- **url_launcher** - Lanzamiento de URLs

### Herramientas de Desarrollo
- **flutter_launcher_icons 0.13.1** - Generación de iconos multiplataforma
- **lints 6.0** - Análisis de código Dart
- **Gradle 8.x** - Build system Android

---

## 📱 Plataformas Soportadas

| Plataforma | Estado | Requisitos |
|-----------|--------|-----------|
| **Android** | ✅ Totalmente soportada | API 21+ |
| **iOS** | ✅ Totalmente soportada | iOS 12.0+ |
| **Windows** | ✅ Totalmente soportada | Windows 10+ |
| **macOS** | ✅ Totalmente soportada | macOS 10.15+ |
| **Web** | ✅ Totalmente soportada | Navegador moderno |
| **Linux** | ✅ Totalmente soportada | Ubuntu 18.04+ |

---

## 🚀 Instalación y Ejecución

### Requisitos Previos
- **Flutter SDK 3.35.7+** - [Descargar Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK 3.9.2+** - Se incluye con Flutter
- **Git** - Para clonar el repositorio
- **Java JDK 11+** - Para compilar Android (opcional)
- **Xcode 14+** - Para iOS (solo macOS)

### 1. Clonar el Repositorio

```bash
git clone https://github.com/nanafakti-code/marketmove_app.git
cd marketmove_app
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Configurar Variables de Entorno

Copia `.env.example` a `.env` y completa los valores:

```bash
cp .env.example .env
```

**Edita `.env` con tus credenciales:**

```env
# Supabase
SUPABASE_URL=tu_url_supabase
SUPABASE_ANON_KEY=tu_anon_key

# Gmail (para envío de emails)
BREVO_SMTP_USER=tu_email@gmail.com
BREVO_SMTP_PASSWORD=tu_contraseña_aplicacion_gmail
BREVO_SENDER_EMAIL=tu_email@gmail.com
```

### 4. Ejecutar la Aplicación

#### En Windows/macOS/Linux (Desktop)
```bash
flutter run
```

#### En Android
```bash
flutter run -d android
```

#### En iOS (solo macOS)
```bash
flutter run -d ios
```

#### En Web
```bash
flutter run -d chrome
```

#### En modo Release (Producción)
```bash
flutter run --release
```

### 5. Generar APK/IPA (Compilación)

```bash
# APK para Android
flutter build apk

# APK en split por arquitectura
flutter build apk --split-per-abi

# IPA para iOS
flutter build ios

# EXE para Windows
flutter build windows

# DMG para macOS
flutter build macos

# Web
flutter build web
```

---

## 📦 Configuración de Base de Datos (Supabase)

Para que la aplicación funcione correctamente, necesitas configurar la base de datos en Supabase:

```sql
-- Ver documentación en docs/DATABASE_SETUP.md
-- Ejecutar scripts SQL en docs/
```

### Tablas Principales

- **users** - Usuarios del sistema
- **empresas** - Información de empresas
- **productos** - Catálogo de productos
- **ventas** - Registro de transacciones
- **gastos** - Gastos operacionales
- **clientes_empresa** - Base de clientes

Para más detalles, consulta [docs/DATABASE_SETUP.md](docs/DATABASE_SETUP.md)

---

## 🔑 Configuración de Emails (Gmail)

1. **Usar cuenta Gmail**: https://mail.google.com
2. **Generar contraseña de aplicación**: 
   - Ir a https://myaccount.google.com/security
   - Habilitar autenticación de dos factores
   - Generar contraseña de aplicación para "Mail"
3. **Configurar en `.env`**: Usar las variables BREVO_* con credenciales de Gmail

**Nota**: Aunque usamos variables nombradas BREVO_*, actualmente estamos usando Gmail SMTP con la librería `mailer`.

---

## 📚 Documentación Adicional

- [Guía de Ejecución Rápida](docs/COMO_EJECUTAR.md)
- [Configuración de Base de Datos](docs/DATABASE_SETUP.md)
- [Diagrama de Arquitectura](docs/ARQUITECTURA_DIAGRAMA.md)
- [Diagrama Entidad-Relación](docs/DIAGRAMA_ER.md)
- [Configuración de Autenticación GitHub](docs/AUTENTICACION_GITHUB.md)
- [Todas las guías de documentación](docs/INDEX.md)

---

## 👤 Gestión de Roles

### Superadministrador (Superadmin)
- Acceso total al sistema
- Crear/editar/eliminar administradores
- Crear/editar/eliminar empresas
- Ver todas las operaciones del sistema
- Acceso a configuración avanzada

### Administrador (Admin)
- Gestión completa de su empresa
- Crear/editar/eliminar ventas, productos, gastos
- Gestión de clientes
- Ver reportes de su empresa
- Crear/editar clientes (usuarios normales)

### Usuario (User)
- Acceso limitado a funcionalidades
- Ver sus propias operaciones
- Crear ventas asignadas
- Ver información de perfil

---

## 🔒 Seguridad

- ✅ Autenticación con JWT (Supabase)
- ✅ RLS (Row Level Security) en PostgreSQL
- ✅ Variables de entorno para credenciales sensibles
- ✅ No almacenar secrets en el repositorio
- ✅ Encriptación en tránsito (HTTPS)

---

## 🐛 Solución de Problemas

### "LateInitializationError: Field '_fromEmail@...' has not been initialized"
Este error ocurre si no se inicializa EmailService antes de enviar emails. La solución se encuentra en [data_repository.dart](lib/src/shared/repositories/data_repository.dart) línea 150.

### "Refresh token is not valid"
Asegúrate de que tu sesión de Supabase es válida. Intenta hacer logout y login nuevamente.

### "Cannot connect to Supabase"
Verifica que:
- Tu `.env` tiene las credenciales correctas de Supabase
- La URL de Supabase es accesible
- El API Key es válido

---

## 🖼️ Capturas

*Próximamente...*

---

## 📄 Licencia

Este proyecto está bajo licencia MIT. Consulta [LICENSE](LICENSE) para más detalles.

---

## 👨‍💼 Autor

**NanaFakti Code**
- GitHub: [@nanafakti-code](https://github.com/nanafakti-code)
- Proyecto: MarketMove - App Inteligente de Gestión Empresarial

---

## 📞 Soporte y Contacto

Para reportar errores o solicitar funcionalidades, abre un [Issue](https://github.com/nanafakti-code/marketmove_app/issues) en GitHub.

---

## 🙏 Agradecimientos

- **Flutter** por el excelente framework
- **Supabase** por el backend robusto
- **Brevo** por el servicio de emails
- Toda la comunidad de desarrollo

---

**¡Gracias por usar MarketMove!** 🚀

Última actualización: **11 de Diciembre de 2025**

**Aplicación móvil profesional para gestión integral de pequeños comercios**

[📋 Características](#-características) • [🚀 Quick Start](#-quick-start) • [📁 Estructura](#-estructura) • [🔐 Seguridad](#-seguridad) • [📚 Documentación](#-documentación) • [📖 Docs](docs/INDEX.md)

</div>

---

## 📊 Descripción General

**MarketMove App** es una solución completa desarrollada en **Flutter** para que dueños de pequeños comercios puedan:

- 💰 **Registrar ventas** de forma rápida y sencilla
- 💸 **Controlar gastos** (arriendo, servicios, proveedores, etc.)
- 📦 **Gestionar productos** e inventario en tiempo real
- 📊 **Ver ganancias netas** mediante dashboards visuales
- 🔐 **Acceso seguro** desde iOS o Android

### Beneficios Principales

| Beneficio | Descripción |
|-----------|------------|
| **Multiplataforma** | iOS + Android con un único código |
| **Seguridad** | Row Level Security en base de datos |
| **Escalable** | Infraestructura en la nube (Supabase) |
| **Modern UI** | Material Design 3 |
| **Offline Ready** | Funciona sin conexión (sincroniza después) |

---

## 🚀 Tecnologías y Stack

### Frontend
- **Flutter 3.35.7** - Framework UI multiplataforma
- **Dart 3.9.2** - Lenguaje de programación
- **Material Design 3** - Sistema de diseño
- **Provider** - State Management
- **Supabase Client** - Cliente para BD

### Backend
- **Supabase** - Backend as a Service
- **PostgreSQL** - Base de datos relacional
- **Row Level Security** - Seguridad de datos
- **JWT Authentication** - Autenticación segura

### DevOps & Herramientas
- **GitHub** - Control de versiones
- **Firebase** - Analytics y Crash reporting
- **Google Play Store** - Distribución Android
- **Apple App Store** - Distribución iOS

## 📚 Documentación

La documentación completa del proyecto se encuentra en la carpeta `docs/`:

- **[📖 Índice Completo de Documentación](docs/INDEX.md)** - Listado de todos los documentos disponibles
- **[⚡ Quick Start](docs/QUICK_SETUP.md)** - Configuración rápida del proyecto
- **[🏗️ Arquitectura](docs/ARQUITECTURA_DIAGRAMA.md)** - Diagrama y descripción de la arquitectura
- **[🔧 Configuración de Supabase](docs/SUPABASE_CONFIG.md)** - Guía de configuración
- **[📧 Setup de Brevo](docs/BREVO_SETUP.md)** - Configuración de envío de emails
- **[👥 Gestión de Clientes](docs/CLIENTES_SETUP.md)** - Documentación del módulo de clientes
- **[💾 Base de Datos](docs/DIAGRAMA_ER.md)** - Diagrama entidad-relación

> 💡 **Tip**: Todos los documentos `.md` están organizados en la carpeta `docs/` para mantener la raíz limpia y ordenada.

## 📁 Estructura del Proyecto

```
marketmove_app/
├── lib/
│   ├── main.dart                    # Punto de entrada de la aplicación
│   └── src/
│       ├── features/                # Módulos por funcionalidad
│       │   ├── auth/               # Autenticación
│       │   │   ├── pages/          # Pantallas de login y registro
│       │   │   └── widgets/        # Componentes reutilizables
│       │   ├── ventas/             # Gestión de ventas
│       │   │   ├── pages/
│       │   │   └── widgets/
│       │   ├── gastos/             # Gestión de gastos
│       │   │   ├── pages/
│       │   │   └── widgets/
│       │   ├── productos/          # Gestión de inventario
│       │   │   ├── pages/
│       │   │   └── widgets/
│       │   └── resumen/            # Panel de control
│       │       ├── pages/
│       │       └── widgets/
│       └── shared/                 # Recursos compartidos
│           ├── models/             # Modelos de datos
│           ├── services/           # Servicios (API, DB)
│           ├── providers/          # Gestión de estado
│           └── widgets/            # Widgets compartidos
├── assets/
│   ├── images/                     # Imágenes de la aplicación
│   └── icons/                      # Iconos personalizados
├── test/                           # Tests unitarios y de integración
└── pubspec.yaml                    # Dependencias del proyecto
```

## 🛠️ Cómo Ejecutar el Proyecto

### Requisitos Previos

- Flutter SDK 3.35.7 o superior
- Dart SDK 3.9.2 o superior
- Android Studio / VS Code con extensiones de Flutter
- Emulador Android o dispositivo físico

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/TU_USUARIO/marketmove_app.git
   cd marketmove_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar la instalación de Flutter**
   ```bash
   flutter doctor
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Limpiar el proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Ejecutar tests
flutter test

# Generar APK
flutter build apk

# Generar App Bundle
flutter build appbundle
```

## 📱 Funcionalidades Actuales

### ✅ Implementado (MVP)

- [x] Sistema de autenticación (UI)
  - Pantalla de inicio de sesión
  - Pantalla de registro
  - Validación de formularios
  
- [x] Panel de Resumen
  - Vista general de métricas
  - Accesos rápidos a módulos
  - Resumen financiero
  
- [x] Gestión de Ventas
  - Interfaz para registro de ventas
  - Historial de transacciones
  - Resumen de ventas
  
- [x] Gestión de Gastos
  - Interfaz para registro de gastos
  - Historial de gastos
  - Resumen de gastos
  
- [x] Gestión de Productos
  - Interfaz de inventario
  - Control de stock
  - Búsqueda de productos

- [x] Navegación
  - Rutas configuradas
  - Menú lateral (Drawer)
  - Navegación fluida entre pantallas

## 🔄 Fases del Proyecto

### Fase 1: Estructura y UI Base ✅ (Completada)
- Creación del proyecto Flutter
- Estructura de carpetas profesional
- Pantallas MVP con navegación
- Sistema de rutas

### Fase 2: Integración con Supabase 🚧 (Próximamente)
- Configuración de Supabase
- Autenticación real de usuarios
- Base de datos para ventas, gastos y productos
- Sincronización en tiempo real

### Fase 3: Funcionalidad Completa 📋 (Planificada)
- CRUD completo de ventas
- CRUD completo de gastos
- CRUD completo de productos
- Generación de reportes
- Gráficos y estadísticas

### Fase 4: Mejoras y Optimización 🎯 (Planificada)
- Modo offline
- Exportación de datos (PDF, Excel)
- Notificaciones push
- Temas personalizables
- Optimización de rendimiento

## 👥 Integrantes del Equipo

<!-- Editar esta sección con los datos del equipo -->

| Nombre | Rol | Email |
|--------|-----|-------|
| [Tu Nombre] | Desarrollador Principal | tu.email@ejemplo.com |
| [Nombre 2] | [Rol] | email@ejemplo.com |
| [Nombre 3] | [Rol] | email@ejemplo.com |

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Contacto

Para preguntas o sugerencias, por favor abre un issue en el repositorio.

---

**Desarrollado con ❤️ usando Flutter**
