# Qwen Code Starter - Global Layer

This directory contains templates for the global Qwen Code layer installed to `~/.qwen/`.

## Installation

Run the global installer:

```bash
./scripts/install-global.sh
```

This will:
1. Backup existing `~/.qwen/` to `~/.qwen/.backup-TIMESTAMP/`
2. Copy rules, skills, and agents to `~/.qwen/`
3. Merge settings.json hooks
4. Add setup-project skill

## What Gets Installed

### Skills
- `setup-project` - One-command project bootstrap
- `research` - Universal research skill
- `start` - Session initialization
- `finish` - Session completion
- `housekeeping` - Project maintenance

### Agents
- `researcher` - Research and investigation
- `implementer` - Code implementation
- `reviewer` - Code review
- `writer` - Content creation
- `editor` - Content editing

### Rules
- `autonomy.md` - Independent work guidelines
- `delegation.md` - Task delegation patterns
- `context-management.md` - Context optimization
- `production-safety.md` - Production safeguards
- `logging.md` - Logging standards

## Usage

After global installation, in any project say:
- "Set up this project" or
- "/setup-project"

The skill will:
1. Detect project type (code/content/hybrid)
2. Apply appropriate templates
3. Configure QWEN.md
4. Set up directory structure

## Rollback

To rollback to previous state:

```bash
./scripts/install-global.sh --rollback
```

This restores from the latest backup.

## File Locations

```
~/.qwen/
├── settings.json          # Merged with global hooks
├── skills/
│   ├── setup-project/     # Project bootstrap skill
│   ├── research/
│   ├── start/
│   ├── finish/
│   └── housekeeping/
├── agents/
│   ├── researcher.md
│   ├── implementer.md
│   ├── reviewer.md
│   ├── writer.md
│   └── editor.md
├── rules/
│   ├── autonomy.md
│   ├── delegation.md
│   ├── context-management.md
│   ├── production-safety.md
│   └── logging.md
└── QWEN.md               # Global context (preserved)
```

## Customization

After global installation, you can:
- Edit `~/.qwen/settings.json` for personal preferences
- Add custom skills to `~/.qwen/skills/`
- Modify rules in `~/.qwen/rules/`
- Create custom agents in `~/.qwen/agents/`

## Updates

To update global layer:

```bash
./scripts/install-global.sh --force
```

This updates all files while preserving your custom `QWEN.md`.
