# Configuration complète Open Web UI + Ollama Windows
Write-Host "🔧 Configuration Open Web UI avec Ollama Windows" -ForegroundColor Cyan

# 1. S'assurer qu'Ollama tourne
$ollamaPath = "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe"
$ollamaRunning = Get-Process "ollama" -ErrorAction SilentlyContinue

if (!$ollamaRunning) {
    Write-Host "🚀 Démarrage d'Ollama..." -ForegroundColor Yellow
    Start-Process -FilePath $ollamaPath -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 5
}

# 2. Vérifier les modèles
Write-Host "`n📦 Modèles disponibles dans Ollama:" -ForegroundColor Green
& $ollamaPath list

# 3. Tester l'API
Write-Host "`n🔍 Test API Ollama..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method GET
    Write-Host "✅ API Ollama répond - $($response.models.Count) modèles trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur API Ollama" -ForegroundColor Red
}

# 4. Instructions pour Open Web UI
Write-Host "`n📋 CONFIGURATION DANS OPEN WEB UI:" -ForegroundColor Cyan
Write-Host "1. Ouvrez http://localhost:3000" -ForegroundColor White
Write-Host "2. Allez dans Settings (icône engrenage)" -ForegroundColor White
Write-Host "3. Section 'Connections'" -ForegroundColor White
Write-Host "4. Ollama Base URL: http://host.docker.internal:11434" -ForegroundColor Yellow
Write-Host "5. Cliquez 'Save'" -ForegroundColor White
Write-Host "6. Les modèles apparaîtront dans le menu déroulant" -ForegroundColor White

Write-Host "`n💡 Si ça ne marche pas, essayez ces URLs:" -ForegroundColor Gray
Write-Host "   - http://172.28.224.1:11434 (IP Windows WSL)" -ForegroundColor Gray
Write-Host "   - http://host.docker.internal:11434" -ForegroundColor Gray

# 5. Ouvrir Open Web UI
Write-Host "`n🌐 Ouverture d'Open Web UI..." -ForegroundColor Cyan
Start-Process "http://localhost:3000"