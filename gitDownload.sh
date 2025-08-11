#!/bin/bash
set -euo pipefail

REPO_URL="git@github.com:michael3604/linux-scripts.git"
LOCAL_DIR="$HOME/linux-scripts"
BRANCH="main"

# Clone or fetch latest
if [ ! -d "$LOCAL_DIR/.git" ]; then
  echo "Cloning repository..."
  git clone --branch "$BRANCH" "$REPO_URL" "$LOCAL_DIR"
else
  echo "Fetching latest changes..."
  git -C "$LOCAL_DIR" fetch origin
  git -C "$LOCAL_DIR" checkout "$BRANCH"
  git -C "$LOCAL_DIR" reset --hard "origin/$BRANCH"
fi

echo "Verifying GPG signatures on commits..."

# List all commit hashes on current branch
commits=$(git -C "$LOCAL_DIR" rev-list "$BRANCH")

# Check each commit's signature
for commit in $commits; do
  echo "Verifying commit $commit..."
  if ! git -C "$LOCAL_DIR" verify-commit "$commit" >/dev/null 2>&1; then
    echo "ERROR: Commit $commit has an invalid or missing GPG signature!"
    exit 1
  fi
done

echo "All commits have valid GPG signatures."
