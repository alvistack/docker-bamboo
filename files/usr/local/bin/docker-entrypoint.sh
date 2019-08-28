#!/bin/bash

set -o xtrace

# Prepend executable if command starts with an option
if [ "${1:0:1}" = '-' ]; then
    set -- /opt/atlassian/bamboo/bin/start-bamboo.sh "$@"
fi

# Ensure required folders exist with correct owner:group
mkdir -p $BAMBOO_HOME
chown -Rf $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_HOME
chmod 0755 $BAMBOO_HOME

exec "$@"
