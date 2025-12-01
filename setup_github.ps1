# Script para subir MarketMove a GitHub
# Cuenta: nanafakti@gmail.com

Write-Host "=== Subir MarketMove a GitHub ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tu cuenta Git está configurada como: nanafakti@gmail.com" -ForegroundColor Green
Write-Host ""

# Verificar configuración de Git
Write-Host "Verificando configuración de Git..." -ForegroundColor Yellow
git config user.name
git config user.email
Write-Host ""

Write-Host "PASOS PARA SUBIR A GITHUB:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Ve a: https://github.com/new" -ForegroundColor White
Write-Host ""
Write-Host "2. Configura el repositorio:" -ForegroundColor White
Write-Host "   - Repository name: marketmove_app" -ForegroundColor Yellow
Write-Host "   - Description: Professional Flutter app for business management" -ForegroundColor Yellow
Write-Host "   - Visibility: Public (o Private si prefieres)" -ForegroundColor Yellow
Write-Host "   - NO marques 'Initialize with README'" -ForegroundColor Red
Write-Host "   - NO añadas .gitignore ni license" -ForegroundColor Red
Write-Host ""
Write-Host "3. Haz clic en 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "4. Copia la URL del repositorio que aparecerá" -ForegroundColor White
Write-Host "   (Ejemplo: https://github.com/nanafakti/marketmove_app.git)" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Ejecuta estos comandos (reemplaza <URL> con tu URL):" -ForegroundColor White
Write-Host ""
Write-Host "   git remote add origin <URL>" -ForegroundColor Yellow
Write-Host "   git branch -M main" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Yellow
Write-Host ""
Write-Host "EJEMPLO COMPLETO:" -ForegroundColor Cyan
Write-Host "   git remote add origin https://github.com/TU_USUARIO/marketmove_app.git" -ForegroundColor Gray
Write-Host "   git branch -M main" -ForegroundColor Gray
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "Nota: Si te pide autenticación, usa un Personal Access Token" -ForegroundColor Yellow
Write-Host "Crear token en: https://github.com/settings/tokens" -ForegroundColor Yellow
Write-Host ""

# Preguntar si quiere continuar
$continue = Read-Host "¿Ya creaste el repositorio en GitHub? (s/n)"

if ($continue -eq "s" -or $continue -eq "S") {
    $repoUrl = Read-Host "Pega la URL de tu repositorio"
    
    if ($repoUrl) {
        Write-Host ""
        Write-Host "Configurando repositorio remoto..." -ForegroundColor Cyan
        
        # Verificar si ya existe el remoto
        $remoteExists = git remote get-url origin 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Remoto 'origin' ya existe. Actualizando..." -ForegroundColor Yellow
            git remote set-url origin $repoUrl
        } else {
            git remote add origin $repoUrl
        }
        
        Write-Host "Cambiando a rama 'main'..." -ForegroundColor Cyan
        git branch -M main
        
        Write-Host "Subiendo código a GitHub..." -ForegroundColor Cyan
        git push -u origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ ¡ÉXITO! Tu proyecto está en GitHub" -ForegroundColor Green
            Write-Host "URL: $repoUrl" -ForegroundColor Cyan
        } else {
            Write-Host ""
            Write-Host "❌ Error al subir. Verifica tu autenticación." -ForegroundColor Red
            Write-Host "Puede que necesites un Personal Access Token" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host ""
    Write-Host "Cuando hayas creado el repositorio, ejecuta este script de nuevo." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Fin ===" -ForegroundColor Cyan
