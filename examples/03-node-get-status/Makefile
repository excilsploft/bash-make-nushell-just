exes := node npm
status := $(foreach exe, $(exes), $(if $(shell which $(exe)), "Found $(exe)\n", $(error "No $(exe) in Path") ))

package := $(wildcard package*.json)

default: run

# A Phony target for printing the node version and what the package dependencies are
.PHONY: nodestatus
nodestatus:
	@node --version
	@npm --version	
	@echo $(package)

# A target for installing and updating the scripts dependencies based on package.json and package-lock.json changes
node_modules: $(package)
	@echo installing deps
	npm ci

# A Phony target for running the script
.PHONY: run
run: node_modules
	@echo running script
	@npm run getstatus

# A Phony target for removing the node_modules directory
.PHONY: clean
clean:
	-rm -rf ./node_modules

# A Phony target for printing this Makefile's targets
.PHONY: help
help: $(MAKEFILE_LIST)
	@grep -oE '^([a-zA-Z\.\-]+):+' $< | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort

