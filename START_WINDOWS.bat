@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
 echo Please install Node.js 20 or newer, then run this file again.
 pause
 exit /b 1
)
start "ECHO MEDIC server" cmd /k "node server.mjs"
timeout /t 2 /nobreak >nul
start "" "http://localhost:3000"
