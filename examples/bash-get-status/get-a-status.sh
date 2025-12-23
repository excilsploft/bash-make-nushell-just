#!/usr/bin/env bash

declare -A URLS
URLS=(Github "https://www.githubstatus.com/api/v2/summary.json"
      NPM "https://status.npmjs.org/api/v2/summary.json"
      PyPi "https://status.python.org/api/v2/summary.json")

for url in "${!URLS[@]}"
do
    SERVICE="$url"
    SERVICE_URL="${URLS[$url]}"
    RESPONSE=$(curl -skL "$SERVICE_URL")
    if [[ $? -ne 0 ]]
    then
        printf "Error Getting Status from %s\n" "$url"
        break
    fi

    STATUS=$(echo "$RESPONSE" | sed 's/.*"description":"\(.*\)"}}$/\1/')

    printf "%s Status: %s\n" "$SERVICE" "$STATUS"

done
