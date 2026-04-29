# Qwen Code Starter

A comprehensive framework for configuring Qwen Code projects with best practices, reusable skills, agents, and automation hooks.

## Overview

Qwen Code Starter is an adaptation of Claude Code Starter, specifically designed for Qwen Code. It provides a complete set of templates, rules, skills, and agents to accelerate project setup and ensure consistent development practices.

## Installation

### Quick Start

#### Linux/macOS (Bash)

Initialize a new project with automatic project type detection:

```bash
curl -fsSL https://raw.githubusercontent.com/89simpson/qwen-code-starter/master/scripts/init-project.sh | bash
```

#### Windows (PowerShell)

Initialize a new project on Windows:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/89simpson/qwen-code-starter/master/scripts/init-project.ps1" -OutFile init-project.ps1
.\init-project.ps1
```

### Manual Installation

#### Linux/macOS

1. Clone the repository:
```bash
git clone https://github.com/89simpson/qwen-code-starter.git
cd qwen-code-starter
```

2. Run the installer:
```bash
./init-project.sh
```

#### Windows

1. Clone the repository:
```powershell
git clone https://github.com/89simpson/qwen-code-starter.git
cd qwen-code-starter
```

2. Run the installer:
```powershell
.\init-project.ps1
```

### Global Installation

#### Linux/macOS

Install framework templates to `~/.qwen/`:

```bash
./scripts/install-global.sh
```

#### Windows

Install framework templates to `%USERPROFILE%\.qwen\`:

```powershell
.\scripts\install-global.ps1
```

### Migration from Claude Code Starter

#### Linux/macOS

Migrate existing Claude Code Starter projects:

```bash
./scripts/migrate.sh /path/to/existing/project
```

Or to a new directory:
```bash
./scripts/migrate.sh /path/to/source /path/to/target
```

#### Windows

Migrate existing Claude Code Starter projects:

```powershell
.\scripts\migrate.ps1 C:\path\to\existing\project
```

Or to a new directory:
```powershell
.\scripts\migrate.ps1 C:\path\to\source C:\path\to\target
```

## Project Structure

```
qwen-code-starter/
├── README.md              # This documentation
├── CHANGELOG.md           # Version history
├── init-project.sh        # Main installer (Bash)
├── init-project.ps1       # Main installer (PowerShell)
├── scripts/
│   ├── init-project.sh    # Bootstrap with auto-detection (Bash)
│   ├── init-project.ps1   # Bootstrap with auto-detection (PowerShell)
│   ├── migrate.sh         # Migration from Claude Code Starter (Bash)
│   ├── migrate.ps1        # Migration from Claude Code Starter (PowerShell)
│   ├── install-global.sh  # Global installation (Bash)
│   ├── install-global.ps1 # Global installation (PowerShell)
│   ├── switch-repo-access.sh  # Toggle repository access mode (Bash)
│   ├── switch-repo-access.ps1 # Toggle repository access mode (PowerShell)
│   ├── framework-state-mode.sh  # Check framework state (Bash)
│   ├── framework-state-mode.ps1 # Check framework state (PowerShell)
│   └── lib/
│       ├── install_common.sh  # Shared installation utilities (Bash)
│       ├── install_common.ps1 # Shared installation utilities (PowerShell)
│       └── merge_qwen_md.py   # QWEN.md merge utility
├── templates/
│   ├── code/              # Software development projects
│   │   ├── QWEN.md        # Project passport
│   │   ├── rules/         # 7 development rules
│   │   ├── skills/        # 6 development skills
│   │   └── agents/        # 3 development agents
│   ├── content/           # Content creation projects
│   │   ├── QWEN.md        # Project passport
│   │   ├── rules/         # 5 content rules
│   │   ├── skills/        # 7 content skills
│   │   ├── agents/        # 4 content agents
│   │   └── content-templates/ # 5 content templates
│   └── global/            # Global layer templates
├── .qwen/
│   └── hooks/             # 8 hook scripts (4 Bash + 4 PowerShell)
│       ├── pre-compact.sh
│       ├── pre-compact.ps1
│       ├── post-tool-use.sh
│       ├── post-tool-use.ps1
│       ├── post-tool-use-failure.sh
│       ├── post-tool-use-failure.ps1
│       ├── subagent-stop.sh
│       └── subagent-stop.ps1
└── tests/
    └── test-merge-qwen-md.py  # Merge utility tests
