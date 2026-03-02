# 🧹 safe-cleanup-toolkit

Interactive storage cleanup scripts for **macOS** and **Linux**. Each script shows the size of junk/cache locations and asks before deleting — **nothing is removed without your confirmation.**

---

## 📁 Repository Structure

```
safe-cleanup-toolkit/
├── mac_cleanup.sh       # Cleanup script for macOS
├── linux_cleanup.sh     # Cleanup script for Linux
├── docs/
│   ├── README-mac.md    # macOS script documentation
│   └── README-linux.md  # Linux script documentation
└── README.md
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/neps-in/safe-cleanup-toolkit.git
cd safe-cleanup-toolkit
```

**macOS:**

```bash
chmod +x mac_cleanup.sh && ./mac_cleanup.sh
```

**Linux:**

```bash
chmod +x linux_cleanup.sh && ./linux_cleanup.sh
```

## 📖 Scripts

### 🍎 macOS — `mac_cleanup.sh`

Cleans User/System Logs, Xcode artifacts, pip, CocoaPods, Gradle, Maven, npm, and Homebrew.

→ [Full documentation](docs/readme-mac.md)

---

### 🐧 Linux — `linux_cleanup.sh`

Cleans user cache, thumbnails, trash, pip, npm, Gradle, Maven, Go, Cargo, journal logs, and package manager caches (apt / dnf / pacman). Also handles Snap, Flatpak, and Docker.

→ [Full documentation](docs/readme-linux.md)
