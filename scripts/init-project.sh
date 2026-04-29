#!/usr/bin/env bash
#
# Qwen Code Starter - Bootstrap Script
# Downloads and runs the latest init-project.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check for required tools
check_requirements() {
    local missing=()

    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing+=("curl or wget")
    fi

    if ! command -v bash &> /dev/null; then
        missing+=("bash")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        log_error "Please install the missing tools and try again"
        exit 1
    fi

    log_verbose "All requirements met"
}

# Download the installer
download_installer() {
    local temp_file
    temp_file=$(mktemp)

    log_info "Downloading Qwen Code Starter installer..."

    if command -v curl &> /dev/null; then
        if ! curl -fsSL "https://raw.githubusercontent.com/qwen-code-starter/qwen-code-starter/main/scripts/init-project.sh" -o "$temp_file"; then
            log_error "Failed to download installer"
            rm -f "$temp_file"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if ! wget -q "https://raw.githubusercontent.com/qwen-code-starter/qwen-code-starter/main/scripts/init-project.sh" -O "$temp_file"; then
            log_error "Failed to download installer"
            rm -f "$temp_file"
            exit 1
        fi
    fi

    echo "$temp_file"
}

# Main function
main() {
    log_info "Qwen Code Starter Bootstrap"
    echo

    check_requirements

    local installer_file
    installer_file=$(download_installer)

    log_success "Installer downloaded successfully"
    log_info "Running installer..."
    echo

    # Make executable and run
    chmod +x "$installer_file"
    bash "$installer_file" "$@"

    local exit_code=$?

    # Cleanup
    rm -f "$installer_file"

    if [[ $exit_code -eq 0 ]]; then
        echo
        log_success "Qwen Code Starter installation complete!"
    else
        log_error "Installation failed with exit code: $exit_code"
        exit $exit_code
    fi
}

main "$@"
