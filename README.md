# Hotel Service

Spring Boot 3.3.x + MongoDB microservice that manages hotel records for the Hotel Booking Platform. Exposes CRUD APIs, health status, and OpenAPI documentation for the hotel domain.

## Tech Stack & Prerequisites
- Java 17 (Temurin recommended)
- Maven 3.9+
- MongoDB 7 (local or container)
- Docker & Docker Compose (optional, for containerized runs)

## Configuration
- Server port: `8082`
- Environment variables:
  - `MONGO_URI` (default `mongodb://localhost:27017/hotel_db`)
- Profiles: `dev`, `prod`

## Run Locally (Mongo in Docker, app on host)
```bash
# Start Mongo locally via Docker
docker run -d --name hotel-mongo -p 27017:27017 mongo:7

# Run the service (use ./mvnw if wrapper is present, otherwise mvn)
MONGO_URI=mongodb://localhost:27017/hotel_db ./mvnw spring-boot:run
```
> Tip: Replace `./mvnw` with `mvn` if you maintain a global Maven installation.

## Package the Application
```bash
./mvnw -DskipTests package
java -jar target/hotel-service-0.0.1-SNAPSHOT.jar
```

## Docker & Docker Compose
```bash
./mvnw -DskipTests package

# Build and start both MongoDB and the hotel-service
docker compose up --build
```
- Service URL: http://localhost:8082
- Mongo Express access (if added separately) can point to `mongodb://mongo:27017`.

## API Documentation
- Swagger UI: http://localhost:8082/swagger-ui.html
- OpenAPI JSON: http://localhost:8082/v3/api-docs

## REST API Endpoints
- `POST   /api/hotels` – Create a hotel (201)
- `GET    /api/hotels` – List hotels (200)
- `GET    /api/hotels/{id}` – Fetch by ID (200/404)
- `PUT    /api/hotels/{id}` – Replace hotel details (200/404)
- `DELETE /api/hotels/{id}` – Delete hotel (204/404)
- `GET    /api/health` – Service health (200)

### Curl Examples
```bash
# Health
curl -s http://localhost:8082/api/health

# Create
curl -s -X POST http://localhost:8082/api/hotels \
  -H "Content-Type: application/json" \
  -d '{"name":"Seaside Inn","description":"Beachfront","city":"Miami","country":"USA"}'

# List
curl -s http://localhost:8082/api/hotels

# Get by ID
curl -s http://localhost:8082/api/hotels/<ID>

# Update
curl -s -X PUT http://localhost:8082/api/hotels/<ID> \
  -H "Content-Type: application/json" \
  -d '{"name":"Seaside Inn","description":"Ocean view","city":"Miami Beach","country":"USA"}'

# Delete
curl -i -X DELETE http://localhost:8082/api/hotels/<ID>
```

## CORS
CORS is open to all origins for MVP development. To restrict hosts later, adjust the configuration in `src/main/java/com/hbs/hotel/config/CorsConfig.java` with specific origins and headers.

## Troubleshooting
- **Mongo connection refused**: Ensure the Mongo container is running and `MONGO_URI` points to the right host/port.
- **Validation errors**: `name` is required (2-120 chars). Check response body for details.
- **Port conflicts**: Change `server.port` in `application.yml` or free port `8082`.
- **Swagger unreachable**: Verify the application started without errors and you are hitting `/swagger-ui.html`.

## License
This project is provided as part of the Hotel Booking Platform MVP.
