#!/usr/bin/env pwsh

# Test with existing user and debug the authentication flow
Write-Host "=== EXISTING USER AUTHENTICATION TEST ===" -ForegroundColor Green

# Test login with existing user
Write-Host "`n1. Testing login with existing user (testuser@example.com)..." -ForegroundColor Yellow
$loginBody = @{
    email = "testuser@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful:" -ForegroundColor Green
    Write-Host $loginResponse
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

# Create a new user with unique email to test fresh registration
Write-Host "`n2. Creating new user for fresh test..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$newUserEmail = "newuser$timestamp@example.com"

$registerBody = @{
    name = "New Test User"
    email = $newUserEmail
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ New user registered successfully: $newUserEmail" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Registration failed: $($_.Exception.Message)" -ForegroundColor Yellow
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error details: $errorText" -ForegroundColor Yellow
    }
}

# Test login with the newly created user
Write-Host "`n3. Testing login with newly created user..." -ForegroundColor Yellow
$loginBody2 = @{
    email = $newUserEmail
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse2 = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody2 -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful with new user:" -ForegroundColor Green
    Write-Host $loginResponse2
    
    if ($loginResponse2.data -and $loginResponse2.data.token) {
        Write-Host "Token received: $($loginResponse2.data.token)" -ForegroundColor Cyan
        
        # Test authenticated endpoint
        Write-Host "`n4. Testing authenticated endpoint..." -ForegroundColor Yellow
        $headers = @{
            "Authorization" = "Bearer $($loginResponse2.data.token)"
        }
        
        try {
            $meResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/me" -Method Get -Headers $headers -TimeoutSec 10
            Write-Host "✅ Authenticated endpoint successful:" -ForegroundColor Green
            Write-Host $meResponse
        } catch {
            Write-Host "❌ Authenticated endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Login failed with new user: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

Write-Host "`n=== TEST COMPLETED ===" -ForegroundColor Green
