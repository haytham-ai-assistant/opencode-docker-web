# OpenCode Docker Environment

This repository provides a Docker image and docker‑compose configuration for a lightweight, repeatable development environment that includes:
- **Node.js 20** – Runtime for the OpenCode CLI.
- **Python 3.11** – For Python‑based OpenCode plugins.
- **OpenCode CLI** – Installed using the official bootstrap script.
- **Git** – Version control.
- **GitHub CLI (gh)** – Handy one‑liner interactions.
- **Configuration directory** – `config/` mounted at `/opt/opencode/config`.

The container mounts a `workspace/` directory for your project code and accepts optional environment variables for OpenAI, Anthropic, and OpenCode APIs via an optional `.env` file.

## What's Included

- **Node.js 20** – Runtime for the OpenCode CLI.
- **Python 3.11** – For Python‑based OpenCode plugins.
- **OpenCode CLI** – Installed using the official bootstrap script.
- **Git** – Version control.
- **GitHub CLI (gh)** – Handy one‑liner interactions.
- **Configuration directory** – `config/` mounted at `/opt/opencode/config`.

## Prerequisites

- Docker (>= 25)
- Docker Compose (recommended)

## Quick Start

### Method 1: Docker Compose (Recommended)

1. **Set up environment variables**  
   ```bash
   cp .env.example .env
   # Edit the file and add your API keys
   ```

2. **Create required directories**  
   ```bash
   mkdir -p workspace config
   ```

3. **Build and run the container**  
   ```bash
   docker compose up -d
   ```

4. **Enter the container**  
   ```bash
   docker compose exec opencode bash
   ```

### Method 2: Docker (single container)

```bash
docker build -t opencode-env .
docker run -it \
  -v $(pwd)/workspace:/workspace \
  -v $(pwd)/config:/opt/opencode/config \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.config/gh:/root/.config/gh:ro \
  -e OPENCODE_API_KEY=YOUR_KEY \
  -e ANTHROPIC_API_KEY=YOUR_KEY \
  -e OPENAI_API_KEY=YOUR_KEY \
  opencode-env
```

## Configuration

### OpenCode Configuration Files

Mount your OpenCode configuration files in the `config/` directory. Inside the container they are available at `/opt/opencode/config`.

Typical structure:
```
config/
├── opencode.yaml
├── .opencoderc
└── settings.json
```

### Git Configuration

The container mounts the host’s `~/.gitconfig`. You can also configure git inside the container:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### GitHub CLI Authentication

Authenticate with GitHub by running `gh auth login` inside the container or by mounting your local GH config as shown in the docker-compose file.

## Usage Examples

### OpenCode

```bash
# Inside the container
cd /workspace
opencode --help
```

### Git

```bash
# Inside the container
git clone https://github.com/yourusername/yourrepo.git
cd yourrepo
# Make changes
git add .
git commit -m "Update from OpenCode"
git push
```

### GitHub CLI

```bash
# Inside the container
gh repo list
gh issue list
gh pr create
```

## Directory Structure

```
.
├── Dockerfile              # Docker image definition
├── docker compose.yml      # Docker Compose configuration
├── .env.example           # Example environment variables
├── config/                # OpenCode configuration files (create this)
├── workspace/             # Your working directory (create this)
```

## Managing the Container
- **Stop**: `docker compose down`
- **Rebuild after changes**:

  ```bash
  docker compose down
  docker compose build --no-cache
  docker compose up -d
  ```

### Using the Makefile

To simplify common Docker‑Compose operations, a lightweight `Makefile` is provided.
All targets delegate to `docker compose` underneath, so you don’t need to remember the full docker‑compose command line.

```bash
# Bring the container up in detached mode
make up

# Stop and remove the container
make down

# Execute a shell inside the running container
make exec
```

The `Makefile` is a thin wrapper for the commands you already see in the **Managing the Container** section, but it keeps the workflow terse and consistent across environments.

## Troubleshooting

### API Keys not working
- Verify the `.env` file contains correct keys.
- Restart the container after updating environment variables.

### Permission issues
- The container runs as root by default; adjust file permissions in `workspace` if necessary.

### Config files not loading
- Confirm files exist in `config/`.
- Check inside the container at `/opt/opencode/config/`.

## Security Notes

- Do **not** commit `.env` with real API keys.
- Keep your API keys secure.
- Use volume mounts thoughtfully in production.

## Additional Resources

- [OpenCode Documentation](https://opencode.ai/docs/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Documentation](https://git-scm.com/doc)
