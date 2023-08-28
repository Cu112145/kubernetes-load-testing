FROM python:3.9

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
CMD ["flask", "run", "--host=0.0.0.0", "--port=8082"]

# Expose port 8082 to the outside world
EXPOSE 8082
