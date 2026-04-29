---
name: setup-project
description: One-command project bootstrap. USES init-project.sh SCRIPT - does NOT manually modify files.
---

# Setup Project Skill

## ⚠️ CRITICAL: DO NOT MANUALLY MODIFY PROJECT FILES

This skill **MUST** use the installation script. **NEVER** manually:
- Delete project files
- Overwrite existing files without backup
- Remove directories

## Correct Execution Flow

**When user runs `/setup-project`:**

1. **Check if init-project.sh exists** in project root
2. **If YES**: Run the script: `bash init-project.sh` or `./init-project.sh`
3. **If NO**: Download and run: `curl -fsSL https://raw.githubusercontent.com/89simpson/qwen-code-starter/master/scripts/init-project.sh | bash`
4. **Let the script handle everything** - it has proper backup and merge logic

## When to Use

- Starting a new project
- Adding framework to existing project
- Migrating from Claude Code Starter
- Upgrading framework version

## Procedures (FOR SCRIPT REFERENCE ONLY)

The init-project.sh script handles these procedures automatically. **DO NOT execute these manually!**

### Safety Rules

1. **ALWAYS use init-project.sh** - never manual file operations
2. **ALWAYS create backup** before modifying existing files
3. **NEVER delete** user data, source code, or project files
4. **ALWAYS merge** - don't overwrite QWEN.md if it exists
5. **PRESERVE** .git/, src/, tests/, and all user directories

### Error Recovery

If files were accidentally deleted:

1. **Stop immediately**
2. **Check git**: `git status` and `git restore .` if in git repo
3. **Check backup**: Look for `.qwen/backup-*` or `*.backup` files
4. **Restore from git**: `git checkout HEAD -- <deleted-files>`
5. **Report error**: Tell user what happened and offer recovery options

### New Project

1. **Detect Project State**
   - Check for existing files
   - Determine if git repo exists
   - Identify project type signals

2. **Determine Project Type**
   - **Code**: src/, package.json, pyproject.toml, *.py, *.js, *.ts
   - **Content**: chapters/, modules/, articles/, *.md files
   - **Hybrid**: Both code and content signals
   - **Unknown**: Too few signals, default to code

3. **Apply Templates**
   - Copy appropriate QWEN.md template
   - Install rules for project type
   - Install skills for project type
   - Install agents for project type

4. **Configure Settings**
   - Create .qwen/settings.json
   - Configure hooks
   - Set permissions

5. **Initialize Git** (if needed)
   ```bash
   git init
   git add .
   git commit -m "feat: initialize qwen-code-starter framework"
   ```

### Existing Project

1. **Analyze Current State**
   - Check for existing .qwen/ directory
   - Check for QWEN.md or CLAUDE.md
   - Identify what's missing

2. **Backup Existing Files**
   - Create .qwen/backup-TIMESTAMP/
   - Save QWEN.md, settings.json, etc.

3. **Merge Configuration**
   - Merge QWEN.md with template
   - Merge settings.json hooks
   - Add missing rules/skills/agents

4. **Update Framework**
   - Copy new/updated files
   - Preserve customizations
   - Report conflicts

### Migration from Claude Code Starter

1. **Detect Legacy Markers**
   - .claude/ directory
   - CLAUDE.md file
   - Legacy commands/

2. **Convert Structure**
   - .claude/ → .qwen/
   - CLAUDE.md → QWEN.md
   - Nested agents → flat structure

3. **Adapt Skills**
   - Remove allowed-tools from frontmatter
   - Remove disable-model-invocation
   - Update hook references

4. **Update Hooks**
   - PreCompact → PreCompact
   - PostCompact → Remove (not supported)
   - PostToolUse → PostToolUse
   - SubagentStop → SubagentStop

## Checklists

### New Project Checklist
- [ ] Project type detected
- [ ] QWEN.md created
- [ ] Rules installed
- [ ] Skills installed
- [ ] Agents installed
- [ ] Settings configured
- [ ] Git initialized
- [ ] .qwenignore created

### Migration Checklist
- [ ] Legacy markers found
- [ ] Backup created
- [ ] Structure converted
- [ ] Skills adapted
- [ ] Hooks updated
- [ ] QWEN.md merged
- [ ] Rollback available

