#!/usr/bin/env bash
#
# Install Git Post-Commit Hook
# Copies the post-commit hook to .git/hooks/ for automatic SNAPSHOT.md updates
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"

echo "Installing git post-commit hook..."

# Check if .git directory exists
if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
    echo "Error: Not a git repository ($PROJECT_ROOT)"
    exit 1
fi

# Create hooks directory if needed
mkdir -p "$PROJECT_ROOT/.git/hooks"

# Install bash hook (Linux/macOS)
if command -v bash &> /dev/null; then
    cp "$LIB_DIR/post-commit-hook.sh" "$PROJECT_ROOT/.git/hooks/post-commit"
    chmod +x "$PROJECT_ROOT/.git/hooks/post-commit"
    echo "✅ Installed bash hook: .git/hooks/post-commit"
fi

# Install PowerShell hook (Windows)
if command -v pwsh &> /dev/null || command -v powershell &> /dev/null; then
    cp "$LIB_DIR/post-commit-hook.ps1" "$PROJECT_ROOT/.git/hooks/post-commit.ps1"
    echo "✅ Installed PowerShell hook: .git/hooks/post-commit.ps1"
    echo ""
    echo "⚠️  PowerShell hook requires:"
    echo "   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
fi

echo ""
echo "Git post-commit hook installed successfully!"
echo "SNAPSHOT.md will now auto-update after every commit."
