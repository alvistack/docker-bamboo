#!/bin/bash

set -o xtrace

# Running Bamboo in foreground
exec /etc/init.d/bamboo start -fg
