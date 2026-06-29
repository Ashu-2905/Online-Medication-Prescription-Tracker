# Medication Tracker Backend - Quick Start Guide

## 🚀 HOW TO RUN YOUR APPLICATION

### **Option 1: Quick Start (Recommended)**
```bash
# Navigate to backend folder
cd "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\backend"

# Run the startup script
.\startup-backend.bat
```

### **Option 2: Manual Start**
```bash
# Navigate to backend folder
cd "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\backend"

# Set Java environment and run
set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
java -jar target\medication-tracker-backend-1.0.0.jar --spring.profiles.active=production
```

### **Option 3: PowerShell Start**
```powershell
# Navigate to backend folder
cd "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\backend"

# Set environment and run
$env:JAVA_HOME="C:\Program Files\Java\jdk-25.0.2"
java -jar target\medication-tracker-backend-1.0.0.jar --spring.profiles.active=production
```

## 🌐 Application URLs

Once the server is running, access your application at:

### **Main Backend Server**
- **URL:** http://localhost:8080
- **Status:** ✅ Server running

### **API Endpoints**
- **Authentication:** http://localhost:8080/api/auth/**
- **Chatbot:** http://localhost:8080/api/chat
- **Patient APIs:** http://localhost:8080/api/patient/**
- **Health Check:** http://localhost:8080/api/test/health

### **Test Your System**
```bash
# Quick verification that everything works
.\quick-daily-check.ps1
```

## 📱 Frontend Application (if available)

If you have a frontend application, run it separately:

```bash
# Navigate to frontend folder (if exists)
cd "c:\Users\ashu0\Downloads\Medication and Prescription Tracker (3) (1)\frontend"

# Typical frontend start commands:
npm start
# or
yarn start
# or
npm run dev
```

## 🔧 Troubleshooting

**If port 8080 is already in use:**
```bash
# Kill existing Java processes
taskkill /f /im java.exe

# Then restart the server
.\startup-backend.bat
```

**If Java not found:**
```bash
# Make sure JAVA_HOME is set correctly
echo %JAVA_HOME%

# Should show: C:\Program Files\Java\jdk-25.0.2
```

## ✅ Verification

After starting, you should see:
- ✅ Server started on port 8080
- ✅ MongoDB connected
- ✅ All endpoints accessible
- ✅ Authentication working
- ✅ Chatbot responding

## 🎯 Ready for Project Demo!

Your Medication and Prescription Tracker is now fully functional with:
- ✅ User authentication
- ✅ AI-powered chatbot
- ✅ Patient management
- ✅ Prescription tracking
- ✅ Appointment scheduling
- ✅ All APIs working

**Access your application at: http://localhost:8080**
