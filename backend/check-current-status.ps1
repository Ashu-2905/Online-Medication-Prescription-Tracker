#!/usr/bin/env pwsh

# Quick test to identify exact current error
Write-Host "=== CURRENT AUTHENTICATION STATUS CHECK ===" -ForegroundColor Green

# Test both ports to see which one is actually working
$ports = @(8080, 8081)

foreach ($port in $ports) {
    Write-Host "`nTesting port $port..." -ForegroundColor Yellow
    
    # Test basic connectivity
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$port/api/auth/me" -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
        Write-Host "Port $port: Server responding (expected auth error)" -ForegroundColor Green
    } catch {
        Write-Host "Port $port: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test registration
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
        
        $regResponse = Invoke-RestMethod -Uri "http://localhost:$port/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 5 -ErrorAction SilentlyContinue
        Write-Host "Port $port Registration: ✅ Success" -ForegroundColor Green
        
        # Test login immediately with same user
        $loginBody = @{
            email = $testEmail
            password = "password123"
        } | ConvertTo-Json
        
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:$port/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 5 -ErrorAction SilentlyContinue
        Write-Host "Port $port Login: ✅ Success" -ForegroundColor Green
        
        if ($loginResponse.data -and $loginResponse.data.token) {
            Write-Host "Port $port Token: ✅ Generated" -ForegroundColor Green
        } else {
            Write-Host "Port $port Token: ❌ No token" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "Port $port Auth Error: ❌ $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $errorBody = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorBody)
            $errorText = $reader.ReadToEnd()
            Write-Host "Port $port Error Details: $errorText" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== STATUS CHECK COMPLETED ===" -ForegroundColor Green

# Show current running processes
Write-Host "`nCurrent Java processes:" -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Select-Object Id, ProcessName | Format-Table
