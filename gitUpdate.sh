#!/bin/bash
set -euo pipefail

# Optional: Change this to your main branch name if it's not master
BRANCH="main"

echo "📁 Syncing working directory to GitHub..."

# 1. Stage all new, modified, and deleted files
git add --all

# 2. Commit (PGP signed, fallback to unsigned if needed)
COMMIT_MSG="Auto-sync on $(date '+%F %T')"
if git commit -S -m "$COMMIT_MSG"; then
  echo "✅ Signed commit created."
else
  echo "⚠️ Signed commit failed. Falling back to unsigned commit..."
  git commit -m "$COMMIT_MSG" || echo "ℹ️ Nothing to commit."
fi

# 3. Push to GitHub
git push origin "$BRANCH"

echo "✅ Sync complete. GitHub now matches your local directory."
