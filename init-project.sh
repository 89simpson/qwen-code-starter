#!/usr/bin/env bash
#
# Qwen Code Starter - Main Installer
# Initializes a new Qwen Code project with automatic type detection
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
PROJECT_TYPE="auto"
VERBOSE=false
DRY_RUN=false

# Print usage
usage() {
    cat << EOF
Qwen Code Starter - Project Initializer

Usage: $(basename "$0") [OPTIONS] [PROJECT_PATH]

Options:
    -t, --type TYPE       Project type: code, content, hybrid, auto (default: auto)
    -v, --verbose         Enable verbose output
    -n, --dry-run         Show what would be done without making changes
    -h, --help            Show this help message

Examples:
    $(basename "$0")                          # Auto-detect in current directory
    $(basename "$0") -t code /path/to/project # Force code project type
    $(basename "$0") -t content               # Content project in current dir
    $(basename "$0") -n -v                    # Dry run with verbose output

EOF
    exit 0
}

# Logging functions
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

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                PROJECT_TYPE="$2"
                shift 2
                ;;
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
                PROJECT_PATH="$1"
                shift
                ;;
        esac
    done
}

# Detect project type based on directory contents
detect_project_type() {
    local dir="$1"
    local code_score=0
    local content_score=0

    log_verbose "Detecting project type in: $dir"

    # Check for code indicators
    [[ -f "$dir/package.json" ]] && ((code_score++))
    [[ -f "$dir/requirements.txt" ]] && ((code_score++))
    [[ -f "$dir/go.mod" ]] && ((code_score++))
    [[ -f "$dir/Cargo.toml" ]] && ((code_score++))
    [[ -f "$dir/pom.xml" ]] && ((code_score++))
    [[ -f "$dir/build.gradle" ]] && ((code_score++))
    [[ -d "$dir/src" ]] && ((code_score++))
    [[ -d "$dir/app" ]] && ((code_score++))
    [[ -d "$dir/lib" ]] && ((code_score++))
    [[ $(find "$dir" -maxdepth 2 -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rs" 2>/dev/null | head -1) ]] && ((code_score++))

    # Check for content indicators
    [[ -f "$dir/mkdocs.yml" ]] && ((content_score++))
    [[ -f "$dir/_config.yml" ]] && ((content_score++))
    [[ -f "$dir/config.toml" ]] && ((content_score++))
    [[ -d "$dir/docs" ]] && ((content_score++))
    [[ -d "$dir/content" ]] && ((content_score++))
    [[ -d "$dir/posts" ]] && ((content_score++))
    [[ -d "$dir/pages" ]] && ((content_score++))
    [[ $(find "$dir" -maxdepth 2 -name "*.md" -o -name "*.mdx" 2>/dev/null | head -10 | wc -l) -gt 5 ]] && ((content_score++))

    log_verbose "Code score: $code_score, Content score: $content_score"

    if [[ $code_score -gt $content_score ]]; then
        echo "code"
    elif [[ $content_score -gt $code_score ]]; then
        echo "content"
    elif [[ $code_score -gt 0 && $content_score -gt 0 ]]; then
        echo "hybrid"
    else
        echo "code"  # Default to code if unclear
    fi
}

# Copy template files
copy_templates() {
    local template_dir="$1"
    local target_dir="$2"
    local project_type="$3"

    log_info "Copying $project_type templates to $target_dir"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would copy templates from $template_dir to $target_dir"
        return 0
    fi

    # Create .qwen directory
    mkdir -p "$target_dir/.qwen"

    # Copy QWEN.md
    if [[ -f "$template_dir/QWEN.md" ]]; then
        cp "$template_dir/QWEN.md" "$target_dir/QWEN.md"
        log_verbose "Copied QWEN.md"
    fi

    # Copy rules
    if [[ -d "$template_dir/rules" ]]; then
        mkdir -p "$target_dir/.qwen/rules"
        cp -r "$template_dir/rules/"* "$target_dir/.qwen/rules/" 2>/dev/null || true
        log_verbose "Copied rules"
    fi

    # Copy skills
    if [[ -d "$template_dir/skills" ]]; then
        mkdir -p "$target_dir/.qwen/skills"
        cp -r "$template_dir/skills/"* "$target_dir/.qwen/skills/" 2>/dev/null || true
        log_verbose "Copied skills"
    fi

    # Copy agents
    if [[ -d "$template_dir/agents" ]]; then
        mkdir -p "$target_dir/.qwen/agents"
        cp -r "$template_dir/agents/"* "$target_dir/.qwen/agents/" 2>/dev/null || true
        log_verbose "Copied agents"
    fi

    # Copy content templates (for content projects)
    if [[ -d "$template_dir/content-templates" ]]; then
        mkdir -p "$target_dir/.qwen/content-templates"
        cp -r "$template_dir/content-templates/"* "$target_dir/.qwen/content-templates/" 2>/dev/null || true
        log_verbose "Copied content templates"
    fi

    # Copy settings.json
    if [[ -f "$SCRIPT_DIR/.qwen/settings.json" ]]; then
        cp "$SCRIPT_DIR/.qwen/settings.json" "$target_dir/.qwen/settings.json"
        log_verbose "Copied settings.json"
    fi

    # Copy hooks
    if [[ -d "$SCRIPT_DIR/.qwen/hooks" ]] && [[ ! -d "$target_dir/.qwen/hooks" ]]; then
        cp -r "$SCRIPT_DIR/.qwen/hooks" "$target_dir/.qwen/"
        log_verbose "Copied hooks"
    fi
}

# Create .qwenignore file
create_qwenignore() {
    local target_dir="$1"

    log_info "Creating .qwenignore file"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would create .qwenignore"
        return 0
    fi

    cat > "$target_dir/.qwenignore" << 'EOF'
# Qwen Code Ignore File
# Files and directories that Qwen Code should not access

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
}

# Initialize settings.json with project-specific values
init_settings() {
    local target_dir="$1"
    local project_type="$2"
    local project_name="$3"

    log_info "Initializing settings.json for $project_name"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would initialize settings.json"
        return 0
    fi

    local settings_file="$target_dir/.qwen/settings.json"

    # Update project name in settings if file exists
    if [[ -f "$settings_file" ]]; then
        # Use Python for JSON manipulation if available, otherwise use sed
        if command -v python3 &> /dev/null; then
            python3 -c "
import json
with open('$settings_file', 'r') as f:
    settings = json.load(f)
settings['projectName'] = '$project_name'
settings['projectType'] = '$project_type'
with open('$settings_file', 'w') as f:
    json.dump(settings, f, indent=2)
"
        fi
        log_verbose "Updated settings.json"
    fi
}

# Main initialization function
init_project() {
    local target_dir="${PROJECT_PATH:-.}"

    # Resolve to absolute path
    target_dir="$(cd "$target_dir" && pwd)"

    log_info "Initializing Qwen Code project in: $target_dir"
    log_info "Project type: $PROJECT_TYPE"

    # Auto-detect project type if needed
    if [[ "$PROJECT_TYPE" == "auto" ]]; then
        PROJECT_TYPE=$(detect_project_type "$target_dir")
        log_info "Auto-detected project type: $PROJECT_TYPE"
    fi

    # Validate project type
    case "$PROJECT_TYPE" in
        code|content|hybrid)
            log_verbose "Valid project type: $PROJECT_TYPE"
            ;;
        *)
            log_error "Invalid project type: $PROJECT_TYPE"
            log_error "Valid types: code, content, hybrid, auto"
            exit 1
            ;;
    esac

    # Check if .qwen directory already exists
    if [[ -d "$target_dir/.qwen" ]]; then
        log_warning ".qwen directory already exists"
        read -p "Overwrite existing configuration? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborting initialization"
            exit 0
        fi
    fi

    # Determine template directory
    local template_dir="$SCRIPT_DIR/templates/$PROJECT_TYPE"
    if [[ ! -d "$template_dir" ]]; then
        log_error "Template directory not found: $template_dir"
        exit 1
    fi

    # Copy templates
    copy_templates "$template_dir" "$target_dir" "$PROJECT_TYPE"

    # For hybrid projects, also copy content templates
    if [[ "$PROJECT_TYPE" == "hybrid" ]]; then
        log_info "Adding content templates for hybrid project"
        copy_templates "$SCRIPT_DIR/templates/content" "$target_dir" "content"
    fi

    # Create .qwenignore
    create_qwenignore "$target_dir"

    # Initialize settings
    local project_name
    project_name="$(basename "$target_dir")"
    init_settings "$target_dir" "$PROJECT_TYPE" "$project_name"

    log_success "Qwen Code project initialized successfully!"
    echo
    echo "Next steps:"
    echo "  1. Review and customize QWEN.md for your project"
    echo "  2. Configure .qwen/settings.json as needed"
    echo "  3. Update .qwenignore for your specific needs"
    echo "  4. Start coding with Qwen Code!"
    echo
}

# Main entry point
main() {
    parse_args "$@"
    init_project
}

main "$@"
