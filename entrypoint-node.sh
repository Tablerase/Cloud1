#!/bin/bash
set -e

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting SSH daemon..."
/usr/sbin/sshd

log "SSH node ready for connections"

# Execute the main command
exec "$@"
