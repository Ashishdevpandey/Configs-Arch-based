#!/bin/bash

# Configuration
SOURCE_DB="/home/ashish/.memos/memos_prod.db"
BACKUP_REPO_DIR="/home/ashish/memos-backup-sync"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# 1. Navigate to the backup repository
cd "$BACKUP_REPO_DIR" || exit

# 2. Copy the database file
cp "$SOURCE_DB" .

# 3. Check if there are actual changes
if git diff --quiet memos_prod.db; then
    echo "[$TIMESTAMP] No changes in database. Skipping backup."
    exit 0
fi

# 4. Git commit
git add memos_prod.db
git commit -m "Auto-backup: $TIMESTAMP"

# 5. Push to GitHub with connectivity check
MAX_RETRIES=12
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    # Check if github.com is reachable before pushing
    if ping -c 1 -W 2 github.com >/dev/null 2>&1; then
        if git push origin main; then
            echo "[$TIMESTAMP] Successfully pushed to GitHub."
            exit 0
        fi
    fi
    
    echo "[$TIMESTAMP] Push failed or network down. Retrying in 10 seconds ($((RETRY_COUNT + 1))/$MAX_RETRIES)"
    sleep 10
    RETRY_COUNT=$((RETRY_COUNT + 1))
done

echo "[$TIMESTAMP] Failed to push to GitHub after $MAX_RETRIES attempts."
exit 1
