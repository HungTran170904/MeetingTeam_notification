# Build stage
FROM maven:3.8.3-openjdk-17 AS build-stage

## Change directory
WORKDIR /app

## Download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

## Build code
COPY src ./src
RUN mvn install -DskipTests=true

# Run stage
FROM alpine:3.19 AS run-stage
MAINTAINER com.HungTran
RUN apk add openjdk17

## Change directory
WORKDIR /app

## Create non-root user
RUN adduser -D mt_notification
RUN chown -R mt_notification. /app
USER mt_notification

## Copy war file and run app
COPY --from=build-stage /app/target/NotificationService-0.0.1-SNAPSHOT.war mt_notification.war
ENTRYPOINT ["java","-jar","mt_notification.war"]

## Expose port 8081
EXPOSE 8081