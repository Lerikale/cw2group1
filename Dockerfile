FROM node:alpine
EXPOSE 8081
COPY server.js .
CMD node server.js
