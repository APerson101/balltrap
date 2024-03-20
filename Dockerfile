# Use the official MySQL 8.0 image from Docker Hub
FROM mysql:latest

# Set environment variables for MySQL configuration
ENV MYSQL_ROOT_PASSWORD=11111111
ENV MYSQL_DATABASE=balltrap

# Copy SQL script to initialize the database
COPY init.sql /docker-entrypoint-initdb.d/

# Expose MySQL default port
EXPOSE 3306
