@echo off
setlocal
REM Simple clickable installer for Windows (user-scope, no admin)

set "BIN=%USERPROFILE%\.ghost\bin"
set "ZIP=%BIN%\ghost.zip"
set "URL=https://github.com/GhostEnvoy/Shell-Ghost/releases/latest/download/ghost-in-the-shell-windows-x64.tar.gz"

echo Installing GhostShell to %BIN%...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "New-Item -Force -ItemType Directory -Path '%BIN%' | Out-Null;" ^
  "Invoke-WebRequest -UseBasicParsing '%URL%' -OutFile '%ZIP%';" ^
  "if (Get-Command 'tar' -ErrorAction SilentlyContinue) { tar -xzf '%ZIP%' -C '%BIN%'; } else { Add-Type -AssemblyName System.IO.Compression.FileSystem; $temp = '%BIN%\temp'; New-Item -ItemType Directory -Path $temp -Force | Out-Null; [IO.Compression.ZipFile]::ExtractToDirectory('%ZIP%', $temp); Move-Item '$temp\*' '%BIN%\' -Force; Remove-Item $temp -Recurse -Force; };" ^
  "Remove-Item '%ZIP%';" ^
  "$exe = Get-ChildItem '%BIN%' -Filter '*ghost*.exe' | Select-Object -First 1;" ^
  "Move-Item -Force $exe.FullName (Join-Path '%BIN%' 'ghost.exe');" ^
  "$p=[Environment]::GetEnvironmentVariable('PATH','User');" ^
  "if(-not ($p -split ';' -contains '%BIN%')) {[Environment]::SetEnvironmentVariable('PATH', '%BIN%;'+$p,'User'); Write-Host 'Added to PATH; restart terminal.'} else {Write-Host 'PATH already set.'};" ^
  "Write-Host 'Installed:' (Join-Path '%BIN%' 'ghost.exe');" ^
  "Write-Host 'Version:'; & (Join-Path '%BIN%' 'ghost.exe') --version"

if %ERRORLEVEL% NEQ 0 (
  echo Install failed. Please run this from PowerShell and capture the error.
  exit /b %ERRORLEVEL%
)

echo Done. Restart your terminal, then run: ghost --version
endlocal
