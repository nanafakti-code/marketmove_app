# 📱 MarketMove App - Gestión de Comercios Móvil

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?logo=supabase)
![License](https://img.shields.io/badge/License-Proprietary-red)
![Status](https://img.shields.io/badge/Status-En%20Desarrollo-yellow)

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
