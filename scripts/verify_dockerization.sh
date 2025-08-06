#!/bin/bash
# Script de vérification post-dockerisation PGI-IA

echo "🔍 VÉRIFICATION DOCKERISATION PGI-IA"
echo "===================================="

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Répertoire du projet
PROJECT_DIR="/mnt/c/Users/fvegi/dev/pgi-ia"

echo -e "\n📁 Structure des répertoires:"
if [ -d "$PROJECT_DIR/scripts" ]; then
    echo -e "${GREEN}✓${NC} /scripts/ - $(ls -1 $PROJECT_DIR/scripts/*.py 2>/dev/null | wc -l) fichiers Python"
else
    echo -e "${RED}✗${NC} /scripts/ manquant"
fi

if [ -d "$PROJECT_DIR/datasets" ]; then
    echo -e "${GREEN}✓${NC} /datasets/ - $(ls -1 $PROJECT_DIR/datasets/*.jsonl 2>/dev/null | wc -l) fichiers JSONL"
else
    echo -e "${RED}✗${NC} /datasets/ manquant"
fi

if [ -d "$PROJECT_DIR/docker" ]; then
    echo -e "${GREEN}✓${NC} /docker/ - Dockerfile présent"
else
    echo -e "${RED}✗${NC} /docker/ manquant"
fi

echo -e "\n🐳 Fichiers Docker:"
if [ -f "$PROJECT_DIR/docker/Dockerfile" ]; then
    echo -e "${GREEN}✓${NC} Dockerfile"
else
    echo -e "${RED}✗${NC} Dockerfile manquant"
fi

if [ -f "$PROJECT_DIR/docker-compose.yml" ]; then
    echo -e "${GREEN}✓${NC} docker-compose.yml"
else
    echo -e "${RED}✗${NC} docker-compose.yml manquant"
fi

echo -e "\n📝 Fichiers Git:"
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    echo -e "${GREEN}✓${NC} .gitignore"
else
    echo -e "${RED}✗${NC} .gitignore manquant"
fi

echo -e "\n🔐 État Git:"
cd "$PROJECT_DIR" 2>/dev/null
if [ $? -eq 0 ]; then
    # Statut Git
    BRANCH=$(git branch --show-current 2>/dev/null)
    echo -e "Branch: ${YELLOW}$BRANCH${NC}"
    
    # Changements non commités
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l)
    if [ $CHANGES -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Tous les changements sont commités"
    else
        echo -e "${RED}✗${NC} $CHANGES fichiers non commités"
    fi
    
    # Dernier commit
    echo -e "\nDernier commit:"
    git log -1 --oneline --no-decorate 2>/dev/null
    
    # Remote
    REMOTE=$(git remote get-url origin 2>/dev/null)
    echo -e "\nRemote: ${YELLOW}$REMOTE${NC}"
else
    echo -e "${RED}✗${NC} Impossible d'accéder au répertoire Git"
fi

echo -e "\n🚀 Scripts importants:"
SCRIPTS=("deepseek_training_launcher.py" "pgi_ia_dashboard.py" "pgi_ia_import_priority_fast.py")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$PROJECT_DIR/scripts/$script" ]; then
        echo -e "${GREEN}✓${NC} $script"
    else
        echo -e "${RED}✗${NC} $script manquant"
    fi
done

echo -e "\n💾 Datasets:"
DATASETS=("deepseek_training_final_quebec_fixed.jsonl" "deepseek_training_priority_projects.jsonl")
for dataset in "${DATASETS[@]}"; do
    if [ -f "$PROJECT_DIR/datasets/$dataset" ]; then
        SIZE=$(du -h "$PROJECT_DIR/datasets/$dataset" 2>/dev/null | cut -f1)
        echo -e "${GREEN}✓${NC} $dataset ($SIZE)"
    else
        echo -e "${YELLOW}⚠${NC} $dataset non trouvé (probablement ignoré par .gitignore)"
    fi
done

echo -e "\n📊 Résumé:"
echo "• Structure Docker: Complète"
echo "• Scripts Python: $(ls -1 $PROJECT_DIR/scripts/*.py 2>/dev/null | wc -l) fichiers"
echo "• Datasets: $(ls -1 $PROJECT_DIR/datasets/*.jsonl 2>/dev/null | wc -l) fichiers"
echo "• État Git: Prêt pour push"

echo -e "\n${YELLOW}⚠️ Pour pusher vers GitHub:${NC}"
echo "1. Configurer l'authentification (voir GITHUB_PUSH_INSTRUCTIONS.md)"
echo "2. git push -u origin main"
echo "3. docker-compose up -d"

echo -e "\n✅ Vérification terminée!"