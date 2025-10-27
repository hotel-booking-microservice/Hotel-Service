# Complete Guide to Hotel Service Project

## 🎯 What is This Project?

This is a **Hotel Service** - a microservice that manages hotel information for a hotel booking platform. Think of it like a digital hotel registry where you can:

- **Create** hotel listings
- **Read/View** hotel details
- **Update** hotel information
- **Delete** hotel entries

It's built using **Spring Boot** (Java framework) and stores data in **MongoDB** (a NoSQL database).

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      YOUR COMPUTER                           │
│                                                              │
│  ┌──────────────────┐          ┌──────────────────┐        │
│  │  Docker Engine   │          │   Your Browser   │        │
│  │                  │          │   (Chrome/Edge)  │        │
│  │  ┌────────────┐  │          │                  │        │
│  │  │ MongoDB    │  │          │  HTTP Requests   │        │
│  │  │  Container │◄─┼──────────┼──► REST API Calls │        │
│  │  │            │  │          │                  │        │
│  │  │ Port:27017 │  │          └──────────────────┘        │
│  │  └────────────┘  │                    ▲                  │
│  │                  │                    │                  │
│  └──────────────────┘                    │                  │
│          ▲                                │                  │
│          │                                │                  │
│  ┌───────┴───────────────────────────────┴──────┐         │
│  │  Spring Boot Application (Hotel Service)     │         │
│  │  ┌───────────────────────────────────────┐   │         │
│  │  │ Controllers (REST API Endpoints)      │   │         │
│  │  │ - /api/hotels                         │   │         │
│  │  │ - /api/health                        │   │         │
│  │  └───────────────────────────────────────┘   │         │
│  │  ┌───────────────────────────────────────┐   │         │
│  │  │ Services (Business Logic)             │   │         │
│  │  │ - CRUD operations                     │   │         │
│  │  └───────────────────────────────────────┘   │         │
│  │  ┌───────────────────────────────────────┐   │         │
│  │  │ Repository (Database Layer)          │   │         │
│  │  │ - MongoDB connection                  │   │         │
│  │  └───────────────────────────────────────┘   │         │
│  │                                              │         │
│  │  Running on Port: 8082                       │         │
│  └──────────────────────────────────────────────┘         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 What is Maven? (Build Tool)

### Think of Maven as a "Smart Project Manager"

**Maven** is a build automation tool for Java projects. Here's what it does:

1. **Downloads Dependencies**: Gets libraries your project needs (like Spring Boot, MongoDB drivers)
2. **Compiles Code**: Converts your Java code into executable `.jar` files
3. **Packages**: Creates the final application you can run
4. **Runs Tests**: Automatically runs tests if you have them

### How It Works

```xml
<!-- pom.xml is like a shopping list -->
<dependencies>
  <!-- I need Spring Boot Web -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <!-- I need MongoDB support -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb</artifactId>
  </dependency>
</dependencies>
```

Maven reads this file and automatically:

1. Downloads these libraries from the internet
2. Includes them in your project
3. Makes them available when you run your code

### Maven vs Gradle - The Difference

| Feature            | Maven                    | Gradle                           |
| ------------------ | ------------------------ | -------------------------------- |
| **Language**       | XML configuration        | Groovy/Kotlin DSL (programmable) |
| **Speed**          | Slower                   | Faster (uses caching)            |
| **Learning Curve** | Easier for beginners     | Steeper learning curve           |
| **Flexibility**    | Declarative (tells what) | More programmatic                |
| **Ecosystem**      | More mature              | Modern, growing fast             |

**Simple analogy:**

- **Maven** = Ikea instructions (step by step, clear)
- **Gradle** = Custom furniture building (more flexible, can automate more)

### Maven Commands You'll Use

```bash
mvn clean           # Delete compiled files
mvn compile         # Compile your code
mvn package         # Create the JAR file
mvn install         # Install to local repository
mvn spring-boot:run # Run the Spring Boot app
```

---

## 🗄️ What is MongoDB?

**MongoDB** is a **NoSQL database** (document-based) - unlike traditional SQL databases that use tables.

### Traditional SQL Database

```
Table: Hotels
| ID | Name          | City    | Country |
|----|---------------|---------|---------|
| 1  | Seaside Inn   | Miami   | USA     |
| 2  | Grand Hotel   | Paris  | France  |
```

### MongoDB (Document-based)

```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "Seaside Inn",
  "city": "Miami",
  "country": "USA"
}
```

**Why use MongoDB?**

- Flexible schema (no rigid table structure)
- Stores JSON-like documents
- Great for rapid development
- Scales horizontally easily

---

## 🐳 What is Docker?

**Docker** runs apps in isolated containers, like lightweight virtual machines.

### Without Docker

```
You need to:
1. Download MongoDB installer
2. Install MongoDB
3. Configure MongoDB
4. Start MongoDB service
5. Remember to start it every time
6. Install on every machine differently
```

### With Docker

```
One command:
docker run mongo:7

Done! MongoDB is running in an isolated container.
```

