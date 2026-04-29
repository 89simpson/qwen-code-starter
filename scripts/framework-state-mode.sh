#!/usr/bin/env bash
#
# Qwen Code Starter - Framework State Mode Helper
# Checks and reports the current framework state and repository access mode
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-.}"

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
Qwen Code Starter - Framework State Checker

Checks the current framework state and repository access mode.

Usage: $(basename "$0") [PROJECT_DIR]

Arguments:
    PROJECT_DIR    Path to project directory (default: current directory)

Examples:
    $(basename "$0")                    # Check current directory
    $(basename "$0") /path/to/project   # Check specific project

EOF
    exit 0
}

# Check for help flag
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
fi

# Check framework installation
check_framework() {
    local project_dir="$1"
    local status="not_installed"

    echo -e "${CYAN}Framework Status:${NC}"

    # Check for .qwen directory
    if [[ -d "$project_dir/.qwen" ]]; then
        status="installed"
        echo -e "  ${GREEN}✓${NC} .qwen/ directory exists"

        # Check for QWEN.md
        if [[ -f "$project_dir/QWEN.md" ]]; then
            echo -e "  ${GREEN}✓${NC} QWEN.md found"
        else
            echo -e "  ${YELLOW}!${NC} QWEN.md missing"
            status="incomplete"
        fi

        # Check for settings.json
        if [[ -f "$project_dir/.qwen/settings.json" ]]; then
            echo -e "  ${GREEN}✓${NC} settings.json found"
        else
            echo -e "  ${YELLOW}!${NC} settings.json missing"
        fi

        # Check for rules
        local rules_count
        rules_count=$(find "$project_dir/.qwen/rules" -name "*.md" 2>/dev/null | wc -l)
        if [[ $rules_count -gt 0 ]]; then
            echo -e "  ${GREEN}✓${NC} Rules: $rules_count rule(s)"
        else
            echo -e "  ${YELLOW}!${NC} No rules found"
        fi

        # Check for skills
        local skills_count
        skills_count=$(find "$project_dir/.qwen/skills" -name "*.md" 2>/dev/null | wc -l)
        if [[ $skills_count -gt 0 ]]; then
            echo -e "  ${GREEN}✓${NC} Skills: $skills_count skill(s)"
        else
            echo -e "  ${YELLOW}!${NC} No skills found"
        fi

        # Check for agents
        local agents_count
        agents_count=$(find "$project_dir/.qwen/agents" -name "*.md" 2>/dev/null | wc -l)
        if [[ $agents_count -gt 0 ]]; then
            echo -e "  ${GREEN}✓${NC} Agents: $agents_count agent(s)"
        else
            echo -e "  ${YELLOW}!${NC} No agents found"
        fi

        # Check for hooks
        if [[ -f "$project_dir/.qwen/settings.json" ]]; then
            if grep -q '"hooks"' "$project_dir/.qwen/settings.json" 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} Hooks configured"
            else
                echo -e "  ${YELLOW}!${NC} Hooks not configured"
            fi
        fi
    else
        echo -e "  ${RED}✗${NC} .qwen/ directory not found"
        status="not_installed"
    fi

    echo
    return 0
}

# Check repository access mode
check_repo_access() {
    local project_dir="$1"

    echo -e "${CYAN}Repository Access Mode:${NC}"

    # Check for .qwenignore
    if [[ -f "$project_dir/.qwenignore" ]]; then
        echo -e "  ${GREEN}✓${NC} .qwenignore found (RESTRICTED mode)"

        # Count ignored patterns
        local patterns_count
        patterns_count=$(grep -v '^#' "$project_dir/.qwenignore" 2>/dev/null | grep -v '^$' | wc -l)
        echo -e "  ${BLUE}•${NC} $patterns_count ignore pattern(s)"

        # Show some patterns
        echo -e "  ${BLUE}•${NC} Sample patterns:"
        grep -v '^#' "$project_dir/.qwenignore" 2>/dev/null | grep -v '^$' | head -5 | while read -r pattern; do
            echo -e "      $pattern"
        done

        local mode="restricted"
    elif [[ -d "$project_dir/.qwen" ]]; then
        echo -e "  ${YELLOW}!${NC} .qwenignore not found (FULL ACCESS mode)"
        echo -e "  ${BLUE}•${NC} Qwen Code can access all files"
        local mode="full"
    else
        echo -e "  ${RED}✗${NC} Framework not installed"
        local mode="unknown"
    fi

    echo
    return 0
}

