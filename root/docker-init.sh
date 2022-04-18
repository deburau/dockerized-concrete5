#!/bin/bash
set -e

# first arg not empty and is not `-f` or `--some-option`
if [ -n "$1" -a "${1#-}" = "$1" ]; then
  exec "$@"
fi

echo "[+] docker-init.sh for concrete cms"

# Execute all scripts in /docker-init.d/
for file in /docker-init.d/*; do
  if file -b ${file} | fgrep -iq "shell script"; then
    source "${file}" "$@"
  elif [ -x "${file}" ]; then
    "${file}" "$@"
  else
    echo "!!! cannot execute ${file}"
    exit 1
  fi
done
