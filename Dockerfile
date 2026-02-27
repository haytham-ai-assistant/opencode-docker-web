# OpenCode Docker Image
FROM node:22-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    OPENCODE_CONFIG_DIR=/opt/opencode/config \
    PATH="/root/.cargo/bin:/root/.local/bin:/root/.opencode/bin:${PATH}"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    bash \
    nano \
    chromium \
    wget \
    fonts-liberation \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    gnupg \
    git \
    gosu \
    jq \
    python3 \
    python3-pip \
    build-essential \
    unzip \
    pandoc \
    socat \
    tini \
    websockify \
    gh \
    file \
    texlive-base \
    texlive-binaries \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    texlive-lang-chinese \
    texlive-latex-extra \
    nix-setup-systemd \
    && rm -rf /var/lib/apt/lists/*

# Install chsrc
RUN curl -LO https://gitee.com/RubyMetric/chsrc/releases/download/pre/chsrc_latest-1_amd64.deb
RUN apt install ./chsrc_latest-1_amd64.deb
RUN rm ./chsrc_latest-1_amd64.deb

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode from npm
RUN mkdir -p /root/.local/share/opencode
RUN curl -fsSL https://opencode.ai/install | bash
RUN test -x /root/.opencode/bin/opencode && echo "OpenCode installed successfully" || (echo "OpenCode installation failed" && exit 1)

# Install x-cmd
RUN eval "$(curl https://get.x-cmd.com)"

# Install Rust toolchain
RUN curl -sSf https://sh.rustup.rs --output rustup-init && \
    sh rustup-init -y && \
    rm rustup-init && \
    rustup component add rustfmt clippy

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

# Set up volume for home
VOLUME /root

# Copy .nanorc
COPY .nanorc /root/.nanorc

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY retry-exec /usr/local/bin/retry-exec
RUN chmod +x /usr/local/bin/retry-exec

# Default command: start OpenCode web server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
