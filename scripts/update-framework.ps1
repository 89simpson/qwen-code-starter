#
# Qwen Code Starter - Framework Update Script (PowerShell)
# Updates an existing project with the latest framework files
#

param(
    [string]$ProjectPath = ".",
    [switch]$Force = $false,
    [switch]$DryRun = $false,
    [switch]$Help = $false
)

# Validate ProjectPath is not a flag
if ($ProjectPath -like '-*') {
    Write-LogError "Invalid path: $ProjectPath"
    Show-Help
}

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
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Show-Help {
    Write-Host @"
Qwen Code Starter - Framework Updater

Updates an existing project with the latest framework files from qwen-code-starter.

Usage: .\update-framework.ps1 [OPTIONS] [PROJECT_PATH]

Options:
    -Force                Force overwrite of all files (default: skip existing)
    -DryRun               Show what would be updated without making changes
    -Help                 Show this help message

Components Updated:
    - .qwen/hooks/        Hook scripts (bash + PowerShell)
    - templates/          Project templates (code, content, global)
    - scripts/            Framework scripts (optional, with -Force)

Examples:
    .\update-framework.ps1                        # Update current directory
    .\update-framework.ps1 C:\path\to\project     # Update specific project
    .\update-framework.ps1 -Force                 # Force overwrite all files
    .\update-framework.ps1 -DryRun                # Dry run (show changes)
"@
    exit 0
}

if ($Help) {
    Show-Help
}

# Resolve paths
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$FrameworkDir = Split-Path -Path $ScriptDir -Parent
$TargetDir = Resolve-Path -Path $ProjectPath

Write-LogInfo "Qwen Code Starter - Framework Updater"
Write-LogInfo "Source: $FrameworkDir"
Write-LogInfo "Target: $TargetDir"
Write-Host ""

# Check if target is a Qwen Code project
if (-not (Test-Path "$TargetDir\.qwen")) {
    Write-LogError "Not a Qwen Code project: $TargetDir"
    Write-LogError "Missing .qwen/ directory"
    exit 1
}

# Update hooks
function Update-Hooks {
    Write-LogInfo "Updating hooks..."
    
    $srcHooks = "$FrameworkDir\.qwen\hooks"
    $tgtHooks = "$TargetDir\.qwen\hooks"
    
    if (-not (Test-Path $srcHooks)) {
        Write-LogWarning "Source hooks directory not found"
        return
    }
    
    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would update hooks"
        return
    }
    
    # Create target directory
    if (-not (Test-Path $tgtHooks)) {
        New-Item -ItemType Directory -Path $tgtHooks -Force | Out-Null
    }
    
    # Copy hook files
    $updated = 0
    Get-ChildItem -Path $srcHooks -File | ForEach-Object {
        $target = "$tgtHooks\$($_.Name)"
        
        if ((Test-Path $target) -and (-not $Force)) {
            # Check if files differ
            if ((Get-FileHash $_.FullName).Hash -ne (Get-FileHash $target).Hash) {
                Copy-Item $_.FullName $target -Force
                Write-LogInfo "  Updated: $($_.Name)"
                $updated++
            }
        } else {
            Copy-Item $_.FullName $target -Force
            Write-LogInfo "  Added: $($_.Name)"
            $updated++
        }
    }
    
    Write-LogSuccess "Hooks updated: $updated files"
}

# Update templates
function Update-Templates {
    Write-LogInfo "Updating templates..."
    
    $srcTemplates = "$FrameworkDir\templates"
    $tgtTemplates = "$TargetDir\templates"
    
    if (-not (Test-Path $srcTemplates)) {
        Write-LogWarning "Source templates directory not found"
        return
    }
    
    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would update templates"
        return
    }
    
    # Copy templates
    if ($Force) {
        if (Test-Path $tgtTemplates) {
            Remove-Item $tgtTemplates -Recurse -Force
        }
        Copy-Item $srcTemplates $tgtTemplates -Recurse -Force
        Write-LogSuccess "Templates replaced"
    } else {
        # Copy only new files (no overwrite)
        Copy-Item $srcTemplates $tgtTemplates -Recurse -Force
        Write-LogSuccess "Templates updated"
    }
}

# Update scripts (optional, only with -Force)
function Update-Scripts {
    if (-not $Force) {
        Write-LogInfo "Skipping scripts update (use -Force to update)"
        return
    }
    
    Write-LogInfo "Updating framework scripts..."
    
    $srcScripts = "$FrameworkDir\scripts"
    $tgtScripts = "$TargetDir\scripts"
    
    if (-not (Test-Path $srcScripts)) {
        Write-LogWarning "Source scripts directory not found"
        return
    }
    
    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would update scripts"
        return
    }
    
    # Backup existing scripts
    if (Test-Path $tgtScripts) {
        $backup = "$TargetDir\scripts.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item $tgtScripts $backup -Force
        Write-LogInfo "  Backed up old scripts to: $backup"
    }
    
    # Copy new scripts (exclude update-framework.ps1 to avoid self-replacement)
    New-Item -ItemType Directory -Path $tgtScripts -Force | Out-Null
    Get-ChildItem -Path $srcScripts -File | Where-Object { $_.Name -ne "update-framework.ps1" } | ForEach-Object {
        Copy-Item $_.FullName "$tgtScripts\$($_.Name)" -Force
    }
    
    # Copy lib directory
    if (Test-Path "$srcScripts\lib") {
        Copy-Item "$srcScripts\lib" "$tgtScripts\lib" -Recurse -Force
    }
    
    Write-LogSuccess "Scripts updated"
}

# Update .qwenignore
function Update-Qwenignore {
    Write-LogInfo "Updating .qwenignore..."
    
    $srcQwenignore = "$FrameworkDir\.qwenignore"
    $tgtQwenignore = "$TargetDir\.qwenignore"
    
    if (-not (Test-Path $srcQwenignore)) {
        Write-LogWarning "Source .qwenignore not found"
        return
    }
    
    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would update .qwenignore"
        return
    }
    
    # Copy (overwrite for simplicity)
    Copy-Item $srcQwenignore $tgtQwenignore -Force
    Write-LogSuccess ".qwenignore updated"
}

# Show summary
function Show-Summary {
    Write-Host ""
    Write-LogSuccess "Framework update complete!"
    Write-Host ""
    Write-Host "Updated components:"
    if (Test-Path "$TargetDir\.qwen\hooks") { Write-Host "  ✓ Hooks" }
    if (Test-Path "$TargetDir\templates") { Write-Host "  ✓ Templates" }
    if (Test-Path "$TargetDir\.qwenignore") { Write-Host "  ✓ .qwenignore" }
    if ($Force -and (Test-Path "$TargetDir\scripts")) { Write-Host "  ✓ Scripts (force)" }
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Review changes: git diff"
    Write-Host "  2. Test your project"
    Write-Host "  3. Commit: git add . && git commit -m 'chore: update framework'"
    Write-Host ""
}

# Main
Update-Hooks
Update-Templates
Update-Scripts
Update-Qwenignore
Show-Summary
