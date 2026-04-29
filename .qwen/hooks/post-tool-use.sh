#!/usr/bin/env bash
#
# Post-Tool-Use Hook
# Executed after Qwen Code uses a tool successfully
#
# Use this to log tool usage, trigger follow-up actions, or update state
#

set -euo pipefail

# Tool name is passed as first argument
TOOL_NAME="${1:-unknown}"

# Log hook execution
echo "[PostToolUse Hook] Tool '$TOOL_NAME' executed at $(date)"

# Example: Log tool usage
# echo "$(date) - $TOOL_NAME" >> .qwen/tool-log.txt

# Example: Trigger specific actions based on tool
case "$TOOL_NAME" in
    write_file|edit)
        # Run linter after code changes
        # npm run lint || true
        echo "[PostToolUse] Code file modified"
        ;;
    run_shell_command)
        echo "[PostToolUse] Command executed"
        ;;
    *)
        echo "[PostToolUse] Tool executed: $TOOL_NAME"
        ;;
esac

exit 0
