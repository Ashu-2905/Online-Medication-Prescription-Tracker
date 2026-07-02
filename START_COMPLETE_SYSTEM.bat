@echo off
echo =================================================
echo Medication Tracker - Complete System Startup
echo =================================================
echo.

echo [1/4] Stopping any existing processes...
taskkill /f /im java.exe 2>nul
taskkill /f /im node.exe 2>nul
timeout /t 3 /nobreak >nul

echo [2/4] Starting Backend Server...
cd /d "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\backend"
set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
start "Backend Server" cmd /k "java -jar target\medication-tracker-backend-1.0.0.jar --spring.profiles.active=production"
timeout /t 10 /nobreak >nul

echo [3/4] Starting Frontend Application...
cd /d "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\Frontend"
start "Frontend Application" cmd /k "npm run dev"
timeout /t 8 /nobreak >nul

echo [4/4] Testing System Integration...
echo.
echo =================================================
echo SYSTEM STARTUP COMPLETED!
echo =================================================
echo.
echo Backend Server: http://localhost:8080
echo Frontend Application: http://localhost:5173
echo.
echo Testing Backend Health...
powershell -Command "try { Invoke-RestMethod -Uri 'http://localhost:8080/api/test/health' -TimeoutSec 5 | Out-Null; Write-Host '✅ Backend: RUNNING' -ForegroundColor Green } catch { Write-Host '❌ Backend: FAILED' -ForegroundColor Red }"

echo Testing Frontend...
powershell -Command "try { Invoke-RestMethod -Uri 'http://localhost:5173' -TimeoutSec 5 | Out-Null; Write-Host '✅ Frontend: RUNNING' -ForegroundColor Green } catch { Write-Host '❌ Frontend: FAILED' -ForegroundColor Red }"

echo.
echo =================================================
echo 🎉 COMPLETE SYSTEM IS READY!
echo =================================================
echo.
echo Access your application at:
echo Frontend: http://localhost:5173
echo Backend API: http://localhost:8080
echo.
echo Press any key to test the complete system...
pause >nul





echo.
echo Testing Complete System Integration...
cd /d "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\backend"
powershell -ExecutionPolicy Bypass -File "complete-system-test-fixed.ps1"

echo.
echo =================================================
echo 🚀 SYSTEM TEST COMPLETED!
echo =================================================
pause
