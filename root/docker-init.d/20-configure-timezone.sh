#!/bin/bash

if [ "x$TZ" != "x" ]; then
    echo "[+] Configuring timezone ..."

    echo "$TZ" > /etc/timezone
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata
fi
