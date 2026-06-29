#!/usr/bin/env pwsh

# Simple test to check exact current error
Write-Host "=== CURRENT AUTHENTICATION STATUS ===" -ForegroundColor Green

# Test port 8080 first
Write-Host "`nTesting port 8080..." -ForegroundColor Yellow

try {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $testEmail = "test$timestamp@example.com"
    
    $registerBody = @{
        name = "Test User"
        email = $testEmail
        password = "password123"
        role = "PATIENT"
        phone = "1234567890"
    } | ConvertTo-Json
    
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 5
    Write-Host "Port 8080 Registration: SUCCESS" -ForegroundColor Green
    
    $loginBody = @{
        email = $testEmail
        password = "password123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 5
    Write-Host "Port 8080 Login: SUCCESS" -ForegroundColor Green
    Write-Host "Response: $loginResponse"
    
} catch {
    Write-Host "Port 8080 Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Details: $errorText" -ForegroundColor Red
    }
}

Write-Host "`n=== STATUS CHECK COMPLETED ===" -ForegroundColor Green
