# Use an official Maven runtime as a parent image
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file
COPY ./pom.xml .

# Copy the source code
COPY ./src ./src

# Build the application with Maven
RUN mvn clean install

# Create a new stage for the runtime environment
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/your-app.jar ./app.jar

# Expose the port your application will listen on (adjust as needed)
EXPOSE 8080

# Define the command to run your application
CMD ["java", "-jar", "app.jar"]
