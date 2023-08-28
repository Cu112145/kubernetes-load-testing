#!/bin/bash

# Function to check and kill process running on a given port
kill_process_on_port() {
    local port="$1"

    # Find the process ID
    pid=$(lsof -t -i:$port)

    # Check if a process is running on the port
    if [[ -z "$pid" ]]; then
        echo "No process is running on port $port."
    else
        echo "Killing process on port $port with PID $pid."
        
        # Kill the process
        kill -9 $pid

        if [[ $? -eq 0 ]]; then
            echo "Successfully killed process on port $port."
        else
            echo "Failed to kill process on port $port."
        fi
    fi
}

# Main script starts here
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <port>"
    exit 1
fi

port="$1"

kill_process_on_port "$port"
