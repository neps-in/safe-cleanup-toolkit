# 🧹 Linux Storage Cleanup Script

An interactive, terminal-based storage cleanup tool for Linux. Scans common cache and junk locations, shows their size, and asks before deleting anything — nothing is removed without your confirmation.

---

## ✨ Features

- ✅ **Interactive prompts** — confirm every deletion individually
- 💾 **Before/after free space** summary
- 🔍 **Auto-detects** your package manager (apt / dnf / pacman)
- 📦 Handles both **user-level** and **system-level** caches
- 🛠️ Cleans **tool-managed** caches (npm, pip, snap, flatpak, docker)
- 🔒 Uses `sudo` only where strictly necessary

---

## 📋 What It Cleans

### User Caches

| Target             | Path                   |
| ------------------ | ---------------------- |
| General user cache | `~/.cache/*`           |
| Thumbnail cache    | `~/.cache/thumbnails`  |
| User logs          | `~/.local/share/logs`  |
| Trash              | `~/.local/share/Trash` |

### Developer Caches

| Target       | Path                      |
| ------------ | ------------------------- |
| pip          | `~/.cache/pip`            |
| npm          | `$(npm config get cache)` |
| Gradle       | `~/.gradle/caches`        |
| Maven        | `~/.m2/repository`        |
| Go modules   | `~/go/pkg/mod/cache`      |
| Cargo (Rust) | `~/.cargo/registry/cache` |

### System (requires sudo)

| Target                               | Method                                  |
| ------------------------------------ | --------------------------------------- |
| Journal logs                         | `journalctl --vacuum-time=7d`           |
| Compressed log files (`*.gz`, `*.1`) | `find /var/log`                         |
| APT package cache                    | `apt-get clean && autoremove`           |
| DNF package cache                    | `dnf clean all`                         |
| Pacman package cache                 | `paccache -rk2` (keeps last 2 versions) |

### App Runtimes

| Target                  | Method                              |
| ----------------------- | ----------------------------------- |
| Snap old revisions      | Removes all disabled snap revisions |
| Flatpak unused runtimes | `flatpak uninstall --unused`        |
| Docker build cache      | `docker system prune -f`            |

---

## 🚀 Usage

```bash
# Make executable
chmod +x linux_cleanup.sh

# Run
./linux_cleanup.sh
```

At each step you'll see the target path, its current size, and a `y/n` prompt:

```
──────────────────────────────────────
📁 User Cache (~/.cache)
   Path : /home/user/.cache
   Size : 1.2G

   🗑️  Delete? (y/n):
```

---

## ⚙️ Requirements

- Bash 4+
- `sudo` access for system-level cleanups
- Optional tools (skipped gracefully if not installed): `npm`, `docker`, `snap`, `flatpak`, `paccache`

---

## ⚠️ Notes

- **Nothing is deleted without your explicit `y` confirmation.**
- Pacman cleanup uses `paccache` (from `pacman-contrib`) — install it with `sudo pacman -S pacman-contrib` if missing.
- Docker cleanup uses `docker system prune` which removes **all** stopped containers, dangling images, and unused networks — not just the build cache.
- Journal cleanup removes logs older than **7 days**. Edit `--vacuum-time=7d` in the script to change the retention window.

---

## 🖥️ Also Available

A **macOS** version of this script is available with equivalent functionality for macOS-specific paths (`~/Library/Caches`, Xcode artifacts, Homebrew, etc.).

---

## 📄 License

MIT — free to use, modify, and distribute.
