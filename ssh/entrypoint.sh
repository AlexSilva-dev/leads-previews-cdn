#!/bin/bash

# Ensure /app exists and has correct permissions
mkdir -p /app
chown sshuser:sshuser /app

# Run sshd in foreground
/usr/sbin/sshd -D -e
