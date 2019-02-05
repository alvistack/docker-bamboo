#!/bin/bash

set -o xtrace

# Ensure required folders exist with correct owner:group
mkdir -p $BAMBOO_HOME
chmod 0755 $BAMBOO_HOME
chown -Rf $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_HOME

# Running Bamboo in foreground
exec /etc/init.d/bamboo start -fg
