#!/usr/bin/env pwsh

# Simple test to check server status and debug authentication
Write-Host "=== SERVER STATUS AND AUTH DEBUG ===" -ForegroundColor Green

# Test basic server connectivity
Write-Host "`n1. Testing server connectivity..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/me" -Method Get -TimeoutSec 5 -ErrorAction SilentlyContinue
    Write-Host "✅ Server responding" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Server error (expected for unauthorized): $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test registration with debug info
Write-Host "`n2. Testing registration..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$testEmail = "test$timestamp@example.com"

$registerBody = @{
    name = "Debug User"
    email = $testEmail
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

Write-Host "Registering user: $testEmail" -ForegroundColor Cyan

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Registration successful" -ForegroundColor Green
    Write-Host $regResponse
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error details: $errorText" -ForegroundColor Red
    }
}

# Test login with detailed error handling
Write-Host "`n3. Testing login with detailed error handling..." -ForegroundColor Yellow
$loginBody = @{
    email = $testEmail
    password = "password123"
} | ConvertTo-Json

Write-Host "Attempting login for: $testEmail" -ForegroundColor Cyan

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful" -ForegroundColor Green
    Write-Host $loginResponse
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

Write-Host "`n=== DEBUG COMPLETED ===" -ForegroundColor Green
