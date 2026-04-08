#!/bin/bash

# Update password if SSH_PASSWORD is set
if [ ! -z "$SSH_PASSWORD" ]; then
    echo "sshuser:$SSH_PASSWORD" | chpasswd
fi

# Ensure /app exists and has correct permissions
mkdir -p /app
chown sshuser:sshuser /app

# Run sshd in foreground
/usr/sbin/sshd -D -e
