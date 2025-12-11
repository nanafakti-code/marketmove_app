# Configuración de GitHub para MarketMove App

Este documento contiene instrucciones para subir el proyecto a GitHub.

## Estado Actual

✅ Git inicializado
✅ Primer commit realizado
✅ Proyecto listo para subir a GitHub

## Opción 1: Usando el Script Automático (Recomendado)

Ejecuta el script de PowerShell incluido:

```powershell
.\setup_github.ps1
```

Este script:
- Detectará si tienes GitHub CLI instalado
- Creará el repositorio automáticamente
- Configurará el remoto
- Subirá el código

## Opción 2: Instalación Manual de GitHub CLI

1. Descarga e instala GitHub CLI desde: https://cli.github.com/

2. Autentícate:
```bash
gh auth login
```

3. Crea el repositorio:
```bash
gh repo create marketmove_app --public --source=. --remote=origin
```

4. Sube el código:
```bash
git branch -M main
git push -u origin main
```

## Opción 3: Configuración Manual (Sin GitHub CLI)

1. Ve a https://github.com/new

2. Crea un nuevo repositorio:
   - Nombre: `marketmove_app`
   - Descripción: "Professional Flutter app for business management"
   - Visibilidad: Público o Privado (según prefieras)
   - **NO** inicialices con README, .gitignore, o licencia

3. Copia la URL del repositorio

4. En tu terminal, ejecuta:
```bash
git remote add origin <URL_DE_TU_REPOSITORIO>
git branch -M main
git push -u origin main
```

## Verificación

Una vez completado, verifica que tu código esté en GitHub visitando:
```
https://github.com/TU_USUARIO/marketmove_app
```

## Próximos Pasos

Después de subir a GitHub:

1. Configura GitHub Pages (opcional)
2. Añade colaboradores al proyecto
3. Configura GitHub Actions para CI/CD (opcional)
4. Añade badges al README (opcional)

## Problemas Comunes

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin <URL_DE_TU_REPOSITORIO>
```

### Error: "failed to push some refs"
```bash
git pull origin main --rebase
git push -u origin main
```

### Error de autenticación
- Asegúrate de tener configurado un token de acceso personal
- O usa GitHub CLI: `gh auth login`
