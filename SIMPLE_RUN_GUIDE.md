# 🚀 How to Run Your Hotel Service - Step by Step

## ✅ What You Have Now

1. **MongoDB** - Running in Docker container ✅
2. **Spring Boot Application** - Built and ready ✅
3. **All Dependencies** - Installed ✅

---

## 🎯 Step-by-Step Instructions

### Step 1: Open PowerShell in Project Directory

```powershell
cd D:\hotelbookingsystem\Hotel-Service
```

### Step 2: Run the Test Script (Easiest Way)

```powershell
.\TEST_APPLICATION.ps1
```

**This script will:**

- ✅ Check MongoDB is running
- ✅ Start your Spring Boot application
- ✅ Test all API endpoints
- ✅ Show you the results
- ✅ Give you access URLs

---

## 🔧 Manual Way (If You Want More Control)

### Step 1: Start MongoDB (if not running)

```powershell
# Check if MongoDB is running
docker ps

# If you see "hotel-mongo", you're good!
# If not, start it:
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

### Step 2: Start Spring Boot Application

```powershell
# In the Hotel-Service directory
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

**You should see output like:**

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.3.4)

2024-10-26 22:50:00.123  INFO 12345 --- [main] c.h.h.HotelServiceApplication : Starting HotelServiceApplication
2024-10-26 22:50:01.456  INFO 12345 --- [main] c.h.h.HotelServiceApplication : Started HotelServiceApplication in 1.333 seconds
```

### Step 3: Test the Application

**Open a new PowerShell window and run:**

```powershell
# Test health
Invoke-WebRequest -Uri http://localhost:8082/api/health

# Create a hotel
$hotel = @{
    name = "Grand Hotel"
    description = "Luxury hotel"
    city = "New York"
    country = "USA"
} | ConvertTo-Json

Invoke-RestMethod -Method POST `
  -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body $hotel

# Get all hotels
Invoke-RestMethod -Uri http://localhost:8082/api/hotels
```

---

## 🌐 Access Your Application

Once running, you can access:

### 1. Swagger UI (Interactive API Documentation)

```
http://localhost:8082/swagger-ui.html
```

**This gives you a web interface to test all APIs!**

### 2. Health Check

```
http://localhost:8082/api/health
```

**Should return:** `{"status":"UP"}`

### 3. Hotels API

```
http://localhost:8082/api/hotels
```

**GET** - See all hotels
**POST** - Create new hotel

---

## 🏨 How Collections Work in MongoDB

### Automatic Collection Creation

**You DON'T need to manually create collections!**

When you POST a hotel:

1. Spring Boot connects to MongoDB
2. MongoDB automatically creates `hotel_db` database
3. MongoDB automatically creates `hotels` collection
4. Your hotel data is stored as a document

### What Happens When You POST a Hotel

```json
POST /api/hotels
{
  "name": "Grand Hotel",
  "description": "Luxury hotel",
  "city": "New York",
  "country": "USA"
}
```

**MongoDB stores it as:**

```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "Grand Hotel",
  "description": "Luxury hotel",
  "city": "New York",
  "country": "USA"
}
```

### View Your Data

**Option 1: Using Swagger UI**

1. Go to http://localhost:8082/swagger-ui.html
2. Try the "GET /api/hotels" endpoint
3. See all your hotels

**Option 2: Using PowerShell**

```powershell
Invoke-RestMethod -Uri http://localhost:8082/api/hotels
```

**Option 3: Using MongoDB Compass (GUI)**

1. Download MongoDB Compass
2. Connect to: `mongodb://localhost:27017`
3. Navigate to `hotel_db` → `hotels` collection

---

## 🧪 Complete Test Example

### Test 1: Health Check

```powershell
Invoke-WebRequest -Uri http://localhost:8082/api/health
```

**Expected:** `{"status":"UP"}`

### Test 2: Create Hotel

```powershell
$hotel = @{
    name = "Seaside Inn"
    description = "Beachfront hotel"
    city = "Miami"
    country = "USA"
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST `
  -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body $hotel

Write-Host "Created hotel with ID: $($response.id)"
```

**Expected:** Hotel created with auto-generated ID

### Test 3: Get All Hotels

```powershell
$hotels = Invoke-RestMethod -Uri http://localhost:8082/api/hotels
Write-Host "Total hotels: $($hotels.Count)"
foreach ($hotel in $hotels) {
    Write-Host "- $($hotel.name) in $($hotel.city)"
}
```

**Expected:** List of all hotels

### Test 4: Get Specific Hotel

```powershell
# Use the ID from Test 2
$hotelId = "YOUR_HOTEL_ID_HERE"
$hotel = Invoke-RestMethod -Uri http://localhost:8082/api/hotels/$hotelId
Write-Host "Hotel: $($hotel.name)"
```

### Test 5: Update Hotel

```powershell
$updateData = @{
    name = "Seaside Inn Updated"
    description = "Updated beachfront hotel"
    city = "Miami Beach"
    country = "USA"
} | ConvertTo-Json

$response = Invoke-RestMethod -Method PUT `
  -Uri http://localhost:8082/api/hotels/$hotelId `
  -ContentType "application/json" `
  -Body $updateData

Write-Host "Updated hotel: $($response.name)"
```

### Test 6: Delete Hotel

```powershell
Invoke-RestMethod -Method DELETE -Uri http://localhost:8082/api/hotels/$hotelId
Write-Host "Hotel deleted"
```

---

## 🐛 Troubleshooting

### Issue: "Cannot connect to MongoDB"

**Solution:**

```powershell
# Check MongoDB
docker ps

# If not running, start it
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

### Issue: "Port 8082 already in use"

**Solution:**

```powershell
# Find what's using the port
netstat -ano | findstr :8082

# Kill the process or change port in application.yml
```

### Issue: "Application won't start"

**Solution:**

```powershell
# Check if JAR exists
Test-Path "target/hotel-service-0.0.1-SNAPSHOT.jar"

# If not, build it
.\mvnw.cmd clean package -DskipTests
```

---

## 🎉 Success!

When everything works, you'll see:

1. ✅ MongoDB running in Docker
2. ✅ Spring Boot application started
3. ✅ Health check returns `{"status":"UP"}`
4. ✅ Can create hotels via API
5. ✅ Can retrieve hotels from MongoDB
6. ✅ Swagger UI accessible at http://localhost:8082/swagger-ui.html

---

## 📚 Next Steps

1. **Explore Swagger UI** - Interactive API testing
2. **Create more hotels** - Test different data
3. **Read the guides** - COMPLETE_GUIDE.md, VISUAL_GUIDE.md
4. **Modify the code** - Add new fields, endpoints
5. **Deploy** - Learn about cloud deployment

---

**🚀 You're now running a full-stack hotel management system!**
