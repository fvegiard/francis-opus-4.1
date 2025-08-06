# Installation Claude Code Windows Native
Write-Host "🚀 Installation Claude Code sur Windows (natif)" -ForegroundColor Cyan

# 1. Vérifier Node.js
Write-Host "`n📦 Vérification Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js trouvé: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js non installé\!" -ForegroundColor Red
    Write-Host "Téléchargez depuis: https://nodejs.org/en/download/" -ForegroundColor Yellow
    exit 1
}

# 2. Vérifier NPM
Write-Host "📦 Vérification NPM..." -ForegroundColor Yellow
$npmVersion = npm --version
Write-Host "✅ NPM trouvé: $npmVersion" -ForegroundColor Green

# 3. Installer Claude Code
Write-Host "`n🔧 Installation Claude Code..." -ForegroundColor Cyan
npm install -g @anthropic-ai/claude

# 4. Vérifier installation
Write-Host "`n✅ Vérification installation..." -ForegroundColor Green
claude --version

# 5. Configuration API Key
Write-Host "`n🔑 Configuration API Key..." -ForegroundColor Yellow
Write-Host "Entrez votre API key Anthropic:" -ForegroundColor Cyan
$apiKey = Read-Host -AsSecureString
$apiKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKey))

# Sauvegarder dans variable d'environnement
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKeyPlain, "User")

Write-Host "`n✅ Installation terminée\!" -ForegroundColor Green
Write-Host "Lancez 'claude' dans PowerShell ou CMD pour utiliser" -ForegroundColor Cyan
Write-Host "`n💡 Commandes utiles:" -ForegroundColor Gray
Write-Host "  claude chat     - Nouvelle conversation" -ForegroundColor White
Write-Host "  claude doctor   - Diagnostic" -ForegroundColor White
Write-Host "  claude --help   - Aide" -ForegroundColor White
