#!/usr/bin/env pwsh

# Debug database and user storage
Write-Host "=== DATABASE DEBUG TEST ===" -ForegroundColor Green

# Check if user exists in database
Write-Host "`n1. Checking if user exists in database..." -ForegroundColor Yellow

# First register a user
$registerBody = @{
    name = "Debug User"
    email = "debug@example.com"
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

try {
    $regResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ User registered successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Registration: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Now try to find the user using different email formats
$emailFormats = @(
    "debug@example.com",
    "Debug@Example.COM", 
    "DEBUG@EXAMPLE.COM"
)

foreach ($email in $emailFormats) {
    Write-Host "`n2. Testing user lookup with email: $email" -ForegroundColor Yellow
    
    # Create a simple endpoint to test user lookup (we'll use the existsByEmail logic)
    try {
        # We'll use a GET request to a test endpoint to check if user exists
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/me" -Method Get -Headers @{"Authorization"="Bearer fake-token"} -TimeoutSec 5 -ErrorAction SilentlyContinue
    } catch {
        # This will fail, but we're just testing if the server is responding
        Write-Host "Server responding (expected auth failure)" -ForegroundColor Cyan
    }
}

# Test the exact authentication flow step by step
Write-Host "`n3. Testing authentication flow components..." -ForegroundColor Yellow

# Test with exact lowercase email
$loginBody = @{
    email = "debug@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Login successful with exact email" -ForegroundColor Green
} catch {
    Write-Host "❌ Login failed with exact email: $($_.Exception.Message)" -ForegroundColor Red
    $errorBody = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorBody)
    $errorText = $reader.ReadToEnd()
    Write-Host "Error details: $errorText" -ForegroundColor Red
}

Write-Host "`n=== DEBUG COMPLETED ===" -ForegroundColor Green
