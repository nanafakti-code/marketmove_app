# Guía Rápida para Subir a GitHub

## ✅ Configuración Actual

- **Email**: nanafakti@gmail.com
- **Nombre**: Rafael
- **Commit**: Actualizado con tu cuenta

## 🚀 Opción 1: Subida Automática con Script

Ejecuta el script interactivo:

```powershell
.\setup_github.ps1
```

El script te guiará paso a paso.

## 📝 Opción 2: Subida Manual

### Paso 1: Crear Repositorio en GitHub

1. Ve a: **https://github.com/new**
2. Configura:
   - **Repository name**: `marketmove_app`
   - **Description**: `Professional Flutter app for business management`
   - **Visibility**: Public o Private
   - ⚠️ **NO marques** "Initialize with README"
   - ⚠️ **NO añadas** .gitignore ni license
3. Haz clic en **"Create repository"**

### Paso 2: Conectar y Subir

Copia la URL que aparece (ejemplo: `https://github.com/TU_USUARIO/marketmove_app.git`)

Luego ejecuta estos comandos:

```bash
git remote add origin https://github.com/TU_USUARIO/marketmove_app.git
git branch -M main
git push -u origin main
```

### Paso 3: Autenticación

Si te pide usuario y contraseña:
- **Usuario**: Tu nombre de usuario de GitHub
- **Contraseña**: Usa un **Personal Access Token** (NO tu contraseña de GitHub)

#### Crear Personal Access Token:

1. Ve a: https://github.com/settings/tokens
2. Click en "Generate new token" → "Generate new token (classic)"
3. Nombre: `MarketMove App`
4. Selecciona: `repo` (todos los permisos de repositorio)
5. Click en "Generate token"
6. **Copia el token** (solo se muestra una vez)
7. Usa este token como contraseña al hacer `git push`

## 🔧 Solución de Problemas

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin <TU_URL>
```

### Error: "failed to push"
```bash
git pull origin main --rebase
git push -u origin main
```

### Verificar configuración
```bash
git config user.name
git config user.email
git remote -v
```

## ✅ Verificación Final

Una vez subido, verifica en:
```
https://github.com/TU_USUARIO/marketmove_app
```

---

**Tu cuenta está configurada como**: nanafakti@gmail.com ✅
