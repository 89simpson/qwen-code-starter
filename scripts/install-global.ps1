# Qwen Code Starter - Global Installation Script
# Installs framework templates to ~/.qwen/
#

param(
    [switch]$Verbose = $false,
    [switch]$Force = $false,
    [switch]$Help = $false
)

# Script directory
$ScriptDir = Split-Path $MyInvocation.ScriptName -Parent
$FrameworkDir = Split-Path $ScriptDir -Parent

$QwenGlobalDir = Join-Path $HOME ".qwen"

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

function Write-LogVerbose {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "[VERBOSE] $Message" -ForegroundColor Cyan
    }
}

function Show-Usage {
    $scriptName = Split-Path $MyInvocation.ScriptName -Leaf
    @"
Qwen Code Starter - Global Installation

Installs framework templates to ~/.qwen/ for use across all projects.

Usage: $scriptName [OPTIONS]

Options:
    -Verbose, -v    Enable verbose output
    -Force, -f      Overwrite existing files without prompting
    -Help, -h       Show this help message

Examples:
    $scriptName              # Install to ~/.qwen/
    $scriptName -Force       # Force overwrite existing files
    $scriptName -Verbose     # Verbose installation

"@
    exit 0
}

function Test-Existing {
    if (Test-Path $QwenGlobalDir) {
        Write-LogWarning "Global Qwen Code directory already exists: $QwenGlobalDir"

        if (!$Force) {
            $response = Read-Host "Overwrite existing files? (y/N)"
            if ($response -notmatch '^[Yy]$') {
                Write-LogInfo "Aborting installation"
                exit 0
            }
        }

        # Backup existing installation
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupDir = "$QwenGlobalDir.backup.$timestamp"
        Write-LogInfo "Backing up existing installation to: $backupDir"
        Copy-Item -Recurse -Force $QwenGlobalDir -Destination $backupDir
    }
}

function Install-Templates {
    Write-LogInfo "Installing templates to $QwenGlobalDir"

    # Create base directory
    if (!(Test-Path $QwenGlobalDir)) {
        New-Item -ItemType Directory -Force -Path $QwenGlobalDir | Out-Null
    }

    # Install code templates
    $codeTemplatesDir = Join-Path $FrameworkDir "templates/code"
    if (Test-Path $codeTemplatesDir) {
        Write-LogInfo "Installing code project templates"
        $targetCodeDir = Join-Path $QwenGlobalDir "templates/code"
        if (!(Test-Path $targetCodeDir)) {
            New-Item -ItemType Directory -Force -Path $targetCodeDir | Out-Null
        }
        Copy-Item -Recurse -Force "$codeTemplatesDir/*" -Destination $targetCodeDir
        Write-LogVerbose "  [x] Code templates installed"
    }

    # Install content templates
    $contentTemplatesDir = Join-Path $FrameworkDir "templates/content"
    if (Test-Path $contentTemplatesDir) {
        Write-LogInfo "Installing content project templates"
        $targetContentDir = Join-Path $QwenGlobalDir "templates/content"
        if (!(Test-Path $targetContentDir)) {
            New-Item -ItemType Directory -Force -Path $targetContentDir | Out-Null
        }
        Copy-Item -Recurse -Force "$contentTemplatesDir/*" -Destination $targetContentDir
        Write-LogVerbose "  [x] Content templates installed"
    }

    # Install global templates
    $globalTemplatesDir = Join-Path $FrameworkDir "templates/global"
    if (Test-Path $globalTemplatesDir) {
        $globalItems = Get-ChildItem -Path $globalTemplatesDir -Force
        if ($globalItems.Count -gt 0) {
            Write-LogInfo "Installing global templates"
            $targetGlobalDir = Join-Path $QwenGlobalDir "templates/global"
            if (!(Test-Path $targetGlobalDir)) {
                New-Item -ItemType Directory -Force -Path $targetGlobalDir | Out-Null
            }
            Copy-Item -Recurse -Force "$globalTemplatesDir/*" -Destination $targetGlobalDir
            Write-LogVerbose "  [x] Global templates installed"
        }
    }
}

function Install-Scripts {
    Write-LogInfo "Installing utility scripts"

    $targetScriptsDir = Join-Path $QwenGlobalDir "scripts"
    if (!(Test-Path $targetScriptsDir)) {
        New-Item -ItemType Directory -Force -Path $targetScriptsDir | Out-Null
    }

    # Copy library scripts
    $libDir = Join-Path $ScriptDir "lib"
    if (Test-Path $libDir) {
        Copy-Item -Recurse -Force $libDir -Destination $targetScriptsDir
        Write-LogVerbose "  [x] Library scripts installed"
    }

    # Copy helper scripts
    foreach ($script in "framework-state-mode.ps1", "framework-state-mode.sh", "switch-repo-access.ps1", "switch-repo-access.sh") {
        $sourceScript = Join-Path $ScriptDir $script
        if (Test-Path $sourceScript) {
            Copy-Item -Force $sourceScript -Destination $targetScriptsDir
        }
    }

    Write-LogVerbose "  [x] Utility scripts installed"
}

