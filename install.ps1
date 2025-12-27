$ErrorActionPreference = 'Stop'

$Repo = 'GhostEnvoy/Shell-Ghost'
$BinName = 'ghost.exe'

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq 'AMD64') { $Arch = 'x64' }
elseif ($Arch -eq 'ARM64') { $Arch = 'arm64' }
else { throw "Unsupported architecture: $Arch" }

$Os = 'windows'

# Prefer user-local install unless overridden
$InstallDir = if ($env:GHOST_INSTALL_DIR) { $env:GHOST_INSTALL_DIR } else { Join-Path $HOME '.ghost\bin' }
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
$Release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ 'User-Agent' = 'ShellGhost-Installer' }

# Accept current and future asset naming schemes + baseline variants
$AssetBases = @(
  "ghost-in-the-shell-$Os-$Arch",
  "ghost-$Os-$Arch",
  "shellghost-$Os-$Arch"
)
$AssetSuffixes = @("", "-baseline", "-musl")
$AssetObj = $null

foreach ($Base in $AssetBases) {
  foreach ($Suffix in $AssetSuffixes) {
    $Candidate = "$Base$Suffix.tar.gz"
    $Match = $Release.assets | Where-Object { $_.name -eq $Candidate } | Select-Object -First 1
    if ($Match) { $AssetObj = $Match; break }
  }
  if ($AssetObj) { break }
}

if (-not $AssetObj) {
  $names = $AssetBases | ForEach-Object { $_ + '.tar.gz' }
  throw "Could not find a compatible Windows asset. Looked for: $($names -join ', ')"
}

$ArchivePath = Join-Path $env:TEMP $AssetObj.name
Invoke-WebRequest -UseBasicParsing -Uri $AssetObj.browser_download_url -OutFile $ArchivePath

$ExtractDir = Join-Path $env:TEMP "shellghost-extract-$([guid]::NewGuid().ToString())"
New-Item -ItemType Directory -Force -Path $ExtractDir | Out-Null
tar -xzf $ArchivePath -C $ExtractDir

# Locate any plausible executable name and normalize to ghost.exe
$Exe = Get-ChildItem -Path $ExtractDir -Recurse -File |
  Where-Object { $_.Name -match '^(ghost|shellghost)(\\.exe)?$' } |
  Select-Object -First 1

if (-not $Exe) {
  throw "Downloaded archive did not contain an executable named ghost or shellghost"
}

Copy-Item -Force $Exe.FullName (Join-Path $InstallDir $BinName)

$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable('Path', "$UserPath;$InstallDir", 'User')
}

Write-Output "Installed ghost to $InstallDir\\$BinName"
Write-Output "Open a NEW terminal session and run: ghost --version"
