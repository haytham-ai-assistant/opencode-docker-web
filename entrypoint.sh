#!/bin/bash
set -e

# Update source
chsrc set cargo
chsrc set node
chsrc set debian

# Build arguments array for opencode web
args=()

# Port configuration
PORT=${OPENCODE_SERVER_PORT:-4096}
args+=("--port" "$PORT")

# Hostname configuration
HOSTNAME=${OPENCODE_SERVER_HOSTNAME:-0.0.0.0}
args+=("--hostname" "$HOSTNAME")

# mDNS configuration
if [ "$OPENCODE_SERVER_MDNS" = "true" ] || [ "$OPENCODE_SERVER_MDNS" = "1" ]; then
    args+=("--mdns")
    if [ -n "$OPENCODE_SERVER_MDNS_DOMAIN" ]; then
        args+=("--mdns-domain" "$OPENCODE_SERVER_MDNS_DOMAIN")
    fi
fi

# CORS configuration
if [ -n "$OPENCODE_SERVER_CORS" ]; then
    # Split by comma if multiple domains provided
    IFS=',' read -ra cors_domains <<< "$OPENCODE_SERVER_CORS"
    for domain in "${cors_domains[@]}"; do
        args+=("--cors" "$domain")
    done
fi

# Authentication is handled via environment variables OPENCODE_SERVER_USERNAME and OPENCODE_SERVER_PASSWORD
# OpenCode automatically picks these up, no need to pass as arguments.

echo "Starting OpenCode web server with arguments: ${args[@]}"
exec opencode web "${args[@]}"
