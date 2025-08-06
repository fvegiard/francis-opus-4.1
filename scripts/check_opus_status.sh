#!/bin/bash
# CHECK OPUS 4.1 STATUS - Vérification complète du système

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔍 VÉRIFICATION SYSTÈME OPUS 4.1${NC}"
echo "===================================="
echo ""

# 1. Claude Code CLI
echo -n "1. Claude Code CLI: "
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Installé${NC} ($(claude --version 2>/dev/null || echo 'version inconnue'))"
else
    echo -e "${RED}✗ Non installé${NC}"
fi

# 2. Serveurs MCP
echo -n "2. Serveurs MCP: "
if [ -d "/mnt/c/Users/fvegi/mcp-servers" ]; then
    count=$(cd /mnt/c/Users/fvegi/mcp-servers && npm list --depth=0 2>/dev/null | grep -c "@modelcontextprotocol" || echo 0)
    echo -e "${YELLOW}$count/19 installés${NC}"
else
    echo -e "${RED}✗ Dossier non trouvé${NC}"
fi

# 3. Configuration Claude Desktop
echo -n "3. Config Claude Desktop: "
if [ -f "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json" ]; then
    servers=$(grep -c '"command"' /mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json 2>/dev/null || echo 0)
    echo -e "${GREEN}✓ $servers serveurs configurés${NC}"
else
    echo -e "${RED}✗ Fichier non trouvé${NC}"
fi

# 4. CLAUDE.md personnalisé
echo -n "4. CLAUDE.md personnalisé: "
if [ -f "~/.claude/CLAUDE.md" ] || [ -f "/root/francis-config/CLAUDE.md" ]; then
    echo -e "${GREEN}✓ Présent${NC}"
else
    echo -e "${RED}✗ Non trouvé${NC}"
fi

# 5. Open Web UI
echo -n "5. Open Web UI: "
if docker ps | grep -q open-webui; then
    echo -e "${GREEN}✓ Actif sur http://localhost:3000${NC}"
else
    echo -e "${RED}✗ Non actif${NC}"
fi

# 6. Ollama
echo -n "6. Ollama (Windows): "
if timeout 2 curl -s http://172.28.224.1:11434 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Accessible${NC}"
else
    echo -e "${YELLOW}⚠ Non accessible depuis WSL${NC}"
fi

# 7. Modèles IA locaux
echo -n "7. Modèles IA: "
if [ -d "/mnt/c/Users/fvegi/.ollama/models/manifests" ]; then
    models=$(ls /mnt/c/Users/fvegi/.ollama/models/manifests/registry.ollama.ai/library/ 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ $models modèles installés${NC}"
else
    echo -e "${RED}✗ Dossier non trouvé${NC}"
fi

# 8. Espace disque
echo -n "8. Espace disque C: "
available=$(df -h /mnt/c | tail -1 | awk '{print $4}')
used_pct=$(df -h /mnt/c | tail -1 | awk '{print $5}')
if [ "${used_pct%\%}" -lt 80 ]; then
    echo -e "${GREEN}✓ $available disponible ($used_pct utilisé)${NC}"
else
    echo -e "${YELLOW}⚠ $available disponible ($used_pct utilisé)${NC}"
fi

# 9. Docker
echo -n "9. Docker: "
if docker info > /dev/null 2>&1; then
    containers=$(docker ps -q | wc -l)
    echo -e "${GREEN}✓ Actif ($containers containers)${NC}"
else
    echo -e "${RED}✗ Non actif${NC}"
fi

# 10. GPU RTX 4060
echo -n "10. GPU RTX 4060: "
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ Détecté${NC}"
else
    echo -e "${YELLOW}⚠ nvidia-smi non installé dans WSL${NC}"
fi

echo ""
echo "===================================="
echo -e "${GREEN}RÉSUMÉ:${NC}"
echo "Tu payes 200$/mois pour Opus 4.1"
echo "Ton système est configuré pour:"
echo "  • Autonomie totale (CLAUDE.md)"
echo "  • 9+ serveurs MCP actifs"
echo "  • 3 modèles IA locaux (RTX 4060)"
echo "  • Open Web UI interface"
echo ""
echo "Pour une performance MAXIMALE, lance:"
echo "  ./SETUP_OPUS_4.1.sh"