function Install-Examples {
    Write-LogInfo "Installing example configurations"

    $targetExamplesDir = Join-Path $QwenGlobalDir "examples"
    if (!(Test-Path $targetExamplesDir)) {
        New-Item -ItemType Directory -Force -Path $targetExamplesDir | Out-Null
    }

    # Copy example .qwen directory structure
    $frameworkQwenDir = Join-Path $FrameworkDir ".qwen"
    if (Test-Path $frameworkQwenDir) {
        $targetQwenExamples = Join-Path $targetExamplesDir "qwen"
        if (!(Test-Path $targetQwenExamples)) {
            New-Item -ItemType Directory -Force -Path $targetQwenExamples | Out-Null
        }
        Copy-Item -Recurse -Force "$frameworkQwenDir/*" -Destination $targetQwenExamples
        Write-LogVerbose "  [x] Example configurations installed"
    }
}

function Create-Readme {
    Write-LogInfo "Creating global directory documentation"

    $readmePath = Join-Path $QwenGlobalDir "README.md"
    @'
# Qwen Code Global Configuration

This directory contains global Qwen Code configurations and templates.

## Structure

```
~/.qwen/
├── templates/           # Project templates
│   ├── code/           # Code project templates
│   ├── content/        # Content project templates
│   └── global/         # Global layer templates
├── scripts/            # Utility scripts
│   └── lib/            # Shared libraries
├── examples/           # Example configurations
└── README.md           # This file
```

## Usage

### Initialize a new project

```powershell
# Using the framework installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/qwen-code-starter/main/scripts/init-project.ps1" -OutFile installer.ps1
.\installer.ps1

# Or manually copy templates
Copy-Item -Recurse ~/.qwen/templates/code/* /path/to/new/project/
```

### Available Scripts

- `scripts/framework-state-mode.ps1` - Check framework state
- `scripts/switch-repo-access.ps1` - Toggle repository access modes

## Updating

To update the global installation:

```powershell
# Re-run the global installer
/path/to/qwen-code-starter/scripts/install-global.ps1
```

## Customization

You can customize templates in this directory for your personal defaults.
These will be used when initializing new projects.
'@ | Set-Content -Path $readmePath

    Write-LogVerbose "  [x] README created"
}

function Verify-Installation {
    Write-LogInfo "Verifying installation"

    $errors = 0

    # Check templates
    if (!(Test-Path (Join-Path $QwenGlobalDir "templates/code"))) {
        Write-LogError "Missing code templates"
        $errors++
    }

    if (!(Test-Path (Join-Path $QwenGlobalDir "templates/content"))) {
        Write-LogError "Missing content templates"
        $errors++
    }

    # Check scripts
    if (!(Test-Path (Join-Path $QwenGlobalDir "scripts/lib"))) {
        Write-LogError "Missing script library"
        $errors++
    }

    if ($errors -gt 0) {
        Write-LogError "Installation verification failed with $errors error(s)"
        return $false
    }

    Write-LogVerbose "  [x] All components verified"
    return $true
}

function Print-Success {
    Write-Host ""
    Write-LogSuccess "Global installation complete!"
    Write-Host ""
    Write-Host "Installed to: $QwenGlobalDir"
    Write-Host ""
    Write-Host "Contents:"
    Write-Host "  - Code project templates"
    Write-Host "  - Content project templates"
    Write-Host "  - Utility scripts"
    Write-Host "  - Example configurations"
    Write-Host ""
    Write-Host "To initialize a new project:"
    Write-Host "  Copy-Item -Recurse $QwenGlobalDir/templates/code/* /path/to/new/project/"
    Write-Host ""
    Write-Host "Or use the project initializer:"
    Write-Host "  /path/to/qwen-code-starter/init-project.ps1"
    Write-Host ""
}

function Main {
    if ($Help) {
        Show-Usage
    }

    Write-LogInfo "Qwen Code Starter - Global Installation"
    Write-Host ""
    Write-LogInfo "Installing to: $QwenGlobalDir"
    Write-Host ""

    Test-Existing
    Install-Templates
    Install-Scripts
    Install-Examples
    Create-Readme

    if (Verify-Installation) {
        Print-Success
    } else {
        Write-LogError "Installation completed with errors"
        exit 1
    }
}

Main
