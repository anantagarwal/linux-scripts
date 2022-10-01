#!/bin/bash

DONT_IGNORE_ERRORS=true
URL=https://httpstat.us/200
FILE_PATH=data/data.json

HTTP_CODE=$(curl --retry 3 --retry-all-errors --retry-delay 5 --max-time 15 --fail -sSL -w '%{http_code}' -o $FILE_PATH $URL )

if [[ "$HTTP_CODE" =~ ^2 ]]; then
    # Server returned 2xx response
    # do_something_with data.json
    cat data/data.json | base64 > data/data.base64
    echo "SUCCESS: server[$URL] returned HTTP[$HTTP_CODE]"    
elif [[ "$DONT_IGNORE_ERRORS" = false ]]; then
    # Server returned error
    touch data/data.base64
    echo "WARNING: server[$URL] returned HTTP[$HTTP_CODE], ignoring the failure since DONT_IGNORE_ERRORS is set to $DONT_IGNORE_ERRORS"
else
    # Server returned error
    echo "ERROR: server[$URL] returned HTTP[$HTTP_CODE]"
    exit 1
fi