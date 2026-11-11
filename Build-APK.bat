@echo off
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_android.ps1" -GameDirectory "%~1"
set "DDTLQ_EXIT=%ERRORLEVEL%"
echo.
pause
exit /b %DDTLQ_EXIT%
