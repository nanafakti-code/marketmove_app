# Prompt para Personalizar MarketMove App

Usa este prompt con un modelo de IA (ChatGPT, Claude, etc.) para crear una versión personalizada de la app MarketMove con tu propia identidad visual.

---

## INSTRUCCIÓN PRINCIPAL

```
Tengo una aplicación Flutter de gestión de ventas y gastos llamada MarketMove. 
Necesito que MANTENGAS COMPLETAMENTE la lógica, estructura y funcionalidad,
pero que CAMBIES la estética visual (colores, botones, fuentes, iconos, gradientes).

CAMBIOS A REALIZAR:

1. **PALETA DE COLORES** - Reemplaza estos colores por nuevos:
   - primaryGradient: [#6366f1, #3b82f6] → [TU_COLOR_1, TU_COLOR_2]
   - primaryCyan: #06b6d4 → TU_COLOR_CYAN
   - primaryPurple: #6366f1 → TU_COLOR_PURPURA
   - primaryBlue: #3b82f6 → TU_COLOR_AZUL
   - success: #10b981 → TU_COLOR_EXITO
   - error: #ef4444 → TU_COLOR_ERROR
   - warning: #f59e0b → TU_COLOR_ADVERTENCIA
   - offWhite: #f5f5f5 → TU_COLOR_FONDO
   - almostBlack: #1a1a1a → TU_COLOR_TEXTO

2. **BOTONES** - Cambia el estilo:
   - Añade bordes redondeados diferentes (más cuadrados o más circulares)
   - Cambia elevación (shadow)
   - Modifica padding y tamaño de fuente
   - Añade efectos hover o animaciones

3. **GRADIENTES** - Reemplaza los gradientes lineales:
   - De: LinearGradient vertical simple
   - A: Radial gradients, diagonal gradients, o multi-color gradients

4. **ICONOS** - Puedes cambiar:
   - El pack de iconos (mantén Icons pero personaliza colores y tamaños)
   - O reemplaza con otros packs como `lucide_icons` o `remixicon`

5. **FUENTES** - Modifica la tipografía:
   - Cambia las fuentes usadas en TextStyle
   - Ajusta tamaños y pesos

6. **COMPONENTES** - Personaliza:
   - Tarjetas (Card): añade bordes, sombras diferentes
   - Drawers: cambia el header design
   - AppBars: modifica altura, elevación
   - TextFormFields: cambia bordes, focus colors

NO CAMBIES:
✅ Lógica de negocios
✅ Estructura de carpetas
✅ Nombres de variables y funciones
✅ Stream management
✅ Autenticación
✅ Base de datos
✅ Email service
✅ Cálculos y validaciones

MANTÉN:
✅ Todos los features (Ventas, Gastos, Productos, Perfil, Resumen)
✅ Navegación y rutas
✅ Formularios y validaciones
✅ Real-time updates con Supabase
✅ Email notifications
✅ Stock management

PASOS A SEGUIR:
1. Crea un archivo nuevo: lib/src/shared/theme/app_colors_custom.dart
2. Define tu nueva paleta de colores
3. Encuentra y reemplaza referencias a AppColors en:
   - lib/src/features/**/pages/*.dart
   - lib/src/features/**/dialogs/*.dart
   - lib/src/shared/widgets/*.dart
4. Ajusta estilos de botones, tarjetas y componentes
5. Personaliza gradientes en Container decorations
6. Modifica TextStyle y font sizes según tu preferencia
7. Prueba que toda la funcionalidad siga igual

ESTRUCTURA TÍPICA A BUSCAR:

// Colores
color: AppColors.primaryPurple → Cambiar a tu color
gradient: AppColors.primaryGradient → Cambiar a tu gradiente

// Botones
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
  ),
)
→ Personaliza backgroundColor, elevation, shape, padding

// Tarjetas
Card(
  color: AppColors.offWhite,
)
→ Cambia color, elevation, shape

// Gradientes en Container
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primaryPurple.withOpacity(0.1), AppColors.offWhite],
    ),
  ),
)
→ Reemplaza con tus colores y tipo de gradiente

EJEMPLO DE NUEVA PALETA:
```
class AppColorsCustom {
  // Gradiente principal: Rosa a Naranja
  static const List<Color> primaryGradient = [Color(0xFFFF6B6B), Color(0xFFFF8E53)];
  
  // Colores individuales
  static const Color primaryCyan = Color(0xFF4ECDC4);
  static const Color primaryPurple = Color(0xFF95E1D3);
  static const Color primaryBlue = Color(0xFF38ADA9);
  
