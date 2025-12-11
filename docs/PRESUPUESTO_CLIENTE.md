# 📊 PRESUPUESTO PROFESIONAL
## MarketMove S.L. - Aplicación Móvil de Gestión Comercial

**Fecha**: 1 de diciembre de 2025  
**Valido por**: 30 días  
**Cliente**: MarketMove S.L.  
**Proyecto**: MarketMove App - Aplicación Móvil para Gestión de Comercios

---

## A. INTRODUCCIÓN

### ¿Qué se va a desarrollar?

MarketMove App es una **aplicación móvil profesional** que permitirá a los dueños de pequeños comercios:

- 📱 **Registrarse y gestionar su cuenta** de forma segura
- 💰 **Registrar ventas diarias** de manera rápida
- 💸 **Controlar gastos operativos** (arriendo, servicios, proveedores, etc.)
- 📦 **Gestionar productos e inventario** con stock en tiempo real
- 📊 **Ver ganancias netas** mediante un panel de resumen visual
- 🔐 **Acceso seguro** desde cualquier dispositivo móvil (iOS/Android)

### ¿Con qué tecnología se desarrollará?

**Tecnología elegida: Flutter + Supabase**

#### ¿Qué es Flutter?

Flutter es un framework de **Google** que permite crear aplicaciones móviles de alta calidad en **iOS y Android usando un único código**. Es como escribir una sola vez y que funcione en ambos dispositivos.

#### Ventajas de Flutter para este proyecto:

| Ventaja | Descripción |
|---------|-------------|
| **Multiplataforma** | Una app para iOS y Android (ahorro de tiempo y dinero) |
| **Rendimiento** | Muy rápida y eficiente |
| **Interfaz moderna** | Diseño profesional y atractivo |
| **Desarrollo rápido** | Se puede cambiar código y ver cambios al instante |
| **Comunidad activa** | Mucho soporte y librerías disponibles |
| **Costo menor** | Una sola aplicación para dos plataformas |

#### ¿Qué es Supabase?

Supabase es una **base de datos en la nube** que actúa como el "cerebro" de la aplicación:
- Almacena los datos de usuarios, ventas, gastos y productos
- Proporciona autenticación segura
- Permite que los datos se sincronicen en tiempo real
- Escala automáticamente sin preocupaciones

---

## B. FASES DEL PROYECTO

### FASE 1: Análisis y Toma de Requisitos
**Duración estimada: 16 horas**

#### Actividades:
- ✅ Reunión inicial con el cliente para validar requisitos
- ✅ Análisis detallado de funcionalidades necesarias
- ✅ Documentación de casos de uso
- ✅ Definición de flujos de usuario (user journeys)
- ✅ Especificación técnica del proyecto
- ✅ Creación de mockups preliminares

#### Entregables:
- Documento de requisitos funcionales
- Especificación técnica
- Mockups básicos de pantallas
- Plan de testing

**Horas**: 16 h

---

### FASE 2: Diseño UX/UI
**Duración estimada: 24 horas**

#### Actividades:
- ✅ Diseño detallado de todas las pantallas
- ✅ Creación de wireframes de alta fidelidad
- ✅ Definición de paleta de colores corporativa
- ✅ Sistema de iconografía
- ✅ Guía de estilos (Design System)
- ✅ Animaciones y transiciones
- ✅ Validación con el cliente

#### Pantallas a diseñar:
1. Pantalla de Login/Registro
2. Dashboard/Resumen
3. Pantalla de Nueva Venta
4. Pantalla de Nuevo Gasto
5. Gestor de Productos
6. Historial de Ventas
7. Historial de Gastos
8. Perfil de Usuario

**Horas**: 24 h

---

### FASE 3: Arquitectura y Base de Datos
**Duración estimada: 20 horas**

#### Actividades:
- ✅ Diseño del modelo de datos (ERD)
- ✅ Creación de base de datos en Supabase
- ✅ Diseño de tablas con Row Level Security (RLS)
- ✅ Definición de políticas de seguridad
- ✅ Creación de índices para optimización
- ✅ Configuración de autenticación
- ✅ Setup del entorno de desarrollo

#### Tablas a crear:
- **users** - Perfiles de usuarios
- **productos** - Inventario
- **ventas** - Transacciones
- **venta_detalles** - Líneas de venta
- **gastos** - Gastos operativos
- **resumen** - Panel de ganancias mensuales
- **audit_logs** - Registro de cambios

**Horas**: 20 h

