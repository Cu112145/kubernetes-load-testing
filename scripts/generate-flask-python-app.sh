#!/bin/bash

# Function to create file with content
create_file() {
  local FILE_PATH="$1"
  local CONTENT="$2"
  echo -e "$CONTENT" > "$FILE_PATH"
}

# Check if flask is available
if ! command -v flask &> /dev/null; then
  echo "'flask' command not found. Please install Flask first."
  exit 1
fi

# Create a new Flask project folder
mkdir my_flask_app
if [ $? -ne 0 ]; then
  echo "Failed to create Flask app folder. Exiting."
  exit 1
fi

cd my_flask_app
if [ $? -ne 0 ]; then
  echo "Failed to navigate to the Flask app directory. Exiting."
  exit 1
fi

# Create main Python script for Flask
FLASK_APP_CONTENT="from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'"

create_file app.py "$FLASK_APP_CONTENT"

# Create Dockerfile
DOCKERFILE_CONTENT="FROM python:3.9

# Set environment variables
ENV FLASK_APP=app.py

# Create and set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask app files
COPY . .

# Run the application
CMD [\"flask\", \"run\", \"--host=0.0.0.0\"]"

create_file Dockerfile "$DOCKERFILE_CONTENT"

# Create requirements.txt with Flask
REQUIREMENTS_TXT_CONTENT="Flask==2.0.1"

create_file requirements.txt "$REQUIREMENTS_TXT_CONTENT"

# Print out a message to indicate success
echo "Flask Python project 'my_flask_app' has been generated with a Dockerfile."
