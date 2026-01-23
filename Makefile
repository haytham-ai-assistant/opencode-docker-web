# Docker Commands
# Set default shell to bash for compatibility with Windows (msys2 and WSLD)

# Main targets
.PHONY: up down exec

up:
	docker compose up -d

down:
	docker compose down

exec:
	docker compose exec opencode bash
