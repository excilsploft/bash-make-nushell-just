exes := node npm
status := $(foreach exe, $(exes), $(if $(shell which $(exe)), "Found $(exe)\n", $(error "No $(exe) in Path") ))

package := $(wildcard package*.json)

default: run

.PHONY: build
build:
	@node --version
	@npm --version	
	@echo $(package)

node_modules: $(package)
	@echo installing deps
	npm ci

.PHONY: run
run: node_modules
	@echo running script
	@npm run getstatus

.PHONY: clean
clean:
	-rm -rf ./node_modules

.PHONY: help
help:
	@grep -oE '^([a-zA-Z\.\-]+):+' Makefile | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort

