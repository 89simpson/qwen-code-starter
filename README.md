# Qwen Code Starter

A comprehensive framework for configuring Qwen Code projects with best practices, reusable skills, agents, and automation hooks.

## Overview

Qwen Code Starter is an adaptation of Claude Code Starter, specifically designed for Qwen Code. It provides a complete set of templates, rules, skills, and agents to accelerate project setup and ensure consistent development practices.

## Installation

### Quick Start

Initialize a new project with automatic project type detection:

```bash
curl -fsSL https://raw.githubusercontent.com/qwen-code-starter/main/scripts/init-project.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/qwen-code-starter/qwen-code-starter.git
cd qwen-code-starter
```

2. Run the installer:
```bash
./init-project.sh
```

### Global Installation

Install framework templates globally to `~/.qwen/`:

```bash
./scripts/install-global.sh
```

## Project Structure

```
qwen-code-starter/
├── README.md              # This documentation
├── CHANGELOG.md           # Version history
├── init-project.sh        # Main installer
├── scripts/
│   ├── init-project.sh    # Bootstrap with auto-detection
│   ├── migrate.sh         # Migration from existing projects
│   ├── install-global.sh  # Global installation
│   ├── switch-repo-access.sh  # Toggle repository access mode
│   ├── framework-state-mode.sh  # Check framework state
│   ├── build-release.sh   # Build release package
│   ├── validate-release.sh # Validate release integrity
│   └── lib/
│       ├── install_common.sh  # Shared installation utilities
│       └── merge_qwen_md.py   # QWEN.md merge utility
├── templates/
│   ├── code/              # Software development projects
│   │   ├── QWEN.md        # Project passport
│   │   ├── rules/         # Development rules
│   │   ├── skills/        # Development skills
│   │   └── agents/        # Development agents
│   ├── content/           # Content creation projects
│   │   ├── QWEN.md        # Project passport
│   │   ├── rules/         # Content rules
│   │   ├── skills/        # Content skills
│   │   ├── agents/        # Content agents
│   │   └── content-templates/ # Content templates
│   └── global/            # Global layer templates
├── .qwen/
│   ├── settings.json      # Qwen Code settings template
│   ├── skills/            # Example skills
│   ├── agents/            # Example agents
│   └── hooks/             # Example hook scripts
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
- `PostToolUse` - After tool execution
- `PostToolUseFailure` - After tool failure
- `SubagentStop` - When subagent stops

**Note:** Qwen Code does not support `PostCompact` hooks.

## Differences from Claude Code Starter

| Feature | Claude Code Starter | Qwen Code Starter |
|---------|---------------------|-------------------|
| Config directory | `.claude/` | `.qwen/` |
| Project passport | `CLAUDE.md` | `QWEN.md` |
| Permissions | `manifest.md` | `settings.json` + `.qwenignore` |
| Agent structure | Nested directories | Flat (`.qwen/agents/name.md`) |
| Skills frontmatter | Includes `allowed-tools`, `disable-model-invocation` | Removed (Qwen doesn't use these) |
| Hooks | PreCompact, PostCompact, PostToolUse, SubagentStop | PreCompact, PostToolUse, PostToolUseFailure, SubagentStop (no PostCompact) |

## Migration

Migrate existing Claude Code Starter projects:

```bash
./scripts/migrate.sh /path/to/existing/project
```

This will:
- Convert `.claude/` to `.qwen/`
- Rename `CLAUDE.md` to `QWEN.md`
- Adapt skills frontmatter
- Convert agent structure to flat layout
- Update hook configurations

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

## Testing

Run the test suite:

```bash
python tests/test-merge-qwen-md.py
```

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please read CONTRIBUTING.md for guidelines.
