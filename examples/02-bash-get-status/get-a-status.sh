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

    DESCRIPTION=$(echo "$RESPONSE" | jq -r '(.status.description)')
    INDICATOR=$(echo "$RESPONSE" | jq -r '(.status.indicator)')

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
