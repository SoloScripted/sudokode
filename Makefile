# ==============================================================================
# Makefile for Flutter Project
# This Makefile automates common Flutter development tasks, including
# FVM management, dependency fetching, building, analysis, and more.
# It dynamically selects the shell (zsh for macOS, bash for others) for recipes.
# ==============================================================================
FVM_INSTALL_URL := https://fvm.app/install.sh
UNAME_S := $(shell uname -s)
VERSION=$(shell awk '/^version:/ {print $$2}' pubspec.yaml)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(UNAME_S),Darwin)
    # For macOS, use zsh as the shell for Makefile recipes
    SHELL := /bin/zsh
else
    # For other systems (e.g., Linux), default to bash
    SHELL := /bin/bash
endif

# ------------------------------------------------------------------------------
# Makefile Configuration
# ------------------------------------------------------------------------------

# .ONESHELL: This special target ensures that all lines within a single recipe
# are executed by a *single* invocation of the SHELL. Without this, each line
# would run in its own subshell, meaning `cd` or variable assignments wouldn't
# persist across lines. This is crucial for targets like `setup` and `tag`.
.ONESHELL:

# .PHONY: Declares targets that do not correspond to actual files. This ensures
# `make` always executes them, even if a file with the same name exists.
.PHONY: all get run build-web clean analyze format l10n help setup tag

# ------------------------------------------------------------------------------
# Targets
# ------------------------------------------------------------------------------

# Default target, runs when you just type `make`
all: help

# setup: Sets up the Flutter project, installing FVM if necessary and all dependencies.
# This target includes logic to check for FVM, install it if missing, and then
# proceed with `fvm install` and `pub get`.
setup: ## Sets up the project: installs FVM (if needed) and all dependencies.
	@echo "Checking for FVM installation..."
	# Check if fvm command exists in PATH
	@if ! command -v fvm >/dev/null 2>&1; then \
		echo "FVM not found. Attempting to install FVM..."; \
		if command -v curl >/dev/null 2>&1; then \
			echo "Downloading and running FVM installation script..."; \
			curl -fsSL $(FVM_INSTALL_URL) | bash; \
			if [ "$(SHELL)" = "/bin/zsh" ] && [ -f "$$HOME/.zshrc" ]; then \
				source "$$HOME/.zshrc"; \
			elif [ "$(SHELL)" = "/bin/bash" ] && [ -f "$$HOME/.bashrc" ]; then \
				source "$$HOME/.bashrc"; \
			elif [ -f "$$HOME/.profile" ]; then \
				source "$$HOME/.profile"; \
			fi; \
			echo "FVM installation complete. Please restart your terminal or source your shell config if 'fvm' command is still not found."; \
			echo "Proceeding with 'fvm install' now, but future calls might require a new terminal."; \
		else \
			echo "Error: 'curl' command not found. Please install curl or install FVM manually."; \
			echo "See: https://fvm.app/docs/getting_started/installation"; \
			exit 1; \
		fi; \
	fi
	@echo "Installing project-specific Flutter SDK via FVM..."
	# `fvm install` will read .fvm/fvm_config.json if FLUTTER_VERSION is not defined.
	fvm install $(FLUTTER_VERSION)
	# Call the `get` target to fetch dependencies after FVM setup.
	@$(MAKE) get

# get: Get project dependencies. Pass CLEAN_LOCK=true to force a clean get.
get: ## Get project dependencies. Pass CLEAN_LOCK=true to force a clean get.
	@echo "Getting Flutter project dependencies..."
	# Conditional removal of pubspec.lock based on CLEAN_LOCK variable.
	@if [ "$(CLEAN_LOCK)" = "true" ]; then \
		echo "Cleaning pubspec.lock..."; \
		rm -f pubspec.lock; \
	fi
	fvm flutter pub get

# run: Run the app in debug mode.
run: ## Run the app in debug mode.
	fvm flutter run

# build-web: Build the web application.
build-web: ## Build the web application.
	fvm flutter build web

# clean: Remove build artifacts.
clean: ## Remove build artifacts.
	fvm flutter clean

# analyze: Analyze the project's source code for possible errors.
analyze: ## Analyze the project's source code for possible errors.
	fvm flutter analyze

# format: Format all .dart files. Pass CHECK=true to exit if not formatted.
format: ## Format all .dart files. Pass CHECK=true to exit if not formatted.
	@if [ "$(CHECK)" = "true" ]; then \
		echo "Checking for formatting issues..."; \
		fvm dart format --output=none --set-exit-if-changed .; \
	else \
		echo "Formatting all .dart files..."; \
		fvm dart format .; \
	fi

# l10n: Generate localization files.
l10n: ## Generate localization files.
	fvm flutter gen-l10n

# tag: Creates and pushes a git tag from the pubspec.yaml version.
# This target includes checks for the current branch and uncommitted changes.
tag: ## Creates and pushes a git tag from the pubspec.yaml version.
	@if ! git diff-index --quiet HEAD --; then \
		echo "Error: You have uncommitted changes. Please commit or stash them before tagging."; \
		exit 1; \
	fi
	@if [ "$(BRANCH)" != "main" ]; then \
		echo "Error: Tagging is only allowed from the 'main' branch. You are currently on '$(BRANCH)'."; \
		exit 1; \
	fi
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: Could not find version in pubspec.yaml"; \
		exit 1; \
	fi
	@git fetch origin --tags --quiet;
	@if git ls-remote --tags origin | grep -q "refs/tags/v$(VERSION)"; then \
		echo "Error: Tag 'v$(VERSION)' already exists on the remote. Please delete it from the remote if you intend to re-tag."; \
		exit 1; \
	fi
	# Create and push the git tag.
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@git push origin "v$(VERSION)";
	@echo "Successfully tagged and pushed v$(VERSION)."

# help: Show this help message.
help: ## Show this help message.
	@echo "Sudokode Flutter Project Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	# Grep and awk magic to parse targets and their help messages.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
