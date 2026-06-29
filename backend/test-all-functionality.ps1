#!/usr/bin/env pwsh

# Comprehensive test to verify all functionality works on port 8081
Write-Host "=== COMPREHENSIVE FUNCTIONALITY TEST ===" -ForegroundColor Green

# Test 1: Registration with different roles
Write-Host "`n1. Testing registration with different roles..." -ForegroundColor Yellow

$roles = @("PATIENT", "DOCTOR", "ADMIN")
foreach ($role in $roles) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $testEmail = "$($role.ToLower())$timestamp@example.com"
    
    $registerBody = @{
        name = "$role Test User"
        email = $testEmail
        password = "password123"
        role = $role
        phone = "1234567890"
    } | ConvertTo-Json
    
    try {
        $regResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
        Write-Host "✅ $role registration successful: $testEmail" -ForegroundColor Green
    } catch {
        Write-Host "❌ $role registration failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 2: Login with each role
Write-Host "`n2. Testing login with each role..." -ForegroundColor Yellow

$testCredentials = @(
    @{email = "patient20260329174800@example.com"; password = "password123"},
    @{email = "doctor20260329174801@example.com"; password = "password123"},
    @{email = "admin20260329174802@example.com"; password = "password123"}
)

foreach ($cred in $testCredentials) {
    $loginBody = @{
        email = $cred.email
        password = $cred.password
    } | ConvertTo-Json
    
    try {
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
        Write-Host "✅ Login successful for: $($cred.email)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Login failed for: $($cred.email) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Case-insensitive login
Write-Host "`n3. Testing case-insensitive login..." -ForegroundColor Yellow

$caseTestLogin = @{
    email = "PATIENT20260329174800@EXAMPLE.COM"
    password = "password123"
} | ConvertTo-Json

try {
    $caseResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $caseTestLogin -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Case-insensitive login successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Case-insensitive login failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Protected endpoints with valid token
Write-Host "`n4. Testing protected endpoints..." -ForegroundColor Yellow

# Get a valid token first
$loginBody = @{
    email = "patient20260329174800@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    $token = $loginResponse.data.token
    
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    # Test patient endpoint
    try {
        $patientResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/patient/medications" -Method Get -Headers $headers -TimeoutSec 10
        Write-Host "✅ Patient endpoint accessible" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Patient endpoint: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ Could not get token for protected endpoint test" -ForegroundColor Red
}

# Test 5: Invalid credentials
Write-Host "`n5. Testing invalid credentials..." -ForegroundColor Yellow

$invalidLogin = @{
    email = "nonexistent@example.com"
    password = "wrongpassword"
} | ConvertTo-Json

try {
    $invalidResponse = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method Post -Body $invalidLogin -ContentType "application/json" -TimeoutSec 10
    Write-Host "❌ Invalid login should have failed" -ForegroundColor Red
} catch {
    Write-Host "✅ Invalid credentials properly rejected" -ForegroundColor Green
}

Write-Host "`n=== ALL TESTS COMPLETED ===" -ForegroundColor Green
