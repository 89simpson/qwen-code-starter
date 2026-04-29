#!/usr/bin/env bash
#
# Post-Tool-Use Failure Hook
# Executed after a tool use fails
#
# Use this to log failures, attempt recovery, or notify about issues
#

set -euo pipefail

# Tool name and error are passed as arguments
TOOL_NAME="${1:-unknown}"
ERROR_MESSAGE="${2:-unknown error}"

# Log hook execution
echo "[PostToolUseFailure Hook] Tool '$TOOL_NAME' failed at $(date)"
echo "[PostToolUseFailure Hook] Error: $ERROR_MESSAGE"

# Example: Log failure
# echo "$(date) - $TOOL_NAME - $ERROR_MESSAGE" >> .qwen/failure-log.txt

# Example: Attempt recovery based on tool
case "$TOOL_NAME" in
    run_shell_command)
        echo "[PostToolUseFailure] Command failed - check permissions and paths"
        ;;
    write_file|edit)
        echo "[PostToolUseFailure] File operation failed - check disk space and permissions"
        ;;
    web_fetch)
        echo "[PostToolUseFailure] Web fetch failed - check network and URL"
        ;;
    *)
        echo "[PostToolUseFailure] Tool failed: $TOOL_NAME"
        ;;
esac

# Example: Notify on critical failures
# if [[ "$TOOL_NAME" == "critical_tool" ]]; then
#     echo "Critical tool failure! Notifying team..."
#     # Send notification
# fi

exit 0
