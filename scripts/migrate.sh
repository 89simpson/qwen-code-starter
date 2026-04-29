#!/usr/bin/env bash
#
# Qwen Code Starter - Migration Script
# Migrates Claude Code Starter projects to Qwen Code Starter
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR=""
TARGET_DIR=""
VERBOSE=false
DRY_RUN=false

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

usage() {
    cat << EOF
Qwen Code Starter - Migration Tool

Migrates Claude Code Starter projects to Qwen Code Starter format.

Usage: $(basename "$0") [OPTIONS] <SOURCE_DIR> [TARGET_DIR]

Options:
    -v, --verbose     Enable verbose output
    -n, --dry-run     Show what would be done without making changes
    -h, --help        Show this help message

Arguments:
    SOURCE_DIR        Path to existing Claude Code Starter project
    TARGET_DIR        Path for migrated project (default: SOURCE_DIR)

Examples:
    $(basename "$0") /path/to/claude-project
    $(basename "$0") /path/to/claude-project /path/to/qwen-project
    $(basename "$0") -n -v /path/to/claude-project

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *)
                if [[ -z "$SOURCE_DIR" ]]; then
                    SOURCE_DIR="$1"
                elif [[ -z "$TARGET_DIR" ]]; then
                    TARGET_DIR="$1"
                else
                    log_error "Too many arguments"
                    usage
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$SOURCE_DIR" ]]; then
        log_error "SOURCE_DIR is required"
        usage
    fi

    TARGET_DIR="${TARGET_DIR:-$SOURCE_DIR}"
}

# Check if source is a Claude Code Starter project
check_source() {
    log_info "Checking source directory: $SOURCE_DIR"

    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_error "Source directory does not exist: $SOURCE_DIR"
        exit 1
    fi

    local has_claude=false

    if [[ -d "$SOURCE_DIR/.claude" ]]; then
        has_claude=true
        log_verbose "Found .claude/ directory"
    fi

    if [[ -f "$SOURCE_DIR/CLAUDE.md" ]]; then
        has_claude=true
        log_verbose "Found CLAUDE.md"
    fi

    if [[ "$has_claude" == false ]]; then
        log_warning "Directory does not appear to be a Claude Code Starter project"
        log_warning "Proceeding anyway..."
    fi
}

