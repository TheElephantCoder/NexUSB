@echo off
REM Double-click launcher for the NexUSB Windows (WSL2) build.
REM Defaults to a minimal build for the host architecture. Pass args through to
REM the PowerShell script, e.g.:  build-nexusb.cmd -Target full -Arch arm64
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-NexUSB.ps1" %*
echo.
pause
