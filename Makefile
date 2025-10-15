# Makefile for Inception


# Use docker-compose file in srcs
COMPOSE_FILE = srcs/docker-compose.yml

# Default target
all: up

up:
	@echo "$(GREEN)Building and starting the containers...$(RESET)"
	docker-compose -f$(COMPOSE_FILE) up --build -D

# Stops and removes the containers
down:
	@echo "$(RED)Stopping and removing the containers...$(RESET)"
	docker-compose -f$(COMPOSE_FILE) down

# Forces a rebuild of the containers
build:
	@echo "$(YELLOW)Forcing a rebuild of the containers...$(RESET)"
	docker-compose -f $(COMPOSE_FILE) build

# Cleanup: stops containers, removes volumes and images
clean:
	@echo "$(CYAN)Cleaning up...$(RESET)"
	docker-compose -f $(COMPOSE_FILE) down --volumes --rmi all

# Restart the stack from scratch
re:
	@echo "$(PURPLE)Restarting the stack from scratch...$(RESET)"
	@$(MAKE) clean
	@$(MAKE) all

# Tails the logs for all services for debugging
logs:
	@echo "$(BLUE)Tailing the logs for all services...$(RESET)"
	docker-compose -f $(COMPOSE_FILE) logs -f

.PHONY: all up down build clean re logs

# Color definitions for echo statements
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
CYAN = \033[0;36m
WHITE = \033[0;37m
BOLD = \033[1m
RESET = \033[0m
