FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY target/hotel-service-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8082

ENTRYPOINT ["java","-jar","/app/app.jar"]
