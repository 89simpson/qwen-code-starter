#!/usr/bin/env bash
#
# Qwen Code Starter - Common Installation Library
# Shared utilities for installation and migration scripts
#

# Prevent multiple sourcing
if [[ -n "${QWEN_INSTALL_COMMON_LOADED:-}" ]]; then
    return 0
fi
QWEN_INSTALL_COMMON_LOADED=1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global flags
QWEN_VERBOSE="${QWEN_VERBOSE:-false}"
QWEN_DRY_RUN="${QWEN_DRY_RUN:-false}"

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
    if [[ "$QWEN_VERBOSE" == true ]]; then
        echo -e "${CYAN}[VERBOSE]${NC} $1"
    fi
}

log_step() {
    echo -e "${BLUE}━━━${NC} $1 ${BLUE}━━━${NC}"
}

# Check if running as root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root is not recommended"
        log_warning "Consider running as a regular user"
    fi
}

# Check required commands
check_commands() {
    local commands=("$@")
    local missing=()

    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required commands: ${missing[*]}"
        return 1
    fi

    log_verbose "All required commands available"
    return 0
}

# Check disk space
check_disk_space() {
    local required_mb="${1:-100}"
    local target_dir="${2:-/}"

    local available_kb
    available_kb=$(df -k "$target_dir" 2>/dev/null | awk 'NR==2 {print $4}')

    if [[ -z "$available_kb" ]]; then
        log_warning "Unable to check disk space"
        return 0
    fi

    local available_mb=$((available_kb / 1024))

    if [[ $available_mb -lt $required_mb ]]; then
        log_error "Insufficient disk space"
        log_error "Required: ${required_mb}MB, Available: ${available_mb}MB"
        return 1
    fi

    log_verbose "Disk space OK: ${available_mb}MB available"
    return 0
}

# Create directory with proper permissions
ensure_dir() {
    local dir="$1"
    local mode="${2:-755}"

    if [[ "$QWEN_DRY_RUN" == true ]]; then
        log_verbose "[DRY RUN] Would create directory: $dir"
        return 0
    fi

    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        chmod "$mode" "$dir"
        log_verbose "Created directory: $dir"
    fi
}

# Copy file with backup
copy_with_backup() {
    local source="$1"
    local target="$2"

    if [[ ! -f "$source" ]]; then
        log_error "Source file not found: $source"
        return 1
    fi

    if [[ "$QWEN_DRY_RUN" == true ]]; then
        log_verbose "[DRY RUN] Would copy: $source -> $target"
        return 0
    fi

    # Backup existing file
    if [[ -f "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        cp "$target" "$backup"
        log_verbose "Backed up: $target -> $backup"
    fi

    cp "$source" "$target"
    log_verbose "Copied: $source -> $target"
}

# Replace text in file
replace_in_file() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"

    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi

    if [[ "$QWEN_DRY_RUN" == true ]]; then
        log_verbose "[DRY RUN] Would replace in: $file"
        return 0
    fi

    # Use sed with backup
    if sed -i.bak "s/$pattern/$replacement/g" "$file" 2>/dev/null; then
        rm -f "$file.bak"
        log_verbose "Updated: $file"
        return 0
    else
        # Try BSD sed (macOS)
        if sed -i '' "s/$pattern/$replacement/g" "$file" 2>/dev/null; then
            rm -f "$file.bak"
            log_verbose "Updated: $file"
            return 0
        fi
    fi

    log_error "Failed to update: $file"
    return 1
}

# Validate JSON file
validate_json() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi

    if command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
            log_verbose "Valid JSON: $file"
            return 0
        else
            log_error "Invalid JSON: $file"
            return 1
        fi
    elif command -v jq &> /dev/null; then
        if jq '.' "$file" &>/dev/null; then
            log_verbose "Valid JSON: $file"
            return 0
        else
            log_error "Invalid JSON: $file"
            return 1
        fi
    else
        log_warning "No JSON validator available"
        return 0
    fi
}

# Download file with retry
download_file() {
    local url="$1"
    local output="$2"
    local max_retries="${3:-3}"
    local retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        if command -v curl &> /dev/null; then
            if curl -fsSL "$url" -o "$output" 2>/dev/null; then
                log_verbose "Downloaded: $url"
                return 0
            fi
        elif command -v wget &> /dev/null; then
            if wget -q "$url" -O "$output" 2>/dev/null; then
                log_verbose "Downloaded: $url"
                return 0
            fi
        else
            log_error "No download tool available (curl or wget required)"
            return 1
        fi

        ((retry_count++))
        log_warning "Download failed, retrying ($retry_count/$max_retries)"
        sleep 1
    done

    log_error "Download failed after $max_retries attempts: $url"
    return 1
}

# Check git repository
is_git_repo() {
    local dir="${1:-.}"

    if git -C "$dir" rev-parse --git-dir &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Get git branch
get_git_branch() {
    local dir="${1:-.}"

    if is_git_repo "$dir"; then
        git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null
    else
        echo ""
    fi
}

# Check for uncommitted changes
has_uncommitted_changes() {
    local dir="${1:-.}"

    if is_git_repo "$dir"; then
        if ! git -C "$dir" diff-index --quiet HEAD -- 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Prompt for confirmation
confirm() {
    local message="${1:-Continue?}"
    local default="${2:-N}"

    if [[ "$QWEN_DRY_RUN" == true ]]; then
        log_verbose "[DRY RUN] Would prompt: $message"
        return 0
    fi

    local prompt="$message"
    if [[ "$default" == "Y" || "$default" == "y" ]]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi

    read -p "$prompt " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        return 1
    elif [[ -z "$REPLY" ]]; then
        [[ "$default" == "Y" || "$default" == "y" ]]
        return $?
    else
        return 1
    fi
}

# Generate timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Generate unique ID
generate_id() {
    local length="${1:-8}"
    head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length"
    echo
}

# Cleanup trap
cleanup_on_exit() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script exited with error code: $exit_code"
    fi
    # Add cleanup logic here if needed
}

# Set up cleanup trap
trap cleanup_on_exit EXIT

# Export functions for use in subshells
export -f log_info log_success log_warning log_error log_verbose log_step
export -f check_not_root check_commands check_disk_space
export -f ensure_dir copy_with_backup replace_in_file validate_json
export -f download_file is_git_repo get_git_branch has_uncommitted_changes
export -f confirm timestamp generate_id
