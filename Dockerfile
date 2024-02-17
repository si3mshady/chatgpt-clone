# Use an official Node.js image as the base image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Build the React app for production
RUN npm run build

# Expose the port that the app will run on
EXPOSE 3000

# Set the environment variables
ENV REACT_APP_API_URL=http://keycloak:8080/
ENV REACT_APP_REALM=RAG
ENV REACT_APP_CLIENT_ID=rag-client
ENV REACT_APP_SERVER=rag-server-be

# Start the React app when the container launches
CMD ["npm", "start"]