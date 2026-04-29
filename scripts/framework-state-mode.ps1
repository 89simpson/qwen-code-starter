# Qwen Code Starter - Framework State Mode Helper
# Checks and reports the current framework state and repository access mode
#

param(
    [string]$ProjectDir = "."
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
Qwen Code Starter - Framework State Checker

Checks the current framework state and repository access mode.

Usage: $scriptName [PROJECT_DIR]

Arguments:
    PROJECT_DIR    Path to project directory (default: current directory)

Examples:
    $scriptName                    # Check current directory
    $scriptName C:\path\to\project   # Check specific project

"@
    exit 0
}

# Check for help flag
if ($ProjectDir -eq "-h" -or $ProjectDir -eq "--help") {
    Show-Usage
}

# Resolve project directory
if (!(Test-Path $ProjectDir)) {
    Write-LogError "Project directory does not exist: $ProjectDir"
    exit 1
}
$ProjectDir = (Resolve-Path $ProjectDir).Path

function Check-Framework {
    Write-Host "Framework Status:" -ForegroundColor Cyan

    $status = "not_installed"

    # Check for .qwen directory
    $qwenDir = Join-Path $ProjectDir ".qwen"
    if (Test-Path $qwenDir) {
        $status = "installed"
        Write-Host "  [x] .qwen/ directory exists" -ForegroundColor Green

        # Check for QWEN.md
        $qwenMd = Join-Path $ProjectDir "QWEN.md"
        if (Test-Path $qwenMd) {
            Write-Host "  [x] QWEN.md found" -ForegroundColor Green
        } else {
            Write-Host "  [!] QWEN.md missing" -ForegroundColor Yellow
            $status = "incomplete"
        }

        # Check for settings.json
        $settingsFile = Join-Path $qwenDir "settings.json"
        if (Test-Path $settingsFile) {
            Write-Host "  [x] settings.json found" -ForegroundColor Green
        } else {
            Write-Host "  [!] settings.json missing" -ForegroundColor Yellow
        }

        # Check for rules
        $rulesDir = Join-Path $qwenDir "rules"
        if (Test-Path $rulesDir) {
            $rulesCount = (Get-ChildItem -Path $rulesDir -Filter "*.md" -File).Count
            if ($rulesCount -gt 0) {
                Write-Host "  [x] Rules: $rulesCount rule(s)" -ForegroundColor Green
            } else {
                Write-Host "  [!] No rules found" -ForegroundColor Yellow
            }
        }

        # Check for skills
        $skillsDir = Join-Path $qwenDir "skills"
        if (Test-Path $skillsDir) {
            $skillsCount = (Get-ChildItem -Path $skillsDir -Filter "*.md" -File).Count
            if ($skillsCount -gt 0) {
                Write-Host "  [x] Skills: $skillsCount skill(s)" -ForegroundColor Green
            } else {
                Write-Host "  [!] No skills found" -ForegroundColor Yellow
            }
        }

        # Check for agents
        $agentsDir = Join-Path $qwenDir "agents"
        if (Test-Path $agentsDir) {
            $agentsCount = (Get-ChildItem -Path $agentsDir -Filter "*.md" -File).Count
            if ($agentsCount -gt 0) {
                Write-Host "  [x] Agents: $agentsCount agent(s)" -ForegroundColor Green
            } else {
                Write-Host "  [!] No agents found" -ForegroundColor Yellow
            }
        }

        # Check for hooks
        if (Test-Path $settingsFile) {
            $settings = Get-Content -Path $settingsFile -Raw | ConvertFrom-Json
            if ($settings.PSObject.Properties.Match('hooks')) {
                Write-Host "  [x] Hooks configured" -ForegroundColor Green
            } else {
                Write-Host "  [!] Hooks not configured" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  [x] .qwen/ directory not found" -ForegroundColor Red
        $status = "not_installed"
    }

    Write-Host ""
}

function Check-RepoAccess {
    Write-Host "Repository Access Mode:" -ForegroundColor Cyan

    $qwenignorePath = Join-Path $ProjectDir ".qwenignore"
    if (Test-Path $qwenignorePath) {
        Write-Host "  [x] .qwenignore found (RESTRICTED mode)" -ForegroundColor Green

        # Count ignored patterns
        $patterns = Get-Content -Path $qwenignorePath | 
                    Where-Object { $_ -notmatch '^#' -and $_ -notmatch '^\s*$' }
        $patternsCount = $patterns.Count
        Write-Host "  - $patternsCount ignore pattern(s)" -ForegroundColor Cyan

        # Show some patterns
        Write-Host "  - Sample patterns:" -ForegroundColor Cyan
        $patterns | Select-Object -First 5 | ForEach-Object {
            Write-Host "      $_"
        }

        $mode = "restricted"
    } elseif (Test-Path (Join-Path $ProjectDir ".qwen")) {
        Write-Host "  [!] .qwenignore not found (FULL ACCESS mode)" -ForegroundColor Yellow
        Write-Host "  - Qwen Code can access all files" -ForegroundColor Cyan
        $mode = "full"
    } else {
        Write-Host "  [x] Framework not installed" -ForegroundColor Red
        $mode = "unknown"
    }

    Write-Host ""
}

function Detect-ProjectType {
    Write-Host "Project Type:" -ForegroundColor Cyan

    $qwenMd = Join-Path $ProjectDir "QWEN.md"
    if (!(Test-Path $qwenMd)) {
        # Auto-detect from directory contents
        $codeScore = 0
        $contentScore = 0

        if (Test-Path (Join-Path $ProjectDir "package.json")) { $codeScore++ }
        if (Test-Path (Join-Path $ProjectDir "requirements.txt")) { $codeScore++ }
        if (Test-Path (Join-Path $ProjectDir "go.mod")) { $codeScore++ }
        if (Test-Path (Join-Path $ProjectDir "src")) { $codeScore++ }

        if (Test-Path (Join-Path $ProjectDir "mkdocs.yml")) { $contentScore++ }
        if (Test-Path (Join-Path $ProjectDir "docs")) { $contentScore++ }
        if (Test-Path (Join-Path $ProjectDir "content")) { $contentScore++ }

        if ($codeScore -gt $contentScore) {
            Write-Host "  - Detected: CODE project" -ForegroundColor Cyan
        } elseif ($contentScore -gt $codeScore) {
            Write-Host "  - Detected: CONTENT project" -ForegroundColor Cyan
        } elseif ($codeScore -gt 0 -and $contentScore -gt 0) {
            Write-Host "  - Detected: HYBRID project" -ForegroundColor Cyan
        } else {
            Write-Host "  [!] Unable to detect (no QWEN.md, minimal files)" -ForegroundColor Yellow
        }
    } else {
        # Read from QWEN.md
        $content = Get-Content -Path $qwenMd -Raw
        $projectType = $content | Select-String -Pattern "type:\s*(\w+)" | ForEach-Object { $_.Matches.Groups[1].Value }
        if (![string]::IsNullOrEmpty($projectType)) {
            Write-Host "  [x] Defined: $($projectType.ToUpper()) project" -ForegroundColor Green
        } else {
            Write-Host "  [!] Not specified in QWEN.md" -ForegroundColor Yellow
        }
    }

    Write-Host ""
}

function Check-Legacy {
    Write-Host "Legacy Files:" -ForegroundColor Cyan

    $foundLegacy = $false

    if (Test-Path (Join-Path $ProjectDir ".claude")) {
        Write-Host "  [!] .claude/ directory found (should be .qwen/)" -ForegroundColor Yellow
        $foundLegacy = $true
    }

    if (Test-Path (Join-Path $ProjectDir "CLAUDE.md")) {
        Write-Host "  [!] CLAUDE.md found (should be QWEN.md)" -ForegroundColor Yellow
        $foundLegacy = $true
    }

    if (Test-Path (Join-Path $ProjectDir "manifest.md")) {
        Write-Host "  [!] manifest.md found (use .qwenignore)" -ForegroundColor Yellow
        $foundLegacy = $true
    }

    if (!$foundLegacy) {
        Write-Host "  [x] No legacy files found" -ForegroundColor Green
    }

    Write-Host ""
}

function Print-Summary {
    Write-Host "Summary:" -ForegroundColor Cyan

    $issues = 0

    if (!(Test-Path (Join-Path $ProjectDir ".qwen"))) {
        Write-Host "  [!] Framework not installed" -ForegroundColor Red
        $issues++
    }

    if (!(Test-Path (Join-Path $ProjectDir "QWEN.md"))) {
        Write-Host "  [!] QWEN.md missing" -ForegroundColor Yellow
        $issues++
    }

    if (!(Test-Path (Join-Path $ProjectDir ".qwenignore"))) {
        Write-Host "  [!] .qwenignore not configured (full access)" -ForegroundColor Yellow
    }

    if ((Test-Path (Join-Path $ProjectDir ".claude")) -or (Test-Path (Join-Path $ProjectDir "CLAUDE.md"))) {
        Write-Host "  [!] Legacy Claude Code files present" -ForegroundColor Yellow
        $issues++
    }

    if ($issues -eq 0) {
        Write-Host "  [x] All checks passed" -ForegroundColor Green
    } else {
        Write-Host "  - $issues issue(s) found" -ForegroundColor Yellow
    }

    Write-Host ""

    if ($issues -gt 0) {
        Write-Host "Recommendations:"
        if (!(Test-Path (Join-Path $ProjectDir ".qwen"))) { 
            Write-Host "  - Run: init-project.ps1 to install framework" 
        }
        if (!(Test-Path (Join-Path $ProjectDir "QWEN.md"))) { 
            Write-Host "  - Create QWEN.md project passport" 
        }
        if (!(Test-Path (Join-Path $ProjectDir ".qwenignore"))) { 
            Write-Host "  - Create .qwenignore for restricted access" 
        }
        if ((Test-Path (Join-Path $ProjectDir ".claude")) -or (Test-Path (Join-Path $ProjectDir "CLAUDE.md"))) { 
            Write-Host "  - Run: migrate.ps1 to convert from Claude Code Starter" 
        }
        Write-Host ""
    }
}

# Main execution
Write-Host @"
+==========================================================+
|     Qwen Code Starter - Framework State Checker         |
+==========================================================+

Project: $ProjectDir

"@

Check-Framework
Check-RepoAccess
Detect-ProjectType
Check-Legacy
Print-Summary