```

## Project Types

The framework supports three project types with automatic detection:

### Code Projects

Software development projects with:
- Development-focused rules (autonomy, testing, production safety)
- Technical skills (start, finish, db-migrate, testing)
- Development agents (researcher, implementer, reviewer)

### Content Projects

Content creation projects with:
- Content-focused rules (quality, source management, formats)
- Writing skills (research, outline, write, review, enrich)
- Content agents (researcher, writer, editor, reviewer)
- Content templates (chapters, lessons, articles, documents)

### Hybrid Projects

Projects with both code and content components:
- Combined rules from both types
- Full skill set from both types
- All agents available

## Key Components

### QWEN.md

The project passport that defines:
- Project type and goals
- Technology stack
- Development practices
- Project-specific constraints

### Rules

Project-specific guidelines that shape Qwen Code behavior:

**Code Projects:**
- `autonomy.md` - Independent problem solving
- `delegation.md` - Task delegation patterns
- `context-management.md` - Context window optimization
- `production-safety.md` - Production code safeguards
- `local-first.md` - Local development first
- `logging.md` - Logging standards
- `commit-policy.md` - Git commit conventions

**Content Projects:**
- `content-pipeline.md` - Content workflow
- `content-quality.md` - Quality standards
- `source-management.md` - Source citation
- `content-formats.md` - Format specifications
- `content-commit-policy.md` - Content versioning

### Skills

Reusable capabilities that Qwen Code can invoke:

**Code Skills:**
- `start` - Project initialization
- `finish` - Task completion checklist
- `testing` - Test execution
- `db-migrate` - Database migrations
- `housekeeping` - Code cleanup
- `research` - Technical research

**Content Skills:**
- `research` - Content research
- `outline` - Content structuring
- `write-content` - Content creation
- `review-content` - Content review
- `enrich` - Content enhancement
- `content-index` - Content organization
- `housekeeping` - Content cleanup

### Agents

Specialized AI personas for specific tasks:

**Code Agents:**
- `researcher.md` - Technical investigation
- `implementer.md` - Code implementation
- `reviewer.md` - Code review

**Content Agents:**
- `researcher.md` - Content research
- `writer.md` - Content creation
- `editor.md` - Content editing
- `reviewer.md` - Content review

### Hooks

Automation scripts triggered by Qwen Code events:

- `PreCompact` - Before context compaction
- `PostToolUse` - After tool execution (auto-updates SNAPSHOT.md)
- `PostToolUseFailure` - After tool failure
- `SubagentStop` - When subagent stops

**Note:** Qwen Code does not support `PostCompact` hooks.

### Automatic SNAPSHOT.md Updates

SNAPSHOT.md updates automatically after every git commit via post-commit hook.

**Install the hook:**
```bash
# macOS/Linux
bash scripts/install-git-hooks.sh

# Windows (PowerShell)
.\scripts\install-git-hooks.ps1
```

**What it tracks:**
- Last commit message and hash
- Total commit count
- Current branch
- Last activity timestamp

## Migration

Migrate existing Claude Code Starter projects:

```bash
./scripts/migrate.sh /path/to/existing/project
```

Or to a new directory (creates a copy):
```bash
./scripts/migrate.sh /path/to/source /path/to/target
```

Migration does:
- Copy `.claude/` to `.qwen/` (original preserved)
- Copy `CLAUDE.md` to `QWEN.md`
- Replace hooks with qwen-code-starter versions
- Update `settings.json` hook paths
- Flatten agent structure (nested → flat)
- Create `.qwenignore`
- Update markdown references
- Copy agents from templates (correct format)
- Migrate SNAPSHOT.md (preserve project knowledge)

## Updating Framework in Projects

Update existing projects with the latest framework files:

```bash
# Update current directory
./scripts/update-framework.sh

