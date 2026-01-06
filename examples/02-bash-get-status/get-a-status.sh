#!/usr/bin/env bash

set -euo pipefail

# Let's use a Bash feature, to declare and populate an

URLS=("https://www.githubstatus.com/api/v2/summary.json"
      "https://status.npmjs.org/api/v2/summary.json"
      "https://status.python.org/api/v2/summary.json")

# Let's iterate the associative array, query the summary json urls with cURL and then use jq to extract the page.name , status.indicator, and status.description keys
for url in "${URLS[@]}"
do
    RESPONSE=$(curl -skL "$url")
    if [[ $? -ne 0 ]]
    then
        printf "Error Getting Status from %s\n" "$url"
        break
    fi

    # Get the desired keys from the response
    SERVICE=$(echo "$RESPONSE" | jq -r '.page.name')
    DESCRIPTION=$(echo "$RESPONSE" | jq -r '(.status.description)')
    INDICATOR=$(echo "$RESPONSE" | jq -r '(.status.indicator)')

    # evaluate the Indicator string, match and print
    case "$INDICATOR" in 
        critcal)
            printf "%s Status:\033[31m%s\033[0m\n"  "$SERVICE" "$DESCRIPTION"
            ;;
         major)
            printf "%s Status:\033[36m%s\033[0m\n"  "$SERVICE" "$DESCRIPTION"
            ;;
         minor)
            printf "%s Status:\033[33m%s\033[0m\n"  "$SERVICE" "$DESCRIPTION"
            ;;
            *)
            printf "%s Status:\033[32m%s\033[0m\n"  "$SERVICE" "$DESCRIPTION"
            ;;
    esac

done
