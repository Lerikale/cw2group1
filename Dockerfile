# Use official Node.js LTS image as base
FROM node:18-alpine

# Set working directory inside container
WORKDIR /usr/src/app

# Copy application file(s) into container
COPY server.js .

# Expose application port
EXPOSE 8081

# Set environment variable (optional, Kubernetes will overwrite this)
ENV HOSTNAME=devops-app

# Command to run the app
CMD ["node", "server.js"]
