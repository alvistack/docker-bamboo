#!/bin/bash

set -o xtrace

# Prepend executable if command starts with an option
if [ "${1:0:1}" = '-' ]; then
    set -- /opt/atlassian/bamboo/bin/start-bamboo.sh "$@"
fi

# Allow the container to be stated with `--user`
if [ "$1" = '/opt/atlassian/bamboo/bin/start-bamboo.sh' ] && [ "$(id -u)" = '0' ]; then
    mkdir -p $BAMBOO_HOME
    chown $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_HOME
    chmod 0755 $BAMBOO_HOME
    exec gosu $BAMBOO_OWNER "$BASH_SOURCE" "$@"
fi

exec "$@"
