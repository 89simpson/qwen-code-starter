#
# Post-Tool-Use Hook — Auto-update SNAPSHOT.md
# Executed after Qwen Code uses a tool successfully
#

param(
    [string]$ToolName = "unknown"
)

# Only update snapshot after file modifications
if ($ToolName -in @("write_file", "edit")) {
    Write-Host "[PostToolUse] Updating SNAPSHOT.md after '$ToolName'"
    
    # Get current date
    $Date = Get-Date -Format "yyyy-MM-dd HH:mm"
    
    # Get project name
    $ProjectName = Split-Path -Path $PWD -Leaf
    
    # Get recent git commits (if in git repo)
    try {
        $LatestCommit = git log -1 --oneline 2>$null
        if (-not $LatestCommit) { $LatestCommit = "no commits" }
        $CommitCount = git rev-list --count HEAD 2>$null
        if (-not $CommitCount) { $CommitCount = "0" }
    } catch {
        $LatestCommit = "no git repo"
        $CommitCount = "0"
    }
    
    # Update SNAPSHOT.md
    $SnapshotContent = @"
# Project State Snapshot

**Project:** $ProjectName  
**Last Updated:** $Date  
**Version:** v1.0.0

---

## Current Status

Auto-updated at $Date

## Recent Git Activity

**Latest commit:** $LatestCommit  
**Total commits:** $CommitCount

## Last Tool Action

**Tool:** $ToolName  
**Time:** $Date

---

*This file is auto-generated. Do not commit to version control.*
"@
    
    Set-Content -Path ".qwen\SNAPSHOT.md" -Value $SnapshotContent -Encoding UTF8
    Write-Host "[PostToolUse] SNAPSHOT.md updated"
} else {
    Write-Host "[PostToolUse] Tool executed: $ToolName (no snapshot update)"
}
