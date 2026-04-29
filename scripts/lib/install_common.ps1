# Qwen Code Starter - Common Installation Utilities
# Shared functions for installation scripts
#

# Colors for output
$Script:Colors = @{
    Red    = 'Red'
    Green  = 'Green'
    Yellow = 'Yellow'
    Blue   = 'Blue'
    Cyan   = 'Cyan'
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
    if ($Script:Verbose) {
        Write-Host "[VERBOSE] $Message" -ForegroundColor Cyan
    }
}

function Test-IsAdmin {
    <#
    .SYNOPSIS
        Checks if the current PowerShell session is running as administrator.
    
    .DESCRIPTION
        Returns $true if running with elevated privileges, $false otherwise.
        Works on both Windows and PowerShell Core on Linux/macOS.
    
    .EXAMPLE
        if (Test-IsAdmin) { Write-Host "Running as admin" }
    #>
    
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        # PowerShell Core (cross-platform)
        $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
        return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    } else {
        # Windows PowerShell
        $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
}

function Test-CommandExists {
    <#
    .SYNOPSIS
        Checks if a command exists in the current session.
    
    .PARAMETER CommandName
        The name of the command to check.
    
    .EXAMPLE
        if (Test-CommandExists "git") { Write-Host "Git is installed" }
    #>
    
    param([string]$CommandName)
    return Get-Command $CommandName -ErrorAction SilentlyContinue -OutVariable +_null
}

function Test-PowerShellVersion {
    <#
    .SYNOPSIS
        Checks if the PowerShell version meets the minimum requirement.
    
    .PARAMETER MinimumVersion
        The minimum required version (default: 5.1).
    
    .EXAMPLE
        if (Test-PowerShellVersion -MinimumVersion "5.1") { Write-Host "PS version OK" }
    #>
    
    param([string]$MinimumVersion = "5.1")
    
    $currentVersion = [Version]($PSVersionTable.PSVersion.ToString())
    $minVersion = [Version]$MinimumVersion
    
    return $currentVersion -ge $minVersion
}

function Get-TempFile {
    <#
    .SYNOPSIS
        Creates a temporary file and returns its path.
    
    .DESCRIPTION
        Creates a unique temporary file in the system temp directory.
        The caller is responsible for cleaning up the file.
    
    .EXAMPLE
        $tempFile = Get-TempFile
        # ... use file ...
        Remove-Item $tempFile
    #>
    
    return [System.IO.Path]::GetTempFileName()
}

function Get-TempDirectory {
    <#
    .SYNOPSIS
        Creates a temporary directory and returns its path.
    
    .DESCRIPTION
        Creates a unique temporary directory in the system temp directory.
        The caller is responsible for cleaning up the directory.
    
    .EXAMPLE
        $tempDir = Get-TempDirectory
        # ... use directory ...
        Remove-Item -Recurse $tempDir
    #>
    
    $tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path $tempPath | Out-Null
    return $tempPath
}

function Copy-Directory {
    <#
    .SYNOPSIS
        Copies a directory recursively with proper error handling.
    
    .PARAMETER Source
        Source directory path.
    
    .PARAMETER Destination
        Destination directory path.
    
    .PARAMETER Force
        Overwrite existing files.
    
    .EXAMPLE
        Copy-Directory -Source "C:\src" -Destination "C:\dest" -Force
    #>
    
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Force
    )
    
    try {
        if (!(Test-Path $Source)) {
            throw "Source directory does not exist: $Source"
        }
        
        if (!(Test-Path $Destination)) {
            New-Item -ItemType Directory -Force -Path $Destination | Out-Null
        }
        
        $copyParams = @{
            Recurse = $true
            Force   = $Force.IsPresent
        }
        
        Copy-Item -Path "$Source/*" -Destination $Destination @copyParams
        return $true
    } catch {
        Write-LogError "Failed to copy directory: $_"
        return $false
    }
}

function Backup-File {
    <#
    .SYNOPSIS
        Creates a backup of a file with timestamp.
    
    .PARAMETER FilePath
        Path to the file to backup.
    
    .EXAMPLE
        $backupPath = Backup-File -FilePath "C:\config.json"
    #>
    
    param([string]$FilePath)
    
    if (!(Test-Path $FilePath)) {
        return $null
    }
    
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $directory = Split-Path $FilePath -Parent
    $filename = Split-Path $FilePath -Leaf
    $backupPath = Join-Path $directory "$filename.backup.$timestamp"
    
    Copy-Item -Force $FilePath -Destination $backupPath
    return $backupPath
}

