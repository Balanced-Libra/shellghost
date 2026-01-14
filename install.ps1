$ErrorActionPreference = 'Stop'

$Repo = 'GhostEnvoy/Shell-Ghost'
$BinName = 'ghost.cmd'

# Install bun if not present
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
  Write-Output "Installing Bun..."
  & powershell -c "irm bun.sh/install.ps1 | iex"
  $env:Path = "$env:USERPROFILE\.bun\bin;$env:Path"
}

$InstallDir = if ($env:GHOST_INSTALL_DIR) { $env:GHOST_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'ShellGhost\bin' }
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$RepoDir = Join-Path $env:USERPROFILE 'shellghost'

if (Test-Path $RepoDir) {
  Write-Output "Updating existing installation in $RepoDir..."
  Set-Location $RepoDir
  git pull
} else {
  Write-Output "Cloning repository to $RepoDir..."
  git clone "https://github.com/$Repo.git" $RepoDir
  Set-Location $RepoDir
}

Write-Output "Installing dependencies..."
bun install

# Create wrapper script
$WrapperContent = @"
@echo off
cd /d "$RepoDir"
bun run --cwd packages/opencode --conditions=browser src/index.ts %*
"@
$WrapperContent | Out-File -FilePath (Join-Path $InstallDir $BinName) -Encoding ASCII

$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable('Path', "$UserPath;$InstallDir", 'User')
}

Write-Output "Installed ghost to $InstallDir\$BinName"
Write-Output "Repository installed to $RepoDir"
Write-Output "Open a NEW terminal session and run: ghost"
