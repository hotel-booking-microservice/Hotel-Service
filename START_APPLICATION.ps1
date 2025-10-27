# Hotel Service Startup Script
# This script starts the Spring Boot application

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "   Hotel Service Startup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if MongoDB is running
Write-Host "Checking MongoDB..." -ForegroundColor Yellow
$mongoRunning = docker ps --filter "name=hotel-mongo" --format "{{.Names}}"
if ($mongoRunning -eq "hotel-mongo") {
    Write-Host "✓ MongoDB is running" -ForegroundColor Green
}
else {
    Write-Host "✗ MongoDB is NOT running" -ForegroundColor Red
    Write-Host "Starting MongoDB..." -ForegroundColor Yellow
    docker run -d --name hotel-mongo -p 27017:27017 mongo:7
    Start-Sleep -Seconds 3
    Write-Host "✓ MongoDB started" -ForegroundColor Green
}
Write-Host ""

# Check if JAR file exists
Write-Host "Checking application..." -ForegroundColor Yellow
if (Test-Path "target/hotel-service-0.0.1-SNAPSHOT.jar") {
    Write-Host "✓ Application JAR found" -ForegroundColor Green
    Write-Host ""
    Write-Host "Starting Hotel Service..." -ForegroundColor Cyan
    Write-Host "Application will be available at:" -ForegroundColor Yellow
    Write-Host "  - API: http://localhost:8082" -ForegroundColor White
    Write-Host "  - Swagger UI: http://localhost:8082/swagger-ui.html" -ForegroundColor White
    Write-Host "  - Health Check: http://localhost:8082/api/health" -ForegroundColor White
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Yellow
    Write-Host ""
    
    # Start the application
    java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
}
else {
    Write-Host "✗ JAR file not found!" -ForegroundColor Red
    Write-Host "Building the application first..." -ForegroundColor Yellow
    Write-Host ""
    .\mvnw.cmd clean package -DskipTests
    
    if (Test-Path "target/hotel-service-0.0.1-SNAPSHOT.jar") {
        Write-Host "✓ Build successful!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starting Hotel Service..." -ForegroundColor Cyan
        java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
    }
    else {
        Write-Host "✗ Build failed!" -ForegroundColor Red
        Write-Host "Please check the errors above." -ForegroundColor Red
    }
}

