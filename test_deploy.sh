#!/bin/bash

# Configuration
SSH_USER="sshuser"
SSH_PASS="password"
SSH_PORT="2222"
SSH_HOST="localhost"
WEB_URL="http://localhost:80"

echo "Starting environment..."
docker compose up -d

echo "Waiting for services to be ready..."
sleep 5

echo "Creating a test file..."
TEST_CONTENT="<h1>Deployed via SSH at $(date)</h1>"
echo "$TEST_CONTENT" > test_index.html

echo "Uploading file via SSH..."
if ! command -v sshpass &> /dev/null; then
    echo "ERROR: sshpass is not installed. Please install it to run this test."
    # Fallback to manual check if we can't run sshpass
    echo "Checking if we can at least reach the web server..."
    if curl -s "$WEB_URL" > /dev/null; then
        echo "Web server is UP."
    else
        echo "Web server is DOWN."
    fi
    exit 1
fi

sshpass -p "$SSH_PASS" scp -P "$SSH_PORT" -o StrictHostKeyChecking=no test_index.html "$SSH_USER@$SSH_HOST:/app/index.html"

echo "Verifying deployment via HTTP..."
RESPONSE=$(curl -s "$WEB_URL")

if [[ "$RESPONSE" == *"$TEST_CONTENT"* ]]; then
    echo "SUCCESS: File deployed and verified!"
    rm test_index.html
    exit 0
else
    echo "FAILURE: Content mismatch or service unreachable."
    echo "Response: $RESPONSE"
    rm test_index.html
    exit 1
fi
