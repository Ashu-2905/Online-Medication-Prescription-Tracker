@echo off
echo =================================================
echo Medication Tracker Backend - Startup Script
echo =================================================
echo.

echo [1/3] Stopping any existing Java processes...
taskkill /f /im java.exe 2>nul
timeout /t 3 /nobreak >nul

echo [2/3] Starting backend server on port 8080...
cd /d "%~dp0"
set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
java -jar target\medication-tracker-backend-1.0.0.jar --spring.profiles.active=production

echo.
echo =================================================
echo Server startup completed!
echo Server is running on: http://localhost:8080
echo =================================================
pause
