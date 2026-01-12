#!/bin/bash

APP_VERSION="v0.1.1"

DATE=$(date -u)

echo "Running generate.sh ($APP_VERSION) at $DATE ..."

BUILD_ANYWAY=0
SKIP_COMMIT=0
if [[ "$1" == "-f" ]]; then
	BUILD_ANYWAY=1
elif [[ "$1" == "-s" ]]; then
	SKIP_COMMIT=1
fi
if [[ "$2" == "-f" ]]; then
	BUILD_ANYWAY=1
fi

# Pull changes from GitHub repo.
git remote set-url origin https://$GITHUB_TOKEN@github.com/zputrle/s2ofGo.git
git pull origin

# Last commit to the SRC_URL.
SRC_URL=https://go.googlesource.com/website
LAST_COMMIT=$(git ls-remote $SRC_URL master | awk '{print $1;}')

# Last commit from which README.md was generated.
LAST_GEN_COMMIT=$(curl -s https://raw.githubusercontent.com/zputrle/s2ofGo/refs/heads/main/last_commit.txt)

echo "last commit: $LAST_COMMIT"
echo "last generated: $LAST_GEN_COMMIT"

if [[ "$LAST_GEN_COMMIT" != "$LAST_COMMIT" ||
	  "$BUILD_ANYWAY" -eq 1 ]]; then

	# Generate README.md only if a new commit was pushed to $SRC_URL.

	# Generate
	echo "Generating README.md ..."

	set -x

	rm -rf tour/
	#git clone https://go.googlesource.com/website
	mkdir tour
	cd tour
	wget https://go.googlesource.com/website/+archive/refs/heads/master/_content/tour.tar.gz
	tar xf tour.tar.gz
	cd ..
	go run .

	rm -rf tour/

	set +x

else
	echo "Nothing to do."
fi

# Remember the last commit ID.
echo $LAST_COMMIT > last_commit.txt

# Note the last time the script was run.
echo "$DATE - $APP_VERSION" > last_run.txt

# Commit changes.
if [[ "$SKIP_COMMIT" -eq 1 ]]; then
	echo "Skipping commit."
	exit 0
fi

git add README.md
git add last_commit.txt
git add last_run.txt

git commit -m "Auto-commit by generate.sh"

git push origin
