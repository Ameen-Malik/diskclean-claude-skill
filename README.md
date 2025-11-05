# 🧹 DiskClean - Claude Code Skill

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/Ameen-Malik/diskclean-claude-skill)
[![Claude Code](https://img.shields.io/badge/claude--code-skill-purple)](https://docs.claude.com/en/docs/claude-code/skills)

> **A professional disk space analyzer and cleanup skill for Claude Code**
> Automatically identify and safely remove unnecessary files to free up storage space.

---

## ✨ Features

- 🔍 **Comprehensive Analysis** - Scans drives and folders to identify space consumers
- 🎯 **Smart Detection** - Auto-detects duplicates, node_modules, temp files, old installers, and game installations
- 💬 **Natural Language** - Interactive cleanup using conversational commands
- ✅ **Safety First** - Always confirms before deletion with clear explanations
- 📊 **Live Progress** - Real-time progress updates during deletion
- 🌐 **Cross-Platform** - Works on Windows, macOS, and Linux
- ⚡ **Quick Wins** - Auto-selects obvious duplicates for fast cleanup

---

## 🚀 Quick Start

### Installation (2 commands)

```bash
# 1. Add the marketplace in Claude Code
/plugin marketplace add Ameen-Malik/diskclean-claude-skill

# 2. Install the skill
/plugin install diskclean
```

### Usage (Just ask!)

```bash
# In Claude Code, simply type:
"Clean up my D drive"
"Analyze space on C:"
"What's taking up space in Downloads?"
"Free up storage"
```

That's it! The skill activates automatically when you mention disk cleanup.

---

## 📖 How It Works

### 1. **Analysis Phase**
DiskClean scans your target drive/folder and categorizes findings:

```
═══════════════════════════════════════════════════════
DISK ANALYSIS COMPLETE
═══════════════════════════════════════════════════════

Drive Status: D:\
├─ Total: 131.67 GB
├─ Used: 128.69 GB
└─ Free: 2.98 GB (2.3%) ⚠️ CRITICALLY LOW

Found 54.5 GB of reclaimable space!

───────────────────────────────────────────────────────
🎯 QUICK WINS (Auto-selected ✓)
───────────────────────────────────────────────────────
✓ [1] Duplicate PostgreSQL installer (341 MB)
✓ [2] Old Cursor installer (106 MB)
✓ [3] Temp files (85 MB)
    Total: 532 MB

───────────────────────────────────────────────────────
📦 LARGE ITEMS (Review recommended)
───────────────────────────────────────────────────────
⬜ [4] VALORANT game (52.97 GB)
⬜ [5] node_modules x3 (1.2 GB)
⬜ [6] Recovery folder (6.15 GB)
```

### 2. **Interactive Selection**
Choose what to delete using natural language or numbered commands:

```bash
# Natural language
"Show me details about VALORANT"
"Delete all duplicates"
"Remove node_modules but keep the games"

# Numbered commands
"select 4"      # Mark item 4
"details 3"     # Show item 3 info
"delete 1,2,5"  # Select multiple

# Shortcuts
"dd"   = delete all
"d4"   = details 4
"s4"   = select 4
"go"   = proceed
```

### 3. **Safe Deletion**
Review and confirm before any deletion:

```
⚠️  FINAL CONFIRMATION

Ready to delete:
• VALORANT game (52.97 GB)
• Duplicate installers (532 MB)

D: 2.98GB → 56.5GB free (42.9%)

⚠️  This action cannot be undone!
✅ Cloud-saved data (VALORANT account) will not be affected

Type "yes" to proceed (or "cancel" to abort):
```

### 4. **Execution & Verification**
Live progress with post-deletion verification:

```
🗑️  Deleting selected items...

[1/2] Deleting duplicate installers... ✓ (532 MB freed)
[2/2] Deleting VALORANT...
      Progress: ████████████░░░░ 80% (42.4/52.97 GB)

✅ CLEANUP COMPLETE!

Summary:
├─ Deleted: 53.5 GB
├─ Files removed: 1,247 files
└─ Duration: 2m 34s

Drive Status: D:\
├─ Free space: 56.5 GB (was 2.98 GB)
└─ Freed: 53.52 GB ✨
```

---

## 🎯 What It Detects

### Quick Wins (Auto-selected)
- ✅ Duplicate installers (PostgreSQL, VS Code, etc.)
- ✅ Numbered duplicates (`file (1).txt`, `file (2).txt`)
- ✅ Temporary cache files
- ✅ Old installer backups

### Large Items (User Review)
- 🎮 Game installations (VALORANT, League of Legends, Steam games)
- 📦 `node_modules` directories (can regenerate with `npm install`)
- 🔨 Build outputs (`dist/`, `build/`, `.next/`, `target/`)
- 🎬 Large media files (videos >100MB)
- 📥 Old downloads and installers
- 🗂️ Recovery/backup folders

### Protected (Never Suggests)
- 🚫 System folders (Windows, Program Files, System32)
- 🚫 Active project files
- 🚫 Documents, Photos, Desktop (analyzes only)
- 🚫 Recently modified files (<7 days)

---

## 💡 Usage Examples

### Example 1: Quick Duplicate Cleanup
```
You: "diskclean D:"
Skill: [Finds 681MB of duplicate installers auto-selected]
You: "delete quick wins"
Skill: "Type 'yes' to delete 681MB"
You: "yes"
✨ Freed 681MB in 5 seconds!
```

### Example 2: Major Drive Cleanup
```
You: "My C drive is full, help me clean it up"
Skill: [Analyzes C:, finds games, node_modules, duplicates]
You: "Show me details about VALORANT"
Skill: [Shows 53GB game, explains cloud-saved data]
You: "Remove VALORANT and all node_modules"
Skill: [Selects items, shows 54GB to free]
You: "proceed"
You: "yes"
✨ Freed 54GB! Drive went from 2% to 42% free!
```

### Example 3: Folder-Specific Cleanup
```
You: "What's taking up space in my Downloads?"
Skill: [Analyzes Downloads, shows large files]
You: "Delete all exe and msi files but keep videos"
Skill: [Selects installers only]
You: "yes"
✨ Removed 15 old installers, freed 2.3GB!
```

---

## 🛡️ Safety Features

- ✅ **No surprises** - Always shows exactly what will be deleted
- ✅ **Explicit confirmation** - Requires typing "yes" to proceed
- ✅ **Smart protection** - Won't suggest deleting system/important files
- ✅ **Clear explanations** - Tells you what each item is and if it's safe
- ✅ **Recovery info** - Explains what's cloud-saved vs. permanent
- ✅ **Error handling** - Gracefully handles locked files and permissions
- ✅ **Verification** - Scans for remnants after deletion

---

## 🔧 Platform Support

| Platform | Support | Script Used |
|----------|---------|-------------|
| Windows  | ✅ Full | PowerShell |
| macOS    | ✅ Full | Bash |
| Linux    | ✅ Full | Bash |

---

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md) - Detailed installation steps
- [Usage Guide](docs/USAGE.md) - Comprehensive usage examples
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

**Ways to contribute:**
- 🐛 Report bugs via [Issues](https://github.com/Ameen-Malik/diskclean-claude-skill/issues)
- 💡 Suggest features
- 📝 Improve documentation
- 🔧 Submit pull requests

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built for the [Claude Code](https://claude.com/claude-code) community
- Inspired by the need for safe, automated disk cleanup
- Thanks to all contributors and users!

---

## ⭐ Show Your Support

If this skill helped you free up space, please:
- ⭐ Star this repository
- 🐦 Share on social media with #ClaudeCode
- 🗣️ Tell your team about it

---

## 📞 Support

- 📖 [Documentation](docs/)
- 🐛 [Report Issues](https://github.com/Ameen-Malik/diskclean-claude-skill/issues)
- 💬 [Discussions](https://github.com/Ameen-Malik/diskclean-claude-skill/discussions)

---

**Made with ❤️ for the Claude Code community**

*Keep your drives clean and your workflows fast!* 🚀

