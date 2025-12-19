$ErrorActionPreference = 'Stop'

$Repo = 'GhostEnvoy/Shell-Ghost'
$BinName = 'ghost.exe'

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq 'AMD64') { $Arch = 'x64' }
elseif ($Arch -eq 'ARM64') { $Arch = 'arm64' }
else { throw "Unsupported architecture: $Arch" }

$Os = 'windows'
$Asset = "shellghost-$Os-$Arch.zip"

$InstallDir = if ($env:GHOST_INSTALL_DIR) { $env:GHOST_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'ShellGhost\bin' }
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
$Release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ 'User-Agent' = 'ShellGhost-Installer' }

$AssetObj = $Release.assets | Where-Object { $_.name -eq $Asset } | Select-Object -First 1
if (-not $AssetObj) {
  throw "Could not find release asset: $Asset"
}

$ZipPath = Join-Path $env:TEMP $Asset
Invoke-WebRequest -Uri $AssetObj.browser_download_url -OutFile $ZipPath

$ExtractDir = Join-Path $env:TEMP "shellghost-extract-$([guid]::NewGuid().ToString())"
New-Item -ItemType Directory -Force -Path $ExtractDir | Out-Null
Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir -Force

$Exe = Join-Path $ExtractDir 'shellghost.exe'
if (-not (Test-Path $Exe)) {
  throw "Downloaded archive did not contain expected binary 'shellghost.exe'"
}

Copy-Item -Force $Exe (Join-Path $InstallDir $BinName)

$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable('Path', "$UserPath;$InstallDir", 'User')
}

Write-Output "Installed ghost to $InstallDir\\$BinName"
Write-Output "Open a NEW terminal session and run: ghost"
