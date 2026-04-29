#!/usr/bin/env bash
#
# Qwen Code Starter - Global Installation Script
# Installs framework templates to ~/.qwen/
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

QWEN_GLOBAL_DIR="$HOME/.qwen"
VERBOSE=false
FORCE=false

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
Qwen Code Starter - Global Installation

Installs framework templates to ~/.qwen/ for use across all projects.

Usage: $(basename "$0") [OPTIONS]

Options:
    -v, --verbose     Enable verbose output
    -f, --force       Overwrite existing files without prompting
    -h, --help        Show this help message

Examples:
    $(basename "$0")              # Install to ~/.qwen/
    $(basename "$0") -f           # Force overwrite existing files
    $(basename "$0") -v           # Verbose installation

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
            -f|--force)
                FORCE=true
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
                log_error "Unexpected argument: $1"
                usage
                ;;
        esac
    done
}

# Check if global directory exists and handle existing installation
check_existing() {
    if [[ -d "$QWEN_GLOBAL_DIR" ]]; then
        log_warning "Global Qwen Code directory already exists: $QWEN_GLOBAL_DIR"
        
        if [[ "$FORCE" != true ]]; then
            read -p "Overwrite existing files? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Aborting installation"
                exit 0
            fi
        fi
        
        # Backup existing installation
        local backup_dir="$QWEN_GLOBAL_DIR.backup.$(date +%Y%m%d%H%M%S)"
        log_info "Backing up existing installation to: $backup_dir"
        cp -r "$QWEN_GLOBAL_DIR" "$backup_dir"
    fi
}

# Install templates
install_templates() {
    log_info "Installing templates to $QWEN_GLOBAL_DIR"

    # Create base directory
    mkdir -p "$QWEN_GLOBAL_DIR"

    # Install code templates
    if [[ -d "$FRAMEWORK_DIR/templates/code" ]]; then
        log_info "Installing code project templates"
        mkdir -p "$QWEN_GLOBAL_DIR/templates/code"
        cp -r "$FRAMEWORK_DIR/templates/code/"* "$QWEN_GLOBAL_DIR/templates/code/"
        log_verbose "  ✓ Code templates installed"
    fi

    # Install content templates
    if [[ -d "$FRAMEWORK_DIR/templates/content" ]]; then
        log_info "Installing content project templates"
        mkdir -p "$QWEN_GLOBAL_DIR/templates/content"
        cp -r "$FRAMEWORK_DIR/templates/content/"* "$QWEN_GLOBAL_DIR/templates/content/"
        log_verbose "  ✓ Content templates installed"
    fi

    # Install global templates
    if [[ -d "$FRAMEWORK_DIR/templates/global" ]] && [[ "$(ls -A "$FRAMEWORK_DIR/templates/global" 2>/dev/null)" ]]; then
        log_info "Installing global templates"
        mkdir -p "$QWEN_GLOBAL_DIR/templates/global"
        cp -r "$FRAMEWORK_DIR/templates/global/"* "$QWEN_GLOBAL_DIR/templates/global/"
        log_verbose "  ✓ Global templates installed"
    fi
}

# Install scripts
install_scripts() {
    log_info "Installing utility scripts"

    mkdir -p "$QWEN_GLOBAL_DIR/scripts"

    # Copy library scripts
    if [[ -d "$FRAMEWORK_DIR/scripts/lib" ]]; then
        cp -r "$FRAMEWORK_DIR/scripts/lib" "$QWEN_GLOBAL_DIR/scripts/"
        log_verbose "  ✓ Library scripts installed"
    fi

    # Copy helper scripts
    for script in framework-state-mode.sh switch-repo-access.sh; do
        if [[ -f "$FRAMEWORK_DIR/scripts/$script" ]]; then
            cp "$FRAMEWORK_DIR/scripts/$script" "$QWEN_GLOBAL_DIR/scripts/"
            chmod +x "$QWEN_GLOBAL_DIR/scripts/$script"
        fi
    done

    log_verbose "  ✓ Utility scripts installed"
}

# Install example configurations
install_examples() {
    log_info "Installing example configurations"

    mkdir -p "$QWEN_GLOBAL_DIR/examples"

    # Copy example .qwen directory structure
    if [[ -d "$FRAMEWORK_DIR/.qwen" ]]; then
        mkdir -p "$QWEN_GLOBAL_DIR/examples/qwen"
        cp -r "$FRAMEWORK_DIR/.qwen/"* "$QWEN_GLOBAL_DIR/examples/qwen/"
        log_verbose "  ✓ Example configurations installed"
    fi
}

# Create README for global directory
create_readme() {
    log_info "Creating global directory documentation"

    cat > "$QWEN_GLOBAL_DIR/README.md" << EOF
# Qwen Code Global Configuration

This directory contains global Qwen Code configurations and templates.

## Structure

\`\`\`
~/.qwen/
├── templates/           # Project templates
│   ├── code/           # Code project templates
│   ├── content/        # Content project templates
│   └── global/         # Global layer templates
├── scripts/            # Utility scripts
│   └── lib/            # Shared libraries
├── examples/           # Example configurations
└── README.md           # This file
\`\`\`

## Usage

### Initialize a new project

\`\`\`bash
# Using the framework installer
curl -fsSL https://raw.githubusercontent.com/qwen-code-starter/main/scripts/init-project.sh | bash

# Or manually copy templates
cp -r ~/.qwen/templates/code/* /path/to/new/project/
\`\`\`

### Available Scripts

- \`scripts/framework-state-mode.sh\` - Check framework state
- \`scripts/switch-repo-access.sh\` - Toggle repository access modes

## Updating

To update the global installation:

\`\`\`bash
# Re-run the global installer
/path/to/qwen-code-starter/scripts/install-global.sh
\`\`\`

## Customization

You can customize templates in this directory for your personal defaults.
These will be used when initializing new projects.
EOF

    log_verbose "  ✓ README created"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation"

    local errors=0

    # Check templates
    if [[ ! -d "$QWEN_GLOBAL_DIR/templates/code" ]]; then
        log_error "Missing code templates"
        ((errors++))
    fi

    if [[ ! -d "$QWEN_GLOBAL_DIR/templates/content" ]]; then
        log_error "Missing content templates"
        ((errors++))
    fi

    # Check scripts
    if [[ ! -d "$QWEN_GLOBAL_DIR/scripts/lib" ]]; then
        log_error "Missing script library"
        ((errors++))
    fi

    if [[ $errors -gt 0 ]]; then
        log_error "Installation verification failed with $errors error(s)"
        return 1
    fi

    log_verbose "  ✓ All components verified"
    return 0
}

# Print success message
print_success() {
    echo
    log_success "Global installation complete!"
    echo
    echo "Installed to: $QWEN_GLOBAL_DIR"
    echo
    echo "Contents:"
    echo "  - Code project templates"
    echo "  - Content project templates"
    echo "  - Utility scripts"
    echo "  - Example configurations"
    echo
    echo "To initialize a new project:"
    echo "  cp -r $QWEN_GLOBAL_DIR/templates/code/* /path/to/new/project/"
    echo
    echo "Or use the project initializer:"
    echo "  /path/to/qwen-code-starter/init-project.sh"
    echo
}

main() {
    parse_args "$@"

    log_info "Qwen Code Starter - Global Installation"
    echo
    log_info "Installing to: $QWEN_GLOBAL_DIR"
    echo

    check_existing
    install_templates
    install_scripts
    install_examples
    create_readme

    if verify_installation; then
        print_success
    else
        log_error "Installation completed with errors"
        exit 1
    fi
}

main "$@"
