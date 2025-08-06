#!/bin/bash
# Installation des 19 serveurs MCP pour Francis
# Basé sur claude-code-complete-setup mais adapté

set -euo pipefail

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Installation des 19 serveurs MCP pour Francis${NC}"
echo "================================================"

# Créer le dossier MCP
MCP_DIR="/mnt/c/Users/fvegi/mcp-servers"
mkdir -p "$MCP_DIR"
cd "$MCP_DIR"

# Initialiser npm si nécessaire
if [ ! -f package.json ]; then
    npm init -y > /dev/null 2>&1
fi

echo -e "\n${YELLOW}📦 Installation des serveurs MCP core...${NC}"

# Serveurs MCP core (npm)
SERVERS=(
    "@modelcontextprotocol/server-filesystem"
    "@modelcontextprotocol/server-github" 
    "@modelcontextprotocol/server-postgres"
    "@modelcontextprotocol/server-memory"
    "@modelcontextprotocol/server-puppeteer"
    "@modelcontextprotocol/server-git"
    "@modelcontextprotocol/server-perplexity"
    "@modelcontextprotocol/server-slack"
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-google-drive"
    "@modelcontextprotocol/server-google-maps"
    "@modelcontextprotocol/server-everart"
    "@modelcontextprotocol/server-time"
    "@modelcontextprotocol/server-aws"
    "@modelcontextprotocol/server-reddit"
    "firecrawl-mcp-server"
    "exa-mcp-server"
)

for server in "${SERVERS[@]}"; do
    echo -n "Installing $server... "
    if npm list "$server" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Already installed${NC}"
    else
        npm install "$server" >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    fi
done

# Sequential-thinking (Python)
echo -e "\n${YELLOW}🐍 Installation de sequential-thinking...${NC}"
if [ ! -d "sequential-thinking" ]; then
    git clone https://github.com/sequentialread/sequential-thinking-mcp.git sequential-thinking
    cd sequential-thinking
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -e .
    deactivate
    cd ..
    echo -e "${GREEN}✓ Sequential-thinking installé${NC}"
else
    echo -e "${GREEN}✓ Sequential-thinking déjà installé${NC}"
fi

echo -e "\n${GREEN}✅ Installation terminée!${NC}"
echo "19 serveurs MCP sont maintenant disponibles"
echo ""
echo "Prochaine étape: Configurer claude_desktop_config.json"