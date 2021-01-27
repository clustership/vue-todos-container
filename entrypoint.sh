#!/bin/sh
# vim:sw=4:ts=4:et

set -e
#export USER_ID=$(id -u)
#export GROUP_ID=$(id -g)

export USER_ID=1000
export GROUP_ID=0

PASSHOME=/home

grep -v ^nginx /etc/passwd > "$PASSHOME/passwd"
echo "nginx:x:${USER_ID}:${GROUP_ID}:nginx user:${PASSHOME}:/bin/bash" >> "$PASSHOME/passwd"

export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=${PASSHOME}/passwd
export NSS_WRAPPER_GROUP=/etc/group

set -x
echo "Going to run: exec /docker-entrypoint.sh \"$@\""
exec /docker-entrypoint.sh "$@"
