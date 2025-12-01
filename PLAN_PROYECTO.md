# 📋 PLAN DE PROYECTO - MarketMove App

## Información del Cliente

**Nombre**: MarketMove S.L.  
**Sector**: Gestión de pequeños comercios  
**Tipo de Contrato**: Desarrollo de aplicación móvil  
**Presupuesto**: €13,649 IVA incluido  
**Duración**: 6 semanas (48 días hábiles)  
**Inicio**: 2 de diciembre de 2025  
**Entrega**: 16 de enero de 2026

---

## 🎯 Objetivos del Proyecto

### Objetivos Principales
1. ✅ Desarrollar aplicación móvil funcional para iOS y Android
2. ✅ Implementar sistema de gestión de ventas
3. ✅ Implementar control de gastos operativos
4. ✅ Crear panel de análisis y ganancias
5. ✅ Publicar en app stores oficiales

### Objetivos Secundarios
- Proporcionar documentación profesional
- Capacitar al cliente en uso de la app
- Establecer soporte post-lanzamiento
- Crear base para futuras mejoras

---

## 📊 Fases del Proyecto

### ✅ FASE 1: Análisis y Requisitos (Semana 1)
**Duración**: 16 horas  
**Responsable**: Product Manager + Cliente

#### Deliverables:
- Documento de requisitos funcionales
- Especificación técnica
- Diagrama de casos de uso
- Lista de acceptance criteria

**Hitos**:
- [ ] Reunión inicial con cliente
- [ ] Validación de requisitos
- [ ] Documentación completa
- [ ] Aprobación cliente

---

### 🎨 FASE 2: Diseño UX/UI (Semana 1-2)
**Duración**: 24 horas  
**Responsable**: UX/UI Designer

#### Pantallas a diseñar:
1. **Splash Screen** - Pantalla de inicio
2. **Login** - Autenticación
3. **Register** - Registro de usuario
4. **Dashboard** - Panel principal (KPIs)
5. **Nueva Venta** - Formulario de venta
6. **Historial Ventas** - Listado de transacciones
7. **Nueva Gasto** - Formulario de gasto
8. **Historial Gastos** - Listado de gastos
9. **Productos** - Gestor de inventario
10. **Nuevo Producto** - Formulario de producto
11. **Perfil** - Gestión de cuenta
12. **Configuración** - Preferencias

#### Deliverables:
- Wireframes de baja fidelidad
- Mockups de alta fidelidad (Figma)
- Design System (colores, tipografía, componentes)
- Documentación de navegación
- Aprobación cliente

**Hitos**:
- [ ] Wireframes completados
- [ ] Mockups en Figma
- [ ] Design tokens definidos
- [ ] Validación con cliente

---

### 🏗️ FASE 3: Arquitectura y Base de Datos (Semana 2-3)
**Duración**: 20 horas  
**Responsable**: Backend Developer + Arquitecto

#### Actividades:
- Diseño del modelo de datos (ERD)
- Creación proyecto Supabase
- Creación de tablas y esquema
- Configuración de RLS (Row Level Security)
- Setup de autenticación
- Creación de índices
- Documentación de API

#### Tablas:
```
- users           (Perfiles de usuarios)
- productos       (Inventario)
- ventas          (Transacciones)
- venta_detalles  (Líneas de venta)
- gastos          (Gastos operativos)
- resumen         (Dashboard mensual)
- audit_logs      (Registro de auditoría)
```

#### Deliverables:
- Esquema de base de datos (ERD)
- Script SQL de creación
- Documentación de tablas
- Políticas de seguridad (RLS)

**Hitos**:
- [ ] BD creada en Supabase
- [ ] Tablas y relaciones
- [ ] RLS implementado
- [ ] Autenticación configurada

---

### 💻 FASE 4: Desarrollo Frontend (Semana 3-5)
**Duración**: 80 horas  
**Responsable**: 2 Flutter Developers

#### 4.1 Setup inicial (8h)
```
- Crear proyecto Flutter
- Configurar dependencias
- Setup de estructura de carpetas
- Configurar Provider para state management
- Setup de dotenv para credenciales
```

#### 4.2 Módulo Autenticación (16h)
```
- UI Login/Registro
- Validación de formularios
- Integración Supabase Auth
- Persistencia de sesión
- Manejo de errores
- Recuperación de contraseña
```

#### 4.3 Módulo Ventas (20h)
```
- Pantalla nueva venta
- Selector de productos
- Cálculo de totales/impuestos
- Descuentos
- Historial de ventas
- Búsqueda y filtrado
- Detalles de venta
- Integración BD
```

#### 4.4 Módulo Gastos (16h)
```
- Pantalla nuevo gasto
- Categorías de gastos
- Historial de gastos
- Búsqueda por categoría
- Búsqueda por proveedor
- Detalles de gasto
- Integración BD
```