## Commands

### Interactive Mode
```
User: "Set up this project"
You: "I'll initialize Qwen Code Starter. Detected: code project. Applying templates..."
```

### Direct Command
```
/setup-project
```

### With Options
```
/setup-project --type content --content-type book
```

## Project Type Heuristics

### Code Signals
- Directories: src/, lib/, app/, components/, tests/
- Files: package.json, pyproject.toml, Cargo.toml, go.mod, *.py, *.js, *.ts, *.go, *.rs
- Ratio: >70% code files

### Content Signals
- Directories: chapters/, modules/, lessons/, articles/, docs/, content/
- Files: INDEX.md, *.md (many), book.json
- Ratio: >70% markdown files

### Hybrid Signals
- Both code and content directories
- Both code and content files
- Neither ratio >70%

## Error Handling

### Conflict Detection
If QWEN.md merge has conflicts:
1. Stop installation
2. Create .qwen/QWEN.md.merge-proposal.md
3. Report: "Hard conflict detected. See proposal."
4. Offer: --apply-proposal or --rollback

### Missing Template
If template not found:
1. Fall back to default template
2. Log warning
3. Continue installation

### Git Issues
If git operations fail:
1. Log error
2. Continue without git
3. Report manual steps needed

## Output Format

### Success
```
✓ Qwen Code Starter v1.0.0 installed

Project: my-project
Type: code
Content Type: n/a

Installed:
- QWEN.md
- 7 rules
- 6 skills
- 3 agents
- 4 hooks

Next: Open project in Qwen Code and run /start
```

### Migration Success
```
✓ Migrated from Claude Code Starter

Backup: .qwen/backup-20260429-120000
Converted:
- .claude/ → .qwen/
- CLAUDE.md → QWEN.md
- 3 agents (flat structure)
- 6 skills (adapted)

Next: Review QWEN.md and run /start
```

### Conflict
```
✗ Hard conflict in QWEN.md

Proposal: .qwen/QWEN.md.merge-proposal.md

Options:
- Review proposal and run: init-project.sh --apply-proposal
- Rollback: init-project.sh --rollback
- Manual: Edit QWEN.md based on proposal
```

## Examples

### Example 1: New Code Project

**User:** "Set up this project"

**You:**
```
Analyzing project structure...
Detected: code project (package.json, src/, tests/)

Installing Qwen Code Starter v1.0.0...
✓ Created: QWEN.md
✓ Created: .qwen/settings.json
✓ Installed: 7 rules
✓ Installed: 6 skills
✓ Installed: 3 agents
✓ Initialized: git

Ready! Run /start to begin.
```

### Example 2: Content Project Migration

**User:** "Migrate this Claude Code project"

**You:**
```
Detecting legacy markers...
Found: .claude/, CLAUDE.md

Creating backup: .qwen/backup-20260429-120000
Converting structure...
✓ Renamed: .claude/ → .qwen/
✓ Merged: CLAUDE.md → QWEN.md
✓ Adapted: 6 skills
✓ Converted: 3 agents

Migration complete!
```

### Example 3: Hybrid Project

**User:** "/setup-project"

**You:**
```
Analyzing project...
Detected: hybrid project (src/ + chapters/)
Applying: content templates (broader scope)

Installing framework...
✓ QWEN.md (content template)
✓ 12 rules (code + content)
✓ 13 skills (code + content)
✓ 7 agents (all types)

Hybrid mode active!
```

## Troubleshooting

### "Project type detected incorrectly"
Override with: `--type code|content|hybrid`

### "Skills not appearing"
Check: `.qwen/skills/` directory exists
Verify: SKILL.md has valid frontmatter

### "Agents not working"
Check: `.qwen/agents/` directory exists
Verify: agent.md has valid frontmatter with tools:

### "Hooks not firing"
Check: settings.json has hooks section
Verify: hook scripts are executable: `chmod +x .qwen/hooks/*.sh`

## Related Skills

- `/start` - Initialize session after setup
- `/housekeeping` - Maintain project after setup
- `research` - Investigate project structure
