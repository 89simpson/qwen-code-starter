# Changelog

All notable changes to Qwen Code Starter will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### Windows/PowerShell Support
- Full PowerShell support for Windows environments
- PowerShell 5.1 and PowerShell 7+ compatibility
- Native Windows path handling with proper separator support (`\`)

#### PowerShell Scripts
- `scripts/init-project.ps1` - Bootstrap installer for Windows
- `scripts/migrate.ps1` - Migration from Claude Code Starter for Windows
- `scripts/install-global.ps1` - Global installation for Windows
- `scripts/switch-repo-access.ps1` - Repository access mode switcher for Windows
- `scripts/framework-state-mode.ps1` - Framework state checker for Windows
- `scripts/lib/install_common.ps1` - Shared installation utilities for PowerShell

#### PowerShell Hooks
- `.qwen/hooks/pre-compact.ps1` - Pre-compact hook for Windows
- `.qwen/hooks/post-tool-use.ps1` - Post-tool-use hook for Windows
- `.qwen/hooks/post-tool-use-failure.ps1` - Post-tool-use-failure hook for Windows
- `.qwen/hooks/subagent-stop.ps1` - Subagent-stop hook for Windows

#### Documentation
- Windows installation instructions in README.md
- PowerShell script usage examples
- Execution policy guidance for Windows users
- Cross-platform script comparison table

### Changed

#### Scripts
- All PowerShell scripts use proper error handling with try/catch
- PowerShell scripts use Write-Host with colors for consistent output
- Path operations use PowerShell-native cmdlets for cross-platform compatibility

## [1.0.0] - 2026-04-29

### Added

#### Core Framework
- Initial release of Qwen Code Starter
- Complete project structure with templates for code and content projects
- Automatic project type detection (code/content/hybrid)
- Main installer (`init-project.sh`) with interactive setup

#### Scripts
- `scripts/init-project.sh` - Bootstrap with auto-detection
- `scripts/migrate.sh` - Migration from Claude Code Starter projects
- `scripts/install-global.sh` - Global installation to `~/.qwen/`
- `scripts/switch-repo-access.sh` - Toggle repository access modes
- `scripts/framework-state-mode.sh` - Check framework state
- `scripts/lib/install_common.sh` - Shared installation utilities
- `scripts/lib/merge_qwen_md.py` - QWEN.md merge utility

#### Code Project Templates
- `QWEN.md` - Project passport for code projects
- 7 rules (autonomy, delegation, context-management, production-safety, local-first, logging, commit-policy)
- 6 skills (start, finish, testing, db-migrate, housekeeping, research)
- 3 agents (researcher, implementer, reviewer)

#### Content Project Templates
- `QWEN.md` - Project passport for content projects
- 5 rules (content-pipeline, content-quality, source-management, content-formats, content-commit-policy)
- 7 skills (research, outline, write-content, review-content, enrich, content-index, housekeeping)
- 4 agents (researcher, writer, editor, reviewer)
- 5 content templates (chapter, lesson, article, document, transcript)

#### Qwen Configuration
- `.qwen/hooks/` - 4 hook scripts (pre-compact, post-tool-use, post-tool-use-failure, subagent-stop)
- Support for PreCompact, PostToolUse, PostToolUseFailure, SubagentStop hooks

#### Testing
- `tests/test-merge-qwen-md.py` - Test suite for merge utility (20 tests)

### Changed

#### From Claude Code Starter
- Renamed `.claude/` directory to `.qwen/`
- Renamed `CLAUDE.md` to `QWEN.md`
- Replaced `manifest.md` with permissions in `settings.json` + `.qwenignore`
- Converted nested agent structure to flat (`.qwen/agents/name.md`)
- Removed `allowed-tools` and `disable-model-invocation` from skills frontmatter
- Removed `PostCompact` hook (not supported by Qwen Code)
- Added `PostToolUseFailure` hook support

#### Bug Fixes
- **migrate.sh**: Fixed hooks migration to update nested hook structure in settings.json
- **migrate.sh**: Changed from `mv` to `cp` for cross-filesystem support
- **migrate.sh**: Added target directory creation (mkdir -p)
- **init-project.sh**: Fixed hybrid project template detection (uses code + content templates)

### Technical Details

#### Agent Format
```markdown
---
name: agent-name
description: Role description
color: automatic color
tools:
  - read_file
  - write_file
  - edit
  - task
---

# Agent Role
...
```

#### Skill Format
```markdown
---
name: skill-name
description: What it does and when to use
---

# Skill Name
...
```

#### Hook Configuration
```json
{
  "hooks": {
    "PreCompact": [...],
    "PostToolUse": [...],
    "PostToolUseFailure": [...],
    "SubagentStop": [...]
  }
}
```

### Documentation
- Complete README with installation, structure, and usage guides
- Project type detection documentation
- Migration guide from Claude Code Starter
- Repository access modes documentation
- Differences table from Claude Code Starter

[1.0.0]: https://github.com/89simpson/qwen-code-starter/releases/tag/v1.0.0
