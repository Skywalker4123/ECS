# Use a base image with Maven and Java already installed
FROM maven:3.8.4-openjdk-8-slim AS builder

# Copy the Maven POM file and download dependencies
COPY pom.xml /app/
WORKDIR /app
RUN mvn -B dependency:go-offline

# Copy the source code and build the application
COPY src /app/src
RUN mvn -B package

# Use a lightweight base image for the final Docker image
FROM openjdk:8-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR/WAR file from the builder stage
COPY --from=builder /app/target/vprofile.war /app/

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "vprofile.war"]
