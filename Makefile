# Makefile for the sudokode Flutter project
FVM_INSTALL_URL := https://fvm.app/install.sh

.PHONY: all get run build-web clean analyze format l10n help setup


all: help ## Default target, runs when you just type `make`

setup: ## Sets up the project: installs FVM (if needed) and all dependencies.
	@echo "Checking for FVM installation..."
	@if ! command -v fvm >/dev/null 2>&1; then \
		echo "FVM not found. Attempting to install FVM..."; \
		if command -v curl >/dev/null 2>&1; then \
			echo "Downloading and running FVM installation script..."; \
			curl -fsSL $(FVM_INSTALL_URL) | bash; \
			if [ -f "$$HOME/.zshrc" ]; then source "$$HOME/.zshrc"; fi; \
			if [ -f "$$HOME/.bashrc" ]; then source "$$HOME/.bashrc"; fi; \
			if [ -f "$$HOME/.profile" ]; then source "$$HOME/.profile"; fi; \
			echo "FVM installation complete. Please restart your terminal or source your shell config if 'fvm' command is still not found."; \
			echo "Proceeding with 'fvm install' now, but future calls might require a new terminal."; \
		else \
			echo "Error: 'curl' command not found. Please install curl or install FVM manually."; \
			echo "See: https://fvm.app/docs/getting_started/installation"; \
			exit 1; \
		fi; \
	fi
	@echo "Installing project-specific Flutter SDK via FVM..."
	@fvm install $(FLUTTER_VERSION) # Pass FLUTTER_VERSION if defined, otherwise FVM uses .fvm/fvm_config.json
	@$(MAKE) get

get: ## Get project dependencies. Pass CLEAN_LOCK=true to force a clean get.
	@echo "Getting Flutter project dependencies..."
	@if [ "$(CLEAN_LOCK)" = "true" ]; then \
		echo "Cleaning pubspec.lock..."; \
		rm -f pubspec.lock; \
	fi
	fvm flutter pub get

run: ## Run the app in debug mode.
	fvm flutter run

build-web: ## Build the web application.
	fvm flutter build web

clean: ## Remove build artifacts.
	fvm flutter clean

analyze: ## Analyze the project's source code for possible errors.
	fvm flutter analyze

format: ## Format all dart files. Pass CHECK=true to exit if not formatted.
	@if [ "$(CHECK)" = "true" ]; then \
		echo "Checking for formatting issues..."; \
		fvm dart format --output=none --set-exit-if-changed .; \
	else \
		echo "Formatting all .dart files..."; \
		fvm dart format .; \
	fi

l10n:  ## Generate localization files.
	fvm flutter gen-l10n

help: ## Show this help message.
	@echo "Sudokode Flutter Project Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'