function Backup-Directory {
    <#
    .SYNOPSIS
        Creates a backup of a directory with timestamp.
    
    .PARAMETER DirectoryPath
        Path to the directory to backup.
    
    .EXAMPLE
        $backupPath = Backup-Directory -DirectoryPath "C:\config"
    #>
    
    param([string]$DirectoryPath)
    
    if (!(Test-Path $DirectoryPath)) {
        return $null
    }
    
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $parentDir = Split-Path $DirectoryPath -Parent
    $dirName = Split-Path $DirectoryPath -Leaf
    $backupPath = Join-Path $parentDir "$dirName.backup.$timestamp"
    
    Copy-Item -Recurse -Force $DirectoryPath -Destination $backupPath
    return $backupPath
}

function Confirm-Action {
    <#
    .SYNOPSIS
        Prompts user for confirmation before proceeding.
    
    .PARAMETER Message
        The message to display to the user.
    
    .PARAMETER Default
        Default response if user just presses Enter (default: 'N').
    
    .EXAMPLE
        if (Confirm-Action "Continue with installation?") { ... }
    #>
    
    param(
        [string]$Message,
        [string]$Default = "N"
    )
    
    $response = Read-Host "$Message ($Default)"
    if ([string]::IsNullOrEmpty($response)) {
        $response = $Default
    }
    
    return $response -match '^[Yy]$'
}

function Write-ProgressBar {
    <#
    .SYNOPSIS
        Displays a progress bar in the console.
    
    .PARAMETER Percent
        Progress percentage (0-100).
    
    .PARAMETER Message
        Message to display alongside the progress bar.
    
    .EXAMPLE
        Write-ProgressBar -Percent 50 -Message "Installing..."
    #>
    
    param(
        [int]$Percent,
        [string]$Message
    )
    
    $Percent = [Math]::Min(100, [Math]::Max(0, $Percent))
    $progress = "[" + ("#" * ($Percent / 5)) + ("." * (20 - ($Percent / 5))) + "] $Percent%"
    
    if (![string]::IsNullOrEmpty($Message)) {
        $progress = "$Message $progress"
    }
    
    Write-Host "`r$progress" -NoNewline
}

function Clear-ProgressBar {
    <#
    .SYNOPSIS
        Clears the progress bar line and moves to next line.
    
    .EXAMPLE
        Clear-ProgressBar
    #>
    
    Write-Host ""
}

function Test-PathWritable {
    <#
    .SYNOPSIS
        Checks if a path is writable.
    
    .PARAMETER Path
        Path to check.
    
    .EXAMPLE
        if (Test-PathWritable -Path "C:\test") { ... }
    #>
    
    param([string]$Path)
    
    try {
        $testFile = Join-Path $Path ".write_test_$([System.IO.Path]::GetRandomFileName())"
        "" | Out-File -FilePath $testFile -Force -ErrorAction Stop
        Remove-Item -Force $testFile -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Get-FrameworkRoot {
    <#
    .SYNOPSIS
        Gets the root directory of the qwen-code-starter framework.
    
    .DESCRIPTION
        Determines the framework root based on the current script location.
    
    .EXAMPLE
        $frameworkRoot = Get-FrameworkRoot
    #>
    
    $scriptDir = Split-Path $MyInvocation.ScriptName -Parent
    # Navigate up from scripts/lib to framework root
    return Split-Path $scriptDir -Parent
}

function Export-ModuleMember {
    # Export all public functions
    @('Write-LogInfo', 'Write-LogSuccess', 'Write-LogWarning', 'Write-LogError', 'Write-LogVerbose',
      'Test-IsAdmin', 'Test-CommandExists', 'Test-PowerShellVersion',
      'Get-TempFile', 'Get-TempDirectory', 'Copy-Directory',
      'Backup-File', 'Backup-Directory', 'Confirm-Action',
      'Write-ProgressBar', 'Clear-ProgressBar', 'Test-PathWritable',
      'Get-FrameworkRoot') | ForEach-Object {
        Export-ModuleMember -Function $_
    }
}
