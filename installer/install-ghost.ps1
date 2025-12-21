$ErrorActionPreference = "Stop"

$Version       = "latest"      # set to a tag like v1.0.162 if desired
$RepoOverride  = $null         # optionally set to "owner/repo" to force a repo (e.g., "Balanced-Libra/GhostShell")
# Candidate repos in case the project was renamed or moved
$RepoCandidates = @(
  "Balanced-Libra/Shell-Ghost",
  "Balanced-Libra/GhostShell",
  "GhostEnvoy/Shell-Ghost"
) | Where-Object { $_ }  # trim nulls if override provided
$BaseDir   = Join-Path $HOME ".ghost"
$BinDir    = Join-Path $BaseDir "bin"
$ExePath   = Join-Path $BinDir "ghost.exe"

Write-Host "Installing GhostShell ($Version) to $BinDir..."

function Resolve-Repo {
  param($Candidates, $Version)
  foreach ($c in $Candidates) {
    $owner, $name = $c.Split("/")
    $api = if ($Version -eq "latest") {
      "https://api.github.com/repos/$owner/$name/releases/latest"
    } else {
      "https://api.github.com/repos/$owner/$name/releases/tags/$Version"
    }
    try {
      $release = Invoke-RestMethod -UseBasicParsing $api
      return @{ Owner = $owner; Name = $name; Tag = $release.tag_name }
    } catch {
      continue
    }
  }
  throw "Could not find a reachable repo from: $($Candidates -join ', ')"
}

$Resolved = Resolve-Repo -Candidates ($(if ($RepoOverride) { @($RepoOverride) + $RepoCandidates } else { $RepoCandidates })) -Version $Version
$RepoOwner = $Resolved.Owner
$RepoName = $Resolved.Name
$Tag = $Resolved.Tag

$AssetNames = @(
  "ghost-in-the-shell-windows-x64.tar.gz",
  "ghost-in-the-shell-windows-x64-baseline.tar.gz"
)
$Downloaded = $false
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

foreach ($AssetName in $AssetNames) {
  $DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/download/$Tag/$AssetName"
  $TarPath = Join-Path $BinDir "ghost.tar.gz"
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $DownloadUrl -OutFile $TarPath
    $Downloaded = $true
    break
  } catch {
    if (Test-Path $TarPath) { Remove-Item $TarPath }
    continue
  }
}

if (-not $Downloaded) { throw "Could not download a compatible Windows asset for tag $Tag" }

# Extract tar.gz on Windows
tar -xzf $TarPath -C $BinDir
Remove-Item $TarPath

# Debug: List what was extracted
Write-Host "Contents of $BinDir after extraction:"
Get-ChildItem -Path $BinDir -Recurse | ForEach-Object { Write-Host "  $($_.FullName)" }

# Look for executable, skip macOS metadata files
$Found = Get-ChildItem -Path $BinDir -Filter "*.exe" -Recurse | 
           Where-Object { $_.Name -notlike '._*' } | 
           Select-Object -First 1
Write-Host "Found executable: $($Found.FullName)"
if (-not $Found) { throw "Could not find ghost executable after extraction." }
Move-Item -Force $Found.FullName $ExePath

$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if (-not ($UserPath -split ";" | Where-Object { $_ -eq $BinDir })) {
  [Environment]::SetEnvironmentVariable("PATH", "$BinDir;$UserPath", "User")
  Write-Host "Added $BinDir to PATH (user scope). Restart your terminal."
} else {
  Write-Host "$BinDir already on PATH."
}

Write-Host "Installed ghost at $ExePath"
Write-Host "Version:"
& $ExePath --version
