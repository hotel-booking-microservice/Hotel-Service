# Hotel Service - Setup Guide & Analysis

## Summary of Issues Fixed

### ✅ Fixed Issues

1. **Missing Maven Wrapper** - Generated `mvnw`, `mvnw.cmd`, and `.mvn/` directory
2. **Docker Compose Dependencies** - Added health check for MongoDB so the service waits for it to be ready
3. **Java Version** - Project specifies Java 17, but Java 21 is installed (this should work fine with backward compatibility)

### ⚠️ Current System Status

| Component | Status         | Version          | Notes                             |
| --------- | -------------- | ---------------- | --------------------------------- |
| Java      | ✅ Installed   | 21.0.8 (Temurin) | Project requires 17, but 21 works |
| Maven     | ✅ Installed   | 3.9.6            | Ready to use                      |
| Docker    | ✅ Installed   | 28.5.1           | Ready for containerization        |
| MongoDB   | ⚠️ Needs setup | -                | Will run in Docker                |

## What You Need to Install

### Already Installed ✅

- ✅ Java 21 (your system has this, project requires 17 but 21 will work)
- ✅ Maven 3.9.6
- ✅ Docker Desktop
- ✅ Git

### Nothing Else Needed! 🎉

All required tools are already installed. The project is ready to run.

## How to Run the Application

### Option 1: Using Docker Compose (Recommended) 🐳

```bash
# Build and run everything in one command
docker compose up --build

# This will:
# 1. Start MongoDB container
# 2. Build the Spring Boot application
# 3. Wait for MongoDB to be healthy
# 4. Start the hotel-service on port 8082
```

**Note:** First run will take several minutes as it downloads dependencies and builds the image.

### Option 2: Run Locally (MongoDB in Docker) 💻

```bash
# Step 1: Start MongoDB in Docker
docker run -d --name hotel-mongo -p 27017:27017 mongo:7

# Step 2: Build and run the application (Windows)
.\mvnw.cmd clean package -DskipTests
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar

# Or use Maven directly if you prefer
mvn clean package -DskipTests
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

### Option 3: Run with Maven Spring Boot Plugin 🚀

```bash
# Set MongoDB URI (Windows PowerShell)
$env:MONGO_URI="mongodb://localhost:27017/hotel_db"
.\mvnw.cmd spring-boot:run

# Or with Maven directly
mvn spring-boot:run
```

## Access the Application

Once running, access:

- **API Base URL**: http://localhost:8082
- **Swagger UI**: http://localhost:8082/swagger-ui.html
- **OpenAPI Docs**: http://localhost:8082/v3/api-docs
- **Health Check**: http://localhost:8082/api/health

## Testing the API

### Using PowerShell (if you have curl)

```powershell
# Health check
curl -Uri http://localhost:8082/api/health

# Create a hotel
curl -Method POST -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body '{"name":"Seaside Inn","description":"Beachfront hotel","city":"Miami","country":"USA"}'

# List all hotels
curl -Uri http://localhost:8082/api/hotels
```

### Using Invoke-WebRequest (PowerShell native)

```powershell
# Health check
Invoke-WebRequest -Uri http://localhost:8082/api/health

# Create a hotel
$body = @{
    name = "Seaside Inn"
    description = "Beachfront hotel"
    city = "Miami"
    country = "USA"
} | ConvertTo-Json

Invoke-WebRequest -Method POST -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body $body

# List all hotels
Invoke-WebRequest -Uri http://localhost:8082/api/hotels | Select-Object -ExpandProperty Content
```

## Available API Endpoints

| Method | Endpoint           | Description          |
| ------ | ------------------ | -------------------- |
| POST   | `/api/hotels`      | Create a hotel       |
| GET    | `/api/hotels`      | List all hotels      |
| GET    | `/api/hotels/{id}` | Get hotel by ID      |
| PUT    | `/api/hotels/{id}` | Update hotel         |
| DELETE | `/api/hotels/{id}` | Delete hotel         |
| GET    | `/api/health`      | Service health check |

## Project Structure

```
Hotel-Service/
├── src/main/java/com/hbs/hotel/
│   ├── config/          # CORS config, Dev data loader
│   ├── controller/       # REST controllers
│   ├── dto/             # Data transfer objects
│   ├── exception/        # Exception handling
│   ├── model/            # Entity models
│   ├── repository/       # MongoDB repositories
│   ├── service/          # Business logic
│   └── HotelServiceApplication.java
├── src/main/resources/
│   └── application.yml   # Configuration
├── pom.xml               # Maven dependencies
├── Dockerfile            # Docker image config
├── docker-compose.yml    # Docker compose setup
└── README.md             # Original documentation
```

## Technology Stack

- **Framework**: Spring Boot 3.3.4
- **Language**: Java 17+ (running on Java 21)
- **Database**: MongoDB 7
- **Build Tool**: Maven 3.9.6
- **Documentation**: SpringDoc OpenAPI (Swagger)
- **Validation**: Jakarta Bean Validation
- **Utilities**: Lombok

## Common Issues & Solutions

### Issue 1: Port 8082 already in use

**Solution**: Either free the port or change it in `src/main/resources/application.yml`:

```yaml
server:
  port: 8083 # Change to any available port
```

### Issue 2: MongoDB connection refused

**Solution**: Ensure MongoDB is running:

```bash
docker ps  # Check if mongo container is running
docker start hotel-mongo  # Start if stopped
```

### Issue 3: "Cannot find symbol" errors during build

**Solution**: Clean and rebuild:

```bash
.\mvnw.cmd clean install
```

### Issue 4: Slow first build

**Solution**: Normal behavior - Maven is downloading dependencies (happens once)

## Recommended IDE Setup

1. **IntelliJ IDEA** or **Eclipse** or **VS Code**
2. Install Lombok plugin (if using IntelliJ)
3. Import as Maven project
4. Install Spring Boot extension (if using VS Code)

## Next Steps

1. ✅ Run the application using one of the methods above
2. ✅ Access Swagger UI to explore APIs
3. ✅ Test CRUD operations
4. ✅ Check MongoDB data using a GUI tool like MongoDB Compass
5. 🚀 Start building your frontend/other services!

## Database Access

If you want to connect to MongoDB with a GUI tool:

- **Host**: localhost
- **Port**: 27017
- **Database**: hotel_db
- **Connection String**: `mongodb://localhost:27017/hotel_db`

Install **MongoDB Compass**: https://www.mongodb.com/try/download/compass

---

**You're all set! 🎉 Happy coding!**