### Why Docker is Amazing

1. **Consistency**: Works the same on any machine (Windows, Mac, Linux)
2. **Isolation**: MongoDB runs in its own container, won't affect your system
3. **Easy Cleanup**: Delete the container = everything gone
4. **Portability**: Run the same setup anywhere

---

## 🔗 How This Project Integrates Everything

### The Data Flow

```
1. You make HTTP request
   POST http://localhost:8082/api/hotels
   { "name": "Seaside Inn", ... }

   ↓

2. Spring Boot receives request
   HotelController.java handles it

   ↓

3. Business logic processes it
   HotelService.java validates data

   ↓

4. Data saved to MongoDB
   HotelRepository.java saves to MongoDB

   ↓

5. Response sent back
   { "id": "...", "name": "Seaside Inn", ... }
```

### How MongoDB Connection Works

```yaml
# application.yml (Configuration file)
spring:
  data:
    mongodb:
      # This tells Spring Boot where MongoDB is
      uri: mongodb://localhost:27017/hotel_db
      #                         ↑       ↑
      #                    host:port  database name
```

**When your app starts:**

1. Spring Boot reads this configuration
2. Connects to MongoDB on localhost:27017
3. Uses database named "hotel_db"
4. Ready to store and retrieve hotel data

---

## 🚀 How to Run the Project

### Prerequisites Check

```bash
# Check Java
java -version
# Should show version 17 or higher

# Check Maven
mvn -version
# Should show Maven version

# Check Docker
docker --version
# Should show Docker version
```

### Step-by-Step Running

#### Option 1: Using Docker Compose (Easiest)

```bash
# This starts BOTH MongoDB AND your application
cd D:\hotelbookingsystem\Hotel-Service
docker compose up
```

**What happens:**

1. Downloads MongoDB image if not already downloaded
2. Starts MongoDB container
3. Builds your Spring Boot application
4. Starts the application
5. Application connects to MongoDB automatically

#### Option 2: Manual Run (More Control)

**Terminal 1 - Start MongoDB:**

```bash
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

**Terminal 2 - Run Application:**

```bash
cd D:\hotelbookingsystem\Hotel-Service
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

Or if you haven't built yet:

```bash
mvn spring-boot:run
```

---

## 📂 Project Structure Explained

```
Hotel-Service/
│
├── src/main/java/com/hbs/hotel/
│   ├── config/
│   │   ├── CorsConfig.java          # Allows browser requests from any origin
│   │   └── DevDataLoader.java        # Loads sample data on startup (dev mode)
│   │
│   ├── controller/
│   │   ├── HotelController.java      # REST endpoints (/api/hotels)
│   │   └── HealthController.java     # Health check endpoint
│   │
│   ├── dto/                          # Data Transfer Objects
│   │   ├── HotelRequest.java         # Input data structure
│   │   └── HotelResponse.java        # Output data structure
│   │
│   ├── exception/
│   │   ├── ApiError.java             # Error response format
│   │   ├── NotFoundException.java   # Custom exception
│   │   └── GlobalExceptionHandler.java # Catches all errors
│   │
│   ├── model/
│   │   └── Hotel.java                # The hotel entity (matches MongoDB)
│   │
│   ├── repository/
│   │   └── HotelRepository.java      # Database operations (find, save, delete)
│   │
│   ├── service/
│   │   └── HotelService.java         # Business logic (create, read, update, delete)
│   │
│   └── HotelServiceApplication.java  # Main entry point
│
├── src/main/resources/
│   └── application.yml               # Configuration (port, database, etc.)
│
├── pom.xml                            # Maven dependencies
├── docker-compose.yml                # Docker setup
└── Dockerfile                         # How to build Docker image
```

### File Explanation

#### 1. Hotel.java (The Model)

```java
@Document(collection = "hotels")  // MongoDB collection name
public class Hotel {
    @Id
    private String id;           // Auto-generated by MongoDB

    @NotBlank
    private String name;         // Required field

    private String description;
    private String city;
    private String country;
}
```

This defines what a hotel looks like in the database.

#### 2. HotelController.java (The API)

```java
@RestController
@RequestMapping("/api/hotels")
public class HotelController {

    @PostMapping  // Handles POST requests
    public ResponseEntity<HotelResponse> createHotel(...) {
        // Creates a hotel
    }

    @GetMapping  // Handles GET requests
    public ResponseEntity<List<HotelResponse>> getHotels() {
        // Returns all hotels
    }
}
```

This creates the REST API endpoints.

#### 3. HotelService.java (The Business Logic)

```java
@Service
public class HotelService {

    public Hotel create(HotelRequest request) {
        // 1. Convert request to Hotel object
        // 2. Validate data
        // 3. Save to database
        // 4. Return saved hotel
    }
}
```

This contains the logic for creating, reading, updating, deleting hotels.

#### 4. HotelRepository.java (The Database Layer)

