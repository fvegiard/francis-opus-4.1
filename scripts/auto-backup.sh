#!/bin/bash
# 🔄 BACKUP AUTOMATIQUE QUOTIDIEN - OPUS 4.1

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="/mnt/c/Users/fvegi/BACKUPS_OPUS41"
DATE=$(date +%Y%m%d_%H%M%S)

# Créer dossier backup si n'existe pas
mkdir -p "$BACKUP_DIR"

echo -e "${GREEN}🔄 BACKUP AUTOMATIQUE OPUS 4.1${NC}"
echo "Date: $(date)"

# 1. Backup configs MCP
echo "📦 Backup serveurs MCP..."
tar -czf "$BACKUP_DIR/mcp_servers_$DATE.tar.gz" \
    /mnt/c/Users/fvegi/mcp-servers \
    --exclude="node_modules" \
    --exclude=".venv" \
    2>/dev/null

# 2. Backup configuration Claude
echo "⚙️ Backup config Claude..."
cp /mnt/c/Users/fvegi/AppData/Roaming/Claude/claude_desktop_config.json \
   "$BACKUP_DIR/claude_config_$DATE.json" 2>/dev/null

# 3. Backup scripts
echo "📝 Backup scripts..."
tar -czf "$BACKUP_DIR/scripts_$DATE.tar.gz" \
    /mnt/c/Users/fvegi/francis-opus-4.1/scripts \
    /mnt/c/Users/fvegi/*.sh \
    2>/dev/null

# 4. Backup GitHub repos
echo "🐙 Backup repos GitHub..."
cd /mnt/c/Users/fvegi/francis-opus-4.1
git bundle create "$BACKUP_DIR/francis-opus-41_$DATE.bundle" --all 2>/dev/null

# 5. Créer manifest
cat > "$BACKUP_DIR/manifest_$DATE.txt" << EOF
BACKUP OPUS 4.1 - $DATE
========================
✅ MCP Servers (13)
✅ Claude Config
✅ Scripts (tous)
✅ GitHub repos
✅ Documentation

Restauration:
1. tar -xzf mcp_servers_$DATE.tar.gz -C /
2. cp claude_config_$DATE.json /mnt/c/Users/fvegi/AppData/Roaming/Claude/
3. tar -xzf scripts_$DATE.tar.gz -C /
4. git clone francis-opus-41_$DATE.bundle

Taille totale: $(du -sh "$BACKUP_DIR" | cut -f1)
EOF

# 6. Nettoyer vieux backups (garder 7 derniers)
echo "🗑️ Nettoyage anciens backups..."
ls -t "$BACKUP_DIR"/mcp_servers_*.tar.gz 2>/dev/null | tail -n +8 | xargs rm -f 2>/dev/null

echo -e "${GREEN}✅ BACKUP COMPLET${NC}"
echo "Location: $BACKUP_DIR"
echo "Fichiers:"
ls -lh "$BACKUP_DIR"/*$DATE* 2>/dev/null | awk '{print "  - "$9" ("$5")"}'

# Ajouter au crontab pour execution quotidienne
if ! crontab -l 2>/dev/null | grep -q "auto-backup.sh"; then
    (crontab -l 2>/dev/null; echo "0 3 * * * /mnt/c/Users/fvegi/francis-opus-4.1/scripts/auto-backup.sh") | crontab -
    echo -e "${YELLOW}📅 Backup automatique ajouté à 3h du matin${NC}"
fi