# Migrate directory structure
migrate_directories() {
    log_info "Migrating directory structure"

    # Ensure target directory exists
    mkdir -p "$TARGET_DIR"

    # .claude -> .qwen (copy, not move, to support cross-filesystem migration)
    if [[ -d "$SOURCE_DIR/.claude" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would copy .claude/ to .qwen/"
        else
            if [[ -d "$TARGET_DIR/.qwen" ]]; then
                log_warning ".qwen/ already exists, removing"
                rm -rf "$TARGET_DIR/.qwen"
            fi
            # Use cp -r instead of mv to support cross-filesystem and separate dirs
            cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/.qwen"
            log_verbose "Copied .claude/ to .qwen/"
        fi
    fi

    # Migrate nested agent directories to flat structure
    if [[ -d "$TARGET_DIR/.qwen/agents" ]]; then
        log_info "Converting agents to flat structure"
        migrate_agents_flat "$TARGET_DIR/.qwen/agents"
    fi
}

# Convert nested agent structure to flat
migrate_agents_flat() {
    local agents_dir="$1"

    # Find all nested agent files
    find "$agents_dir" -type f -name "*.md" -not -path "$agents_dir/*.md" 2>/dev/null | while read -r agent_file; do
        local filename
        filename=$(basename "$agent_file")
        local flat_path="$agents_dir/$filename"

        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would flatten: $agent_file -> $flat_path"
        else
            if [[ -f "$flat_path" ]]; then
                log_warning "Agent already exists at $flat_path, skipping"
            else
                mv "$agent_file" "$flat_path"
                log_verbose "Flattened: $filename"
            fi
        fi
    done

    # Remove empty nested directories
    if [[ "$DRY_RUN" != true ]]; then
        find "$agents_dir" -mindepth 1 -type d -empty -delete 2>/dev/null || true
    fi
}

# Migrate CLAUDE.md to QWEN.md
migrate_project_passport() {
    log_info "Migrating project passport"

    if [[ -f "$SOURCE_DIR/CLAUDE.md" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would copy CLAUDE.md to QWEN.md"
        else
            if [[ -f "$TARGET_DIR/QWEN.md" ]]; then
                log_warning "QWEN.md already exists, backing up"
                mv "$TARGET_DIR/QWEN.md" "$TARGET_DIR/QWEN.md.backup"
            fi
            # Use cp instead of mv to support cross-filesystem migration
            cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/QWEN.md"

            # Replace CLAUDE references with QWEN in the file
            sed -i.bak 's/CLAUDE\.md/QWEN.md/g; s/\.claude/\.qwen/g' "$TARGET_DIR/QWEN.md"
            rm -f "$TARGET_DIR/QWEN.md.bak"

            log_verbose "Copied CLAUDE.md to QWEN.md"
        fi
    elif [[ -f "$SOURCE_DIR/QWEN.md" ]]; then
        log_verbose "QWEN.md already exists"
    fi
}

# Migrate skills (remove unsupported frontmatter)
migrate_skills() {
    log_info "Migrating skills"

    local skills_dir="$TARGET_DIR/.qwen/skills"

    if [[ ! -d "$skills_dir" ]]; then
        log_verbose "No skills directory found"
        return 0
    fi

    find "$skills_dir" -name "SKILL.md" -o -name "*.md" 2>/dev/null | while read -r skill_file; do
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would migrate skill: $skill_file"
        else
            # Remove allowed-tools and disable-model-invocation from frontmatter
            local temp_file
            temp_file=$(mktemp)
            
            python3 << EOF > "$temp_file"
import re

with open('$skill_file', 'r') as f:
    content = f.read()

# Remove allowed-tools from frontmatter
content = re.sub(r'allowed-tools:.*?\n', '', content)
content = re.sub(r'- allowed-tool:.*?\n', '', content)

# Remove disable-model-invocation from frontmatter
content = re.sub(r'disable-model-invocation:.*?\n', '', content)

print(content, end='')
EOF
            
            mv "$temp_file" "$skill_file"
            log_verbose "Migrated skill: $(basename "$skill_file")"
        fi
    done
}

# Migrate hooks configuration
migrate_hooks() {
    log_info "Migrating hooks configuration"

    local settings_file="$TARGET_DIR/.qwen/settings.json"

    # Replace old Claude hooks with Qwen hooks from framework
    if [[ -d "$SCRIPT_DIR/../.qwen/hooks" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would replace hooks with qwen-code-starter versions"
        else
            # Remove old hooks and copy fresh ones from framework
            rm -rf "$TARGET_DIR/.qwen/hooks"
            cp -r "$SCRIPT_DIR/../.qwen/hooks" "$TARGET_DIR/.qwen/"
            log_verbose "Replaced hooks with qwen-code-starter versions"
        fi
    fi

    if [[ ! -f "$settings_file" ]]; then
        log_verbose "No settings.json found"
        return 0
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would migrate hooks in settings.json"
    else
        # Update hooks paths from .claude to .qwen and use standard qwen hooks
        python3 << EOF
import json
import re

with open('$settings_file', 'r') as f:
    settings = json.load(f)

if 'hooks' in settings:
    # Remove PostCompact hooks (not supported by Qwen Code)
    settings['hooks'].pop('PostCompact', None)

    # Fix paths in remaining hooks (.claude -> .qwen)
    # Structure: hooks[hook_type][] -> hooks[] -> command
    for hook_type in settings['hooks']:
        for hook_config in settings['hooks'][hook_type]:
            if 'hooks' in hook_config:
                for hook in hook_config['hooks']:
                    if 'command' in hook:
                        # Replace .claude/hooks with .qwen/hooks
                        hook['command'] = hook['command'].replace('.claude/hooks', '.qwen/hooks')
                        # Replace specific hook file names with standard qwen hooks
                        hook['command'] = re.sub(r'post-tool-checkpoint\.sh', 'post-tool-use.sh', hook['command'])
                        hook['command'] = re.sub(r'subagent-done\.sh', 'subagent-stop.sh', hook['command'])

    # Add PostToolUseFailure if not present
    if 'PostToolUseFailure' not in settings['hooks']:
        settings['hooks']['PostToolUseFailure'] = []

with open('$settings_file', 'w') as f:
    json.dump(settings, f, indent=2)
EOF

        log_verbose "Migrated hooks configuration"
    fi
}

# Migrate manifest.md to .qwenignore
migrate_permissions() {
    log_info "Migrating permissions"

    if [[ -f "$SOURCE_DIR/manifest.md" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY RUN] Would convert manifest.md to .qwenignore"
        else
            log_info "Converting manifest.md to .qwenignore format"
            
            # Create .qwenignore from manifest
            cat > "$TARGET_DIR/.qwenignore" << 'EOF'
# Qwen Code Ignore File
# Generated from manifest.md migration

# Environment and secrets
.env
.env.*
*.env
*.key
*.pem
*.crt
secrets/
credentials/

# IDE and editor files
.idea/
.vscode/
*.swp
*.swo
*~

# Build artifacts
dist/
build/
*.o
*.pyc
__pycache__/
node_modules/

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db
EOF
            
            log_verbose "Created .qwenignore"
        fi
    elif [[ ! -f "$TARGET_DIR/.qwenignore" ]]; then
        # Create default .qwenignore
        if [[ "$DRY_RUN" != true ]]; then
            cat > "$TARGET_DIR/.qwenignore" << 'EOF'
# Qwen Code Ignore File

# Environment and secrets
.env
.env.*
*.key
secrets/

# Build artifacts
node_modules/
__pycache__/
*.pyc
EOF
            log_verbose "Created default .qwenignore"
        fi
    fi
}

# Update references in all markdown files
update_references() {
    log_info "Updating references in markdown files"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would update references in markdown files"
        return 0
    fi

    find "$TARGET_DIR" -name "*.md" -type f 2>/dev/null | while read -r md_file; do
        if grep -q "CLAUDE\|\.claude" "$md_file" 2>/dev/null; then
            sed -i.bak 's/CLAUDE\.md/QWEN.md/g; s/\.claude/\.qwen/g; s/Claude Code/Qwen Code/g' "$md_file"
            rm -f "$md_file.bak"
            log_verbose "Updated references in: $(basename "$md_file")"
        fi
    done
}

# Clean up empty directories
cleanup() {
    log_info "Cleaning up"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would remove empty directories"
        return 0
    fi

    # Remove empty directories in .qwen
    find "$TARGET_DIR/.qwen" -mindepth 1 -type d -empty -delete 2>/dev/null || true
    
    log_verbose "Cleanup complete"
}

# Generate migration report
generate_report() {
    echo
    log_success "Migration complete!"
    echo
    echo "Migration Summary:"
    echo "  Source: $SOURCE_DIR"
    echo "  Target: $TARGET_DIR"
    echo
    echo "Changes made:"
    [[ -d "$TARGET_DIR/.qwen" ]] && echo "  ✓ Renamed .claude/ to .qwen/"
    [[ -f "$TARGET_DIR/QWEN.md" ]] && echo "  ✓ Renamed CLAUDE.md to QWEN.md"
    [[ -f "$TARGET_DIR/.qwenignore" ]] && echo "  ✓ Created .qwenignore"
    echo "  ✓ Updated skills frontmatter"
    echo "  ✓ Migrated hooks configuration"
    echo "  ✓ Flattened agent structure"
    echo
    echo "Next steps:"
    echo "  1. Review QWEN.md and update for Qwen Code"
    echo "  2. Check .qwen/settings.json for hook configurations"
    echo "  3. Update .qwenignore for your specific needs"
    echo "  4. Test your migrated configuration with Qwen Code"
    echo
}

main() {
    parse_args "$@"
    
    log_info "Qwen Code Starter Migration"
    echo
    
    check_source
    migrate_directories
    migrate_project_passport
    migrate_skills
    migrate_hooks
    migrate_permissions
    update_references
    cleanup
    generate_report
}

main "$@"
