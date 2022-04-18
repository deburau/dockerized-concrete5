#!/bin/bash
set -e

echo "[+] Starting apache2-foreground ..."

set -x
exec /usr/local/bin/apache2-foreground
