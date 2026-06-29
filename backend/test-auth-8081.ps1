#!/usr/bin/env pwsh

# Test authentication on port 8081
Write-Host "=== AUTHENTICATION TEST ON PORT 8081 ===" -ForegroundColor Green

# Test registration
Write-Host "`n1. Testing registration..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$testEmail = "test$timestamp@example.com"

$registerBody = @{
    name = "Test User"
    email = $testEmail
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

Write-Host "Registering user: $testEmail" -ForegroundColor Cyan

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
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

# Test login
Write-Host "`n2. Testing login..." -ForegroundColor Yellow
$loginBody = @{
    email = $testEmail
    password = "password123"
} | ConvertTo-Json

Write-Host "Attempting login for: $testEmail" -ForegroundColor Cyan

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful" -ForegroundColor Green
    Write-Host $loginResponse
    
    if ($loginResponse.data -and $loginResponse.data.token) {
        Write-Host "Token received: $($loginResponse.data.token)" -ForegroundColor Cyan
        
        # Test authenticated endpoint
        Write-Host "`n3. Testing authenticated endpoint..." -ForegroundColor Yellow
        $headers = @{
            "Authorization" = "Bearer $($loginResponse.data.token)"
        }
        
        try {
            $meResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/me" -Method Get -Headers $headers -TimeoutSec 10
            Write-Host "✅ Authenticated endpoint successful" -ForegroundColor Green
            Write-Host $meResponse
        } catch {
            Write-Host "❌ Authenticated endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
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

Write-Host "`n=== TEST COMPLETED ===" -ForegroundColor Green
