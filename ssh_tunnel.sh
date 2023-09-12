#!/bin/bash

# Your SSH user and host. Replace these with your actual username and hostname or IP.
SSH_USER="root"
SSH_HOST="135.181.246.248"

# Setup SSH tunnels for each service
# This will map the localhost ports on the remote machine to localhost ports on your local machine
ssh -f -N -L 8082:localhost:8082 ${SSH_USER}@${SSH_HOST} &
ssh -f -N -L 8083:localhost:8083 ${SSH_USER}@${SSH_HOST} &
ssh -f -N -L 8081:localhost:8081 ${SSH_USER}@${SSH_HOST} &
ssh -f -N -L 8080:localhost:8080 ${SSH_USER}@${SSH_HOST} &
ssh -f -N -L 8084:localhost:8084 ${SSH_USER}@${SSH_HOST} &
ssh -f -N -L 5432:localhost:5432 ${SSH_USER}@${SSH_HOST} &

# Print out the forwarded ports
echo "SSH tunneling setup is complete."
echo "You can now access the services on your local machine using the following localhost ports:"
echo "Flask service 1: 8082"
echo "Flask service 2: 8083"
echo "Gin service: 8081"
echo "Spring Boot service: 8080"
echo "React Frontend: 8084"
echo "PostgreSQL: 5432"
