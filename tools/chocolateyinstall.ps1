$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "Starting installation..."

# Check for existing DOSBox-X installation from various sources
$dosboxPath = $null

# Check common installation paths
$possiblePaths = @(
    "C:\DOSBox-X\dosbox-x.exe",
    "$env:ProgramFiles\DOSBox-X\dosbox-x.exe",
    "${env:ProgramFiles(x86)}\DOSBox-X\dosbox-x.exe",
    "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\joncampbell123.DOSBox-X_*\dosbox-x.exe",
    "$env:USERPROFILE\scoop\apps\dosbox-x\current\dosbox-x.exe"
)

foreach ($path in $possiblePaths) {
    $resolved = Resolve-Path $path -ErrorAction SilentlyContinue
    if ($resolved) {
        $dosboxPath = $resolved.Path
        Write-Host "Found existing DOSBox-X at: $dosboxPath"
        break
    }
}

# Check PATH
if (-not $dosboxPath) {
    $pathCmd = Get-Command dosbox-x.exe -ErrorAction SilentlyContinue
    if ($pathCmd) {
        $dosboxPath = $pathCmd.Source
        Write-Host "Found DOSBox-X in PATH: $dosboxPath"
    }
}

# If no existing installation found, DOSBox-X will be installed via dependency
if (-not $dosboxPath) {
    Write-Host "No existing DOSBox-X installation found. It will be installed as a dependency."
}

# Download DN
$params = @{
    PackageName = 'dn-dosnav'
    Url = 'https://www.ritlabs.com/download/dn/dn151.zip'
    FileFullPath = (Join-Path $toolsDir 'dn151.zip')
    Checksum = 'F6DEE3904945A2F390F8576A5D18D83446F4554E43D6F0A3C75F8AA5B570D7D9'
    ChecksumType = 'sha256'
}

Get-ChocolateyWebFile @params

Get-ChocolateyUnzip -FileFullPath (Join-Path $toolsDir 'dn151.zip') -Destination (Join-Path $toolsDir 'dn151')

# Create launcher that detects DOSBox-X dynamically
$launcher = @'
@echo off
setlocal

REM Check for DOSBox-X in various locations
set "_DBX="

REM Check Chocolatey installation
if exist "C:\DOSBox-X\dosbox-x.exe" set "_DBX=C:\DOSBox-X\dosbox-x.exe"
if exist "%ProgramFiles%\DOSBox-X\dosbox-x.exe" set "_DBX=%ProgramFiles%\DOSBox-X\dosbox-x.exe"
if exist "%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe" set "_DBX=%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe"

REM Check PATH
if "%_DBX%"=="" for %%F in (dosbox-x.exe) do if not "%%~$PATH:F"=="" set "_DBX=%%~$PATH:F"

REM Check WinGet installation (common location)
if "%_DBX%"=="" for /d %%D in ("%LOCALAPPDATA%\Microsoft\WinGet\Packages\joncampbell123.DOSBox-X_*") do (
    if exist "%%D\dosbox-x.exe" set "_DBX=%%D\dosbox-x.exe"
)

REM Check Scoop installation
if "%_DBX%"=="" if exist "%USERPROFILE%\scoop\apps\dosbox-x\current\dosbox-x.exe" set "_DBX=%USERPROFILE%\scoop\apps\dosbox-x\current\dosbox-x.exe"

if "%_DBX%"=="" (
    echo ERROR: DOSBox-X not found. Please install it via:
    echo   - Chocolatey: choco install dosbox-x
    echo   - WinGet:     winget install joncampbell123.DOSBox-X
    echo   - Scoop:      scoop install dosbox-x
    exit /b 1
)

set "_DNPATH=%~dp0dn151"
"%_DBX%" -c "mount c \"%CD%\"" -c "mount d \"%_DNPATH%\"" -c "c:" -c "d:\dn.com"
endlocal
'@

$batPath = Join-Path $toolsDir 'dn.bat'
Set-Content -LiteralPath $batPath -Value $launcher -Encoding ASCII

Write-Host "Creating shim for dn.bat..."
Install-BinFile -Name 'dn' -Path $batPath