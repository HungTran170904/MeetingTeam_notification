FROM openjdk:17-jdk-alpine

## Change directory
WORKDIR /app

## Create non-root user
RUN adduser -D mt_notification
RUN chown -R mt_notification. /app
USER mt_notification

## Copy war file and run app
COPY target/NotificationService-0.0.1-SNAPSHOT.war mt_notification.war
ENTRYPOINT ["java","-jar","mt_notification.war"]

## Expose port 8081
EXPOSE 8081