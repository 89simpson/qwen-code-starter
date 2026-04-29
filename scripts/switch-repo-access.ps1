# Qwen Code Starter - Repository Access Switcher
# Toggles between full and restricted repository access modes
#

param(
    [string]$Mode = "",
    [string]$ProjectDir = ".",
    [switch]$Help = $false
)

function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red -ErrorVariable +_
}

function Show-Usage {
    $scriptName = Split-Path $MyInvocation.ScriptName -Leaf
    @"
Qwen Code Starter - Repository Access Switcher

Switches between full and restricted repository access modes.

Usage: $scriptName <MODE> [PROJECT_DIR]

Arguments:
    MODE           Access mode: full, restricted, status
    PROJECT_DIR    Path to project (default: current directory)

Modes:
    full           Qwen Code can access all files
    restricted     Qwen Code respects .qwenignore patterns
    status         Show current access mode

Examples:
    $scriptName status               # Check current mode
    $scriptName restricted           # Enable restricted access
    $scriptName full                 # Enable full access
    $scriptName restricted C:\path\to  # Set mode for specific project

"@
    exit 0
}

function Test-Arguments {
    if ([string]::IsNullOrEmpty($Mode) -or $Mode -eq "-h" -or $Mode -eq "--help") {
        Show-Usage
    }

    switch ($Mode) {
        "full" { }
        "restricted" { }
        "status" { }
        default {
            Write-LogError "Invalid mode: $Mode"
            Write-LogError "Valid modes: full, restricted, status"
            Show-Usage
        }
    }

    # Resolve project directory
    if (!(Test-Path $ProjectDir)) {
        Write-LogError "Project directory does not exist: $ProjectDir"
        exit 1
    }
    $script:ProjectDir = (Resolve-Path $ProjectDir).Path
}

function Show-Status {
    Write-Host @"
+==========================================================+
|        Repository Access Mode - Status                   |
+==========================================================+

Project: $ProjectDir

"@

    $qwenignorePath = Join-Path $ProjectDir ".qwenignore"
    if (Test-Path $qwenignorePath) {
        Write-Host "Current Mode: RESTRICTED" -ForegroundColor Green
        Write-Host ""
        Write-Host ".qwenignore is active with the following patterns:"
        Write-Host ""
        
        $patterns = Get-Content -Path $qwenignorePath | 
                    Where-Object { $_ -notmatch '^#' -and $_ -notmatch '^\s*$' }
        foreach ($pattern in $patterns) {
            Write-Host "  - $pattern"
        }
        Write-Host ""
        Write-Host "Qwen Code will NOT access files matching these patterns."
    } else {
        Write-Host "Current Mode: FULL ACCESS" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "No .qwenignore file found."
        Write-Host "Qwen Code can access all files in the repository."
    }

    Write-Host ""
    Write-Host "To change mode:"
    Write-Host "  $((Split-Path $MyInvocation.ScriptName -Leaf)) restricted    # Enable restricted access"
    Write-Host "  $((Split-Path $MyInvocation.ScriptName -Leaf)) full          # Enable full access"
    Write-Host ""
}

function Enable-Restricted {
    Write-LogInfo "Enabling restricted repository access"

    $qwenignorePath = Join-Path $ProjectDir ".qwenignore"
    if (Test-Path $qwenignorePath) {
        Write-LogWarning ".qwenignore already exists"
        $response = Read-Host "Overwrite existing .qwenignore? (y/N)"
        if ($response -notmatch '^[Yy]$') {
            Write-LogInfo "Aborting"
            exit 0
        }
    }

    # Create .qwenignore
    @'
# Qwen Code Ignore File
# Repository Access Mode: RESTRICTED
#
# Qwen Code will not access files matching these patterns.
# See: https://qwen-code.dev/docs/repo-access

# Environment and secrets
.env
.env.*
*.env
*.key
*.pem
*.crt
*.secret
secrets/
credentials/
passwords/

# Personal IDE settings
.idea/
.vscode/settings.json
.vscode/launch.json
*.swp
*.swo
*~

# Local configuration
.local.env
.config.local
*.local

# Build artifacts (optional)
# Uncomment if you want to exclude build outputs
# dist/
# build/
# *.o
# *.pyc
# __pycache__/
# node_modules/

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db
'@ | Set-Content -Path $qwenignorePath

    Write-LogSuccess "Restricted access enabled"
    Write-Host ""
    Write-Host "Created .qwenignore with default patterns."
    Write-Host "Edit .qwenignore to customize which files Qwen Code cannot access."
    Write-Host ""
}

function Enable-Full {
    Write-LogInfo "Enabling full repository access"

    $qwenignorePath = Join-Path $ProjectDir ".qwenignore"
    if (!(Test-Path $qwenignorePath)) {
        Write-LogWarning "No .qwenignore file found"
        Write-Host "Already in full access mode."
        exit 0
    }

    $response = Read-Host "Remove .qwenignore and enable full access? (y/N)"
    if ($response -notmatch '^[Yy]$') {
        Write-LogInfo "Aborting"
        exit 0
    }

    # Backup and remove
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupFile = "$qwenignorePath.backup.$timestamp"
    Move-Item -Force $qwenignorePath -Destination $backupFile

    Write-LogSuccess "Full access enabled"
    Write-Host ""
    Write-Host "Removed .qwenignore (backed up to: $(Split-Path $backupFile -Leaf))"
    Write-Host "Qwen Code can now access all files in the repository."
    Write-Host ""
    Write-Host "To restore restricted access:"
    Write-Host "  Move-Item $backupFile $qwenignorePath"
    Write-Host ""
}

# Main execution
Test-Arguments

switch ($Mode) {
    "status" { Show-Status }
    "restricted" { Enable-Restricted }
    "full" { Enable-Full }
}