# Detect project type
detect_project_type() {
    local project_dir="$1"

    echo -e "${CYAN}Project Type:${NC}"

    if [[ ! -f "$project_dir/QWEN.md" ]]; then
        # Auto-detect from directory contents
        local code_score=0
        local content_score=0

        [[ -f "$project_dir/package.json" ]] && ((code_score++))
        [[ -f "$project_dir/requirements.txt" ]] && ((code_score++))
        [[ -f "$project_dir/go.mod" ]] && ((code_score++))
        [[ -d "$project_dir/src" ]] && ((code_score++))

        [[ -f "$project_dir/mkdocs.yml" ]] && ((content_score++))
        [[ -d "$project_dir/docs" ]] && ((content_score++))
        [[ -d "$project_dir/content" ]] && ((content_score++))

        if [[ $code_score -gt $content_score ]]; then
            echo -e "  ${BLUE}•${NC} Detected: CODE project"
        elif [[ $content_score -gt $code_score ]]; then
            echo -e "  ${BLUE}•${NC} Detected: CONTENT project"
        elif [[ $code_score -gt 0 && $content_score -gt 0 ]]; then
            echo -e "  ${BLUE}•${NC} Detected: HYBRID project"
        else
            echo -e "  ${YELLOW}!${NC} Unable to detect (no QWEN.md, minimal files)"
        fi
    else
        # Read from QWEN.md
        local project_type
        project_type=$(grep -i "type:" "$project_dir/QWEN.md" 2>/dev/null | head -1 | cut -d: -f2 | tr -d ' ')
        if [[ -n "$project_type" ]]; then
            echo -e "  ${GREEN}✓${NC} Defined: ${project_type^^} project"
        else
            echo -e "  ${YELLOW}!${NC} Not specified in QWEN.md"
        fi
    fi

    echo
    return 0
}

# Check for legacy Claude Code Starter files
check_legacy() {
    local project_dir="$1"

    echo -e "${CYAN}Legacy Files:${NC}"

    local found_legacy=false

    if [[ -d "$project_dir/.claude" ]]; then
        echo -e "  ${YELLOW}!${NC} .claude/ directory found (should be .qwen/)"
        found_legacy=true
    fi

    if [[ -f "$project_dir/CLAUDE.md" ]]; then
        echo -e "  ${YELLOW}!${NC} CLAUDE.md found (should be QWEN.md)"
        found_legacy=true
    fi

    if [[ -f "$project_dir/manifest.md" ]]; then
        echo -e "  ${YELLOW}!${NC} manifest.md found (use .qwenignore)"
        found_legacy=true
    fi

    if [[ "$found_legacy" == false ]]; then
        echo -e "  ${GREEN}✓${NC} No legacy files found"
    fi

    echo
    return 0
}

# Print summary
print_summary() {
    local project_dir="$1"

    echo -e "${CYAN}Summary:${NC}"

    local issues=0

    if [[ ! -d "$project_dir/.qwen" ]]; then
        echo -e "  ${RED}!${NC} Framework not installed"
        ((issues++))
    fi

    if [[ ! -f "$project_dir/QWEN.md" ]]; then
        echo -e "  ${YELLOW}!${NC} QWEN.md missing"
        ((issues++))
    fi

    if [[ ! -f "$project_dir/.qwenignore" ]]; then
        echo -e "  ${YELLOW}!${NC} .qwenignore not configured (full access)"
    fi

    if [[ -d "$project_dir/.claude" || -f "$project_dir/CLAUDE.md" ]]; then
        echo -e "  ${YELLOW}!${NC} Legacy Claude Code files present"
        ((issues++))
    fi

    if [[ $issues -eq 0 ]]; then
        echo -e "  ${GREEN}✓${NC} All checks passed"
    else
        echo -e "  ${YELLOW}•${NC} $issues issue(s) found"
    fi

    echo

    if [[ $issues -gt 0 ]]; then
        echo "Recommendations:"
        [[ ! -d "$project_dir/.qwen" ]] && echo "  - Run: init-project.sh to install framework"
        [[ ! -f "$project_dir/QWEN.md" ]] && echo "  - Create QWEN.md project passport"
        [[ ! -f "$project_dir/.qwenignore" ]] && echo "  - Create .qwenignore for restricted access"
        [[ -d "$project_dir/.claude" ]] && echo "  - Run: migrate.sh to convert from Claude Code Starter"
        echo
    fi
}

main() {
    local project_dir="${1:-.}"
    project_dir="$(cd "$project_dir" && pwd)"

    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║     Qwen Code Starter - Framework State Checker         ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo
    echo "Project: $project_dir"
    echo

    check_framework "$project_dir"
    check_repo_access "$project_dir"
    detect_project_type "$project_dir"
    check_legacy "$project_dir"
    print_summary "$project_dir"
}

main "$PROJECT_DIR"
