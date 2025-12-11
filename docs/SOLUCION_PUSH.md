# ⚠️ Problema de Autenticación - Solución

## 🔍 Diagnóstico

El error 403 puede deberse a:
1. ❌ El repositorio no existe en GitHub
2. ❌ El token no tiene los permisos correctos
3. ❌ El token está mal copiado

## ✅ Solución Paso a Paso

### Opción 1: Verificar que el Repositorio Existe

1. **Abre tu navegador** y ve a:
   ```
   https://github.com/nanafakti-code/marketmove_app
   ```

2. **Si ves "404 - Not Found"**:
   - El repositorio NO existe todavía
   - Necesitas crearlo primero en: https://github.com/new
   - Nombre: `marketmove_app`
   - **NO marques** "Initialize with README"

3. **Si el repositorio existe**:
   - Continúa con la Opción 2

### Opción 2: Crear Nuevo Token con Permisos Correctos

Tu token actual puede no tener los permisos necesarios. Crea uno nuevo:

1. Ve a: **https://github.com/settings/tokens**
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Configuración:
   - **Note**: `MarketMove App - Full Access`
   - **Expiration**: 90 days
   - **Scopes** - Marca TODOS estos:
     - ✅ **repo** (todos los sub-items)
     - ✅ **workflow**
     - ✅ **write:packages**
     - ✅ **delete:packages**
4. Click **"Generate token"**
5. **Copia el token completo**

### Opción 3: Push con el Nuevo Token

Una vez que tengas el nuevo token, ejecuta:

```powershell
# Primero, limpia la URL del remoto
git remote set-url origin https://github.com/nanafakti-code/marketmove_app.git

# Luego haz push (te pedirá credenciales)
git push -u origin main
```

Cuando pida credenciales:
- **Username**: `nanafakti-code`
- **Password**: Pega tu **NUEVO token**

### Opción 4: Push con Token en la URL (Método Rápido)

```bash
git remote set-url origin https://nanafakti-code:TU_NUEVO_TOKEN@github.com/nanafakti-code/marketmove_app.git
git push -u origin main
```

Reemplaza `TU_NUEVO_TOKEN` con el token que acabas de crear.

## 🔧 Comandos Útiles

### Ver configuración actual:
```bash
git remote -v
git config user.name
git config user.email
```

### Limpiar credenciales guardadas:
```bash
cmdkey /delete:LegacyGeneric:target=git:https://github.com
```

### Restaurar URL limpia:
```bash
git remote set-url origin https://github.com/nanafakti-code/marketmove_app.git
```

## 📋 Checklist de Verificación

- [ ] El repositorio existe en GitHub (https://github.com/nanafakti-code/marketmove_app)
- [ ] El token tiene permisos de `repo` completos
- [ ] El token está copiado correctamente (sin espacios extra)
- [ ] Tu usuario es `nanafakti-code` (no `raafaablancoo`)

## 🆘 Si Nada Funciona

Prueba crear el repositorio usando GitHub CLI:

```bash
# Instala GitHub CLI desde: https://cli.github.com/
gh auth login
gh repo create marketmove_app --public --source=. --remote=origin --push
```

---

**Siguiente paso**: Verifica que el repositorio existe en GitHub o créalo si no existe.