---

### FASE 4: Desarrollo del Frontend (Flutter)
**Duración estimada: 80 horas**

#### 4.1 Configuración inicial del proyecto (8h)
- Setup del proyecto Flutter
- Estructura de carpetas profesional
- Configuración de dependencias
- Setup de estado management (Provider)

#### 4.2 Módulo de Autenticación (16h)
- Pantalla de Login
- Pantalla de Registro
- Validación de formularios
- Recuperación de contraseña
- Integración con Supabase Auth
- Persistencia de sesión

#### 4.3 Módulo de Ventas (20h)
- Pantalla de nueva venta
- Selector de productos
- Cálculo de totales, impuestos, descuentos
- Historial de ventas
- Búsqueda y filtrado
- Detalles de venta
- Integración con base de datos

#### 4.4 Módulo de Gastos (16h)
- Pantalla de nuevo gasto
- Categorización de gastos
- Historial de gastos
- Búsqueda por categoría/proveedor
- Detalles de gasto
- Integración con base de datos

#### 4.5 Módulo de Productos (12h)
- Listado de productos
- Agregar producto
- Editar producto
- Eliminar producto
- Control de stock
- Búsqueda y filtrado

#### 4.6 Dashboard/Resumen (8h)
- Pantalla principal con KPIs
- Gráficos de ventas
- Gráficos de gastos
- Indicador de ganancia neta
- Estadísticas del mes

**Subtotal Fase 4**: 80 h

---

### FASE 5: Integración y Testing
**Duración estimada: 24 horas**

#### Actividades:
- ✅ Testing funcional de todas las pantallas
- ✅ Testing de integridad de datos
- ✅ Testing de seguridad (RLS)
- ✅ Testing de rendimiento
- ✅ Testing en múltiples dispositivos
- ✅ Corrección de bugs
- ✅ Validación con cliente

#### Tipos de testing:
- Unit tests (lógica de negocio)
- Widget tests (componentes UI)
- Integration tests (flujos completos)

**Horas**: 24 h

---

### FASE 6: Documentación y Entrega
**Duración estimada: 16 horas**

#### Actividades:
- ✅ Documentación de código
- ✅ Manual de usuario (en PDF)
- ✅ Guía de instalación
- ✅ Documentación técnica
- ✅ Video tutorial
- ✅ Capacitación al cliente (online)
- ✅ Entrega final

#### Entregables:
- README completo en GitHub
- Documentación técnica (API, estructura)
- Manual de usuario
- Video de demostración
- Código comentado

**Horas**: 16 h

---

### FASE 7: Publicación en Stores
**Duración estimada: 12 horas**

#### Actividades:
- ✅ Preparación de assets (iconos, screenshots)
- ✅ Publicación en Google Play Store (Android)
- ✅ Publicación en Apple App Store (iOS)
- ✅ Configuración de privacidad y términos
- ✅ Optimización de metadatos
- ✅ Monitoreo de métricas

**Nota**: Requiere cuentas de desarrollador en ambas tiendas  
**Nota**: Google Play (~$25 única vez), Apple (~$99/año)

**Horas**: 12 h

---

## C. ESTIMACIÓN DE HORAS

### Desglose por fase:

| Fase | Actividad | Horas |
|------|-----------|-------|
| 1 | Análisis y Requisitos | 16 h |
| 2 | Diseño UX/UI | 24 h |
| 3 | Arquitectura y BD | 20 h |
| 4 | Desarrollo Frontend | 80 h |
| 5 | Integración y Testing | 24 h |
| 6 | Documentación | 16 h |
| 7 | Publicación | 12 h |
| **TOTAL** | | **192 h** |

### Estimación con contingencia (15%):
- **Horas base**: 192 h
- **Contingencia (15%)**: 28.8 h
- **Total con contingencia**: 220.8 h ≈ **221 h**

---

## D. PRESUPUESTO

### Desglose de costos:

#### 1. Desarrollo (Equipo técnico)
```
- Tarifa horaria del equipo: €45/hora
- Horas de desarrollo: 221 h
- Subtotal desarrollo: 221 h × €45 = €9,945
```

#### 2. Infraestructura y Herramientas (primer año)
```
- Dominio personalizado: €12/año
- Certificados SSL: €0 (incluido en Supabase)
- Supabase Pro (según uso): €100/mes = €1,200/año
- Herramientas de diseño: €0 (Figma free)
- Git hosting (GitHub): €0 (plan free)
- Subtotal infraestructura: €1,212
```

