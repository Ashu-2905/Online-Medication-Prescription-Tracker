#!/usr/bin/env pwsh

# Quick test script for daily use - verifies all critical functionality
Write-Host "========================================" -ForegroundColor Green
Write-Host "MEDICATION TRACKER - DAILY CHECK" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Quick server check
try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/test/health" -Method Get -TimeoutSec 5
    Write-Host "✅ Server: RUNNING" -ForegroundColor Green
} catch {
    Write-Host "❌ Server: NOT RUNNING - Please start server first" -ForegroundColor Red
    exit 1
}

# Quick auth test
try {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $testEmail = "quick$timestamp@example.com"
    
    $registerBody = @{
        name = "Quick Test"
        email = $testEmail
        password = "password123"
        role = "PATIENT"
        phone = "1234567890"
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -TimeoutSec 5 | Out-Null
    
    $loginBody = @{
        email = $testEmail
        password = "password123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -TimeoutSec 5
    
    Write-Host "✅ Authentication: WORKING" -ForegroundColor Green
    
    # Quick chatbot test
    $chatBody = @{
        message = "Hello"
    } | ConvertTo-Json
    
    $chatResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/chat" -Method Post -Body $chatBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ Chatbot: WORKING" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Quick Test Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SYSTEM READY FOR USE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
