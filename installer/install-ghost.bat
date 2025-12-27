@echo off
setlocal
REM Delegates to the PowerShell installer (handles repo/asset fallbacks)

set "SCRIPT=%~dp0install-ghost.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
if %ERRORLEVEL% NEQ 0 (
  echo Install failed. Please run the PowerShell script directly for error details: %SCRIPT%
  exit /b %ERRORLEVEL%
)

echo Done. Restart your terminal, then run: ghost --version
endlocal