#### 3. Cuentas en App Stores
```
- Google Play Store: €25 (única vez)
- Apple App Store: €99/año
- Certificados iOS: €0 (incluido en cuenta)
- Subtotal stores: €124 + €99/año
```

#### 4. Documentación y Capacitación
```
- Incluido en Fase 6
- Videos y manuales: Incluido
- Sesión de capacitación (1 hora): Incluido
```

---

## E. PRESUPUESTO FINAL

### Opción 1: Desarrollo Completo (Recomendado)

**Concepto** | **Costo**
---|---
Desarrollo (221 h × €45) | €9,945
Infraestructura primer año | €1,212
Publicación en stores | €124
**SUBTOTAL** | **€11,281**
IVA (21%) | €2,368.01
**TOTAL CON IVA** | **€13,649.01**

### Opción 2: MVP (Versión Básica)

Si quieres comenzar con funcionalidades mínimas:

**Concepto** | **Costo**
---|---
Desarrollo (120 h × €45) | €5,400
Infraestructura primer año | €1,212
Sin publicación en stores | €0
**SUBTOTAL** | **€6,612**
IVA (21%) | €1,388.52
**TOTAL CON IVA** | **€7,999.52**

*Incluye: Autenticación, Ventas básicas, Gastos, Productos, Dashboard*  
*Excluye: Publicación en stores, Análisis avanzado, Gráficos complejos*

---

## F. CRONOGRAMA (TIMELINE)

```
SEMANA 1 (40h)
├─ Análisis y Requisitos (16h)
└─ Diseño UX/UI - Parte 1 (24h)

SEMANA 2 (40h)
├─ Diseño UX/UI - Parte 2 (12h)
├─ Arquitectura y BD (20h)
└─ Setup proyecto Flutter (8h)

SEMANA 3 (40h)
├─ Módulo Autenticación (16h)
└─ Módulo Ventas - Parte 1 (24h)

SEMANA 4 (40h)
├─ Módulo Ventas - Parte 2 (8h)
├─ Módulo Gastos (16h)
└─ Módulo Productos (16h)

SEMANA 5 (40h)
├─ Dashboard (8h)
├─ Integración (16h)
└─ Testing - Parte 1 (16h)

SEMANA 6 (41h)
├─ Testing - Parte 2 (8h)
├─ Documentación (16h)
├─ Publicación en stores (12h)
└─ Presentación al cliente (5h)

TOTAL: 6 semanas = 241 días ≈ 48 días hábiles
```

**Fecha de inicio**: 2 de diciembre de 2025  
**Fecha estimada de entrega**: 16 de enero de 2026

---

## G. OBSERVACIONES IMPORTANTES

### ✅ Incluido en el presupuesto:

- ✓ Desarrollo completo de la aplicación
- ✓ Base de datos en Supabase
- ✓ Diseño profesional UX/UI
- ✓ Autenticación segura
- ✓ Testing funcional
- ✓ Documentación completa
- ✓ Capacitación básica (1 hora)
- ✓ Publicación en stores
- ✓ Primer año de infraestructura
- ✓ 30 días de soporte post-lanzamiento

### ❌ NO incluido en el presupuesto:

- ✗ Mantenimiento continuado después de 30 días
- ✗ Nuevas funcionalidades futuras
- ✗ Integraciones con terceros (pasarelas de pago, etc.)
- ✗ Análisis avanzados o BI
- ✗ Cambios mayores de diseño después de Phase 2
- ✗ Localización a otros idiomas (inicial: Español)

---

## H. POSIBLES AMPLIACIONES FUTURAS

Si después del lanzamiento quieren agregar más funcionalidades:

| Funcionalidad | Estimación |
|---|---|
| **Integración Pasarela de Pago** (Stripe, PayPal) | 24h |
| **Reportes avanzados y Exportación PDF** | 16h |
| **Gráficos y Análisis Predictivos** | 20h |
| **Modo offline** | 16h |
| **Sincronización en tiempo real** | 12h |
| **WhatsApp/Email de notificaciones** | 12h |
| **Gestión de múltiples usuarios por tienda** | 20h |
| **Multiidioma** (Inglés, Francés, etc.) | 16h |
| **Aplicación web** (versión desktop) | 40h |
| **App de delivery integrada** | 32h |

Podemos hacer un plan de mejoras gradual si lo necesitas.

---

## I. CONDICIONES DE PAGO

