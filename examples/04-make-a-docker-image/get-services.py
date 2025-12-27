#!/usr/bin/env python

import requests

CONST_URLS = {"Github": "https://www.githubstatus.com/api/v2/summary.json",
              "NPM":  "https://status.npmjs.org/api/v2/summary.json",
              "PyPi": "https://status.python.org/api/v2/summary.json"
             }

for srvc in CONST_URLS:
    data = None
    resp = requests.get(CONST_URLS[srvc])
    if requests.codes.OK:
       data = resp.json()
       print(f"Service {srvc}: {data['status']['description']}")

    else:
        print(f"Servic {srvc} Status gave a non-200 response")