#### 4.5 Módulo Productos (12h)
```
- Listado de productos
- Agregar producto
- Editar producto
- Eliminar producto
- Control de stock
- Búsqueda y filtrado
```

#### 4.6 Dashboard/Resumen (8h)
```
- Panel principal con KPIs
- Gráficos de ventas
- Gráficos de gastos
- Indicador ganancia neta
- Resumen diario/mensual
```

#### Deliverables:
- Código fuente (Git)
- Cada módulo funcional
- Tests unitarios
- Documentación de código

**Hitos**:
- [ ] Semana 3: Autenticación + Setup
- [ ] Semana 4: Ventas + Gastos + Productos
- [ ] Semana 5: Dashboard + Pulido

---

### 🧪 FASE 5: Testing e Integración (Semana 5-6)
**Duración**: 24 horas  
**Responsable**: QA Engineer + Developers

#### Testing Plan:
- **Unit Tests**: Lógica de negocio
- **Widget Tests**: Componentes UI
- **Integration Tests**: Flujos completos
- **Testing de seguridad**: Validación RLS
- **Testing de performance**: Carga y velocidad
- **Cross-device testing**: Múltiples dispositivos

#### Casos de prueba:
1. Registro e inicio de sesión
2. Crear venta completa
3. Registrar gasto
4. Agregar producto
5. Ver dashboard
6. Sincronización datos
7. Offline mode (si aplica)

#### Deliverables:
- Reporte de defectos
- Reporte de pruebas
- Certificado de calidad

**Hitos**:
- [ ] Suite de tests completada
- [ ] 100+ casos de prueba
- [ ] 0 bugs críticos
- [ ] Validación cliente

---

### 📚 FASE 6: Documentación y Entrega (Semana 6)
**Duración**: 16 horas  
**Responsable**: PM + Developers

#### Documentación:
1. **README.md** - Descripción del proyecto
2. **SETUP.md** - Cómo ejecutar localmente
3. **API.md** - Documentación de endpoints/servicios
4. **ARCHITECTURE.md** - Explicación de arquitectura
5. **CONTRIBUTING.md** - Cómo contribuir
6. **Manual de Usuario** (PDF)
7. **Guía de Instalación** (PDF)
8. **Video Tutorial** (YouTube)

#### Entregables:
- Documentación completa en GitHub
- Manual PDF para usuario final
- Video demostración (10-15 min)
- Código comentado
- Commits bien organizados

**Hitos**:
- [ ] README completado
- [ ] Documentación técnica
- [ ] Manual usuario
- [ ] Video tutorial

---

### 🚀 FASE 7: Publicación en Stores (Semana 6)
**Duración**: 12 horas  
**Responsable**: PM + Developers

#### Google Play Store:
- Crear cuenta desarrollador (si no existe)
- Preparar assets (iconos, screenshots)
- Llenar metadatos (descripción, categoría)
- Subir APK firmado
- Configurar privacidad
- Publicar

#### Apple App Store:
- Crear cuenta desarrollador (si no existe)
- Generar certificados
- Crear provisioning profiles
- Preparar assets
- Llenar metadatos
- Subir build
- Esperar revisión
- Publicar

#### Deliverables:
- App publicada en Play Store
- App publicada en App Store
- Enlaces de descarga
- Instrucciones para usuario final

**Hitos**:
- [ ] Cuentas de desarrollador activas
- [ ] Activos preparados
- [ ] Builds compilados
- [ ] Apps publicadas

---

## 📆 Cronograma Detallado

```
DICIEMBRE 2025
┌─────────────────────────────────────────────────────────┐
│ Semana 1 (2-6 Dic) - ANÁLISIS & DISEÑO                 │
│ ├─ Lun-Mié: Análisis requisitos (16h)                  │
│ └─ Mié-Vie: Diseño UX/UI Parte 1 (12h)                 │
│                                                          │
│ Semana 2 (9-13 Dic) - DISEÑO & ARQUITECTURA             │
│ ├─ Lun-Mar: Diseño UX/UI Parte 2 (12h)                 │
│ └─ Mar-Vie: Arquitectura y BD (20h)                     │
│             Setup Flutter (8h)                          │
│                                                          │
│ Semana 3 (16-20 Dic) - DESARROLLO AUTH & VENTAS         │
│ ├─ Autenticación (16h)                                  │
│ └─ Ventas Parte 1 (24h)                                 │
│                                                          │
│ Semana 4 (23-27 Dic) - DESARROLLO GASTOS & PRODUCTOS   │
│ ├─ Ventas Parte 2 (8h)                                  │
│ ├─ Gastos (16h)                                         │
│ └─ Productos (16h)                                      │
│                                                          │
│ Semana 5 (30 Dic - 3 Ene) - DASHBOARD & TESTING        │
│ ├─ Dashboard (8h)                                       │
│ ├─ Integración (16h)                                    │
│ └─ Testing Parte 1 (16h)                                │
│                                                          │
│ Semana 6 (6-17 Ene) - TESTING, DOCS & PUBLICACIÓN      │
│ ├─ Testing Parte 2 (8h)                                 │
│ ├─ Documentación (16h)                                  │
│ ├─ Publicación Stores (12h)                             │
│ └─ Presentación Cliente (5h)                            │
│                                                          │
│ ENTREGA FINAL: Viernes 16 de Enero de 2026              │
└─────────────────────────────────────────────────────────┘
```

