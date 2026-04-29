#!/usr/bin/env bash
#
# Pre-Compact Hook
# Executed before Qwen Code compacts the conversation context
#
# Use this to save important context, create summaries, or preserve state
#

set -euo pipefail

# Log hook execution
echo "[PreCompact Hook] Running at $(date)"

# Example: Save conversation summary
# mkdir -p .qwen/compact-history
# echo "Compact at $(date)" >> .qwen/compact-history/log.txt

# Example: Save important variables or state
# export CONVERSATION_STATE="..."

exit 0
