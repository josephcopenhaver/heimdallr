SHELL:=/bin/bash

LATEST_BASE_IMAGE_COMMAND:=docker images -f reference=heimdallr:base -q
LATEST_BASE_IMAGE:=$(shell ${LATEST_BASE_IMAGE_COMMAND})

LATEST_DEV_IMAGE_COMMAND:=docker images -f reference=heimdallr:latest -q
LATEST_DEV_IMAGE:=$(shell ${LATEST_DEV_IMAGE_COMMAND})


.PHONY: all
all: build-base build dev

.PHONY: clean-tmp
clean-tmp:
	rm -rf tmp

.PHONY: build-base
build-base: clean-tmp
	mkdir tmp
	cp dockerfiles/Dockerfile.base tmp/Dockerfile
	cd tmp && docker build -t heimdallr:base .
	[ "$(LATEST_BASE_IMAGE)" == "$$(${LATEST_BASE_IMAGE_COMMAND})" ] || \
	  docker rmi $(LATEST_BASE_IMAGE) || \
	  true

.PHONY: build
build:
	docker build -t heimdallr:latest .
	[ "$(LATEST_DEV_IMAGE)" == "$$(${LATEST_DEV_IMAGE_COMMAND})" ] || \
	  docker rmi $(LATEST_DEV_IMAGE) || \
	  true

.PHONY: dev
dev:
	docker run --rm -it \
	  -e "GITHUB_TOKEN=$$GITHUB_TOKEN" \
	  -v "$$(pwd)/src:/opt/service" \
	  heimdallr:latest \
	  bash $$(test ! -f .bashrc || printf '%s' '--init-file .bashrc')
