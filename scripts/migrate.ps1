# Qwen Code Starter - Migration Script
# Migrates Claude Code Starter projects to Qwen Code Starter
#

param(
    [switch]$Verbose = $false,
    [switch]$DryRun = $false,
    [switch]$Help = $false,
    [string]$SourceDir = "",
    [string]$TargetDir = ""
)

# Colors for output
$Colors = @{
    Red    = 'Red'
    Green  = 'Green'
    Yellow = 'Yellow'
    Blue   = 'Blue'
    None   = ''
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
Qwen Code Starter - Migration Tool

Migrates Claude Code Starter projects to Qwen Code Starter format.

Usage: $scriptName [OPTIONS] <SOURCE_DIR> [TARGET_DIR]

Options:
    -Verbose, -v      Enable verbose output
    -DryRun, -n       Show what would be done without making changes
    -Help, -h         Show this help message

Arguments:
    SOURCE_DIR        Path to existing Claude Code Starter project
    TARGET_DIR        Path for migrated project (default: SOURCE_DIR)

Examples:
    $scriptName /path/to/claude-project
    $scriptName /path/to/claude-project /path/to/qwen-project
    $scriptName -Verbose -DryRun /path/to/claude-project

"@
    exit 0
}

function Test-IsFrameworkClone {
    param([string]$Dir)
    return (Test-Path (Join-Path $Dir "templates")) -and 
           (Test-Path (Join-Path $Dir "scripts")) -and 
           (Test-Path (Join-Path $Dir "tests"))
}

function Invoke-MigrateFrameworkFiles {
    Write-LogInfo "Updating framework files from qwen-code-starter"

    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would copy framework files"
        return
    }

    $scriptDir = Split-Path $MyInvocation.ScriptName -Parent
    $frameworkDir = Split-Path $scriptDir -Parent

    # Copy templates from qwen-code-starter
    $templatesDir = Join-Path $frameworkDir "templates"
    if (Test-Path $templatesDir) {
        $targetTemplates = Join-Path $TargetDir "templates"
        if (Test-Path $targetTemplates) {
            Remove-Item -Recurse -Force $targetTemplates
        }
        Copy-Item -Recurse -Force $templatesDir -Destination $TargetDir
        Write-LogVerbose "Copied templates from framework"
    }

    # Copy scripts from qwen-code-starter (except migrate.ps1/migrate.sh)
    $scriptsDir = Join-Path $frameworkDir "scripts"
    if (Test-Path $scriptsDir) {
        $targetScripts = Join-Path $TargetDir "scripts"
        if (!(Test-Path $targetScripts)) {
            New-Item -ItemType Directory -Force -Path $targetScripts | Out-Null
        }
        
        Get-ChildItem -Path $scriptsDir -File | ForEach-Object {
            $basename = $_.Name
            if ($basename -ne "migrate.sh" -and $basename -ne "migrate.ps1") {
                Copy-Item -Force $_.FullName -Destination $targetScripts
            }
        }
        
        # Copy lib directory
        $libDir = Join-Path $scriptsDir "lib"
        if (Test-Path $libDir) {
            Copy-Item -Recurse -Force $libDir -Destination $targetScripts
        }
        Write-LogVerbose "Copied scripts from framework"
    }

    # Copy tests from qwen-code-starter
    $testsDir = Join-Path $frameworkDir "tests"
    if (Test-Path $testsDir) {
        $targetTests = Join-Path $TargetDir "tests"
        if (Test-Path $targetTests) {
            Remove-Item -Recurse -Force $targetTests
        }
        Copy-Item -Recurse -Force $testsDir -Destination $TargetDir
        Write-LogVerbose "Copied tests from framework"
    }

    # Copy release-notes from qwen-code-starter
    $releaseNotesDir = Join-Path $frameworkDir "release-notes"
    if (Test-Path $releaseNotesDir) {
        $targetReleaseNotes = Join-Path $TargetDir "release-notes"
        if (Test-Path $targetReleaseNotes) {
            Remove-Item -Recurse -Force $targetReleaseNotes
        }
        Copy-Item -Recurse -Force $releaseNotesDir -Destination $TargetDir
        Write-LogVerbose "Copied release-notes from framework"
    }

    # Copy core files from qwen-code-starter
    foreach ($file in "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE", "init-project.sh") {
        $sourceFile = Join-Path $frameworkDir $file
        if (Test-Path $sourceFile) {
            Copy-Item -Force $sourceFile -Destination $TargetDir
        }
    }
    Write-LogVerbose "Copied core files from framework"
}

