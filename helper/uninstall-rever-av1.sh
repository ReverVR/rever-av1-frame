#!/bin/sh
# Rever AV1 (Steam Frame): everything install-rever-av1.sh put in place taken away; Valve's driver bound first.
set -u
[ "$(id -u)" = "0" ] || { echo "run with sudo" >&2; exit 77; }
[ -x /etc/rever/av1/rever-av1 ] && /etc/rever/av1/rever-av1 off
rm -f /etc/sudoers.d/zz-rever-av1
rm -rf /etc/rever/av1 /home/.rever-av1 /var/lib/rever-av1
rmdir /etc/rever 2>/dev/null  # only when nothing else of Rever is there
echo "Rever AV1 removed"
