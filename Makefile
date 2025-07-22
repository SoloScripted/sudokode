# Makefile for the sudokode Flutter project

.PHONY: all get run build-web clean analyze format l10n help setup

# Default target, runs when you just type `make`
all: help

setup: get l10n ## Setup the project by getting dependencies and generating localizations.

get: ## Get project dependencies. Pass CLEAN=1 to force a clean get.
	@if [ "$(CLEAN)" = "1" ]; then \
		echo "Removing pubspec.lock and regenerating dependencies..."; \
		rm -f pubspec.lock; \
	fi
	flutter pub get

run: ## Run the app in debug mode.
	flutter run

build-web: ## Build the web application.
	flutter build web

clean: ## Remove build artifacts.
	flutter clean

analyze: ## Analyze the project's source code for possible errors.
	flutter analyze

format: ## Format all .dart files in the project.
	dart format .

l10n: ## Generate localization files.
	flutter gen-l10n

help: ## Show this help message.
	@echo "Sudokode Flutter Project Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'