function Invoke-CheckSource {
    Write-LogInfo "Checking source directory: $SourceDir"

    if (!(Test-Path $SourceDir)) {
        Write-LogError "Source directory does not exist: $SourceDir"
        exit 1
    }

    $hasClaude = $false

    if (Test-Path (Join-Path $SourceDir ".claude")) {
        $hasClaude = $true
        Write-LogVerbose "Found .claude/ directory"
    }

    if (Test-Path (Join-Path $SourceDir "CLAUDE.md")) {
        $hasClaude = $true
        Write-LogVerbose "Found CLAUDE.md"
    }

    # Check if this is a framework clone
    if (Test-IsFrameworkClone -Dir $SourceDir) {
        Write-LogInfo "Detected framework clone - will update framework files"
        $script:IsFrameworkClone = $true
    } else {
        $script:IsFrameworkClone = $false
    }

    if (!$hasClaude -and !$script:IsFrameworkClone) {
        Write-LogWarning "Directory does not appear to be a Claude Code Starter project"
        Write-LogWarning "Proceeding anyway..."
    }
}

function Invoke-MigrateAgentsFlat {
    param([string]$AgentsDir)

    # Find all nested agent files
    $agentFiles = Get-ChildItem -Path $AgentsDir -Filter "*.md" -Recurse -File | 
                  Where-Object { $_.DirectoryName -ne $AgentsDir }

    foreach ($agentFile in $agentFiles) {
        $filename = $agentFile.Name
        $flatPath = Join-Path $AgentsDir $filename

        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would flatten: $($agentFile.FullName) -> $flatPath"
        } else {
            if (Test-Path $flatPath) {
                Write-LogWarning "Agent already exists at $flatPath, skipping"
            } else {
                Move-Item -Force $agentFile.FullName -Destination $flatPath
                Write-LogVerbose "Flattened: $filename"
            }
        }
    }

    # Remove empty nested directories
    if (!$DryRun) {
        Get-ChildItem -Path $AgentsDir -Recurse -Directory | 
            Sort-Object -Property FullName -Descending |
            Where-Object { (Get-ChildItem -Path $_.FullName -Force).Count -eq 0 } |
            ForEach-Object { Remove-Item -Force $_.FullName }
    }
}

function Invoke-MigrateDirectories {
    Write-LogInfo "Migrating directory structure"

    # Ensure target directory exists
    if (!(Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    }

    # For framework clones: replace framework files, preserve user data
    if ($script:IsFrameworkClone) {
        Write-LogInfo "Migrating framework clone - replacing framework files"
        Invoke-MigrateFrameworkFiles
    }

    # Copy user project files (exclude framework dirs, .git, .qwen, .claude)
    Write-LogInfo "Copying project files from $SourceDir to $TargetDir"
    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would copy project files"
    } else {
        # Copy user files manually (exclude framework dirs)
        $excludePatterns = @('.git', '.qwen', '.claude', 'templates', 'scripts', 'tests', 
                            'release-notes', 'CHANGELOG.md', 'CONTRIBUTING.md', 'init-project.sh')
        
        Get-ChildItem -Path $SourceDir -Force | ForEach-Object {
            $basename = $_.Name
            if ($excludePatterns -notcontains $basename) {
                $destPath = Join-Path $TargetDir $basename
                Copy-Item -Recurse -Force $_.FullName -Destination $destPath
            }
        }
        Write-LogVerbose "Copied project files"
    }

    # .claude -> .qwen (copy, not move, to support cross-filesystem migration)
    $sourceClaude = Join-Path $SourceDir ".claude"
    if (Test-Path $sourceClaude) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would copy .claude/ to .qwen/"
        } else {
            $targetQwen = Join-Path $TargetDir ".qwen"
            if (Test-Path $targetQwen) {
                Write-LogWarning ".qwen/ already exists, removing"
                Remove-Item -Recurse -Force $targetQwen
            }
            # Use Copy-Item instead of Move-Item to support cross-filesystem
            Copy-Item -Recurse -Force $sourceClaude -Destination $targetQwen
            # Remove .claude from target (it was copied from source)
            $targetClaude = Join-Path $TargetDir ".claude"
            if (Test-Path $targetClaude) {
                Remove-Item -Recurse -Force $targetClaude
            }
            Write-LogVerbose "Copied .claude/ to .qwen/"
        }
    }

    # Migrate nested agent directories to flat structure
    $agentsDir = Join-Path $TargetDir ".qwen/agents"
    if (Test-Path $agentsDir) {
        Write-LogInfo "Converting agents to flat structure"
        Invoke-MigrateAgentsFlat -AgentsDir $agentsDir
    }
}

