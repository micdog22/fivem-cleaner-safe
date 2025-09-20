@echo off
setlocal
set SCRIPT=%~dp0Clean-FiveM.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
endlocal
