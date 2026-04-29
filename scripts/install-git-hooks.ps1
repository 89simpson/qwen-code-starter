#
# Install Git Post-Commit Hook (PowerShell)
# Copies the post-commit hook to .git/hooks/ for automatic SNAPSHOT.md updates
#

param(
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Install Git Post-Commit Hook

Usage: .\install-git-hooks.ps1 [-Help]

This script installs git post-commit hooks that automatically update
.qwen/SNAPSHOT.md after every git commit.

Hooks installed:
- .git/hooks/post-commit (bash, for Git Bash/WSL)
- .git/hooks/post-commit.ps1 (PowerShell, for native PowerShell)

Requirements:
- Git for Windows
- PowerShell 5.1+ or PowerShell 7+
- Execution policy that allows script execution:
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
"@
    exit 0
}

$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$ProjectRoot = Split-Path -Path $ScriptDir -Parent
$LibDir = "$ScriptDir\lib"

Write-Host "Installing git post-commit hook..."

# Check if .git directory exists
if (-not (Test-Path "$ProjectRoot\.git")) {
    Write-Host "Error: Not a git repository ($ProjectRoot)" -ForegroundColor Red
    exit 1
}

# Create hooks directory if needed
if (-not (Test-Path "$ProjectRoot\.git\hooks")) {
    New-Item -ItemType Directory -Path "$ProjectRoot\.git\hooks" -Force | Out-Null
}

# Install PowerShell hook
Copy-Item "$LibDir\post-commit-hook.ps1" "$ProjectRoot\.git\hooks\post-commit.ps1" -Force
Write-Host "✅ Installed PowerShell hook: .git\hooks\post-commit.ps1" -ForegroundColor Green

# Install bash hook (for Git Bash)
if (Test-Path "$LibDir\post-commit-hook.sh") {
    Copy-Item "$LibDir\post-commit-hook.sh" "$ProjectRoot\.git\hooks\post-commit" -Force
    # Can't chmod on Windows, but Git Bash handles it
    Write-Host "✅ Installed bash hook: .git\hooks\post-commit" -ForegroundColor Green
}

Write-Host ""
Write-Host "Git post-commit hook installed successfully!" -ForegroundColor Green
Write-Host "SNAPSHOT.md will now auto-update after every commit."
Write-Host ""
Write-Host "⚠️  If hooks don't run, check execution policy:" -ForegroundColor Yellow
Write-Host "   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
