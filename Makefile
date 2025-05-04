CODE = src
REQUIREMENTS = requirements.txt
SECRETS_BASELINE = .secrets.baseline


# Format code with Black.
format:
	@poetry run black $(CODE)

# Export the requirements with no environment markers.
$(REQUIREMENTS):
	@poetry export --without-hashes -f $(REQUIREMENTS) --output $(REQUIREMENTS)
	@sed -i '' 's/;.*//' $(REQUIREMENTS)

# Run pre-commit hooks.
pre-commit:
	@poetry run pre-commit run --all-files


## Secrets

# Create a baseline of secrets for the project.
$(SECRETS_BASELINE):
	@poetry run detect-secrets scan > $(SECRETS_BASELINE)

# Check for secrets against the baseline.
secrets:
	@poetry run detect-secrets scan --baseline $(SECRETS_BASELINE)


## Lint

# Scan code for security issues, ignoring virtual environments.
bandit:
	@poetry run bandit -r $(CODE) -x "**/.venv/**,**/.venv.bak/**"

# Check code for formatting issues.
black:
	@poetry run black $(CODE) --check

# Lint code with pylint and perflint, for performance.
pylint:
	@poetry run pylint $(CODE) --load-plugins perflint

# Lint code with ruff to check for unused imports, etc.
ruff:
	@poetry run ruff check $(CODE)

# Lint code with all linters.
lint: black pylint ruff bandit scan


.PHONY: format pylint lint ruff black bandit scan pre-commit