  // Colores semánticos
  static const Color success = Color(0xFF52B788);
  static const Color error = Color(0xFFD62828);
  static const Color warning = Color(0xFFF77F00);
  static const Color offWhite = Color(0xFFFEFEFE);
  static const Color almostBlack = Color(0xFF2B2D42);
}
```

TIPS DE DISEÑO:
- Elige una paleta armónica (usa herramientas como coolors.co o paletton.com)
- Mantén alto contraste entre texto y fondo para accesibilidad
- Los colores cálidos (rojos, naranjas) dan energía
- Los colores fríos (azules, verdes) dan calma
- Los gradientes suaves lucen más profesionales que abruptos
- Prueba diferentes radios de borde (8, 12, 16, 20)

VALIDACIÓN FINAL:
□ La app compila sin errores
□ Todos los botones funcionan
□ Las transiciones entre pantallas son suaves
□ Los formularios validan correctamente
□ Los datos se guardan en Supabase
□ Los emails se envían correctamente
□ El diseño es consistente en todas las páginas
```

---

## VARIANTES DE PROMPTS ESPECÍFICOS

### Si quieres un estilo MODERNO MINIMALISTA:
```
Personaliza MarketMove con:
- Colores neutros (grises, blancos, negros)
- Un solo color de acento (ej: azul profundo)
- Botones sin sombra, bordes redondeados sutiles (4-8px)
- Tipografía sans-serif moderna (Inter, Roboto)
- Espaciado generoso
- Iconos delgados y elegantes
```

### Si quieres un estilo COLORIDO Y VIBRANTE:
```
Personaliza MarketMove con:
- Paleta de colores vibrantes (5-6 colores)
- Gradientes diagonales y radiales
- Botones con sombra y bordes redondeados grandes (12-16px)
- Tipografía bold y destacada
- Animaciones suaves en interacciones
- Iconos gruesos y llamativos
```

### Si quieres un estilo OSCURO (Dark Mode):
```
Personaliza MarketMove con:
- Fondo oscuro (#1a1a1a, #121212)
- Colores de acento brillantes (neon, pasteles)
- Gradientes oscuros y sutiles
- Texto blanco/gris claro
- Tarjetas con borde o muy ligera elevación
- Botones con colores vibrantes sobre fondo oscuro
```

### Si quieres un estilo CORPORATIVO:
```
Personaliza MarketMove con:
- Azules profesionales, grises, blancos
- Un máximo de 2-3 colores de acento
- Botones sólidos sin gradiente
- Fuentes profesionales (Roboto, Lato)
- Líneas y bordes definidos
- Iconos corporativos
- Máximo respeto a la alineación y grid
```

---

## ARCHIVOS PRINCIPALES A MODIFICAR

```
lib/
├── src/
│   ├── shared/
│   │   ├── theme/
│   │   │   ├── app_colors.dart ← MODIFICAR AQUÍ (colores principales)
│   │   │   └── app_theme.dart ← MODIFICAR AQUÍ (estilos globales)
│   │   └── widgets/
│   │       └── *.dart ← Buscar AppColors.* y personalizar
│   ├── features/
│   │   ├── auth/pages/*.dart ← Botones, inputs
│   │   ├── ventas/pages/*.dart ← Cards, gradientes
│   │   ├── gastos/pages/*.dart ← Cards, gradientes
│   │   ├── productos/pages/*.dart ← Cards, gradientes
│   │   ├── perfil/pages/*.dart ← Formularios
│   │   └── resumen/pages/*.dart ← Tarjetas de datos
```

---

## COMANDO PARA BUSCAR REFERENCIAS

En VS Code, usa:
```
Ctrl + Shift + H (Find and Replace)
Buscar: AppColors\.
Reemplazar: AppColorsCustom.
(Revisa cada coincidencia antes de reemplazar)
```

---

## VALIDACIÓN DE LA PERSONALIZACIÓN

Checklist final:
- [ ] Colores nuevos aplicados en todas las páginas
- [ ] Botones tienen nuevo estilo
- [ ] Gradientes personalizados
- [ ] Fuentes y tamaños ajustados
- [ ] App compila sin errores
- [ ] Login/Register funciona
- [ ] CRUD de productos funciona
- [ ] CRUD de ventas funciona
- [ ] CRUD de gastos funciona
- [ ] Resumen actualiza en tiempo real
- [ ] Perfil se puede editar
- [ ] Emails se envían correctamente
- [ ] Drawer navega correctamente
- [ ] No hay errores en console

---

¡Comparte tu nueva paleta de colores y te ayudo a personalizarla! 🎨
