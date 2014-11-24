#!/bin/bash

# Copy sites-enabled content if the directory is empty
SITES_ENABLED="/etc/nginx/sites-enabled"
if [ ! "$(ls -A $SITES_ENABLED)" ]; then
    cp -r /sites-enabled/* $SITES_ENABLED
fi

# Start Supervisor
exec supervisord -n

