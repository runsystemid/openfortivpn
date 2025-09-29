#!/bin/bash

# Create PPP device if it doesn't exist
if [ ! -c /dev/ppp ]; then
    echo "Creating /dev/ppp device..."
    mknod /dev/ppp c 108 0
fi

# Start openfortivpn
exec openfortivpn -c /etc/openfortivpn/config