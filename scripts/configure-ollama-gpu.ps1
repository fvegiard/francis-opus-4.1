# Configuration Ollama pour RTX 4060 (8GB VRAM)
Write-Host "🎮 Configuration GPU RTX 4060 pour Ollama" -ForegroundColor Cyan

# Variables d'environnement pour forcer l'utilisation GPU
[Environment]::SetEnvironmentVariable("CUDA_VISIBLE_DEVICES", "0", "User")
[Environment]::SetEnvironmentVariable("OLLAMA_NUM_GPU", "999", "User")
[Environment]::SetEnvironmentVariable("OLLAMA_GPU_OVERHEAD", "0", "User")

Write-Host "✅ Variables GPU configurées" -ForegroundColor Green

# Redémarrer Ollama avec GPU
Write-Host "🔄 Redémarrage d'Ollama avec support GPU..." -ForegroundColor Yellow
Stop-Process -Name "ollama" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

$ollamaPath = "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe"
Start-Process -FilePath $ollamaPath -ArgumentList "serve" -WindowStyle Hidden

Start-Sleep -Seconds 5
Write-Host "✅ Ollama redémarré avec GPU activé" -ForegroundColor Green

# Test GPU
Write-Host "`n🔥 Test utilisation GPU..." -ForegroundColor Cyan
& $ollamaPath run deepseek-coder-v2 "print('test')" --verbose 2>&1 | Select-String "gpu|cuda"

Write-Host "`n📋 Modèles disponibles:" -ForegroundColor Green
& $ollamaPath list

Write-Host "`n✅ Configuration terminée!" -ForegroundColor Green
Write-Host "Les modèles utilisent maintenant votre RTX 4060" -ForegroundColor Cyan