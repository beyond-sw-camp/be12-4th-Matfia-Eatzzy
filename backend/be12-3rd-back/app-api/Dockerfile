FROM openjdk:17-ea-slim-buster
EXPOSE 8080
ADD     ./build/libs/app-api-0.0.1-SNAPSHOT.jar    /app.jar
CMD     java -jar app.jar --spring.config.location=/config/application.yml