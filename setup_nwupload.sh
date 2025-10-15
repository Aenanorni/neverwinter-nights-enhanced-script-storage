#!/bin/bash
# === Neverwinter Auto GitHub Backup ===
# Author: Aenanorni
# Purpose: One-shot Termux-friendly sync to GitHub main branch

# ==== CONFIG ====
REPO_URL="git@github.com:Aenanorni/neverwinter-nights-enhanced-script-storage.git"
LOCAL_PATH="/storage/6FDB-76B4/Software/Custom Software/Neverwinter Nights Enhanced Edition"
CLONE_PATH="$HOME/neverwinter-nights-enhanced-backup"

# ==== SETUP ====
pkg install -y git openssh termux-api >/dev/null 2>&1

# ==== CLONE OR UPDATE REPO ====
echo "🔄 Preparing local backup repo..."
if [ ! -d "$CLONE_PATH/.git" ]; then
  rm -rf "$CLONE_PATH"
  git clone "$REPO_URL" "$CLONE_PATH"
else
  cd "$CLONE_PATH" && git pull origin main
fi

# ==== SYNC FILES ====
echo "📁 Syncing files from SD to local repo..."
rsync -av --delete "$LOCAL_PATH/" "$CLONE_PATH/" --exclude ".git"

# ==== COMMIT & PUSH ====
cd "$CLONE_PATH" || exit
echo "🚀 Uploading changes to GitHub..."

git add .
git commit -m "Auto backup: $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ Nothing to commit"
git push origin main && termux-toast "✅ Upload complete!" || termux-toast "❌ Upload failed!"

echo "✅ Done! Backup synced to GitHub main branch."