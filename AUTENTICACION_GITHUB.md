# 🔐 Autenticación Requerida para GitHub

## ⚠️ Situación Actual

El repositorio está configurado correctamente:
- ✅ Remoto: https://github.com/nanafakti-code/marketmove_app.git
- ✅ Rama: main
- ✅ Commit listo para subir

**Pero necesitas autenticarte con GitHub para poder hacer push.**

## 🚀 Solución: Usar Personal Access Token

### Paso 1: Crear un Personal Access Token

1. Ve a: **https://github.com/settings/tokens**
2. Click en **"Generate new token"** → **"Generate new token (classic)"**
3. Configuración:
   - **Note**: `MarketMove App`
   - **Expiration**: 90 days (o el que prefieras)
   - **Select scopes**: Marca **`repo`** (todos los permisos de repositorio)
4. Scroll abajo y click en **"Generate token"**
5. **¡IMPORTANTE!** Copia el token inmediatamente (solo se muestra una vez)
   - Ejemplo: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Paso 2: Hacer Push con el Token

Ejecuta este comando:

```bash
git push -u origin main
```

Cuando te pida credenciales:
- **Username**: `nanafakti-code`
- **Password**: Pega tu **Personal Access Token** (NO tu contraseña de GitHub)

### Paso 3: Guardar Credenciales (Opcional)

Para no tener que ingresar el token cada vez:

```bash
git config credential.helper store
```

Luego haz el push una vez más y las credenciales se guardarán.

## 🔄 Alternativa: Usar SSH

Si prefieres usar SSH en lugar de HTTPS:

1. Genera una clave SSH:
   ```bash
   ssh-keygen -t ed25519 -C "nanafakti@gmail.com"
   ```

2. Añade la clave a GitHub:
   - Copia el contenido de `~/.ssh/id_ed25519.pub`
   - Ve a: https://github.com/settings/keys
   - Click "New SSH key" y pega la clave

3. Cambia la URL del remoto:
   ```bash
   git remote set-url origin git@github.com:nanafakti-code/marketmove_app.git
   git push -u origin main
   ```

## ✅ Verificación

Una vez que hagas push exitosamente, verifica tu repositorio en:
**https://github.com/nanafakti-code/marketmove_app**

---

**Siguiente paso**: Crea tu Personal Access Token y ejecuta `git push -u origin main`
