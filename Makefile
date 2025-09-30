.PHONY: help dev build clean deploy logs stop restart status

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

dev: ## Start development environment (build and run)
	@echo "🚀 Starting development environment..."
	docker-compose up -d --build
	@echo "✅ Development environment started. Use 'make logs' to view output."

build: ## Build the Docker image
	@echo "🔨 Building Docker image..."
	docker-compose build
	@echo "✅ Build complete."

clean: ## Stop and remove containers, networks, and volumes
	@echo "🧹 Cleaning up containers, networks, and volumes..."
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "✅ Cleanup complete."

deploy: ## Deploy using production configuration
	@echo "🚀 Deploying with production configuration..."
	docker-compose -f docker-compose.deploy.yml up -d
	@echo "✅ Deployment complete. Use 'make logs-deploy' to view output."

logs: ## Show development logs (follow)
	@echo "📄 Showing development logs (Ctrl+C to exit)..."
	docker-compose logs -f

logs-deploy: ## Show deployment logs (follow)
	@echo "📄 Showing deployment logs (Ctrl+C to exit)..."
	docker-compose -f docker-compose.deploy.yml logs -f

stop: ## Stop all containers
	@echo "⏹️  Stopping containers..."
	docker-compose down
	docker-compose -f docker-compose.deploy.yml down 2>/dev/null || true
	@echo "✅ All containers stopped."

restart: ## Restart development environment
	@echo "🔄 Restarting development environment..."
	docker-compose restart
	@echo "✅ Development environment restarted."

restart-deploy: ## Restart deployment environment
	@echo "🔄 Restarting deployment environment..."
	docker-compose -f docker-compose.deploy.yml restart
	@echo "✅ Deployment environment restarted."

status: ## Show container status
	@echo "📊 Container status:"
	@docker-compose ps 2>/dev/null || echo "No development containers running"
	@echo ""
	@echo "📊 Deployment status:"
	@docker-compose -f docker-compose.deploy.yml ps 2>/dev/null || echo "No deployment containers running"

push: ## Build and push image to registry
	@echo "📤 Building and pushing image..."
	docker build -t runsystemid/openfortivpn:latest .
	docker push runsystemid/openfortivpn:latest
	@echo "✅ Image pushed to registry."

config-check: ## Validate configuration file exists
	@if [ ! -f .openfortivpn.conf ]; then \
		echo "❌ Configuration file .openfortivpn.conf not found!"; \
		echo "💡 Copy from template: cp .openfortivpn.conf.example .openfortivpn.conf"; \
		exit 1; \
	else \
		echo "✅ Configuration file found."; \
	fi

setup: ## Initial setup - copy config template
	@if [ ! -f .openfortivpn.conf ]; then \
		echo "🔧 Setting up configuration..."; \
		cp .openfortivpn.conf.example .openfortivpn.conf; \
		echo "✅ Configuration template copied to .openfortivpn.conf"; \
		echo "📝 Please edit .openfortivpn.conf with your VPN credentials"; \
	else \
		echo "✅ Configuration file already exists."; \
	fi

# Compound commands
install: setup config-check ## Initial project setup and validation
	@echo "🎉 Setup complete! You can now run 'make dev' to start development."

all: clean build dev ## Clean, build and start development environment
	@echo "🎉 Full development environment ready!"