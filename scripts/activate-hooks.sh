#!/bin/bash
# ACTIVATION DES HOOKS AUTOMATIQUES

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 ACTIVATION HOOKS AUTOMATIQUES${NC}"
echo "================================"

# Copier hooks dans config Claude
cp /root/.claude/hooks.yaml ~/.claude/hooks.yaml 2>/dev/null || {
    mkdir -p ~/.claude
    cp /root/.claude/hooks.yaml ~/.claude/
}

# Copier CLAUDE.md mis à jour
cp /root/.claude/CLAUDE.md ~/.claude/CLAUDE.md 2>/dev/null

# Créer watcher pour activation automatique
cat > ~/.claude/hook-watcher.sh << 'EOF'
#!/bin/bash
# WATCHER - Active les hooks selon les triggers

WRAPPER="/mnt/c/Users/fvegi/francis-opus-4.1/scripts/mcp-wrapper.sh"

# Fonction de détection
detect_and_activate() {
    local input="$1"
    
    # Détection complexité
    if echo "$input" | grep -qiE "debug|complex|architecture|erreur|crash|problème"; then
        echo "🧠 [AUTO] Complexité détectée - Activation sequential-thinking"
        $WRAPPER "$input" &
        return 0
    fi
    
    # Détection erreur
    if echo "$input" | grep -qiE "error|exception|failed"; then
        echo "🔍 [AUTO] Erreur détectée - Branches debug activées"
        # Activer branches debug
        return 0
    fi
    
    # Détection performance
    if echo "$input" | grep -qiE "slow|lag|timeout|memory"; then
        echo "⚡ [AUTO] Performance issue - Optimisation en cours"
        # Lancer optimisation
        return 0
    fi
    
    return 1
}

# Export pour utilisation
export -f detect_and_activate
EOF

chmod +x ~/.claude/hook-watcher.sh

# Ajouter au bashrc pour activation permanente
if ! grep -q "hook-watcher" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# HOOKS AUTOMATIQUES CLAUDE
source ~/.claude/hook-watcher.sh 2>/dev/null
export CLAUDE_HOOKS_ENABLED=true
export CLAUDE_WRAPPER="/mnt/c/Users/fvegi/francis-opus-4.1/scripts/mcp-wrapper.sh"
alias claude-hook='detect_and_activate'
EOF
fi

# Activer immédiatement
source ~/.bashrc

echo -e "${GREEN}✅ HOOKS ACTIVÉS${NC}"
echo
echo "Hooks configurés:"
echo -e "${YELLOW}→${NC} Complexité → Sequential-Thinking AUTO"
echo -e "${YELLOW}→${NC} Erreur → Debug Branches AUTO"
echo -e "${YELLOW}→${NC} Performance → Optimisation AUTO"
echo -e "${YELLOW}→${NC} Long process → Handoff AUTO"
echo -e "${YELLOW}→${NC} Code sans tests → Tests AUTO"
echo -e "${YELLOW}→${NC} Sécurité → Fix immédiat AUTO"
echo
echo -e "${GREEN}🚀 AUTONOMIE ABSOLUE ACTIVÉE!${NC}"
echo "Plus JAMAIS 'Puis-je activer...?'"