# Update specific project
./scripts/update-framework.sh /path/to/project

# Force overwrite all files (including scripts)
./scripts/update-framework.sh --force

# Dry run (show what would be updated)
./scripts/update-framework.sh --dry-run
```

**PowerShell (Windows):**
```powershell
.\scripts\update-framework.ps1
.\scripts\update-framework.ps1 -ProjectPath C:\path\to\project
.\scripts\update-framework.ps1 -Force
```

**What gets updated:**
- `.qwen/hooks/` - Hook scripts (bash + PowerShell)
- `templates/` - Project templates
- `.qwenignore` - Ignore patterns
- `scripts/` - Framework scripts (with `--force`)

**Manual Update from GitHub:**

```bash
# Download and run update script
curl -fsSL https://raw.githubusercontent.com/89simpson/qwen-code-starter/master/scripts/update-framework.sh | bash
```

## Differences from Claude Code Starter

| Feature | Claude Code Starter | Qwen Code Starter |
|---------|---------------------|-------------------|
| Config directory | `.claude/` | `.qwen/` |
| Project passport | `CLAUDE.md` | `QWEN.md` |
| Permissions | `manifest.md` | `settings.json` + `.qwenignore` |
| Agent structure | Nested directories | Flat (`.qwen/agents/name.md`) |
| Skills frontmatter | `allowed-tools`, `disable-model-invocation` | Removed (not supported) |
| Hooks | PreCompact, PostCompact, PostToolUse, SubagentStop | PreCompact, PostToolUse, PostToolUseFailure, SubagentStop |

## Repository Access Modes

Qwen Code Starter supports two repository access modes:

### Full Access (Default)

Qwen Code can read and write all files in the repository.

### Restricted Access

Use `.qwenignore` to restrict access to sensitive files:

```
# .qwenignore
.env
*.key
secrets/
```

Switch between modes:

```bash
./scripts/switch-repo-access.sh restricted
./scripts/switch-repo-access.sh full
```

Or on Windows:

```powershell
.\scripts\switch-repo-access.ps1 restricted
.\scripts\switch-repo-access.ps1 full
```

## Windows Support

Qwen Code Starter provides full support for Windows environments through PowerShell scripts.

### Requirements

- **PowerShell 5.1** or later (included with Windows 10/11)
- **PowerShell 7+** recommended for best experience

### Available PowerShell Scripts

All bash scripts have equivalent PowerShell versions:

| Bash Script | PowerShell Script | Description |
|-------------|-------------------|-------------|
| `init-project.sh` | `init-project.ps1` | Bootstrap installer |
| `migrate.sh` | `migrate.ps1` | Migration from Claude Code Starter |
| `install-global.sh` | `install-global.ps1` | Global installation |
| `switch-repo-access.sh` | `switch-repo-access.ps1` | Toggle repository access |
| `framework-state-mode.sh` | `framework-state-mode.ps1` | Check framework state |

### PowerShell Hooks

All hooks are available in both Bash and PowerShell formats:

- `pre-compact.ps1` - Before context compaction
- `post-tool-use.ps1` - After successful tool execution
- `post-tool-use-failure.ps1` - After tool failure
- `subagent-stop.ps1` - When subagent stops

### Path Handling

PowerShell scripts properly handle Windows path separators (`\`) and UNC paths. All file operations use PowerShell's native cmdlets for cross-platform compatibility.

### Running PowerShell Scripts

If you encounter execution policy errors, run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then run scripts normally:

```powershell
.\scripts\migrate.ps1 C:\path\to\project
```

## Testing

Run the test suite for the merge utility:

```bash
python3 tests/test-merge-qwen-md.py
```

## Version

Current version: **v1.0.0**

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please read CONTRIBUTING.md for guidelines.
