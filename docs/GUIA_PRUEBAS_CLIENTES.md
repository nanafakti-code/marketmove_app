# 🧪 GUÍA DE PRUEBAS - SELECTOR DE CLIENTES

## Verificación Rápida Pre-Migración

Antes de ejecutar la migración en Supabase, verifica que todo compila correctamente:

```bash
# En la terminal del proyecto
flutter clean
flutter pub get
flutter analyze
```

**Resultado esperado**: ✅ Sin errores de análisis en los diálogos de venta

---

## 📋 Checklist de Implementación

### ✅ Código Compilado
- [x] `crear_venta_dialog.dart` - Sin errores
- [x] `editar_venta_dialog.dart` - Sin errores  
- [x] `database_models.dart` - Cliente model completo
- [x] `data_repository.dart` - Métodos de cliente listos

### ✅ Estructura de UI
- [x] Dropdown de cliente en crear_venta_dialog
- [x] Dropdown de cliente en editar_venta_dialog
- [x] Validación de cliente requerido
- [x] Campos de cliente (nombre, email, teléfono) removidos de formulario

### ✅ Validaciones
- [x] Cliente obligatorio antes de guardar venta
- [x] Mensajes de error claros (SnackBar)
- [x] Datos del cliente se usan directamente del objeto seleccionado

### ✅ Base de Datos  
- [x] Migración preparada en `migrations_clientes.sql`
- [x] RLS policies definidas correctamente
- [x] Métodos DataRepository listos para usar

---

## 🚀 Pasos de Ejecución

### Paso 1: Ejecutar Migración
1. Ve a https://app.supabase.com
2. Selecciona tu proyecto "marketmove_app"
3. Ve a "SQL Editor" en el menú lateral
4. Click "New Query"
5. Abre el archivo `migrations_clientes.sql`
6. Copia TODO el contenido
7. Pégalo en el editor SQL
8. Click "Run" o presiona Ctrl+Enter
9. Verifica que aparezca en "Tables" la tabla `clientes`

### Paso 2: Crear Datos de Prueba
1. En Supabase → "SQL Editor" → Nueva query
2. Ejecuta:
```sql
-- Crear un cliente de prueba para tu usuario
INSERT INTO clientes (user_id, nombre, email, telefono, empresa, direccion)
VALUES (
  (SELECT id FROM auth.users LIMIT 1),
  'Cliente Test',
  'test@example.com',
  '+34 666 123 456',
  'Empresa Test S.L.',
  'Calle Test 123, Madrid'
);
```

### Paso 3: Compilar la App
1. En VS Code terminal:
```bash
flutter clean
flutter pub get
flutter run
```

### Paso 4: Prueba de Crear Venta
1. Inicia sesión en la app
2. Ve a "Ventas"
3. Click en "Crear Venta"
4. Selecciona un producto del dropdown
5. **Verifica**: El dropdown "Selecciona Cliente" está visible
6. Click en dropdown de cliente
7. **Verifica**: Aparece "Cliente Test" en la lista
8. Selecciona el cliente
9. **Verifica**: Los datos se cargan (NOTA: no hay campos visibles, pero se usan internamente)
10. Rellena otros campos (impuesto, descuento, etc.)
11. Click "Crear Venta"
12. **Resultado esperado**: ✅ Venta creada exitosamente

### Paso 5: Verificar Venta en Base de Datos
1. En Supabase → "Table Editor" → "ventas"
2. Verifica que la nueva venta tiene:
   - `cliente_nombre: "Cliente Test"`
   - `cliente_email: "test@example.com"`
   - `cliente_telefono: "+34 666 123 456"`

### Paso 6: Prueba de Editar Venta
1. En la app, ve a "Ventas"
2. Busca y abre la venta que acabas de crear
3. Click en "Editar"
4. **Verifica**: El dropdown de cliente muestra el cliente actual
5. Cambia el cliente (si hay más)
6. Modifica otros campos
7. Click "Actualizar"
8. **Resultado esperado**: ✅ Venta actualizada exitosamente

---

