#!/bin/sh
# vim:sw=4:ts=4:et

set -e

ME=$(basename $0)
DEFAULT_CONF_FILE="etc/nginx/conf.d/default.conf"

if [ ! -f "/$DEFAULT_CONF_FILE" ]; then
    echo >&3 "$ME: info: /$DEFAULT_CONF_FILE is not a file or does not exist"
    exit 0
fi

# check if the file can be modified, e.g. not on a r/o filesystem
touch /$DEFAULT_CONF_FILE 2>/dev/null || { echo >&3 "$ME: info: can not modify /$DEFAULT_CONF_FILE (read-only file system?)"; exit 0; }

# enable ipv6 on default.conf listen sockets
sed -i -E 's,listen       80;,listen       8080;,' /$DEFAULT_CONF_FILE
sed -i 's,listen\(.*\):80;,listen\1:8080;,' /$DEFAULT_CONF_FILE

echo >&3 "$ME: info: Enabled listen on 8080 in /$DEFAULT_CONF_FILE"

exit 0
