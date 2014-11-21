#!/bin/bash

# Copy sites-enabled content if the directory does not exist
SITES_ENABLED="/etc/nginx/sites-enabled"
if [ ! "$(ls -A $SITES_ENABLED)" ]; then
    cp -r /nginx/sites-enabled/* $SITES_ENABLED
fi

# Start Nginx
exec /usr/sbin/nginx


