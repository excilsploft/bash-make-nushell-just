exes := curl jq 
status := $(foreach exe, $(exes), $(if $(shell which $(exe)), "Found $(exe)\n", $(error "No $(exe) in Path") ))

urls := "https://www.githubstatus.com/api/v2/summary.json" \
"https://status.npmjs.org/api/v2/summary.json" \
"https://status.python.org/api/v2/summary.json"

default: getstatus

.PHONY: getstatus
getstatus:
	@for url in $(urls); do \
		STATUS=$$(curl -skL "$$url" | jq -r '.status.description' ); \
		echo "$${url} Status $$STATUS" ; \
		if [[ "$$STATUS" != "All Systems Operational" ]] ; then \
			echo "$${url}" Status "$${STATUS}"; \
			exit 1; \
		fi ;\
	done

.PHONY: all
all: githubstatus npmstatus pypistatus

.PHONY: githubstatus
githubstatus:
	@curl -skL $(word 1, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

.PHONY: npmstatus
npmstatus:
	@curl -skL $(word 2, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

.PHONY: pypistatus
pypistatus:
	@curl -skL $(word 3, $(urls)) | jq -r '"\(.page.name):\t\(.status.description)"'

.PHONY: help
help:
	@grep -oE '^([a-zA-Z\.\-]+):+' Makefile | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort
