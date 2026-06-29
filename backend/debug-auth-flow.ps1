#!/usr/bin/env pwsh

# Debug authentication flow step by step
Write-Host "=== DEBUG AUTHENTICATION FLOW ===" -ForegroundColor Green

# Create a user and immediately try to login
Write-Host "`n1. Creating user and testing immediate login..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$testEmail = "debug$timestamp@example.com"

$registerBody = @{
    name = "Debug User"
    email = $testEmail
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

Write-Host "Registering: $testEmail" -ForegroundColor Cyan

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Registration successful" -ForegroundColor Green
    
    # Wait a moment for database to settle
    Start-Sleep 2
    
    # Try login immediately
    Write-Host "`n2. Testing immediate login..." -ForegroundColor Yellow
    $loginBody = @{
        email = $testEmail
        password = "password123"
    } | ConvertTo-Json
    
    try {
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
        Write-Host "✅ Immediate login successful" -ForegroundColor Green
        Write-Host $loginResponse
    } catch {
        Write-Host "❌ Immediate login failed: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $errorBody = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorBody)
            $errorText = $reader.ReadToEnd()
            Write-Host "Error Body: $errorText" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test with the previously working user
Write-Host "`n3. Testing with previously working user..." -ForegroundColor Yellow

$loginBody2 = @{
    email = "test20260329174743@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse2 = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $loginBody2 -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Previous user login successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Previous user login failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== DEBUG COMPLETED ===" -ForegroundColor Green
