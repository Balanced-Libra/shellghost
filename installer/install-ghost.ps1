$ErrorActionPreference = "Stop"

$Version       = "latest"      # set to a tag like v1.0.162 if desired
$RepoOverride  = $null         # optionally set to "owner/repo" to force a repo (e.g., "GhostEnvoy/Shell-Ghost")
# Candidate repos in case the project was renamed or moved (ordered by preference)
$RepoCandidates = @(
  "GhostEnvoy/Shell-Ghost",
  "Balanced-Libra/Shell-Ghost",
  "Balanced-Libra/GhostShell"
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

$AssetBases = @(
  "ghost-in-the-shell-windows-x64",
  "ghost-windows-x64",
  "shellghost-windows-x64"
)
$AssetSuffixes = @("", "-baseline", "-musl")
$Downloaded = $false
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

foreach ($Base in $AssetBases) {
  foreach ($Suffix in $AssetSuffixes) {
    $AssetName = "$Base$Suffix.tar.gz"
    $DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/download/$Tag/$AssetName"
    $TarPath = Join-Path $BinDir "ghost.tar.gz"
    try {
      Invoke-WebRequest -UseBasicParsing -Uri $DownloadUrl -OutFile $TarPath
      $Downloaded = $true
      break 2
    } catch {
      if (Test-Path $TarPath) { Remove-Item $TarPath }
      continue
    }
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
$Found = Get-ChildItem -Path $BinDir -Recurse -File |
           Where-Object { $_.Name -match '^(ghost|shellghost)(\.exe)?$' -and $_.Name -notlike '._*' } |
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
