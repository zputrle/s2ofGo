#!/bin/bash

timeout -k 5s 25s ./generate.sh "$@"

if [ $? -eq 124 ]; then
    echo "Command timed out!"
fi
