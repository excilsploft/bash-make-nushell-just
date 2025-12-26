
URLS := "https://www.githubstatus.com/api/v2/summary.json" \
"https://status.npmjs.org/api/v2/summary.json" \
"https://status.python.org/api/v2/summary.json"

default: getstatus

.PHONY: getstatus
getstatus:
	@for url in $(URLS); do \
		STATUS=$$(curl -skL "$$url" | jq -r '.status.description' ); \
		echo "$${url} Status $$STATUS" ; \
		if [[ "$$STATUS" != "All Systems Operational" ]] ; then \
			echo "$${url}" Status "$${STATUS}"; \
			exit 1; \
		fi ;\
	done



.PHONY: help
help:
	@grep -oE '^([a-zA-Z\.\-]+):+' Makefile | awk '/^[^.PHONY:]/ { gsub(/:/, " "); print $1}' | sort