function Invoke-MigrateProjectPassport {
    Write-LogInfo "Migrating project passport"

    $sourceClaudeMd = Join-Path $SourceDir "CLAUDE.md"
    $targetQwenMd = Join-Path $TargetDir "QWEN.md"

    if (Test-Path $sourceClaudeMd) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would copy CLAUDE.md to QWEN.md"
        } else {
            if (Test-Path $targetQwenMd) {
                Write-LogWarning "QWEN.md already exists, backing up"
                $backupPath = "$targetQwenMd.backup"
                Move-Item -Force $targetQwenMd -Destination $backupPath
            }
            # Use Copy-Item instead of Move-Item to support cross-filesystem migration
            Copy-Item -Force $sourceClaudeMd -Destination $targetQwenMd

            # Replace CLAUDE references with QWEN in the file
            $content = Get-Content -Path $targetQwenMd -Raw
            $content = $content -replace 'CLAUDE\.md', 'QWEN.md' -replace '\.claude', '.qwen'
            Set-Content -Path $targetQwenMd -Value $content -NoNewline

            # Remove original CLAUDE.md (replaced by QWEN.md)
            $targetClaudeMd = Join-Path $TargetDir "CLAUDE.md"
            if (Test-Path $targetClaudeMd) {
                Remove-Item -Force $targetClaudeMd
            }

            Write-LogVerbose "Copied CLAUDE.md to QWEN.md"
        }
    } elseif (Test-Path (Join-Path $SourceDir "QWEN.md")) {
        Write-LogVerbose "QWEN.md already exists"
    }
}

function Invoke-MigrateSnapshot {
    Write-LogInfo "Migrating project state (SNAPSHOT.md)"

    $sourceClaudeSnapshot = Join-Path $SourceDir ".claude/SNAPSHOT.md"
    $sourceSnapshot = Join-Path $SourceDir "SNAPSHOT.md"
    $targetQwenSnapshot = Join-Path $TargetDir ".qwen/SNAPSHOT.md"

    if (Test-Path $sourceClaudeSnapshot) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would copy SNAPSHOT.md to .qwen/SNAPSHOT.md"
        } else {
            Copy-Item -Force $sourceClaudeSnapshot -Destination $targetQwenSnapshot
            Write-LogVerbose "Copied SNAPSHOT.md (project state preserved)"
        }
    } elseif (Test-Path $sourceSnapshot) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would copy SNAPSHOT.md to .qwen/SNAPSHOT.md"
        } else {
            Copy-Item -Force $sourceSnapshot -Destination $targetQwenSnapshot
            Write-LogVerbose "Copied SNAPSHOT.md (project state preserved)"
        }
    } else {
        Write-LogVerbose "No SNAPSHOT.md found (new project state will be created)"
    }
}

function Invoke-MigrateSkills {
    Write-LogInfo "Migrating skills"

    $skillsDir = Join-Path $TargetDir ".qwen/skills"

    if (!(Test-Path $skillsDir)) {
        Write-LogVerbose "No skills directory found"
        return
    }

    $skillFiles = Get-ChildItem -Path $skillsDir -Filter "*.md" -Recurse -File
    foreach ($skillFile in $skillFiles) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would migrate skill: $($skillFile.FullName)"
        } else {
            # Remove allowed-tools and disable-model-invocation from frontmatter
            $content = Get-Content -Path $skillFile.FullName -Raw
            
            # Remove allowed-tools from frontmatter
            $content = $content -replace 'allowed-tools:.*?\n', ''
            $content = $content -replace '- allowed-tool:.*?\n', ''
            
            # Remove disable-model-invocation from frontmatter
            $content = $content -replace 'disable-model-invocation:.*?\n', ''
            
            Set-Content -Path $skillFile.FullName -Value $content -NoNewline
            Write-LogVerbose "Migrated skill: $($skillFile.Name)"
        }
    }
}

