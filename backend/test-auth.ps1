#!/usr/bin/env pwsh

# Simple authentication test script
Write-Host "Testing Authentication Fix..." -ForegroundColor Green

# Test login endpoint
$loginBody = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    Write-Host "Testing login endpoint..."
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "Login response received:" -ForegroundColor Yellow
    Write-Host $response
} catch {
    Write-Host "Login test failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

# Test registration endpoint
$registerBody = @{
    name = "Test User"
    email = "newuser@example.com"
    password = "password123"
    role = "PATIENT"
    phone = "1234567890"
} | ConvertTo-Json

try {
    Write-Host "Testing registration endpoint..."
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "Registration response received:" -ForegroundColor Yellow
    Write-Host $response
} catch {
    Write-Host "Registration test failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        $errorBody = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorBody)
        $errorText = $reader.ReadToEnd()
        Write-Host "Error Body: $errorText" -ForegroundColor Red
    }
}

Write-Host "Authentication test completed." -ForegroundColor Green
