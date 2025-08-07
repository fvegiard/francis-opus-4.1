#!/bin/bash
# WRAPPER pour donner l'autonomie MCP à Claude

# Fonction pour sequential-thinking Python
sequential_thinking() {
    cd /mnt/c/Users/fvegi/mcp-servers/sequential-thinking
    source .venv/bin/activate
    python -m mcp_sequential_thinking.server "$@"
    deactivate
}

# Fonction pour sequential-thinking-branches
sequential_branches() {
    node /mnt/c/Users/fvegi/mcp-servers/sequential-thinking-branches/index.js "$@"
}

# Détection automatique du besoin
if [[ "$1" == *"complex"* ]] || [[ "$1" == *"debug"* ]]; then
    echo "🧠 Complexité détectée - Activation Sequential-Thinking"
    sequential_branches "$@"
elif [[ "$1" == *"linear"* ]]; then
    sequential_thinking "$@"
else
    echo "💭 Analyse standard"
fi

# Log pour Claude
echo "[MCP-WRAPPER] Executed: $1" >> ~/.claude/mcp-usage.log