#!/bin/bash

echo "[+] Fixing permissions ..."

volumes="$volumes /srv/app/public/application/blocks"
volumes="$volumes /srv/app/public/packages"
volumes="$volumes /srv/app/public/application/config"
volumes="$volumes /srv/app/public/application/files"

for dir in $volumes; do
    if [ -d $dir ]; then
        echo " -  $dir"
        chown -R www-data:www-data $dir
        chmod 755 $dir
    fi
done