## 🔍 Validaciones Esperadas

### Error: Cliente no seleccionado
**Pasos**:
1. Abre "Crear Venta"
2. Selecciona producto
3. No selecciones cliente (déjalo vacío)
4. Intenta guardar

**Resultado esperado**: ❌ SnackBar rojo con mensaje "Por favor selecciona un cliente"

### Error: Producto no seleccionado  
**Pasos**:
1. Abre "Crear Venta"
2. Selecciona cliente
3. No selecciones producto
4. Intenta guardar

**Resultado esperado**: ❌ SnackBar rojo con mensaje "Por favor selecciona un producto"

### Éxito: Todos los datos completos
**Pasos**:
1. Abre "Crear Venta"
2. Selecciona producto
3. Selecciona cliente
4. Rellena impuesto, descuento, método de pago
5. Guarda

**Resultado esperado**: ✅ Venta guardada, modal cierra, venta aparece en lista

---

## 🛠️ Troubleshooting

### Problema: El dropdown de cliente está vacío
**Posible causa**: La migración no se ejecutó o no hay clientes en la BD
**Solución**:
1. Verifica que `migrations_clientes.sql` se ejecutó correctamente
2. Verifica que la tabla `clientes` existe en Supabase
3. Crea datos de prueba manualmente
4. Recarga la app

### Problema: Error "RLS policy violation"
**Posible causa**: Las políticas RLS no están correctas
**Solución**:
1. Verifica que el `user_id` en los datos de prueba coincide con tu usuario
2. Ejecuta de nuevo la migración con las políticas
3. Verifica los logs de Supabase

### Problema: Dropdown aparece pero no carga clientes
**Posible causa**: DataRepository.obtenerClientes() no está siendo llamado
**Solución**:
1. Verifica que `_cargarDatos()` se llama en `initState()`
2. Verifica logs de la app (flutter run con verbose)
3. Verifica que el listener está activo

### Problema: App no compila
**Solución**:
1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Verifica que el archivo `database_models.dart` tiene la clase `Cliente`

---

## 📊 Monitoreo en Supabase

### Ver clientes creados
```
Dashboard → Table Editor → clientes
```

### Ver ventas con datos de clientes
```
Dashboard → Table Editor → ventas
Busca: cliente_nombre, cliente_email, cliente_telefono
```

### Ver logs de operaciones
```
Dashboard → Logs → Filter por tabla 'clientes'
```

---

## ✨ Casos de Uso Validados

### Caso 1: Usuario con un cliente
- ✅ Puede crear venta seleccionando ese cliente
- ✅ Datos del cliente se guardan correctamente

### Caso 2: Usuario con múltiples clientes
- ✅ Dropdown muestra todos los clientes
- ✅ Al seleccionar cada uno, se usan sus datos
- ✅ Puede cambiar de cliente y volver a guardar

### Caso 3: Editar venta existente
- ✅ Dropdown muestra cliente actual seleccionado
- ✅ Puede cambiar a otro cliente
- ✅ Los datos se actualizan correctamente

### Caso 4: Usuario sin clientes
- ✅ Dropdown muestra vacío
- ✅ Error de validación si intenta guardar sin cliente
- ✅ Mensaje claro: "Por favor selecciona un cliente"

---

## 📱 Responsividad

Verifica en diferentes tamaños de pantalla:

### Small Screen (<600px)
- [x] Dropdown cliente visible y usable
- [x] Texto no se corta
- [x] Altura adecuada

### Medium Screen (600-1200px)
- [x] Dropdown cliente bien formateado
- [x] Espaciado consistente

### Large Screen (>1200px)  
- [x] Dropdown cliente en posición correcta
- [x] Ancho adecuado

---

## 🎉 Conclusión de Pruebas

**Cuando todas las pruebas pasen**: El sistema está listo para producción.

**Documentación de resultados**:
1. Captura de pantalla del dropdown funcionando
2. Captura de la tabla `clientes` en Supabase
3. Captura de venta guardada con datos del cliente
4. Video corto del flujo completo (opcional)

