#!/usr/bin/env bash

set -euo pipefail

# Let's use a Bash 4+ feature, declare and populate an associative array
declare -A URLS
URLS=(Github "https://www.githubstatus.com/api/v2/summary.json"
      NPM "https://status.npmjs.org/api/v2/summary.json"
      PyPi "https://status.python.org/api/v2/summary.json")

 # Let's iterate the associative array, query the summary json urls with cURL and then use Bash to extract the status.description key
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

    # Bash parameter expansion based extraction of the description
    STATUS=$(echo ${RESPONSE#*\"status\":\{}})
    STATUS_CLEAN=$(echo ${STATUS%%\}*})
    DESCRIPTION_QUOTED=$(echo ${STATUS_CLEAN#*\"description\":\"})
    DESCRIPTION=$(echo ${DESCRIPTION_QUOTED%%\"})

    # sed extraction, commented out but left as another approach
    #DESCRIPTION=$(echo "$RESPONSE" | sed 's/.*"description":"\(.*\)"}}$/\1/')

    printf "%s Status: %s\n" "$SERVICE" "$DESCRIPTION"

done
