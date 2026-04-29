# Post-Tool-Use Failure Hook
# Executed after a tool use fails
#
# Use this to log failures, attempt recovery, or notify about issues
#

param(
    [string]$ToolName = "unknown",
    [string]$ErrorMessage = "unknown error"
)

# Log hook execution
Write-Host "[PostToolUseFailure Hook] Tool '$ToolName' failed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "[PostToolUseFailure Hook] Error: $ErrorMessage"

# Example: Log failure
# $failureLogFile = Join-Path ".qwen" "failure-log.txt"
# Add-Content -Path $failureLogFile -Value "$(Get-Date) - $ToolName - $ErrorMessage"

# Example: Attempt recovery based on tool
switch ($ToolName) {
    "run_shell_command" {
        Write-Host "[PostToolUseFailure] Command failed - check permissions and paths"
    }
    { $_ -match "write_file|edit" } {
        Write-Host "[PostToolUseFailure] File operation failed - check disk space and permissions"
    }
    "web_fetch" {
        Write-Host "[PostToolUseFailure] Web fetch failed - check network and URL"
    }
    default {
        Write-Host "[PostToolUseFailure] Tool failed: $ToolName"
    }
}

# Example: Notify on critical failures
# if ($ToolName -eq "critical_tool") {
#     Write-Host "Critical tool failure! Notifying team..."
#     # Send notification
# }

exit 0
