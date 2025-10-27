# Simple Hotel Service Test Script
# This script will test your hotel service step by step

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Hotel Service Testing Guide" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check MongoDB
Write-Host "Step 1: Checking MongoDB..." -ForegroundColor Yellow
$mongoStatus = docker ps --filter "name=hotel-mongo" --format "{{.Status}}"
if ($mongoStatus -like "*Up*") {
    Write-Host "✓ MongoDB is running" -ForegroundColor Green
} else {
    Write-Host "✗ MongoDB is not running" -ForegroundColor Red
    Write-Host "Starting MongoDB..." -ForegroundColor Yellow
    docker run -d --name hotel-mongo -p 27017:27017 mongo:7
    Start-Sleep -Seconds 3
    Write-Host "✓ MongoDB started" -ForegroundColor Green
}
Write-Host ""

# Step 2: Check if JAR exists
Write-Host "Step 2: Checking application..." -ForegroundColor Yellow
if (Test-Path "target/hotel-service-0.0.1-SNAPSHOT.jar") {
    Write-Host "✓ Application JAR found" -ForegroundColor Green
} else {
    Write-Host "✗ JAR not found, building..." -ForegroundColor Red
    .\mvnw.cmd clean package -DskipTests
    if (Test-Path "target/hotel-service-0.0.1-SNAPSHOT.jar") {
        Write-Host "✓ Build successful!" -ForegroundColor Green
    } else {
        Write-Host "✗ Build failed!" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 3: Start the application
Write-Host "Step 3: Starting Spring Boot application..." -ForegroundColor Yellow
Write-Host "This will start the application in the background..." -ForegroundColor White
Write-Host ""

# Start the application in background
$job = Start-Job -ScriptBlock {
    Set-Location "D:\hotelbookingsystem\Hotel-Service"
    java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
}

Write-Host "Application starting... Please wait 30 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 4: Test the application
Write-Host "Step 4: Testing the application..." -ForegroundColor Yellow

# Test health endpoint
try {
    $healthResponse = Invoke-WebRequest -Uri http://localhost:8082/api/health -UseBasicParsing
    Write-Host "✓ Health check successful!" -ForegroundColor Green
    Write-Host "Response: $($healthResponse.Content)" -ForegroundColor White
} catch {
    Write-Host "✗ Health check failed" -ForegroundColor Red
    Write-Host "Application might still be starting..." -ForegroundColor Yellow
    Write-Host "Let's wait a bit more and try again..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
    
    try {
        $healthResponse = Invoke-WebRequest -Uri http://localhost:8082/api/health -UseBasicParsing
        Write-Host "✓ Health check successful!" -ForegroundColor Green
        Write-Host "Response: $($healthResponse.Content)" -ForegroundColor White
    } catch {
        Write-Host "✗ Application failed to start" -ForegroundColor Red
        Write-Host "Check the job output:" -ForegroundColor Yellow
        Receive-Job $job
        Stop-Job $job
        Remove-Job $job
        exit 1
    }
}
Write-Host ""

# Step 5: Test creating a hotel
Write-Host "Step 5: Testing hotel creation..." -ForegroundColor Yellow

$hotelData = @{
    name = "Grand Hotel"
    description = "A luxurious hotel in the city center"
    city = "New York"
    country = "USA"
} | ConvertTo-Json

try {
    $createResponse = Invoke-RestMethod -Method POST `
        -Uri http://localhost:8082/api/hotels `
        -ContentType "application/json" `
        -Body $hotelData
    
    Write-Host "✓ Hotel created successfully!" -ForegroundColor Green
    Write-Host "Hotel ID: $($createResponse.id)" -ForegroundColor White
    Write-Host "Hotel Name: $($createResponse.name)" -ForegroundColor White
    Write-Host "Hotel City: $($createResponse.city)" -ForegroundColor White
} catch {
    Write-Host "✗ Failed to create hotel" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Step 6: Test getting all hotels
Write-Host "Step 6: Testing hotel retrieval..." -ForegroundColor Yellow

try {
    $hotelsResponse = Invoke-RestMethod -Uri http://localhost:8082/api/hotels
    Write-Host "✓ Hotels retrieved successfully!" -ForegroundColor Green
    Write-Host "Number of hotels: $($hotelsResponse.Count)" -ForegroundColor White
    
    foreach ($hotel in $hotelsResponse) {
        Write-Host "  - $($hotel.name) in $($hotel.city), $($hotel.country)" -ForegroundColor White
    }
} catch {
    Write-Host "✗ Failed to retrieve hotels" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Step 7: Show access URLs
Write-Host "Step 7: Access URLs" -ForegroundColor Yellow
Write-Host "✓ Application is running!" -ForegroundColor Green
Write-Host ""
Write-Host "You can access:" -ForegroundColor Cyan
Write-Host "  🌐 Swagger UI: http://localhost:8082/swagger-ui.html" -ForegroundColor White
Write-Host "  ❤️  Health Check: http://localhost:8082/api/health" -ForegroundColor White
Write-Host "  🏨 Hotels API: http://localhost:8082/api/hotels" -ForegroundColor White
Write-Host ""
Write-Host "To stop the application, press Ctrl+C" -ForegroundColor Yellow
Write-Host ""

# Keep the application running
Write-Host "Application is running in the background..." -ForegroundColor Green
Write-Host "Press any key to stop the application..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Clean up
Write-Host "Stopping application..." -ForegroundColor Yellow
Stop-Job $job
Remove-Job $job
Write-Host "Application stopped." -ForegroundColor Green
