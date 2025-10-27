# How to Run Your Hotel Service

## 🚀 Quick Start (Easiest Method)

### Step 1: Open PowerShell in the Project Directory

```powershell
cd D:\hotelbookingsystem\Hotel-Service
```

### Step 2: Run the Startup Script

```powershell
.\START_APPLICATION.ps1
```

That's it! The script will:

- ✓ Check if MongoDB is running (start it if not)
- ✓ Check if your app is built (build it if needed)
- ✓ Start the application on port 8082

---

## 🎯 Manual Steps (If You Want More Control)

### Terminal 1: Make Sure MongoDB is Running

```powershell
# Check if MongoDB is running
docker ps

# If you see "hotel-mongo", you're good!
# If not, start it:
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

### Terminal 2: Start the Application

```powershell
# Navigate to project
cd D:\hotelbookingsystem\Hotel-Service

# Run the application
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

---

## ✅ How to Verify It's Working

### 1. Check Health

Open your browser or PowerShell:

```powershell
# PowerShell
Invoke-WebRequest -Uri http://localhost:8082/api/health

# Browser
http://localhost:8082/api/health
```

Expected response: `{"status":"UP"}`

### 2. Visit Swagger UI

Open in browser:

```
http://localhost:8082/swagger-ui.html
```

This gives you an interactive interface to test all API endpoints!

### 3. Test Creating a Hotel

In PowerShell:

```powershell
$body = @{
    name = "Grand Hotel"
    description = "Luxury hotel in the city center"
    city = "New York"
    country = "USA"
} | ConvertTo-Json

Invoke-RestMethod -Method POST `
  -Uri http://localhost:8082/api/hotels `
  -ContentType "application/json" `
  -Body $body
```

---

## 📚 What Happens When You Run

```
1. Application Starts
   ↓
2. Connects to MongoDB (localhost:27017)
   ↓
3. Creates "hotel_db" database (if doesn't exist)
   ↓
4. Starts web server on port 8082
   ↓
5. Ready to accept HTTP requests!
```

---

## 🛑 How to Stop

Press `Ctrl+C` in the terminal where the application is running.

To stop MongoDB:

```powershell
docker stop hotel-mongo
```

---

## 🐛 Troubleshooting

### Issue: "Port 8082 already in use"

**Solution:** Something else is using port 8082

```powershell
# Find what's using it
netstat -ano | findstr :8082

# Or just use a different port in application.yml
```

### Issue: "Cannot connect to MongoDB"

**Solution:** Start the MongoDB container

```powershell
docker run -d --name hotel-mongo -p 27017:27017 mongo:7
```

### Issue: "JAR file not found"

**Solution:** Build the project first

```powershell
.\mvnw.cmd clean package -DskipTests
```

---

## 🎓 Read More

- **COMPLETE_GUIDE.md** - Everything about the project, architecture, and concepts
- **SETUP_GUIDE.md** - Detailed setup and configuration
- **README.md** - Original documentation

---

## 🎉 You're All Set!

Once running, you can:

1. ✅ Visit Swagger UI: http://localhost:8082/swagger-ui.html
2. ✅ Create hotels via API
3. ✅ Read hotels from database
4. ✅ Update hotel information
5. ✅ Delete hotels

Happy coding! 🚀
