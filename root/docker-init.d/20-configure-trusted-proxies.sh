#!/bin/bash

if [ "x$TRUSTED_PROXIES" != "x" ]; then
      echo "[+] Configuring trusted-proxies ..."

      for h in $TRUSTED_PROXIES; do
            ip=$(getent hosts $h | cut -d' ' -f1)
            if [ "x$ip" != "x" ]; then
                  ips="$ips '$ip',"
            else
                  echo " -  cannot resolve $h" >&2
            fi
      done

      if [ "x$ips" != "x" ]; then
            f=/srv/app/public/application/config/concrete.php
            echo " -  generating trusted proxies in $f"
            cat <<EOF | tee $f > /dev/null
<?php

return [
    'security' => [
        'trusted_proxies' => [
            'ips' => [
                $ips
            ],
            'headers' => -1,
        ],
    ],
];
EOF
            chown www-data:www-data $f
            chmod 644 $f
      fi
fi
