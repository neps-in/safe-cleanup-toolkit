#!/bin/bash

# ─────────────────────────────────────────
#  Linux Safe Cleanup Script
# ─────────────────────────────────────────

confirm_delete() {
  local label="$1"
  local path="$2"
  local cmd="$3"

  # Check if path exists
  if [ ! -e "$path" ] && [[ "$cmd" != npm* ]] && [[ "$cmd" != pip* ]] && [[ "$cmd" != apt* ]] && [[ "$cmd" != snap* ]]; then
    echo "⚪ SKIP: $label — not found"
    echo ""
    return
  fi

  echo "──────────────────────────────────────"
  echo "📁 $label"
  echo "   Path : $path"

  if [[ "$cmd" == sudo* ]]; then
    size=$(sudo du -sh "$path" 2>/dev/null | cut -f1)
  elif [[ "$cmd" == npm* ]] || [[ "$cmd" == pip* ]] || [[ "$cmd" == apt* ]] || [[ "$cmd" == snap* ]]; then
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
echo "║    Linux Storage Cleanup Script      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Detect distro for package manager hints
if command -v apt &>/dev/null; then
  PKG_MANAGER="apt"
elif command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
else
  PKG_MANAGER="unknown"
fi

echo "🐧 Detected package manager: $PKG_MANAGER"

# Snapshot free space before
before=$(df -h / | awk 'NR==2 {print $4}')
echo "💾 Free space before: $before"
echo ""

# ── User-level caches ─────────────────────

confirm_delete \
  "Thumbnail Cache" \
  "$HOME/.cache/thumbnails" \
  "rm -rf ~/.cache/thumbnails/*"

confirm_delete \
  "User Cache (~/.cache)" \
  "$HOME/.cache" \
  "rm -rf ~/.cache/*"

confirm_delete \
  "User Logs (~/.local/share/logs)" \
  "$HOME/.local/share/logs" \
  "rm -rf ~/.local/share/logs/*"

confirm_delete \
  "Trash" \
  "$HOME/.local/share/Trash" \
  "rm -rf ~/.local/share/Trash/*"

# ── App-specific caches ───────────────────

confirm_delete \
  "pip Cache" \
  "$HOME/.cache/pip" \
  "rm -rf ~/.cache/pip/*"

confirm_delete \
  "Gradle Cache" \
  "$HOME/.gradle/caches" \
  "rm -rf ~/.gradle/caches/*"

confirm_delete \
  "Maven Cache" \
  "$HOME/.m2/repository" \
  "rm -rf ~/.m2/repository/*"

confirm_delete \
  "Go Module Cache" \
  "$HOME/go/pkg/mod/cache" \
  "rm -rf ~/go/pkg/mod/cache/*"

confirm_delete \
  "Cargo Registry Cache" \
  "$HOME/.cargo/registry/cache" \
  "rm -rf ~/.cargo/registry/cache/*"

confirm_delete \
  "Docker Build Cache" \
  "/var/lib/docker" \
  "sudo docker system prune -f"

confirm_delete \
  "Flatpak Unused Runtimes" \
  "/var/lib/flatpak" \
  "flatpak uninstall --unused -y"

# ── System-level caches ───────────────────

echo "──────────────────────────────────────"
echo "🔒 System Logs (/var/log)"
echo "   Note: Requires sudo"
sys_log_size=$(sudo du -sh /var/log 2>/dev/null | cut -f1)
echo "   Size : ${sys_log_size:-unknown}"
read -p "   🗑️  Clean journal logs older than 7 days? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  sudo journalctl --vacuum-time=7d 2>/dev/null && echo "   ✔️  Journal cleaned."
  sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null && echo "   ✔️  Compressed logs removed."
  sudo find /var/log -type f -name "*.1" -delete 2>/dev/null
else
  echo "   ⏭️  Skipped."
fi
echo ""

# ── Package manager caches ────────────────

if [[ "$PKG_MANAGER" == "apt" ]]; then
  echo "──────────────────────────────────────"
  echo "📦 APT Package Cache"
  apt_size=$(sudo du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)
  echo "   Size : ${apt_size:-unknown}"
  read -p "   🗑️  Clean? (y/n): " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] && sudo apt-get clean && sudo apt-get autoremove -y && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
  echo ""
fi

if [[ "$PKG_MANAGER" == "dnf" ]]; then
  echo "──────────────────────────────────────"
  echo "📦 DNF Package Cache"
  dnf_size=$(sudo du -sh /var/cache/dnf 2>/dev/null | cut -f1)
  echo "   Size : ${dnf_size:-unknown}"
  read -p "   🗑️  Clean? (y/n): " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] && sudo dnf clean all && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
  echo ""
fi

if [[ "$PKG_MANAGER" == "pacman" ]]; then
  echo "──────────────────────────────────────"
  echo "📦 Pacman Package Cache"
  pacman_size=$(sudo du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
  echo "   Size : ${pacman_size:-unknown}"
  read -p "   🗑️  Clean (keep last 2 versions)? (y/n): " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] && sudo paccache -rk2 && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
  echo ""
fi

# ── Tool-managed caches ───────────────────

if command -v npm &>/dev/null; then
  echo "──────────────────────────────────────"
  echo "📦 npm Cache (managed by npm)"
  npm_path=$(npm config get cache 2>/dev/null)
  npm_size=$(du -sh "$npm_path" 2>/dev/null | cut -f1)
  echo "   Size : ${npm_size:-run 'npm cache verify' to check}"
  read -p "   🗑️  Clean? (y/n): " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] && npm cache clean --force 2>/dev/null && echo "   ✔️  Done." || echo "   ⏭️  Skipped."
  echo ""
fi

if command -v snap &>/dev/null; then
  echo "──────────────────────────────────────"
  echo "📦 Snap — Old Revisions"
  snap_size=$(sudo du -sh /var/lib/snapd/snaps 2>/dev/null | cut -f1)
  echo "   Size : ${snap_size:-unknown}"
  read -p "   🗑️  Remove old snap revisions? (y/n): " answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
      sudo snap remove "$snapname" --revision="$revision" 2>/dev/null
    done
    echo "   ✔️  Done."
  else
    echo "   ⏭️  Skipped."
  fi
  echo ""
fi

# ── Summary ───────────────────────────────

after=$(df -h / | awk 'NR==2 {print $4}')
echo "╔══════════════════════════════════════╗"
echo "║              SUMMARY                 ║"
echo "╠══════════════════════════════════════╣"
printf "║  Free before : %-23s║\n" "$before"
printf "║  Free after  : %-23s║\n" "$after"
echo "╚══════════════════════════════════════╝"
echo ""