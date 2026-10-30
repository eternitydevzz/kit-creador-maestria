@echo off
rem Lanza actualizar.ps1 aunque Windows bloquee los scripts .ps1 (solo para este proceso)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0actualizar.ps1" %*
pause