### Plan de pagos recomendado:

```
30% al inicio (firma contrato)        →  €4,094.70
40% al finalizar Fase 3 (BD lista)    →  €5,459.60
30% a la entrega final                →  €4,094.71

Total                                  €13,649.01
```

**Métodos de pago aceptados**:
- Transferencia bancaria
- Tarjeta de crédito
- PayPal

**Política de cambios**:
- Cambios mayores solicitados después de Fase 2: cobrables aparte
- Cambios de requisitos: se negocia impacto en horas

---

## J. GARANTÍAS Y SOPORTE

### Garantía incluida:
- ✅ 30 días de corrección de bugs post-lanzamiento
- ✅ Soporte técnico básico por email
- ✅ Una reunión de seguimiento a los 15 días

### Soporte extendido (opcional):
- **Plan Básico**: €300/mes (1h/semana de soporte)
- **Plan Pro**: €600/mes (4h/semana de soporte + nuevas features)
- **Plan Premium**: €1,000/mes (dedicado)

---

## K. TECNOLOGÍAS Y HERRAMIENTAS

### Frontend:
- **Flutter 3.35.7** - Framework de desarrollo
- **Dart** - Lenguaje de programación
- **Provider** - State management
- **Material Design 3** - Diseño UI

### Backend:
- **Supabase** - Database as a Service
- **PostgreSQL** - Base de datos
- **Row Level Security** - Seguridad de datos

### DevOps:
- **GitHub/GitLab** - Control de versiones
- **Firebase Analytics** - Métricas
- **Google Play Store** - Distribución Android
- **Apple App Store** - Distribución iOS

### Herramientas de Desarrollo:
- **VS Code** - Editor de código
- **Android Studio** - Emulador Android
- **Xcode** - Emulador iOS
- **Figma** - Diseño UI/UX

---

## L. EQUIPO DE DESARROLLO

**Composición del equipo**:
- 1 **Product Manager** (requisitos, diseño)
- 1 **UX/UI Designer** (interfaz, experiencia)
- 2 **Flutter Developers** (desarrollo frontend)
- 1 **Backend Developer** (base de datos, APIs)
- 1 **QA Engineer** (testing)

**Dedicación**: A tiempo completo durante 6 semanas

---

## M. RIESGOS Y MITIGACIONES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|--------|-----------|
| Cambios de requisitos | Alta | Medio | Validaciones semanales |
| Delays en aprobaciones Apple | Media | Bajo | Aplicar 2 semanas antes |
| Problemas de compatibilidad | Baja | Alto | Testing exhaustivo |
| Rotación del equipo | Muy baja | Alto | Documentación detallada |
| Incremento de scope | Alta | Medio | Adicionales pagables |

---

## N. PRÓXIMOS PASOS

### Para aceptar esta propuesta:

1. **Revisar** el presupuesto y cronograma
2. **Decidir** entre opción completa o MVP
3. **Firmar** el contrato de desarrollo
4. **Realizar** primer pago (30%)
5. **Agendar** reunión inicial (Fase 1)

### Documentos a firmar:
- Contrato de desarrollo
- NDA (si es necesario)
- Especificación técnica final

---

## O. CONTACTO Y PRÓXIMAS ACCIONES

**Contacto del equipo:**
- Email de proyecto: proyecto@marketmove.dev
- Responsable de proyecto: [Nombre del PM]
- Reunión inicial propuesta: 3 de diciembre de 2025

**Próximas acciones:**
- [ ] Validar presupuesto
- [ ] Elegir plan (Completo vs MVP)
- [ ] Revisar cronograma
- [ ] Firmar contrato
- [ ] Realizar primer pago
- [ ] Comenzar proyecto

---

**Documento preparado por**: Equipo de Desarrollo  
**Fecha**: 1 de diciembre de 2025  
**Validez**: 30 días  
**Revisión**: Según cambios de requisitos

---

## RESUMEN EJECUTIVO

| Concepto | Valor |
|----------|-------|
| **Horas de desarrollo** | 221 h |
| **Duración estimada** | 6 semanas |
| **Costo total (IVA incl.)** | €13,649.01 |
| **Costo por hora** | €45 |
| **Plataformas** | iOS + Android |
| **Garantía** | 30 días |
| **Mantenimiento incluido** | 30 días |
| **Publicación en stores** | Incluida |

---

**¿Preguntas o aclaraciones? Estamos disponibles para discutir cualquier aspecto de esta propuesta.**
