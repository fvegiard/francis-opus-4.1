#!/bin/bash
# 🛡️ SYSTÈME DE PROTECTION FRANCIS OPUS 4.1
# Empêche la suppression accidentelle des composants critiques

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Liste des dossiers protégés
PROTECTED_DIRS=(
    "/mnt/c/Users/fvegi/mcp-servers"
    "/mnt/c/Users/fvegi/francis-opus-4.1"
    "/mnt/c/Users/fvegi/.ollama/models"
    "/root/francis-config"
)

# Liste des fichiers protégés
PROTECTED_FILES=(
    "/mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json"
    "/mnt/c/Users/fvegi/SETUP_OPUS_4.1.sh"
    "/mnt/c/Users/fvegi/check_opus_status.sh"
)

# Fonction de protection
protect_resources() {
    echo -e "${GREEN}🛡️ ACTIVATION DE LA PROTECTION${NC}"
    
    # Créer des alias pour rm dangereux
    echo "# Protection Francis Opus 4.1" >> ~/.bashrc
    echo "alias rm='rm -i'" >> ~/.bashrc
    echo "alias rm-mcp='echo \"⚠️ ERREUR: Suppression MCP servers INTERDITE!\" && false'" >> ~/.bashrc
    
    # Créer des fichiers .noDelete dans les dossiers critiques
    for dir in "${PROTECTED_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            touch "$dir/.CRITICAL_DO_NOT_DELETE"
            echo "⚠️ CRITIQUE - 14H DE CONFIG - NE PAS SUPPRIMER" > "$dir/.WARNING.txt"
            echo -e "${GREEN}✓${NC} Protection ajoutée: $dir"
        fi
    done
    
    # Rendre les fichiers critiques immutables (Linux)
    for file in "${PROTECTED_FILES[@]}"; do
        if [ -f "$file" ]; then
            # Backup d'abord
            cp "$file" "$file.backup.$(date +%Y%m%d)" 2>/dev/null
            echo -e "${GREEN}✓${NC} Backup créé: $file"
        fi
    done
}

# Fonction de vérification
check_system() {
    echo -e "\n${YELLOW}🔍 VÉRIFICATION DU SYSTÈME${NC}"
    
    local errors=0
    
    # Vérifier dossiers
    for dir in "${PROTECTED_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            echo -e "${RED}✗ MANQUANT:${NC} $dir"
            ((errors++))
        else
            echo -e "${GREEN}✓ OK:${NC} $dir"
        fi
    done
    
    # Vérifier fichiers
    for file in "${PROTECTED_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}✗ MANQUANT:${NC} $file"
            ((errors++))
        else
            echo -e "${GREEN}✓ OK:${NC} $file"
        fi
    done
    
    if [ $errors -eq 0 ]; then
        echo -e "\n${GREEN}✅ SYSTÈME INTACT - TOUT EST OK${NC}"
    else
        echo -e "\n${RED}⚠️ ATTENTION: $errors éléments manquants!${NC}"
        echo "Exécuter: ./SETUP_OPUS_4.1.sh pour réparer"
    fi
}

# Fonction wrapper pour rm
safe_rm() {
    local target="$1"
    
    # Vérifier si c'est un dossier protégé
    for protected in "${PROTECTED_DIRS[@]}"; do
        if [[ "$target" == *"$protected"* ]]; then
            echo -e "${RED}🚫 ERREUR: SUPPRESSION INTERDITE${NC}"
            echo -e "${YELLOW}Ce dossier contient 14H de configuration!${NC}"
            echo "Si vraiment nécessaire, utilisez: rm-force-unsafe"
            return 1
        fi
    done
    
    # Demander confirmation
    echo -e "${YELLOW}⚠️ Suppression de: $target${NC}"
    read -p "Êtes-vous SÛR? (tapez 'OUI JE SUIS SUR'): " confirmation
    
    if [ "$confirmation" = "OUI JE SUIS SUR" ]; then
        /bin/rm "$@"
    else
        echo "Suppression annulée"
    fi
}

# Menu principal
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   PROTECTION SYSTÈME OPUS 4.1       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo
echo "1) Activer la protection"
echo "2) Vérifier l'intégrité"
echo "3) Créer backup complet"
echo "4) Afficher l'inventaire"
echo
read -p "Choix: " choice

case $choice in
    1)
        protect_resources
        source ~/.bashrc
        echo -e "\n${GREEN}Protection activée!${NC}"
        ;;
    2)
        check_system
        ;;
    3)
        echo "Création backup..."
        tar -czf ~/opus41_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
            /mnt/c/Users/fvegi/mcp-servers \
            /mnt/c/Users/fvegi/francis-opus-4.1 \
            2>/dev/null
        echo -e "${GREEN}✓ Backup créé dans ~/opus41_backup_*.tar.gz${NC}"
        ;;
    4)
        cat /mnt/c/Users/fvegi/francis-opus-4.1/CRITICAL_INVENTORY.md
        ;;
esac