$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "Starting installation..."

$params = @{
    PackageName = 'dn-dosnav'
    Url = 'https://www.ritlabs.com/download/dn/dn151.zip'
    FileFullPath = (Join-Path $toolsDir 'dn151.zip')
    Checksum = 'F6DEE3904945A2F390F8576A5D18D83446F4554E43D6F0A3C75F8AA5B570D7D9'
    ChecksumType = 'sha256'
}

Get-ChocolateyWebFile @params

Get-ChocolateyUnzip -FileFullPath (Join-Path $toolsDir 'dn151.zip') -Destination (Join-Path $toolsDir 'dn151')

$launcher = @'
@echo off
setlocal
set "_DBX=C:\DOSBox-X\dosbox-x.exe"
if exist "%ProgramFiles%\DOSBox-X\dosbox-x.exe" set "_DBX=%ProgramFiles%\DOSBox-X\dosbox-x.exe"
if exist "%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe" set "_DBX=%ProgramFiles(x86)%\DOSBox-X\dosbox-x.exe"
for %%F in (dosbox-x.exe) do if not "%%~$PATH:F"=="" set "_DBX=%%~$PATH:F"

set "_DNPATH=%~dp0dn151"
"%_DBX%" -c "mount c \"%CD%\"" -c "mount d \"%_DNPATH%\"" -c "c:" -c "d:\dn.com"
endlocal
'@

$batPath = Join-Path $toolsDir 'dn.bat'
Set-Content -LiteralPath $batPath -Value $launcher -Encoding ASCII