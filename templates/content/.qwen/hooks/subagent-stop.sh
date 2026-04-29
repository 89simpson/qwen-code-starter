#!/usr/bin/env bash
#
# Subagent Stop Hook
# Executed when a subagent stops execution
#
# Use this to collect subagent output, update state, or trigger follow-up actions
#

set -euo pipefail

# Subagent name is passed as first argument
SUBAGENT_NAME="${1:-unknown}"

# Log hook execution
echo "[SubagentStop Hook] Subagent '$SUBAGENT_NAME' stopped at $(date)"

# Example: Collect subagent results
# mkdir -p .qwen/subagent-results
# echo "Subagent $SUBAGENT_NAME completed at $(date)" >> .qwen/subagent-results/log.txt

# Example: Process subagent output
case "$SUBAGENT_NAME" in
    researcher)
        echo "[SubagentStop] Research subagent completed - review findings"
        ;;
    implementer)
        echo "[SubagentStop] Implementation subagent completed - review code"
        ;;
    reviewer)
        echo "[SubagentStop] Review subagent completed - address feedback"
        ;;
    *)
        echo "[SubagentStop] Subagent completed: $SUBAGENT_NAME"
        ;;
esac

# Example: Trigger next step in workflow
# if [[ "$SUBAGENT_NAME" == "researcher" ]]; then
#     echo "Research complete - ready for implementation"
# fi

exit 0
