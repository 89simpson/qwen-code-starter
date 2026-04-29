#!/usr/bin/env bash
#
# Qwen Code Starter - Repository Access Switcher
# Toggles between full and restricted repository access modes
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
PROJECT_DIR="${2:-.}"
MODE="${1:-}"

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
Qwen Code Starter - Repository Access Switcher

Switches between full and restricted repository access modes.

Usage: $(basename "$0") <MODE> [PROJECT_DIR]

Arguments:
    MODE           Access mode: full, restricted, status
    PROJECT_DIR    Path to project (default: current directory)

Modes:
    full           Qwen Code can access all files
    restricted     Qwen Code respects .qwenignore patterns
    status         Show current access mode

Examples:
    $(basename "$0") status               # Check current mode
    $(basename "$0") restricted           # Enable restricted access
    $(basename "$0") full                 # Enable full access
    $(basename "$0") restricted /path/to  # Set mode for specific project

EOF
    exit 0
}

# Parse arguments
parse_args() {
    if [[ -z "$MODE" || "$MODE" == "-h" || "$MODE" == "--help" ]]; then
        usage
    fi

    case "$MODE" in
        full|restricted|status)
            ;;
        *)
            log_error "Invalid mode: $MODE"
            log_error "Valid modes: full, restricted, status"
            usage
            ;;
    esac

    # Resolve project directory
    if [[ ! -d "$PROJECT_DIR" ]]; then
        log_error "Project directory does not exist: $PROJECT_DIR"
        exit 1
    fi
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
}

# Show current status
show_status() {
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║        Repository Access Mode - Status                  ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo
    echo "Project: $PROJECT_DIR"
    echo

    if [[ -f "$PROJECT_DIR/.qwenignore" ]]; then
        echo -e "Current Mode: ${GREEN}RESTRICTED${NC}"
        echo
        echo ".qwenignore is active with the following patterns:"
        echo
        grep -v '^#' "$PROJECT_DIR/.qwenignore" 2>/dev/null | grep -v '^$' | while read -r pattern; do
            echo "  • $pattern"
        done
        echo
        echo "Qwen Code will NOT access files matching these patterns."
    else
        echo -e "Current Mode: ${YELLOW}FULL ACCESS${NC}"
        echo
        echo "No .qwenignore file found."
        echo "Qwen Code can access all files in the repository."
    fi

    echo
    echo "To change mode:"
    echo "  $(basename "$0") restricted    # Enable restricted access"
    echo "  $(basename "$0") full          # Enable full access"
    echo
}

# Enable restricted access
enable_restricted() {
    log_info "Enabling restricted repository access"

    if [[ -f "$PROJECT_DIR/.qwenignore" ]]; then
        log_warning ".qwenignore already exists"
        read -p "Overwrite existing .qwenignore? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborting"
            exit 0
        fi
    fi

    # Create .qwenignore
    cat > "$PROJECT_DIR/.qwenignore" << 'EOF'
# Qwen Code Ignore File
# Repository Access Mode: RESTRICTED
#
# Qwen Code will not access files matching these patterns.
# See: https://qwen-code.dev/docs/repo-access

# Environment and secrets
.env
.env.*
*.env
*.key
*.pem
*.crt
*.secret
secrets/
credentials/
passwords/

# Personal IDE settings
.idea/
.vscode/settings.json
.vscode/launch.json
*.swp
*.swo
*~

# Local configuration
.local.env
.config.local
*.local

# Build artifacts (optional)
# Uncomment if you want to exclude build outputs
# dist/
# build/
# *.o
# *.pyc
# __pycache__/
# node_modules/

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db
EOF

    log_success "Restricted access enabled"
    echo
    echo "Created .qwenignore with default patterns."
    echo "Edit .qwenignore to customize which files Qwen Code cannot access."
    echo
}

# Enable full access
enable_full() {
    log_info "Enabling full repository access"

    if [[ ! -f "$PROJECT_DIR/.qwenignore" ]]; then
        log_warning "No .qwenignore file found"
        echo "Already in full access mode."
        exit 0
    fi

    read -p "Remove .qwenignore and enable full access? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Aborting"
        exit 0
    fi

    # Backup and remove
    local backup_file="$PROJECT_DIR/.qwenignore.backup.$(date +%Y%m%d%H%M%S)"
    mv "$PROJECT_DIR/.qwenignore" "$backup_file"

    log_success "Full access enabled"
    echo
    echo "Removed .qwenignore (backed up to: $(basename "$backup_file"))"
    echo "Qwen Code can now access all files in the repository."
    echo
    echo "To restore restricted access:"
    echo "  mv $backup_file $PROJECT_DIR/.qwenignore"
    echo
}

main() {
    parse_args

    case "$MODE" in
        status)
            show_status
            ;;
        restricted)
            enable_restricted
            ;;
        full)
            enable_full
            ;;
    esac
}

main "$@"
