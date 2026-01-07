SHELL := /usr/bin/env bash
#  Necessary executables
exe := docker
# Check that we have docker in the path and send a nice error in not
status := $(if $(shell which $(exe)), "Found $(exe)\n", $(error "No $(exe) in Path") )

# Variables for image name and tag
imagename := py-get-services
imagetag := 1

# The default target to invoke if one is not provided.
default: dockerrun

# Phony target that allows just the build invocation to build the docker file
.PHONY: build
build: iid_file

# Rebuild the Docker Image if the requirements.txt or the script changes
iid_file: requirements.txt get-services.py
	docker build --iidfile $@ -t  $(imagename):$(imagetag) .

# Run the Docker
dockerrun: iid_file
	@docker run -it --rm --name "py-get-services" $(imagename):$(imagetag)

# Clean up artifacts
.PHONY: clean
clean:
	-rm -f iid_file

# Print the available targets
.PHONY: help
help: $(MAKEFILE_LIST)
	@grep -oE '^([a-zA-Z\.\-_]+):+' $< | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort
