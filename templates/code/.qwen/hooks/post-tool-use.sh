#!/usr/bin/env bash
#
# Post-Tool-Use Hook — Auto-update SNAPSHOT.md
# Executed after Qwen Code uses a tool successfully
#

set -euo pipefail

TOOL_NAME="${1:-unknown}"

# Only update snapshot after file modifications
case "$TOOL_NAME" in
    write_file|edit)
        echo "[PostToolUse] Updating SNAPSHOT.md after '$TOOL_NAME'"
        
        # Get current date
        DATE=$(date +"%Y-%m-%d %H:%M")
        
        # Get recent git commits (if in git repo)
        if git rev-parse --git-dir > /dev/null 2>&1; then
            LATEST_COMMIT=$(git log -1 --oneline 2>/dev/null || echo "no commits")
            COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        else
            LATEST_COMMIT="no git repo"
            COMMIT_COUNT="0"
        fi
        
        # Update SNAPSHOT.md
        cat > .qwen/SNAPSHOT.md << EOF
# Project State Snapshot

**Project:** $(basename "$PWD")  
**Last Updated:** $DATE  
**Version:** v1.0.0

---

## Current Status

Auto-updated at $DATE

## Recent Git Activity

**Latest commit:** $LATEST_COMMIT  
**Total commits:** $COMMIT_COUNT

## Last Tool Action

**Tool:** $TOOL_NAME  
**Time:** $DATE

---

*This file is auto-generated. Do not commit to version control.*
EOF
        
        echo "[PostToolUse] SNAPSHOT.md updated"
        ;;
    *)
        echo "[PostToolUse] Tool executed: $TOOL_NAME (no snapshot update)"
        ;;
esac

exit 0
