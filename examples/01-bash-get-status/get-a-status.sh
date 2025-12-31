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

    # Bash Native extraction of the description
    STATUS=$(echo ${RESPONSE#*\"status\":\{}})
    STATUS_CLEAN=$(echo ${STATUS%%\}*})
    DESCRIPTION_QUOTED=$(echo ${STATUS_CLEAN#*\"description\":\"})
    DESCRIPTION=$(echo ${DESCRIPTION_QUOTED%%\"})



    # sed extraction
    #DESCRIPTION=$(echo "$RESPONSE" | sed 's/.*"description":"\(.*\)"}}$/\1/')

    printf "%s Status: %s\n" "$SERVICE" "$DESCRIPTION"

done
