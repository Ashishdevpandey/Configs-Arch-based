#!/bin/bash

# Configuration
SOURCE_DB="/home/ashish/.memos/memos_prod.db"
BACKUP_REPO_DIR="/home/ashish/memos-backup-sync"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# 1. Navigate to the backup repository
cd "$BACKUP_REPO_DIR" || exit

# 2. Copy the database file
cp "$SOURCE_DB" .

# 3. Git operations
git add memos_prod.db
git commit -m "Auto-backup: $TIMESTAMP"
# Try to push up to 12 times, waiting 10 seconds between tries (2 minutes total)
MAX_RETRIES=12
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if git push origin main; then
        echo "Successfully pushed to GitHub."
        break
    else
        echo "Push failed. Waiting for network... Retrying in 10 seconds ($((RETRY_COUNT + 1))/$MAX_RETRIES)"
        sleep 10
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Failed to push to GitHub after $MAX_RETRIES attempts."
    exit 1
fi
