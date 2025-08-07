#!/bin/bash
# AUTO-ACTIVATION Sequential-Thinking
# Lance automatiquement quand complexité détectée

# Détection de complexité dans les logs Claude
monitor_complexity() {
    while true; do
        # Si Claude mentionne "complexe" ou "ULTRATHINK"
        if tail -n 100 ~/.claude/logs/current.log 2>/dev/null | grep -E "complexe|ULTRATHINK|debug|branches"; then
            echo "🧠 Complexité détectée - Activation Sequential-Thinking"
            
            # Restart Claude Desktop avec MCP
            pkill -f "Claude Desktop"
            sleep 2
            
            # Relance avec config MCP complète
            export CLAUDE_MCP_ENABLED=true
            export SEQUENTIAL_THINKING=active
            "/mnt/c/Program Files/Claude/Claude Desktop.exe" &
            
            echo "✅ Sequential-Thinking activé automatiquement"
        fi
        sleep 5
    done
}

# Lancer en background
monitor_complexity &
echo "🔄 Monitoring automatique activé"
echo "Sequential-Thinking s'activera seul si nécessaire"