# Subagent Stop Hook
# Executed when a subagent stops execution
#
# Use this to collect subagent output, update state, or trigger follow-up actions
#

param(
    [string]$SubagentName = "unknown"
)

# Log hook execution
Write-Host "[SubagentStop Hook] Subagent '$SubagentName' stopped at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Example: Collect subagent results
# $resultsDir = Join-Path ".qwen" "subagent-results"
# if (!(Test-Path $resultsDir)) {
#     New-Item -ItemType Directory -Force -Path $resultsDir | Out-Null
# }
# Add-Content -Path (Join-Path $resultsDir "log.txt") -Value "Subagent $SubagentName completed at $(Get-Date)"

# Example: Process subagent output
switch ($SubagentName) {
    "researcher" {
        Write-Host "[SubagentStop] Research subagent completed - review findings"
    }
    "implementer" {
        Write-Host "[SubagentStop] Implementation subagent completed - review code"
    }
    "reviewer" {
        Write-Host "[SubagentStop] Review subagent completed - address feedback"
    }
    default {
        Write-Host "[SubagentStop] Subagent completed: $SubagentName"
    }
}

# Example: Trigger next step in workflow
# if ($SubagentName -eq "researcher") {
#     Write-Host "Research complete - ready for implementation"
# }

exit 0
