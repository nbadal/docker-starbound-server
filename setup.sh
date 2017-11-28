#!/bin/bash
set -e
set -x

usermod -o --uid $PUID starbound
groupmod -o --gid $PGID starbound

chown -R starbound:starbound /steam /starbound
chmod -R 775 /steam /starbound

exec sudo -E -u starbound /run.sh
