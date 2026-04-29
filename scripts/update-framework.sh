#!/usr/bin/env bash
#
# Qwen Code Starter - Framework Update Script
# Updates an existing project with the latest framework files
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
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="${1:-.}"

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

usage() {
    cat << EOF
Qwen Code Starter - Framework Updater

Updates an existing project with the latest framework files from qwen-code-starter.

Usage: $(basename "$0") [OPTIONS] [PROJECT_PATH]

Options:
    -f, --force           Force overwrite of all files (default: skip existing)
    -n, --dry-run         Show what would be updated without making changes
    -h, --help            Show this help message

Components Updated:
    - .qwen/hooks/        Hook scripts (bash + PowerShell)
    - templates/          Project templates (code, content, global)
    - scripts/            Framework scripts (optional)

Examples:
    $(basename "$0")                          # Update current directory
    $(basename "$0") /path/to/project         # Update specific project
    $(basename "$0") -f                       # Force overwrite all files
    $(basename "$0") -n                       # Dry run (show changes)

EOF
    exit 0
}

# Parse arguments
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
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
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# Resolve target directory
if [[ -d "$TARGET_DIR" ]]; then
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
else
    log_error "Directory not found: $TARGET_DIR"
    exit 1
fi

log_info "Qwen Code Starter - Framework Updater"
log_info "Source: $FRAMEWORK_DIR"
log_info "Target: $TARGET_DIR"
echo

# Check if target is a Qwen Code project
if [[ ! -d "$TARGET_DIR/.qwen" ]]; then
    log_error "Not a Qwen Code project: $TARGET_DIR"
    log_error "Missing .qwen/ directory"
    exit 1
fi

# Update hooks
update_hooks() {
    log_info "Updating hooks..."
    
    local src_hooks="$FRAMEWORK_DIR/.qwen/hooks"
    local tgt_hooks="$TARGET_DIR/.qwen/hooks"
    
    if [[ ! -d "$src_hooks" ]]; then
        log_warning "Source hooks directory not found"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would update hooks"
        return 0
    fi
    
    # Create target directory
    mkdir -p "$tgt_hooks"
    
    # Copy hook files
    local updated=0
    for hook in "$src_hooks"/*; do
        local filename
        filename=$(basename "$hook")
        local target="$tgt_hooks/$filename"
        
        if [[ -f "$target" && "$FORCE" != true ]]; then
            # Check if files differ
            if ! diff -q "$hook" "$target" > /dev/null 2>&1; then
                cp "$hook" "$target"
                log_info "  Updated: $filename"
                ((updated++))
            fi
        else
            cp "$hook" "$target"
            log_info "  Added: $filename"
            ((updated++))
        fi
    done
    
    log_success "Hooks updated: $updated files"
}

# Update templates
update_templates() {
    log_info "Updating templates..."
    
    local src_templates="$FRAMEWORK_DIR/templates"
    local tgt_templates="$TARGET_DIR/templates"
    
    if [[ ! -d "$src_templates" ]]; then
        log_warning "Source templates directory not found"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would update templates"
        return 0
    fi
    
    # Copy templates (force overwrite for framework files)
    if [[ "$FORCE" == true ]]; then
        rm -rf "$tgt_templates"
        cp -r "$src_templates" "$tgt_templates"
        log_success "Templates replaced"
    else
        # Copy only new/changed files
        local updated=0
        for type_dir in "$src_templates"/*/; do
            local type_name
            type_name=$(basename "$type_dir")
            local tgt_type="$tgt_templates/$type_name"
            
            if [[ -d "$type_dir" ]]; then
                mkdir -p "$tgt_type"
                cp -rn "$type_dir"* "$tgt_type/" 2>/dev/null || true
                ((updated++))
            fi
        done
        
        log_success "Templates updated: $updated types"
    fi
}

# Update scripts (optional, only with --force)
update_scripts() {
    if [[ "$FORCE" != true ]]; then
        log_info "Skipping scripts update (use --force to update)"
        return 0
    fi
    
    log_info "Updating framework scripts..."
    
    local src_scripts="$FRAMEWORK_DIR/scripts"
    local tgt_scripts="$TARGET_DIR/scripts"
    
    if [[ ! -d "$src_scripts" ]]; then
        log_warning "Source scripts directory not found"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would update scripts"
        return 0
    fi
    
    # Backup existing scripts
    if [[ -d "$tgt_scripts" ]]; then
        local backup="$TARGET_DIR/scripts.backup.$(date +%Y%m%d%H%M%S)"
        mv "$tgt_scripts" "$backup"
        log_info "  Backed up old scripts to: $backup"
    fi
    
    # Copy new scripts
    cp -r "$src_scripts" "$tgt_scripts"
    log_success "Scripts updated"
}

# Update .qwenignore
update_qwenignore() {
    log_info "Updating .qwenignore..."
    
    local src_qwenignore="$FRAMEWORK_DIR/.qwenignore"
    local tgt_qwenignore="$TARGET_DIR/.qwenignore"
    
    if [[ ! -f "$src_qwenignore" ]]; then
        log_warning "Source .qwenignore not found"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would update .qwenignore"
        return 0
    fi
    
    # Merge or replace
    if [[ -f "$tgt_qwenignore" && "$FORCE" != true ]]; then
        # Merge: add missing entries from source
        while IFS= read -r line; do
            if [[ ! -z "$line" && ! "$line" =~ ^# && ! -f "$tgt_qwenignore" ]]; then
                echo "$line" >> "$tgt_qwenignore"
            fi
        done < "$src_qwenignore"
        log_success ".qwenignore merged"
    else
        cp "$src_qwenignore" "$tgt_qwenignore"
        log_success ".qwenignore updated"
    fi
}

# Show summary
show_summary() {
    echo
    log_success "Framework update complete!"
    echo
    echo "Updated components:"
    [[ -d "$TARGET_DIR/.qwen/hooks" ]] && echo "  ✓ Hooks"
    [[ -d "$TARGET_DIR/templates" ]] && echo "  ✓ Templates"
    [[ -f "$TARGET_DIR/.qwenignore" ]] && echo "  ✓ .qwenignore"
    [[ "$FORCE" == true && -d "$TARGET_DIR/scripts" ]] && echo "  ✓ Scripts (force)"
    echo
    echo "Next steps:"
    echo "  1. Review changes: git diff"
    echo "  2. Test your project"
    echo "  3. Commit: git add . && git commit -m 'chore: update framework'"
    echo
}

# Main
update_hooks
update_templates
update_scripts
update_qwenignore
show_summary
