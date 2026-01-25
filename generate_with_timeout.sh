#!/bin/bash

timeout -k 5s 355s ./generate.sh "$@"

if [ $? -eq 124 ]; then
    echo "Command timed out!"
fi
