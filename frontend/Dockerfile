# Step 1: Build the React application
FROM node:14 AS build

# Set working directory
WORKDIR /app

# Install app dependencies
COPY app/package.json  ./
RUN npm install

# Copy the rest of your app's source code from app/ directory
COPY app/ ./

# Build the app
RUN npm run build

# Step 2: Serve the React application using a lightweight node server, e.g., serve
FROM node:14-slim

WORKDIR /app

# Install serve
RUN npm install -g serve

# Copy the build folder from the build image
COPY --from=build /app/build /app/build

# Start command
CMD ["serve", "-s", "build", "-l", "80"]

# Expose port 3000
EXPOSE 80