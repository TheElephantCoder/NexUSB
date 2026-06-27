@echo off
REM double-click launcher for the windows (wsl2) build.
REM defaults to minimal for host arch. args pass through, e.g. build-nexusb.cmd -Target full -Arch arm64
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-NexUSB.ps1" %*
echo.
pause
