SHELL := bash
# A List of required executables
exes := curl jq
# Iterate the list of required executables and exit if we are missing any in our PATH env variable
status := $(foreach exe, $(exes), $(if $(shell which $(exe)), "Found $(exe)\n", $(error "No $(exe) in Path") ))

# A List of Urls
urls := "https://www.githubstatus.com/api/v2/summary.json" \
"https://status.npmjs.org/api/v2/summary.json" \
"https://status.python.org/api/v2/summary.json"

# The Default target which calls the getstatus target
default: getstatus

# In a Bash loop, get the status responses
.PHONY: getstatus
getstatus:
	@for url in $(urls); do \
		RESPONSE=$$(curl -skL "$$url"); \
		STATUS=$$(echo $$RESPONSE | jq -r '.status.description' ); \
		SERVICE=$$(echo $$RESPONSE | jq -r '.page.name' ); \
		echo "$${SERVICE} Status $$STATUS" ; \
		if [[ "$$STATUS" != "All Systems Operational" ]] ; then \
			echo "$${url}" Status "$${STATUS}"; \
			exit 1; \
		fi ;\
	done

# Get all the statuses by invoking each target
.PHONY: all
all: githubstatus npmstatus pypistatus

# Get the Github Status
.PHONY: githubstatus
githubstatus: 
	@curl -skL $(word 1, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

# Get the NPM Status
.PHONY: npmstatus
npmstatus:
	@curl -skL $(word 2, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

# Get the PyPi Status
.PHONY: pypistatus
pypistatus:
	@curl -skL $(word 3, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

# Print the available targets
.PHONY: help
help: $(MAKEFILE_LIST)
	@grep -oE '^([a-zA-Z\.\-]+):+' $< | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort
