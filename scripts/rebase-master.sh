#!/bin/bash

set -o xtrace

HEAD=$(git rev-parse --abbrev-ref HEAD)
BRANCHES=$(git branch -l | egrep -v -e '(develop|master)' | sed 's/\s*//g')

for BRANCH in $BRANCHES; do
    git rebase master $BRANCH
done

git checkout $HEAD
