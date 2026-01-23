# OpenCode Docker Image
FROM node:20-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    OPENCODE_CONFIG_DIR=/opt/opencode/config \
    PATH="/root/.local/bin:${PATH}"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode from npm
RUN curl -fsSL https://opencode.ai/install | bash

# Create config directory for OpenCode configuration files
RUN mkdir -p ${OPENCODE_CONFIG_DIR}

# Create a working directory
WORKDIR /workspace

# Copy config files if they exist (optional)
# Uncomment and use this if you have config files to copy
# COPY config/* ${OPENCODE_CONFIG_DIR}/

# Set up volume for config files
VOLUME ${OPENCODE_CONFIG_DIR}

# Set up volume for workspace
VOLUME /workspace

# Default command
CMD ["bash"]
