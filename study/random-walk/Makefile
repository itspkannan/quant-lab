.DEFAULT_GOAL := help
PROJECT_DESCRIPTION = "Random Walk - Simulation"
PROJECT_NAME = "random-walk"
VENV = .venv
POETRY = poetry
PIP = pip
POETRY_CONF=$(shell echo $(HOME))
UNAME_S := $(shell uname -s)
PIP_CONF_USER := $(addsuffix /.config/pip/pip.conf,$(HOME))
PIP_CONF_USER_OLD := $(addsuffix /.pip/pip.conf,$(HOME))
PIP_CONF_GLOBAL := $(addsuffix /Library/Application Support/pip/pip.conf,$(HOME))
DOCKERFILE ?= dockerfile
IMAGE_NAME ?= random_walk
AUTHZ_PROFILE ?= authz-v1
DOCKER_NETWORK ?= randomwalk
API_PORT ?= 8080
API_SERVER ?= randomwalk
DOCKER_COMPOSE_PROFILE ?= randomwalk

ifeq ($(UNAME_S),Linux)
	POETRY_AUTH_CONF := $(addsuffix /auth.toml,$(POETRY_HOME))
endif
ifeq ($(UNAME_S),Darwin)
	POETRY_AUTH_CONF := $(addsuffix /auth.toml,$(POETRY_HOME))
endif

.PHONY: help
help:  ## 📖 Help message
	@echo ""
	@echo "\033[1;33mAvailable commands:\033[0m" && \
	awk -F ':.*?## ' '/^[a-zA-Z0-9_.-]+:.*## / { \
		cmds[$$1] = $$2; \
		if (length($$1) > max_len) max_len = length($$1); \
	} \
	END { \
		for (cmd in cmds) { \
			printf "  \033[36m%-" max_len "s\033[0m %s\n", cmd, cmds[cmd]; \
		} \
	}' $(MAKEFILE_LIST) | sort
	@echo ""

.PHONY: init.infra
init.infra: ## 🌐 Create the infrastructure
	@docker network create $(DOCKER_NETWORK) || true

.PHONY: init.python
init.python: ## 🧰 Initialize the Poetry development environment
	@echo "[Info] $(PROJECT_DESCRIPTION) Initialization of development Environment - Started"
	$(eval PYTHON_VERSION=$(shell pyenv versions --bare --skip-aliases --skip-envs | grep 3.12 | sort | tail -1))
	@echo "Python Version : $(PYTHON_VERSION)"
	@pyenv local $(PYTHON_VERSION)
	@$(POETRY) config virtualenvs.in-project true && \
		$(POETRY) config installer.max-workers 10 && \
		$(POETRY) run pip install  --upgrade pip setuptools wheel && \
		$(POETRY) install --no-root
	@echo "[Info] $(PROJECT_DESCRIPTION) Initialization of development Environment - Completed"

.PHONY: build
build: build.python build.docker ## 🏗️ Build Python and Rego policies

.PHONY: build.docker
build.docker: ## 🐳 Build application docker image
	@docker build -f dockerfile -t "$(IMAGE_NAME):latest" .

.PHONY: build.python
build.python: ## 🐍 Build python source
	@poetry build

.PHONY: clean
clean: clean.infra ## 🧹 Cleanup temporary files created
	@rm -rf dist

.PHONY: clean.infra
clean.infra: ## 🧼 Cleanup the infrastructure
	@docker network remove $(DOCKER_NETWORK) || true

.PHONY: clean.python
clean.python: ## 🧽 Cleanup the development environment temporary files
	@find . \( \
		-name "__pycache__" -o \
		-name "*.pyc" -o \
		-name "*.pyo" -o \
		-name ".DS_Store" -o \
		-name ".mypy_cache" -o \
		-name ".pytest_cache" -o \
		-name ".coverage" -o \
		-name "coverage.xml" -o \
		-name "htmlcov" -o \
		-name "test-results" \
	\) -exec rm -rf {} +
	@rm -rf build/ .tox

.PHONY: format.python
format.python:  ## 🎨 Format code using Ruff (Black-compatible)
	@poetry run ruff format .

.PHONY: lint.python
lint.python:   ## 🔍 Run static analysis with Ruff and Mypy
	@poetry run ruff check .
	@poetry run mypy random_walk

.PHONY: test.python
test.python:  ## ✅ Run tests with Pytest and show coverage
	@echo "[INFO] Started unit test of python code"
	@poetry run pytest
	@echo "[INFO] Completed unit test of python code"

.PHONY: start.app
start.app: ## 🚀 Start App
	@DOCKER_NETWORK=$(DOCKER_NETWORK) docker compose --profile $(DOCKER_COMPOSE_PROFILE) up -d

.PHONY: stop.app
stop.app: ## 🛑 Stop App
	@DOCKER_NETWORK=$(DOCKER_NETWORK) docker compose --profile $(DOCKER_COMPOSE_PROFILE) down -v

.PHONY: logs.app
logs.app: ## 📜 View application logs
	@DOCKER_NETWORK=$(DOCKER_NETWORK) docker compose --profile $(DOCKER_COMPOSE_PROFILE) logs
