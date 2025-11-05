# Changelog

All notable changes to the DiskClean skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-05

### 🎉 Initial Release

#### Added
- **Core Analysis Engine**
  - Full drive and folder space analysis
  - Automatic categorization of space consumers
  - Support for Windows, macOS, and Linux

- **Smart Detection**
  - Duplicate file detection (installers, archives, numbered files)
  - Development artifacts (node_modules, build outputs, venv)
  - Game installations (VALORANT, League of Legends, Epic Games)
  - Large media files detection
  - Temporary and cache files

- **Interactive Workflow**
  - Natural language command support
  - Numbered command shortcuts
  - Progressive detail disclosure (3 levels)
  - Hybrid interaction model

- **Safety Features**
  - Explicit confirmation before deletion
  - Clear explanations of what will be deleted
  - Protected patterns (system files, recent files, documents)
  - Post-deletion verification
  - Remnant detection and cleanup

- **User Experience**
  - Live progress updates during deletion
  - Before/after space comparison
  - Auto-selected "Quick Wins" for fast cleanup
  - Comprehensive error handling

- **Platform Scripts**
  - `analyze-windows.ps1` - Windows space analyzer
  - `analyze-unix.sh` - macOS/Linux analyzer
  - `find-duplicates.ps1` - Duplicate detector
  - `find-dev-artifacts.ps1` - Dev artifacts finder

#### Documentation
- Comprehensive README with examples
- Installation guide
- Usage guide
- Contributing guidelines
- MIT License

#### Supported Platforms
- Windows (PowerShell-based)
- macOS (Bash-based)
- Linux (Bash-based)

---

## [Unreleased]

### Planned Features
- Browser cache detection and cleanup
- Duplicate file detection by hash (not just name)
- Visual disk usage map/chart
- Scheduled cleanup recommendations
- Compression suggestions for large files
- Cloud storage migration suggestions
- Windows Storage Sense integration
- macOS Time Machine exclusion support

### Under Consideration
- Docker image cache cleanup
- Git repository optimization (.git/objects)
- IDE cache cleanup (VS Code, JetBrains)
- Package manager cache (npm, pip, cargo)
- Video game shader caches
- AI model cache detection (Stable Diffusion, etc.)

---

## Version History

### Version Format

- **Major.Minor.Patch** (e.g., 1.0.0)
  - **Major**: Breaking changes or major new features
  - **Minor**: New features, backward compatible
  - **Patch**: Bug fixes and small improvements

### Change Categories

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes

---

## Support

For issues or questions about specific versions:
- Check the [Issues](https://github.com/yourusername/diskclean-claude-skill/issues) page
- Create a new issue with version tag
- Include version info: Check `.claude-plugin/marketplace.json`

---

*Keep your changelog updated with each release!*
