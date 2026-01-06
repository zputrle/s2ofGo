#!/bin/bash

BUILD_ANYWAY=0

if [[ "$1" == "-f" ]]; then
  BUILD_ANYWAY=1
fi

# Last commit to the SRC_URL.
SRC_URL=https://go.googlesource.com/website
LAST_COMMIT=$(git ls-remote $SRC_URL master | awk '{print $1;}')

# Last commit from which README.md was generated.
LAST_GEN_COMMIT=$(curl -s https://raw.githubusercontent.com/zputrle/s2ofGo/refs/heads/main/last_commit.txt)

echo "last commit: $LAST_COMMIT."
echo "last generated: $LAST_GEN_COMMIT"

if [[ "$LAST_GEN_COMMIT" != "$LAST_COMMIT" ||
	  "$BUILD_ANYWAY" -eq 1 ]]; then
	echo "Generating README.md ..."
	set -x
	rm -rf website/
	git clone https://go.googlesource.com/website
	go run .
else 
	echo "Nothing to do."
fi
