$ErrorActionPreference = 'SilentlyContinue'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Remove-Item -Recurse -Force (Join-Path $toolsDir 'dn151') -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $toolsDir 'dn151.zip') -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $toolsDir 'dn.bat') -ErrorAction SilentlyContinue
