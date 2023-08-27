#!/bin/bash

# Function to test an endpoint
test_endpoint() {
  local URL="$1"
  local EXPECTED="$2"
  local RESPONSE=$(curl -s "$URL")

  echo "Testing $URL..."

  if [[ "$RESPONSE" == "$EXPECTED" ]]; then
    echo "Test succeeded: Received '$RESPONSE'"
  else
    echo "Test failed: Expected '$EXPECTED', but got '$RESPONSE'"
  fi

  echo
}

# Test Spring Boot endpoint on port 8080
test_endpoint "http://localhost:8080/ping" "pong"

# Test Gin endpoint on port 8081
test_endpoint "http://localhost:8081/ping" "{\"message\":\"pong\"}"

# Test Flask endpoint on port 8082
# Note: The expected response is a placeholder.
# Replace it with the actual expected JSON response from your Flask app.
test_endpoint "http://localhost:8082/ping" "{\"message\":\"pong\"}"

