@echo off
setlocal enabledelayedexpansion

echo Installing GhostShell...

set "BIN=%USERPROFILE%\.ghost\bin"
set "EXE_URL=https://github.com/GhostEnvoy/Shell-Ghost/releases/download/v0.1.3/ghost-in-the-shell-windows-x64.tar.gz"

:: Create directory
if not exist "%BIN%" mkdir "%BIN%"

:: Download and extract binary
echo Downloading from: %EXE_URL%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%EXE_URL%' -OutFile '%BIN%\temp.tar.gz'" 2>nul
tar -xzf "%BIN%\temp.tar.gz" -C "%BIN%" 2>nul
del "%BIN%\temp.tar.gz" 2>nul

:: Check if download worked
if not exist "%BIN%\ghost.exe" (
    echo ERROR: Could not download ghost.exe
    echo Please visit https://github.com/GhostEnvoy/Shell-Ghost/releases/latest
    pause
    exit /b 1
)

:: Add to PATH
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"
echo !USER_PATH! | findstr /i /c:"%BIN%" >nul
if errorlevel 1 (
    setx PATH "%BIN%;!USER_PATH!" >nul
    echo Added to PATH. Restart terminal.
) else (
    echo PATH already updated.
)

echo.
echo SUCCESS: Installed to %BIN%\ghost.exe
echo Restart CMD and run: ghost
echo.
pause