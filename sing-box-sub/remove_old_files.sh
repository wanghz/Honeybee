#!/bin/bash

# Validate if $1 is a positive number days
[[ $1 != +([[:digit:]]) ]] &&
   echo "$1: The script has to be run with positive number argument" && exit 1

# Get the X days ago timestamp
X_DAYS_AGO_TIMESTAMP=$(date -d "$1 days ago" +%s)

# Iterate over all files in the repository
for file in $(git ls-files); do
  echo -n "."
  # Get the timestamp of the last commit that modified this file
  LAST_MODIFIED_TIMESTAMP=$(git log -1 --format="%at" -- "$file")
  # If the file hasn't been modified within the last $1 days
  if [ "$LAST_MODIFIED_TIMESTAMP" -lt "$X_DAYS_AGO_TIMESTAMP" ]; then
    # Remove the file from the repository
    echo -e "\nRemoving $file last modified at $(date -d "@$LAST_MODIFIED_TIMESTAMP")"
    git rm --quiet "$file"
  fi
done

# Commit the changes (if any)
if ! git diff --exit-code --quiet --staged; then
  git commit -m "Remove files not modified within the last $1 days"
else
  echo "No files removed"
fi