```java
public interface HotelRepository extends MongoRepository<Hotel, String> {
    // No code needed! Spring Data MongoDB provides:
    // - save()
    // - findAll()
    // - findById()
    // - deleteById()
    // Automatically!
}
```

This is the interface that talks to MongoDB. Spring Data provides the implementation automatically!

---

## 🔄 Complete Workflow Example

### Scenario: Creating a Hotel

```
1. CLIENT (Browser/Postman)
   Makes HTTP POST request:
   POST http://localhost:8082/api/hotels
   Body: {"name": "Seaside Inn", "city": "Miami", "country": "USA"}

2. CONTROLLER (HotelController.java)
   Receives request
   Extracts hotel data from JSON
   Calls HotelService.create()

3. SERVICE (HotelService.java)
   Validates the data
   Creates Hotel object
   Calls HotelRepository.save()

4. REPOSITORY (HotelRepository.java)
   Sends data to MongoDB
   MongoDB stores it in "hotels" collection
   Returns the saved hotel (with new ID)

5. RESPONSE
   Goes back through Service → Controller
   Controller returns JSON response
   Client receives: {"id": "123", "name": "Seaside Inn", ...}
```

---

## 🧪 Testing the API

### Using PowerShell

```powershell
# 1. Check if service is running
Invoke-WebRequest -Uri http://localhost:8082/api/health

# 2. Create a hotel
$body = @{
    name = "Seaside Inn"
    description = "Beachfront hotel"
    city = "Miami"
    country = "USA"
} | ConvertTo-Json

Invoke-RestMethod -Method POST `
  -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body $body

# 3. Get all hotels
Invoke-RestMethod -Uri http://localhost:8082/api/hotels
```

### Using Browser

1. Open: http://localhost:8082/swagger-ui.html
2. Try the "POST /api/hotels" endpoint
3. Click "Try it out"
4. Enter hotel data
5. Click "Execute"

### Using cURL (if you have it)

```bash
# Create hotel
curl -X POST http://localhost:8082/api/hotels \
  -H "Content-Type: application/json" \
  -d '{"name":"Seaside Inn","description":"Beachfront","city":"Miami","country":"USA"}'

# Get all hotels
curl http://localhost:8082/api/hotels
```

---

## 🎓 Key Concepts Explained

### 1. REST API

**Representational State Transfer** - a way to communicate with a web service.

- **GET**: Read data (safe, no side effects)
- **POST**: Create new data
- **PUT**: Update existing data
- **DELETE**: Remove data

### 2. Dependency Injection

Spring Boot automatically provides objects where they're needed:

```java
public HotelService(HotelRepository repository) {
    // Spring Boot automatically gives us the repository
    this.hotelRepository = repository;
}
```

### 3. Annotations

Java decorations that tell Spring Boot what to do:

- `@RestController` - This is a REST API controller
- `@Service` - This contains business logic
- `@Repository` - This talks to the database
- `@Document` - This is a MongoDB document

### 4. Build Tools (Maven/Gradle)

Why we need them:

**Without Maven/Gradle:**

- Manually download every library
- Download dependencies of those libraries
- Manage versions
- Configure classpaths
- Compile code

**With Maven/Gradle:**

- Declare dependencies in config file
- Tool does everything automatically
- Consistent builds across environments

---

## 🐛 Common Issues & Solutions

### Issue: "Cannot connect to MongoDB"

**Solution:**

```bash
# Check if MongoDB container is running
docker ps

# If not, start it
docker start hotel-mongo

# Or create it
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

### Issue: "Port 8082 already in use"

**Solution:**

```bash
# Find what's using port 8082
netstat -ano | findstr :8082

# Kill that process or change port in application.yml
```

### Issue: "Maven build fails"

**Solution:**

```bash
# Clean and rebuild
mvn clean install

# Or use the wrapper
.\mvnw.cmd clean install
```

---

## 📚 Learning Path

### Beginner

1. ✅ Understand what this project does
2. ✅ Run it using `docker compose up`
3. ✅ Test the API using Swagger UI
4. ✅ Create/read/update/delete hotels

### Intermediate

1. Learn Spring Boot basics
2. Understand MongoDB operations
3. Explore the code structure
4. Modify endpoints

### Advanced

1. Add authentication
2. Add validation
3. Add tests
4. Deploy to cloud

---

## 🎯 Summary

**What This Project Is:**

- A hotel management REST API
- Built with Spring Boot (Java framework)
- Uses MongoDB for data storage
- Runs in Docker containers

**How Everything Works Together:**

1. **Maven** manages dependencies and builds the project
2. **Docker** runs MongoDB in an isolated container
3. **Spring Boot** provides the web framework
4. **MongoDB** stores the hotel data
5. **Your browser/Postman** makes requests to the API

**To Run:**

```bash
# Easiest way
docker compose up

# Or manually
docker run -d --name hotel-mongo mongo:7
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

**To Test:**

- Visit: http://localhost:8082/swagger-ui.html
- Try creating, reading, updating, deleting hotels

---

**You're now ready to understand and run this project! 🚀**