---

## 👥 Equipo de Desarrollo

### Composición:
| Rol | Nombre | Horas | Responsabilidades |
|-----|--------|-------|------------------|
| **Product Manager** | [Nombre] | 40h | Requisitos, cliente, planning |
| **UX/UI Designer** | [Nombre] | 36h | Diseño, prototipos |
| **Flutter Dev 1** | [Nombre] | 60h | Frontend, módulos |
| **Flutter Dev 2** | [Nombre] | 60h | Frontend, módulos |
| **Backend Dev** | [Nombre] | 40h | BD, APIs, RLS |
| **QA Engineer** | [Nombre] | 30h | Testing, calidad |

**Total equipo**: 6 personas  
**Dedicación**: A tiempo completo durante 6 semanas

---

## 📝 Entregables por Fase

### Fase 1
- [x] Documento de requisitos
- [x] Especificación técnica
- [x] Diagrama de casos de uso

### Fase 2
- [x] Mockups en Figma
- [x] Design System
- [x] Aprobación cliente

### Fase 3
- [x] Proyecto Supabase creado
- [x] BD con tablas y RLS
- [x] Documentación de API

### Fase 4
- [x] Módulo autenticación
- [x] Módulo ventas
- [x] Módulo gastos
- [x] Módulo productos
- [x] Dashboard
- [x] Tests unitarios

### Fase 5
- [x] Suite de tests completa
- [x] Reporte de calidad
- [x] 0 bugs críticos

### Fase 6
- [x] README.md
- [x] Documentación técnica
- [x] Manual de usuario (PDF)
- [x] Video tutorial

### Fase 7
- [x] App en Google Play
- [x] App en Apple App Store
- [x] Instrucciones para usuario

---

## 📊 Métricas de Éxito

### Técnicas
- ✅ 100% de requisitos implementados
- ✅ Cobertura de tests > 80%
- ✅ 0 bugs críticos
- ✅ Performance < 2s carga inicial
- ✅ RLS en 100% de tablas

### Funcionales
- ✅ Autenticación segura
- ✅ Flujo completo de venta
- ✅ Control de gastos
- ✅ Dashboard funcional
- ✅ Sincronización de datos

### Usuarios
- ✅ App descargable en stores
- ✅ Manual comprensible
- ✅ Video tutorial disponible
- ✅ Capacitación completada
- ✅ Soporte 30 días

---

## ⚠️ Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|--------|-----------|
| Cambios de requisitos | Alta | Medio | Change log + validaciones |
| Delays en aprobación Apple | Media | Bajo | Aplicar 2 sem antes |
| Problemas compatibilidad | Baja | Alto | Testing exhaustivo |
| Rotación equipo | Muy baja | Alto | Documentación detallada |
| Incremento de scope | Alta | Medio | Adicionales pagables |

---

## 💰 Presupuesto y Pagos

### Desglose:
- Desarrollo: €9,945
- Infraestructura: €1,212
- Stores: €124
- **Total sin IVA**: €11,281
- **IVA (21%)**: €2,368
- **Total con IVA**: €13,649

### Plan de pagos:
- 30% al inicio: €4,094.70
- 40% al finalizar Fase 3: €5,459.60
- 30% a la entrega: €4,094.70

---

## 📞 Comunicación y Escaladas

### Comunicación regular:
- **Daily standup**: 15 min (equipo)
- **Revisión semanal con cliente**: 30 min
- **Escalaciones**: Contactar PM directamente

### Canales:
- Email: proyecto@marketmove.dev
- Slack: #marketmove-proyecto
- Meetings: Teams/Zoom cada viernes

---

## ✅ Aprobación

**Cliente**:
- Nombre: ___________________________
- Firma: _____________________________
- Fecha: ______________________________

**Equipo de Desarrollo**:
- Product Manager: ____________________
- Firma: _____________________________
- Fecha: ______________________________

---

**Documento versión**: 1.0  
**Última actualización**: 1 de diciembre de 2025  
**Siguiente revisión**: Semana 1 de ejecución
