# Visual Guide to Hotel Service

## 🎯 Simple Mental Model

Think of this project like a **restaurant**:

```
┌─────────────────────────────────────────────────────────────────┐
│                          YOUR RESTAURANT                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  👤 YOU (The Client)                                              │
│     "I want a hamburger"                                         │
│           ↓                                                       │
│           ↓                                                       │
│     📞 Orders via HTTP                                            │
│           ↓                                                       │
│           ↓                                                       │
│  🍴 WAITER (HotelController)                                     │
│     Receives order: "POST /api/hotels"                           │
│           ↓                                                       │
│           ↓                                                       │
│  👨‍🍳 CHEF (HotelService)                                         │
│     Business logic: "Let me prepare this hotel"                  │
│           ↓                                                       │
│           ↓                                                       │
│  📦 STORAGE (HotelRepository → MongoDB)                          │
│     Saves the hotel to database                                   │
│           ↓                                                       │
│           ↓                                                       │
│     ✅ Returns completed hotel                                   │
│           ↓                                                       │
│  👤 YOU gets: "Here's your hotel!"                              │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Request Flow in Detail

### Scenario: You want to create a hotel

```
STEP 1: You Send Request
════════════════════════════════════════════════════════════
Client: POST http://localhost:8082/api/hotels
Body: {"name": "Grand Hotel", "city": "Paris", ...}
```

```
STEP 2: HotelController Receives
════════════════════════════════════════════════════════════
📁 HotelController.java
   ↓
@PostMapping  ← Spring Boot knows this handles POST
public ResponseEntity createHotel(@RequestBody request) {
    ↓
    "I received a POST request with hotel data"
    ↓
    Calls: hotelService.create(request)
}
```

```
STEP 3: HotelService Processes
════════════════════════════════════════════════════════════
📁 HotelService.java
   ↓
public Hotel create(HotelRequest request) {
    ↓
    Validates: Is name valid? Is it 2-120 chars?
    ↓
    Creates Hotel object:
    {
        name: "Grand Hotel",
        city: "Paris",
        country: "France"
    }
    ↓
    Calls: hotelRepository.save(hotel)
}
```

```
STEP 4: Repository Saves to MongoDB
════════════════════════════════════════════════════════════
📁 HotelRepository.java
   ↓
"MongoDB, please save this hotel"
    ↓
    ↓
MongoDB: Saving to "hotels" collection...
    ↓
    ↓
MongoDB: Done! Here's the saved hotel with ID: "507f1f77bcf..."
```

```
STEP 5: Response Goes Back
════════════════════════════════════════════════════════════
MongoDB → Repository → Service → Controller → You
   ↓
   ↓
Response: {
    "id": "507f1f77bcf86cd799439011",
    "name": "Grand Hotel",
    "city": "Paris",
    "country": "France"
}
```

---

## 📊 Database Storage (MongoDB)

### How Data is Stored

MongoDB stores data as **documents** in **collections**:

```
Database: hotel_db
├── Collection: hotels
    ├── Document 1:
    │   {
    │     "_id": "507f1f77bcf86cd799439011",
    │     "name": "Grand Hotel",
    │     "city": "Paris",
    │     "country": "France"
    │   }
    │
    ├── Document 2:
    │   {
    │     "_id": "507f1f77bcf86cd799439012",
    │     "name": "Seaside Inn",
    │     "city": "Miami",
    │     "country": "USA"
    │   }
    │
    └── Document 3:
        { ... }
```

### MongoDB vs SQL

```
SQL Database:              MongoDB:
┌───────────────┐          ┌───────────────┐
│ Table: hotels │          │ Collection:   │
├────┬─────────┤          │    hotels     │
│ ID │ Name    │          ├───────────────┤
├────┼─────────┤          │ {"_id": "1",  │
│ 1  │ Grand   │          │  "name": "..."│
│ 2  │ Seaside │          │ }             │
└────┴─────────┘          │ {"_id": "2",  │
                          │  "name": "..."│
                          │ }             │
                          └───────────────┘

Rigid structure         Flexible documents
(columns locked)        (add fields anytime)
```

---

## 🐳 Docker Explained Visually

### Without Docker

```
┌──────────────────────────────────────┐
│ Your Computer                         │
│  ┌──────────────────────────────────┐ │
│  │ MongoDB installed globally      │ │
│  │ - Takes up space               │ │
│  │ - Hard to remove              │ │
│  │ - Can conflict with others     │ │
│  │ - Different on each OS         │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │ Your Spring Boot app            │ │
│  │ - Needs MongoDB running         │ │
│  │ - Must start MongoDB manually   │ │
│  └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### With Docker (Like Your Project)

```
┌──────────────────────────────────────┐
│ Docker Container (Isolated)         │
│  ┌──────────────────────────────────┐ │
│  │ Container: hotel-mongo           │ │
│  │  - MongoDB running inside        │ │
│  │  - Completely isolated           │ │
│  │  - Port 27017 exposed            │ │
│  └──────────────────────────────────┘ │
└──────────────────────────────────────┘
         ↑
         │ Connects to
         ↓
┌──────────────────────────────────────┐
│ Your Spring Boot Application         │
│  - Talks to MongoDB in Docker       │
│  - When you delete container,       │
│    everything is gone                │
└──────────────────────────────────────┘
```

---

## 🔧 Build Process Explained

### When You Run `mvn package`

