@echo off
rem Lanza instalar.ps1 aunque Windows bloquee los scripts .ps1 (solo para este proceso)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1" %*
pause
