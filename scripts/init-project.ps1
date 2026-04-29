# Qwen Code Starter - Bootstrap Script
# Downloads and runs the latest init-project.ps1
#

param(
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

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red -ErrorVariable +_
}

function Write-LogVerbose {
    param([string]$Message)
    if ($VerbosePreference -eq 'Continue') {
        Write-Host "[VERBOSE] $Message" -ForegroundColor DarkGray
    }
}

function Test-Requirements {
    $missing = @()

    # Check for PowerShell version (need 5.1+)
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        $missing += "PowerShell 5.1 or later"
    }

    if ($missing.Count -gt 0) {
        Write-LogError "Missing required tools: $($missing -join ', ')"
        Write-LogError "Please install the missing tools and try again"
        exit 1
    }

    Write-LogVerbose "All requirements met"
}

function Get-Installer {
    Write-LogInfo "Downloading Qwen Code Starter installer..."

    $tempFile = [System.IO.Path]::GetTempFileName()
    $installerUrl = "https://raw.githubusercontent.com/89simpson/qwen-code-starter/master/scripts/init-project.ps1"

    try {
        # Try using Invoke-WebRequest (PowerShell 3+)
        Invoke-WebRequest -Uri $installerUrl -OutFile $tempFile -UseBasicParsing
    } catch {
        Write-LogError "Failed to download installer: $_"
        if (Test-Path $tempFile) {
            Remove-Item -Force $tempFile
        }
        exit 1
    }

    return $tempFile
}

function Main {
    Write-LogInfo "Qwen Code Starter Bootstrap"
    Write-Host ""

    Test-Requirements

    $installerFile = Get-Installer

    Write-LogSuccess "Installer downloaded successfully"
    Write-LogInfo "Running installer..."
    Write-Host ""

    # Make executable and run
    try {
        & $installerFile @args
        $exitCode = $LASTEXITCODE
    } catch {
        Write-LogError "Installation failed: $_"
        $exitCode = 1
    }

    # Cleanup
    if (Test-Path $installerFile) {
        Remove-Item -Force $installerFile
    }

    if ($exitCode -eq 0) {
        Write-Host ""
        Write-LogSuccess "Qwen Code Starter installation complete!"
    } else {
        Write-LogError "Installation failed with exit code: $exitCode"
        exit $exitCode
    }
}

if ($Help) {
    $scriptName = Split-Path $MyInvocation.ScriptName -Leaf
    @"
Qwen Code Starter - Bootstrap Script

Downloads and runs the latest init-project.ps1 from the repository.

Usage: $scriptName [OPTIONS]

Options:
    -Help, -h    Show this help message

Examples:
    $scriptName              # Download and run latest installer
    $scriptName -Help        # Show this help message

"@
    exit 0
}

Main
