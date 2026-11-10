@echo off
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch_original_apk.ps1" "%~1"
echo.
pause
