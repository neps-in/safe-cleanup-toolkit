#!/bin/bash

# ─────────────────────────────────────────
#  macOS Safe Cleanup Script
# ─────────────────────────────────────────

confirm_delete() {
  local label="$1"
  local path="$2"
  local cmd="$3"

  # Check if path exists
  if [ ! -e "$path" ] && [[ "$cmd" != npm* ]] && [[ "$cmd" != brew* ]]; then
    echo "⚪ SKIP: $label — not found"
    echo ""
    return
  fi

  # Calculate size
  echo "──────────────────────────────────────"
  echo "📁 $label"
  echo "   Path : $path"

  if [[ "$cmd" == sudo* ]]; then
    size=$(sudo du -sh "$path" 2>/dev/null | cut -f1)
  elif [[ "$cmd" == npm* ]] || [[ "$cmd" == brew* ]]; then
    size="(managed by tool)"
  else
    size=$(du -sh "$path" 2>/dev/null | cut -f1)
  fi

  echo "   Size : ${size:-unknown}"
  echo ""
  read -p "   🗑️  Delete? (y/n): " answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "   ✅ Deleting..."
    eval "$cmd"
    echo "   ✔️  Done."
  else
    echo "   ⏭️  Skipped."
  fi
  echo ""
}

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     macOS Storage Cleanup Script     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Snapshot free space before
before=$(df -h / | awk 'NR==2 {print $4}')
echo "💾 Free space before: $before"
echo ""

# ── Sections ──────────────────────────────

confirm_delete \
  "User Cache" \
  "$HOME/Library/Caches" \
  "rm -rf ~/Library/Caches/*"

confirm_delete \
  "User Logs" \
  "$HOME/Library/Logs" \
  "rm -rf ~/Library/Logs/*"

confirm_delete \
  "System Logs" \
  "/private/var/log" \
  "sudo rm -rf /private/var/log/*"

confirm_delete \
  "Trash" \
  "$HOME/.Trash" \
  "rm -rf ~/.Trash/*"

confirm_delete \
  "Xcode DerivedData" \
  "$HOME/Library/Developer/Xcode/DerivedData" \
  "rm -rf ~/Library/Developer/Xcode/DerivedData/*"

confirm_delete \
  "Xcode iOS DeviceSupport" \
  "$HOME/Library/Developer/Xcode/iOS DeviceSupport" \
  "rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*"

confirm_delete \
  "Xcode Archives" \
  "$HOME/Library/Developer/Xcode/Archives" \
  "rm -rf ~/Library/Developer/Xcode/Archives/*"

confirm_delete \
  "pip Cache" \
  "$HOME/Library/Caches/pip" \
  "rm -rf ~/Library/Caches/pip/*"

confirm_delete \
  "CocoaPods Cache" \
  "$HOME/Library/Caches/CocoaPods" \
  "rm -rf ~/Library/Caches/CocoaPods/*"

confirm_delete \
  "Gradle Cache" \
  "$HOME/.gradle/caches" \
  "rm -rf ~/.gradle/caches/*"

confirm_delete \
  "Maven Cache" \
  "$HOME/.m2/repository" \
  "rm -rf ~/.m2/repository/*"

# ── Tool-managed caches ───────────────────

echo "──────────────────────────────────────"
echo "📦 npm Cache (managed by npm)"
npm_size=$(npm cache verify 2>/dev/null | grep "Cache verified" | awk '{print $NF}')
echo "   Size : ${npm_size:-run 'npm cache verify' to check}"
read -p "   🗑️  Clean? (y/n): " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] && npm cache clean --force 2>/dev/null && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
echo ""

echo "──────────────────────────────────────"
echo "🍺 Homebrew Cache"
brew_size=$(du -sh "$(brew --cache)" 2>/dev/null | cut -f1)
echo "   Size : ${brew_size:-unknown}"
read -p "   🗑️  Clean? (y/n): " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] && brew cleanup --prune=all 2>/dev/null && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
echo ""

# ── Summary ───────────────────────────────

after=$(df -h / | awk 'NR==2 {print $4}')
echo "╔══════════════════════════════════════╗"
echo "║              SUMMARY                 ║"
echo "╠══════════════════════════════════════╣"
echo "║  Free before : $before"              ║"   
echo "║  Free after  : $after"               ║"
echo "╚══════════════════════════════════════╝"
echo ""