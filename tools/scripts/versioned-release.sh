#!/bin/bash

# Test version argument.
if [ -z "$1" ]; then
  echo "A release version must be supplied (e.g. 7.0.1)."

  exit 1
fi
LIQUIBASE_VERSION=$1

# Get current working dir.
PWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
echo $PWD

# Move to appropriate working dir.
mkdir -p tmp
cd ./tmp

# Prepare a new branch for this update.
git checkout -b versioned-release/liquibase-${1//\./\-}

# Download the requested tagged release.
echo "Downloading Liquibase Release Version $1..."

# curl -L -s https://github.com/googlei18n/libphonenumber/archive/v$1.tar.gz -o v$1.tar.gz
TARBALL_FILE_NAME=liquibase-${LIQUIBASE_VERSION}.tar.gz
wget -O $TARBALL_FILE_NAME "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" || rm $TARBALL_FILE_NAME

# Logic Branch for downloaded tarball.
if [ -f "$TARBALL_FILE_NAME" ]; then
	# If it was downloaded...
	mkdir -p ./liquibase
	tar -xf $TARBALL_FILE_NAME --directory ./liquibase

	# Remove previous Liquibase dir in `/bin`.
	find ../bin -depth 1 ! -iregex '../bin/liquibase/liquibase' | xargs rm -rf
	mkdir -p ../bin/liquibase

	# Copy in the new Liquibase directory
	cp -r ./liquibase ../bin

	# Remove the old Tarball
	rm $TARBALL_FILE_NAME

	rm -rf ./liquibase

	# Update package.json version w/ $LIQUIBASE_VERSION
	# sed ...

	echo "Done!"

	# # Add the modified files to git.
	echo "$PWD/../bin"
	git add $PWD/../bin

	# # Commit with the standard message.
	git commit -m "(release): updated bundled Liquibase to match release v$LIQUIBASE_VERSION"
else
	# If it was NOT downloaded...
	echo "$TARBALL_FILE_NAME was not downloaded. Please ensure that you've supplied a valid version number for a Liquibase release."
fi
