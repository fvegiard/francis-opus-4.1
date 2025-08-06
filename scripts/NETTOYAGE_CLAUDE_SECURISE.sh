#!/bin/bash
# Script de nettoyage sécurisé des fichiers Claude obsolètes
# Date: 20 juillet 2025
# IMPORTANT: Vérifie chaque fichier avant suppression

echo "=== NETTOYAGE SÉCURISÉ DES FICHIERS CLAUDE ==="
echo "Ce script va identifier et proposer la suppression de fichiers Claude obsolètes"
echo ""

# Créer dossier pour logs
mkdir -p /mnt/c/Users/fvegi/NETTOYAGE_LOGS
LOG_FILE="/mnt/c/Users/fvegi/NETTOYAGE_LOGS/nettoyage_$(date +%Y%m%d_%H%M%S).log"

# Fonction pour logger
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Compteurs
TOTAL_FILES=0
TOTAL_SIZE=0
CLEANED_FILES=0
CLEANED_SIZE=0

log "Début du nettoyage"

# 1. NETTOYER LES VIEUX SCRIPTS CLAUDE CODE
echo -e "\n📁 VIEUX SCRIPTS CLAUDE CODE (dev/)"
CLAUDE_CODE_FILES=(
    "/mnt/c/Users/fvegi/dev/CLAUDE_CODE_ARNAQUE.md"
    "/mnt/c/Users/fvegi/dev/CLAUDE_CODE_FIX_NOW.bat"
    "/mnt/c/Users/fvegi/dev/FIX_CLAUDE_CODE_1CLICK.bat"
    "/mnt/c/Users/fvegi/dev/STOP_CLAUDE_CODE_BULLSHIT.bat"
    "/mnt/c/Users/fvegi/dev/WSL_CLAUDE_CODE_BROKEN.md"
    "/mnt/c/Users/fvegi/dev/REPAIR_WSL_CLAUDE_CODE.bat"
    "/mnt/c/Users/fvegi/dev/analyze_claude_damage.py"
)

for file in "${CLAUDE_CODE_FILES[@]}"; do
    if [ -f "$file" ]; then
        SIZE=$(stat -c%s "$file" 2>/dev/null || echo 0)
        echo "  ❌ $file ($(numfmt --to=iec-i --suffix=B $SIZE))"
        ((TOTAL_FILES++))
        TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    fi
done

# 2. NETTOYER VIEUX FICHIERS DESKTOP
echo -e "\n📁 VIEUX FICHIERS DESKTOP"
DESKTOP_FILES=(
    "/mnt/c/Users/fvegi/Desktop/CHECK_CLAUDE_AGENT.bat"
    "/mnt/c/Users/fvegi/Desktop/CLAUDE_REPARE_SUCCES.bat"
    "/mnt/c/Users/fvegi/Desktop/FIX_DRAG_DROP_CLAUDE.bat"
    "/mnt/c/Users/fvegi/Desktop/REPARE_CLAUDE_AGENT_AUTONOME.bat"
    "/mnt/c/Users/fvegi/Desktop/diagnostic_claude_agent.py"
)

for file in "${DESKTOP_FILES[@]}"; do
    if [ -f "$file" ]; then
        SIZE=$(stat -c%s "$file" 2>/dev/null || echo 0)
        echo "  ❌ $file ($(numfmt --to=iec-i --suffix=B $SIZE))"
        ((TOTAL_FILES++))
        TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    fi
done

# 3. NETTOYER BACKUPS CLAUDE CONFIG (garder seulement le plus récent)
echo -e "\n📁 VIEUX BACKUPS CLAUDE CONFIG"
BACKUP_FILES=(
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.backup.20250704.json"
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.backup_20250701_143452.json"
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.backup_20250701_224702.json"
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.backup_20250709_155932.json"
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config_backup_20250621_1749.json"
)

for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$file" ]; then
        SIZE=$(stat -c%s "$file" 2>/dev/null || echo 0)
        echo "  ❌ $file ($(numfmt --to=iec-i --suffix=B $SIZE))"
        ((TOTAL_FILES++))
        TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    fi
done

# 4. NETTOYER FICHIERS .OLD ET .BAK > 30 jours
echo -e "\n📁 FICHIERS .OLD ET .BAK ANCIENS (>30 jours)"
while IFS= read -r file; do
    if [[ ! "$file" =~ (BraveSoftware|Chrome|Edge|Microsoft|Windows|System32) ]]; then
        SIZE=$(stat -c%s "$file" 2>/dev/null || echo 0)
        echo "  ❌ $file ($(numfmt --to=iec-i --suffix=B $SIZE))"
        ((TOTAL_FILES++))
        TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    fi
done < <(find /mnt/c/Users/fvegi -type f \( -name "*.old" -o -name "*.bak" \) -mtime +30 2>/dev/null | grep -v AppData/Local)

# 5. NETTOYER CACHES PYTHON
echo -e "\n📁 CACHES PYTHON __pycache__"
PYCACHE_COUNT=$(find /mnt/c/Users/fvegi -type d -name "__pycache__" 2>/dev/null | grep -v AppData | wc -l)
echo "  ❌ $PYCACHE_COUNT dossiers __pycache__ trouvés"

# RÉSUMÉ
echo -e "\n📊 RÉSUMÉ:"
echo "  • Fichiers identifiés: $TOTAL_FILES"
echo "  • Espace à libérer: $(numfmt --to=iec-i --suffix=B $TOTAL_SIZE)"
echo ""

# CONFIRMATION
read -p "🤔 Voulez-vous procéder au nettoyage? (o/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Oo]$ ]]; then
    echo -e "\n🧹 NETTOYAGE EN COURS..."
    
    # Nettoyer avec confirmation
    for file in "${CLAUDE_CODE_FILES[@]}" "${DESKTOP_FILES[@]}" "${BACKUP_FILES[@]}"; do
        if [ -f "$file" ]; then
            SIZE=$(stat -c%s "$file" 2>/dev/null || echo 0)
            rm -f "$file" && {
                log "Supprimé: $file"
                ((CLEANED_FILES++))
                CLEANED_SIZE=$((CLEANED_SIZE + SIZE))
            }
        fi
    done
    
    # Nettoyer pycache
    find /mnt/c/Users/fvegi -type d -name "__pycache__" 2>/dev/null | grep -v AppData | while read dir; do
        rm -rf "$dir" && log "Supprimé: $dir"
    done
    
    echo -e "\n✅ NETTOYAGE TERMINÉ!"
    echo "  • Fichiers supprimés: $CLEANED_FILES"
    echo "  • Espace libéré: $(numfmt --to=iec-i --suffix=B $CLEANED_SIZE)"
    echo "  • Log sauvegardé: $LOG_FILE"
else
    echo "❌ Nettoyage annulé"
fi

# FICHIERS À GARDER (RAPPEL)
echo -e "\n✅ FICHIERS IMPORTANTS CONSERVÉS:"
echo "  • /mnt/c/Users/fvegi/CLAUDE.md"
echo "  • /mnt/c/Users/fvegi/agent-autonome/*"
echo "  • /mnt/c/Users/fvegi/PGI-AI-FINAL/*"
echo "  • Configurations Claude Desktop actuelles"
echo "  • Projets actifs (pgi-ai-production)"