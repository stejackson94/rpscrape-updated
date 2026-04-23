help: ## Show available Make targets
	@grep -E '^[a-zA-Z0-9_-]+:.*## ' Makefile | sed 's/:.*## /: /'

setup: ## Set up development environment
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "uv is not installed. Install from https://docs.astral.sh/uv/"; \
		exit 1; \
	fi
	@$(MAKE) install-dev
	@$(MAKE) setup-hooks
	@echo "Environment setup complete."

install-dev: ## Install project and dev dependencies
	uv sync --extra dev

setup-hooks: ## Install pre-commit hooks (pre-commit + commit-msg)
	uv run pre-commit install
	uv run pre-commit install --hook-type commit-msg

check: ## Run lockfile, lint, and formatting checks
	uv lock --locked
	uv run pre-commit run --all-files

format: ## Format code with ruff
	uv run ruff format .

lint: ## Lint and apply safe fixes with ruff
	uv run ruff check . --fix

run-rpscrape: ## Show rpscrape CLI help
	cd scripts && uv run python rpscrape.py -h

run-racecards: ## Show racecards CLI help
	cd scripts && uv run python racecards.py --help
