# Test Groq API directly
$apiKey = "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"
$url = "https://api.groq.com/openai/v1/chat/completions"

# Use the correct model name
$model = "llama-3.1-8b-instant"

$bodyJson = @{
    model = $model
    messages = @(
        @{
            role = "system"
            content = "You are a pharmacy assistant for an online medication website. Provide helpful information about medicines, symptoms, and usage, but always advise users to consult a doctor before taking medication."
        },
        @{
            role = "user"
            content = "What medicine helps with headache?"
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type" = "application/json"
}

Write-Host "Testing Groq API with model: $model"
Write-Host "URL: $url"
Write-Host "Body: $bodyJson"

try {
    $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $bodyJson
    Write-Host "SUCCESS! Response: $($response | ConvertTo-Json -Depth 10)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode)"
    
    # Read the error response
    $responseStream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($responseStream)
    $errorBody = $reader.ReadToEnd()
    Write-Host "Error Response: $errorBody"
}
