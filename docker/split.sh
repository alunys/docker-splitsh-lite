#!/bin/sh
#
# This script automates the creation and updating of a subtree split in a second repository.
#
set -eu

# Manage ssh key
DEPLOY_KEY="/root/.ssh/deploy_key"

if [ -n "${SSH_KEYSCAN_HOST:-""}" ]; then
  ssh-keyscan "$SSH_KEYSCAN_HOST" > /root/.ssh/known_hosts
fi

if [ -n "${SSH_KEY:-""}" ]; then
    echo "$SSH_KEY" >> $DEPLOY_KEY
    chmod 0600 $DEPLOY_KEY
fi

if [ -f "$DEPLOY_KEY" ]; then
    eval "$(ssh-agent -s)"
    ssh-add $DEPLOY_KEY
fi

command -v splitsh-lite >/dev/null 2>&1 || { echo "$0 requires splitsh-lite but it's not installed.  Aborting." >&2; exit 1; }

# Adjust for your repositories.
VAR_SOURCE_REPOSITORY=${SOURCE_REPOSITORY}
VAR_SOURCE_BRANCH=${SOURCE_BRANCH}
VAR_SOURCE_SPLIT_DIR=${SOURCE_SPLIT_DIR}

VAR_DESTINATION_REPOSITORY=${DESTINATION_REPOSITORY}
VAR_DESTINATION_BRANCH=${DESTINATION_BRANCH:-$SOURCE_BRANCH}

TEMP_REPO=$(mktemp -d)
TEMP_BRANCH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
echo "TEMP_BRANCH: $TEMP_BRANCH"

# Checkout the old repository, make it safe and checkout a temp branch
git clone "$VAR_SOURCE_REPOSITORY" "$TEMP_REPO"
cd "$TEMP_REPO"
git checkout "$VAR_SOURCE_BRANCH"
git remote remove origin
git checkout -b "$TEMP_BRANCH"

# Create the split, check it out and then force push the temp branch up
SHA1=$(splitsh-lite --prefix="$VAR_SOURCE_SPLIT_DIR" --quiet)
git reset --hard "$SHA1"
git remote add remote "$VAR_DESTINATION_REPOSITORY"
git push --force --set-upstream remote "$TEMP_BRANCH":"$VAR_DESTINATION_BRANCH"

# Cleanup
rm -rf "$TEMP_REPO"