function Invoke-MigrateHooks {
    Write-LogInfo "Migrating hooks configuration"

    $settingsFile = Join-Path $TargetDir ".qwen/settings.json"

    # Replace old Claude hooks with Qwen hooks from framework
    $scriptDir = Split-Path $MyInvocation.ScriptName -Parent
    $frameworkHooksDir = Join-Path (Split-Path $scriptDir -Parent) ".qwen/hooks"
    
    if (Test-Path $frameworkHooksDir) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would replace hooks with qwen-code-starter versions"
        } else {
            # Remove old hooks and copy fresh ones from framework
            $targetHooksDir = Join-Path $TargetDir ".qwen/hooks"
            if (Test-Path $targetHooksDir) {
                Remove-Item -Recurse -Force $targetHooksDir
            }
            Copy-Item -Recurse -Force $frameworkHooksDir -Destination (Join-Path $TargetDir ".qwen")
            Write-LogVerbose "Replaced hooks with qwen-code-starter versions"
        }
    }

    if (!(Test-Path $settingsFile)) {
        Write-LogVerbose "No settings.json found"
        return
    }

    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would migrate hooks in settings.json"
    } else {
        # Update hooks paths from .claude to .qwen and use standard qwen hooks
        $settings = Get-Content -Path $settingsFile -Raw | ConvertFrom-Json

        if ($settings.PSObject.Properties.Match('hooks')) {
            # Remove PostCompact hooks (not supported by Qwen Code)
            if ($settings.hooks.PSObject.Properties.Match('PostCompact')) {
                $settings.hooks.PSObject.Properties.Remove('PostCompact')
            }

            # Fix paths in remaining hooks (.claude -> .qwen)
            # Structure: hooks[hook_type][] -> hooks[] -> command
            foreach ($hookType in $settings.hooks.PSObject.Properties.Name) {
                $hookConfigs = $settings.hooks.$hookType
                if ($hookConfigs -is [System.Array]) {
                    foreach ($hookConfig in $hookConfigs) {
                        if ($hookConfig.PSObject.Properties.Match('hooks')) {
                            foreach ($hook in $hookConfig.hooks) {
                                if ($hook.PSObject.Properties.Match('command')) {
                                    # Replace .claude/hooks with .qwen/hooks
                                    $hook.command = $hook.command -replace '\.claude/hooks', '.qwen/hooks'
                                    # Replace specific hook file names with standard qwen hooks
                                    $hook.command = $hook.command -replace 'post-tool-check\.sh', 'post-tool-use.sh'
                                    $hook.command = $hook.command -replace 'subagent-done\.sh', 'subagent-stop.sh'
                                }
                            }
                        }
                    }
                }
            }

            # Add PostToolUseFailure if not present
            if (!$settings.hooks.PSObject.Properties.Match('PostToolUseFailure')) {
                $settings.hooks | Add-Member -MemberType NoteProperty -Name 'PostToolUseFailure' -Value @()
            }
        }

        $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile
        Write-LogVerbose "Migrated hooks configuration"
    }
}

function Invoke-MigratePermissions {
    Write-LogInfo "Migrating permissions"

    $sourceManifest = Join-Path $SourceDir "manifest.md"
    $targetQwenignore = Join-Path $TargetDir ".qwenignore"

    if (Test-Path $sourceManifest) {
        if ($DryRun) {
            Write-LogInfo "[DRY RUN] Would convert manifest.md to .qwenignore"
        } else {
            Write-LogInfo "Converting manifest.md to .qwenignore format"

            # Create .qwenignore from manifest
            @'
# Qwen Code Ignore File
# Generated from manifest.md migration

# Environment and secrets
.env
.env.*
*.env
*.key
*.pem
*.crt
secrets/
credentials/

# IDE and editor files
.idea/
.vscode/
*.swp
*.swo
*~

# Build artifacts
dist/
build/
*.o
*.pyc
__pycache__/
node_modules/

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db
'@ | Set-Content -Path $targetQwenignore

            # Remove original manifest.md (replaced by .qwenignore)
            $targetManifest = Join-Path $TargetDir "manifest.md"
            if (Test-Path $targetManifest) {
                Remove-Item -Force $targetManifest
            }

            Write-LogVerbose "Created .qwenignore"
        }
    } elseif (!(Test-Path $targetQwenignore)) {
        # Create default .qwenignore
        if (!$DryRun) {
            @'
# Qwen Code Ignore File

# Environment and secrets
.env
.env.*
*.key
secrets/

# Build artifacts
node_modules/
__pycache__/
*.pyc
'@ | Set-Content -Path $targetQwenignore
            Write-LogVerbose "Created default .qwenignore"
        }
    }
}

