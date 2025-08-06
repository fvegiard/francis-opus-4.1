#!/bin/bash
# Installation COMPLÈTE de TOUS les serveurs MCP disponibles

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 INSTALLATION COMPLÈTE DES SERVEURS MCP${NC}"
echo "=========================================="
echo ""

cd /mnt/c/Users/fvegi/mcp-servers

# Serveurs officiels @modelcontextprotocol qui existent
echo -e "${YELLOW}📦 Installation des serveurs officiels MCP...${NC}"
OFFICIAL_SERVERS=(
    "@modelcontextprotocol/server-filesystem"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-postgres"
    "@modelcontextprotocol/server-memory"
    "@modelcontextprotocol/server-puppeteer"
    "@modelcontextprotocol/server-slack"
    "@modelcontextprotocol/server-google-maps"
    "@modelcontextprotocol/server-everart"
    "@modelcontextprotocol/server-brave-search"
)

for server in "${OFFICIAL_SERVERS[@]}"; do
    echo -n "  Installing $server... "
    if npm list "$server" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Already installed${NC}"
    else
        npm install "$server" >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    fi
done

# Serveurs communautaires
echo -e "\n${YELLOW}🌐 Installation des serveurs communautaires...${NC}"
COMMUNITY_SERVERS=(
    "exa-mcp-server"
    "mcp-server-fetch"
    "mcp-server-sqlite"
    "@anthropic/mcp-server-twitter"
    "@anthropic/mcp-server-discord"
)

for server in "${COMMUNITY_SERVERS[@]}"; do
    echo -n "  Installing $server... "
    if npm list "$server" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Already installed${NC}"
    else
        npm install "$server" >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${YELLOW}⚠ Not found${NC}"
    fi
done

# Serveurs Python (sequential-thinking)
echo -e "\n${YELLOW}🐍 Installation de sequential-thinking (Python)...${NC}"
if [ ! -d "sequential-thinking" ]; then
    # Clone sans authentification
    git clone --depth 1 https://github.com/modelcontextprotocol/sequential-thinking.git sequential-thinking 2>/dev/null || {
        echo -e "${YELLOW}⚠ Sequential-thinking - clonage échoué${NC}"
    }
    
    if [ -d "sequential-thinking" ]; then
        cd sequential-thinking
        python3 -m venv .venv
        source .venv/bin/activate
        pip install -e . >/dev/null 2>&1
        deactivate
        cd ..
        echo -e "${GREEN}✓ Sequential-thinking installé${NC}"
    fi
else
    echo -e "${GREEN}✓ Sequential-thinking déjà installé${NC}"
fi

# Résumé
echo ""
echo -e "${BLUE}📊 RÉSUMÉ DE L'INSTALLATION${NC}"
echo "============================"

INSTALLED=$(npm list --depth=0 2>/dev/null | grep -c "@modelcontextprotocol\|mcp-server\|exa-mcp" || echo 0)
echo -e "${GREEN}✅ $INSTALLED serveurs MCP installés${NC}"

echo ""
echo "Serveurs disponibles:"
npm list --depth=0 2>/dev/null | grep -E "@modelcontextprotocol|mcp-server|exa-mcp" | sed 's/├──/  •/g' | sed 's/└──/  •/g'

echo ""
echo -e "${GREEN}✨ Installation terminée!${NC}"
echo "Pour vérifier le statut: ./check_opus_status.sh"