```
Step 1: Clean
═══════════════════════════════
Delete old compiled files
└── target/ directory cleared


Step 2: Compile
═══════════════════════════════
Java Source Code (.java)
    ↓
    javac (compiler)
    ↓
Java Bytecode (.class files)
└── target/classes/


Step 3: Download Dependencies
═══════════════════════════════
Read pom.xml
    ↓
Download libraries from internet:
- spring-boot-starter-web
- spring-boot-starter-data-mongodb
- mongodb-driver
- springdoc-openapi
- lombok
    ↓
└── ~/.m2/repository/ (local cache)


Step 4: Package
═══════════════════════════════
Package everything into one file
    ↓
└── target/hotel-service-0.0.1-SNAPSHOT.jar
    This JAR contains:
    - Your code
    - Spring Boot
    - MongoDB driver
    - All dependencies
    - Everything needed to run!


Step 5: Done!
═══════════════════════════════
Run with: java -jar target/...jar
```

---

## 🌐 How HTTP Works with This Project

```
┌─────────────┐           ┌─────────────┐
│  Browser    │           │  Postman    │
│  Swagger UI │           │ (API Client)│
└──────┬──────┘           └──────┬───────┘
       │                        │
       └────────┬───────────────┘
                │
                │ HTTP Request
                │ POST http://localhost:8082/api/hotels
                │ Content-Type: application/json
                │ Body: {"name":"Grand Hotel",...}
                ↓
       ┌────────────────────────┐
       │  Spring Boot Server    │
       │  Running on Port 8082 │
       └─────┬──────────────────┘
             │
             ↓
       ┌────────────────────────┐
       │  HotelController        │
       │  Routes the request     │
       └─────┬──────────────────┘
             │
             ↓
       ┌────────────────────────┐
       │  HotelService          │
       │  Business logic        │
       └─────┬──────────────────┘
             │
             ↓
       ┌────────────────────────┐
       │  HotelRepository        │
       │  Database operations    │
       └─────┬──────────────────┘
             │
             ↓
       ┌────────────────────────┐
       │  MongoDB Database       │
       │  Stores the data        │
       └────────────────────────┘
             │
             ↓
       HTTP Response (JSON):
       {"id":"123","name":"Grand Hotel",...}
             ↓
       Back to Browser/Postman!
```

---

## 📂 Project Files and Their Purpose

```
Hotel-Service/
│
├── 📁 src/main/java/com/hbs/hotel/
│   │
│   ├── 🎮 CONTROLLERS (Handle HTTP requests)
│   │   ├── HotelController.java
│   │   │   "When someone calls /api/hotels, handle it"
│   │   │   → Endpoints: POST, GET, PUT, DELETE
│   │   │
│   │   └── HealthController.java
│   │       "Is the service alive?"
│   │       → Endpoint: GET /api/health
│   │
│   ├── 💼 SERVICES (Business logic)
│   │   └── HotelService.java
│   │       - create() - Creates new hotel
│   │       - list() - Gets all hotels
│   │       - getById() - Gets one hotel
│   │       - update() - Updates hotel
│   │       - delete() - Removes hotel
│   │
│   ├── 📦 REPOSITORIES (Database layer)
│   │   └── HotelRepository.java
│   │       - Inherits from MongoRepository
│   │       - Provides save(), findAll(), etc.
│   │       - Talks to MongoDB
│   │
│   ├── 📋 MODELS (Data structure)
│   │   └── Hotel.java
│   │       - Fields: id, name, description, city, country
│   │       - Maps to MongoDB document
│   │
│   ├── 🧾 DTOs (Data Transfer Objects)
│   │   ├── HotelRequest.java - Data coming IN
│   │   └── HotelResponse.java - Data going OUT
│   │
│   ├── ⚠️ EXCEPTIONS (Error handling)
│   │   ├── NotFoundException.java
│   │   ├── GlobalExceptionHandler.java
│   │   └── ApiError.java
│   │
│   └── ⚙️ CONFIG (Configuration)
│       ├── CorsConfig.java - Allows cross-origin requests
│       └── DevDataLoader.java - Loads sample data
│
├── 📄 pom.xml
│   "Shopping list" for Maven
│   Lists all dependencies (libraries) needed
│
├── 🐳 docker-compose.yml
│   "Orchestration" for Docker
│   "Start MongoDB and connect app to it"
│
├── 🐋 Dockerfile
│   "How to build the Docker image"
│   Creates a container with just the app
│
└── 📝 application.yml
    Configuration file:
    - Server port: 8082
    - MongoDB connection
    - Swagger UI settings
```

---

## 🎓 Key Takeaways

### 1. **Layered Architecture**

```
Controller → Service → Repository → Database
    ↑         ↑         ↑           ↑
    API     Logic    Database    MongoDB
```

### 2. **Separation of Concerns**

- **Controller**: Handles HTTP
- **Service**: Business rules
- **Repository**: Database access

### 3. **Why Each Tool Exists**

| Tool            | Why?                                 |
| --------------- | ------------------------------------ |
| **Maven**       | Manages dependencies, builds project |
| **Spring Boot** | Fast development, auto-configuration |
| **MongoDB**     | Flexible, JSON-like storage          |
| **Docker**      | Consistent environment, easy setup   |
| **Swagger**     | Interactive API documentation        |

---

## 🚀 Quick Start Summary

1. **Start MongoDB**: `docker run -d --name hotel-mongo mongo:7`
2. **Build Project**: `.\mvnw.cmd clean package`
3. **Run Application**: `java -jar target/hotel-service-0.0.1-SNAPSHOT.jar`
4. **Test**: Visit http://localhost:8082/swagger-ui.html

**OR** just run: `.\START_APPLICATION.ps1`

---

## 📖 Learn More

- **COMPLETE_GUIDE.md** - Everything explained in detail
- **HOW_TO_RUN.md** - Step-by-step running instructions
- **SETUP_GUIDE.md** - Troubleshooting and configuration

---

**🎉 You now understand the complete architecture!**