function Invoke-UpdateReferences {
    Write-LogInfo "Updating references in markdown files"

    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would update references in markdown files"
        return
    }

    $mdFiles = Get-ChildItem -Path $TargetDir -Filter "*.md" -Recurse -File
    foreach ($mdFile in $mdFiles) {
        $content = Get-Content -Path $mdFile.FullName -Raw
        if ($content -match "CLAUDE|\.claude") {
            $content = $content -replace 'CLAUDE\.md', 'QWEN.md' -replace '\.claude', '.qwen' -replace 'Claude Code', 'Qwen Code'
            Set-Content -Path $mdFile.FullName -Value $content -NoNewline
            Write-LogVerbose "Updated references in: $($mdFile.Name)"
        }
    }
}

function Invoke-Cleanup {
    Write-LogInfo "Cleaning up"

    if ($DryRun) {
        Write-LogInfo "[DRY RUN] Would remove empty directories"
        return
    }

    # Remove empty directories in .qwen
    $qwenDir = Join-Path $TargetDir ".qwen"
    if (Test-Path $qwenDir) {
        Get-ChildItem -Path $qwenDir -Recurse -Directory | 
            Sort-Object -Property FullName -Descending |
            Where-Object { (Get-ChildItem -Path $_.FullName -Force).Count -eq 0 } |
            ForEach-Object { Remove-Item -Force $_.FullName }
    }

    Write-LogVerbose "Cleanup complete"
}

function Invoke-GenerateReport {
    Write-Host ""
    Write-LogSuccess "Migration complete!"
    Write-Host ""
    Write-Host "Migration Summary:"
    Write-Host "  Source: $SourceDir"
    Write-Host "  Target: $TargetDir"
    if ($script:IsFrameworkClone) {
        Write-Host "  Type: Framework clone (Claude Code Starter -> Qwen Code Starter)"
    }
    Write-Host ""
    Write-Host "Changes made:"
    if (Test-Path (Join-Path $TargetDir ".qwen")) { Write-Host "  [x] Renamed .claude/ to .qwen/" }
    if (Test-Path (Join-Path $TargetDir "QWEN.md")) { Write-Host "  [x] Renamed CLAUDE.md to QWEN.md" }
    if (Test-Path (Join-Path $TargetDir ".qwen/SNAPSHOT.md")) { Write-Host "  [x] Migrated SNAPSHOT.md (project state preserved)" }
    if (Test-Path (Join-Path $TargetDir ".qwenignore")) { Write-Host "  [x] Created .qwenignore" }
    if ($script:IsFrameworkClone) { Write-Host "  [x] Updated framework files (templates, scripts, tests)" }
    Write-Host "  [x] Updated skills frontmatter"
    Write-Host "  [x] Migrated hooks configuration"
    Write-Host "  [x] Flattened agent structure"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Review QWEN.md and update for Qwen Code"
    Write-Host "  2. Check .qwen/settings.json for hook configurations"
    Write-Host "  3. Update .qwenignore for your specific needs"
    Write-Host "  4. Test your migrated configuration with Qwen Code"
    Write-Host ""
}

# Main execution
if ($Help) {
    Show-Usage
}

# Parse positional arguments
$positionalArgs = $args | Where-Object { $_ -notlike "-*" }
if ($positionalArgs.Count -gt 0) {
    $SourceDir = $positionalArgs[0]
}
if ($positionalArgs.Count -gt 1) {
    $TargetDir = $positionalArgs[1]
}

if ([string]::IsNullOrEmpty($SourceDir)) {
    Write-LogError "SOURCE_DIR is required"
    Show-Usage
}

if ([string]::IsNullOrEmpty($TargetDir)) {
    $TargetDir = $SourceDir
}

$script:IsFrameworkClone = $false

Write-LogInfo "Qwen Code Starter Migration"
Write-Host ""

Invoke-CheckSource
Invoke-MigrateDirectories
Invoke-MigrateProjectPassport
Invoke-MigrateSnapshot
Invoke-MigrateSkills
Invoke-MigrateHooks
Invoke-MigratePermissions
Invoke-UpdateReferences
Invoke-Cleanup
Invoke-GenerateReport
