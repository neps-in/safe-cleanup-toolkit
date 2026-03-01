# 🧹 macOS Storage Cleanup Script

A safe, interactive Bash script to free up disk space on macOS by cleaning caches, logs, and development tool artifacts — with a **size preview and y/n confirmation before deleting anything**.

---

## ✨ Features

- 📊 Shows the **size of each directory** before deleting
- ✅ **Asks for confirmation** (y/n) for every section — nothing is deleted silently
- 💾 Displays **free space before and after** cleanup
- ⚙️ Handles both **manual paths** and **tool-managed caches** (npm, Homebrew)
- 🔒 Skips directories that don't exist on your machine

---

## 📦 What It Cleans

| Section                 | Path                                            | Notes                                     |
| ----------------------- | ----------------------------------------------- | ----------------------------------------- |
| User Cache              | `~/Library/Caches/*`                            | Regenerated automatically by apps         |
| User Logs               | `~/Library/Logs/*`                              | App log files                             |
| System Logs             | `/private/var/log/*`                            | Requires `sudo`                           |
| Trash                   | `~/.Trash/*`                                    | Empties the bin                           |
| Xcode DerivedData       | `~/Library/Developer/Xcode/DerivedData/*`       | Rebuilt on next compile                   |
| Xcode iOS DeviceSupport | `~/Library/Developer/Xcode/iOS DeviceSupport/*` | Can be **10GB+**, re-downloaded if needed |
| Xcode Archives          | `~/Library/Developer/Xcode/Archives/*`          | Old build archives                        |
| pip Cache               | `~/Library/Caches/pip/*`                        | Python package cache                      |
| CocoaPods Cache         | `~/Library/Caches/CocoaPods/*`                  | iOS dependency cache                      |
| Gradle Cache            | `~/.gradle/caches/*`                            | Android build cache                       |
| Maven Cache             | `~/.m2/repository/*`                            | Java dependency cache                     |
| npm Cache               | managed by npm                                  | Cleaned via `npm cache clean --force`     |
| Homebrew Cache          | managed by brew                                 | Cleaned via `brew cleanup --prune=all`    |

---

## 🚀 Usage

### 1. Download or create the script

Save the script as `cleanup.sh`.

### 2. Make it executable

```bash
chmod +x cleanup.sh
```

### 3. Run it

```bash
./cleanup.sh
```

### 4. Follow the prompts

For each section you'll see:

```
──────────────────────────────────────
📁 User Cache
   Path : /Users/yourname/Library/Caches
   Size : 3.2G

   🗑️  Delete? (y/n):
```

Type `y` to delete or `n` to skip. At the end you'll see a summary:

```
╔══════════════════════════════════════╗
║              SUMMARY                 ║
╠══════════════════════════════════════╣
║  Free before : 24Gi
║  Free after  : 31Gi
╚══════════════════════════════════════╝
```

---

## ⚠️ Important Notes

- **System logs** require `sudo` — you'll be prompted for your password
- **Do NOT manually delete** `/private/var/vm/` (swap/paging files) — macOS manages these automatically
- Xcode DeviceSupport files will be **re-downloaded** by Xcode if connected to a device running that iOS version
- Maven and Gradle caches will be **re-downloaded** on next build
- It is safe to re-run this script anytime

---

## 🛑 What This Script Does NOT Touch

- `~/Library/Application Support/` — app data and settings
- `~/Library/Preferences/` — app preferences
- `/System/` — macOS system files
- `/Library/` — root-level system libraries
- `/private/var/vm/` — swap and paging files

---

## 🔧 Requirements

| Tool         | Required    | Notes                             |
| ------------ | ----------- | --------------------------------- |
| macOS        | ✅          | Tested on macOS Ventura / Sonoma  |
| Bash         | ✅          | Pre-installed on macOS            |
| sudo access  | ✅          | For system log cleanup only       |
| Xcode        | ❌ Optional | Sections skipped if not installed |
| Homebrew     | ❌ Optional | Sections skipped if not installed |
| Node / npm   | ❌ Optional | Sections skipped if not installed |
| Python / pip | ❌ Optional | Sections skipped if not installed |

---

## 📄 License

MIT — free to use, modify, and distribute.
