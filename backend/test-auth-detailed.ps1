#!/usr/bin/env pwsh

# Comprehensive authentication test to identify the exact issue
Write-Host "=== COMPREHENSIVE AUTHENTICATION TEST ===" -ForegroundColor Green

# First, let's create a test user
Write-Host "`n1. Creating test user..." -ForegroundColor Yellow
$registerBody = @{
    name = "Test User"
    email = "testuser@example.com"
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Registration successful:" -ForegroundColor Green
    Write-Host $regResponse
} catch {
    Write-Host "⚠️ Registration: $($_.Exception.Message)" -ForegroundColor Yellow
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error details: $errorText" -ForegroundColor Yellow
    }
}

# Now test login with the created user
Write-Host "`n2. Testing login with created user..." -ForegroundColor Yellow
$loginBody = @{
    email = "testuser@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful:" -ForegroundColor Green
    Write-Host $loginResponse
    
    # Extract token for further tests
    $token = $loginResponse.data.token
    Write-Host "Token: $token" -ForegroundColor Cyan
    
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

# Test with different email cases
Write-Host "`n3. Testing case-insensitive login..." -ForegroundColor Yellow
$loginBodyCase = @{
    email = "TestUser@Example.COM"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponseCase = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBodyCase -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Case-insensitive login successful:" -ForegroundColor Green
    Write-Host $loginResponseCase
} catch {
    Write-Host "❌ Case-insensitive login failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

Write-Host "`n=== TEST COMPLETED ===" -ForegroundColor Green
