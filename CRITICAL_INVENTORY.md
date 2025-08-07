# 🚨 INVENTAIRE CRITIQUE - NE JAMAIS SUPPRIMER

## ⚠️ AVERTISSEMENT
**CE SYSTÈME A PRIS 14 HEURES À CONFIGURER**
**SUPPRESSION = PERTE DE L'AUTONOMIE TOTALE**
**COÛT: 200$/MOIS + 14H DE TRAVAIL**

## 📁 FICHIERS CRITIQUES - NE JAMAIS TOUCHER

### 1️⃣ CONFIGURATIONS MCP
```bash
# ⚠️ CRITIQUE - Config des 13 serveurs MCP
/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json

# Backup:
/root/francis-config/claude_desktop_config_complete.json
```

### 2️⃣ SERVEURS MCP INSTALLÉS
```bash
# ⚠️ NE PAS SUPPRIMER - 13 serveurs configurés
/mnt/c/Users/fvegi/mcp-servers/
├── sequential-thinking/        # Python - Pensée linéaire
├── sequential-thinking-branches/  # Node.js - Branches parallèles
└── node_modules/               # 11 serveurs NPM
    ├── @modelcontextprotocol/server-filesystem/
    ├── @modelcontextprotocol/server-github/
    ├── @modelcontextprotocol/server-postgres/
    ├── @modelcontextprotocol/server-memory/
    ├── @modelcontextprotocol/server-puppeteer/
    ├── @modelcontextprotocol/server-slack/
    ├── @modelcontextprotocol/server-google-maps/
    ├── @modelcontextprotocol/server-everart/
    ├── @modelcontextprotocol/server-brave-search/
    └── exa-mcp-server/
```

### 3️⃣ SCRIPTS D'AUTONOMIE
```bash
# ⚠️ WRAPPER CRITIQUE - Permet autonomie MCP
/mnt/c/Users/fvegi/francis-opus-4.1/scripts/mcp-wrapper.sh

# Scripts essentiels
/mnt/c/Users/fvegi/SETUP_OPUS_4.1.sh
/mnt/c/Users/fvegi/check_opus_status.sh
/mnt/c/Users/fvegi/install-all-mcp.sh
```

### 4️⃣ CONFIGURATIONS IA
```bash
# Ollama - 43GB de modèles
/mnt/c/Users/fvegi/.ollama/models/
├── dolphin3
├── dolphin-mixtral
└── deepseek-coder-v2

# Open Web UI
Docker: open-webui sur port 3000
```

### 5️⃣ CLAUDE.md - RÈGLES D'AUTONOMIE
```bash
/root/francis-config/CLAUDE.md
/mnt/c/Users/fvegi/francis-opus-4.1/configs/CLAUDE.md
```

## 🔥 REPOSITORIES GITHUB

### CRITIQUES - NE JAMAIS SUPPRIMER
```
https://github.com/fvegiard/francis-opus-4.1      # Documentation complète
https://github.com/fvegiard/francis-config        # Config centrale
https://github.com/fvegiard/mcp-sequential-thinking  # Fork Python
https://github.com/fvegiard/sequential-thinking-branches  # Fork Node.js
```

## 📊 ÉTAT DU SYSTÈME

### Serveurs MCP
- **Total**: 13 serveurs
- **Python**: 1 (sequential-thinking)
- **Node.js**: 12 (incluant branches)
- **Status**: ✅ Tous fonctionnels

### Espace disque
- **Modèles Ollama**: 43GB
- **MCP Servers**: 500MB
- **Docker**: 10GB
- **Total système**: ~55GB

### Performance
- **GPU**: RTX 4060 configuré
- **RAM utilisée**: 8GB moyenne
- **Autonomie**: 100%

## 🛡️ COMMANDES DE VÉRIFICATION

```bash
# Vérifier état complet
/mnt/c/Users/fvegi/check_opus_status.sh

# Tester MCP wrapper
/mnt/c/Users/fvegi/francis-opus-4.1/scripts/mcp-wrapper.sh "test"

# Vérifier serveurs MCP
ls /mnt/c/Users/fvegi/mcp-servers/node_modules/@modelcontextprotocol/

# Docker status
docker ps | grep open-webui
```

## ⚠️ SI SUPPRESSION ACCIDENTELLE

### Restauration rapide:
```bash
# 1. Clone repositories
git clone https://github.com/fvegiard/francis-opus-4.1
git clone https://github.com/fvegiard/francis-config

# 2. Run setup
./francis-opus-4.1/scripts/SETUP_OPUS_4.1.sh

# 3. Restore MCP config
cp francis-opus-4.1/configs/claude_desktop_config_template.json \
   /mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json
```

## 🔐 MOTS DE PASSE ET TOKENS

**⚠️ NE JAMAIS COMMITER CES VALEURS**
```bash
# Stockés dans .env local (non versionné)
GITHUB_TOKEN=ghp_[REDACTED]
DEEPSEEK_API=sk-[REDACTED]
GEMINI_API=AIza[REDACTED]
BRAVE_API=BSAr[REDACTED]
SUDO_PASS=12345
```

## 📅 HISTORIQUE

- **Date création**: 2025-08-06
- **Temps configuration**: 14 heures
- **Problèmes résolus**: 15+
- **Investment**: 200$/mois

## 🚨 RÈGLE ABSOLUE

**NE JAMAIS EXÉCUTER:**
```bash
# ❌ INTERDIT
rm -rf /mnt/c/Users/fvegi/mcp-servers
rm -rf /mnt/c/Users/fvegi/francis-opus-4.1
docker system prune -a --volumes

# ❌ NE PAS DÉSINSTALLER
npm uninstall @modelcontextprotocol/*
```

---
**CE DOCUMENT = VOTRE ASSURANCE VIE TECHNIQUE**
**14 HEURES DE TRAVAIL PROTÉGÉES**
**200$/MOIS D'AUTONOMIE GARANTIE**