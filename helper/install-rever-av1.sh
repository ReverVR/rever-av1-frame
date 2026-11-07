#!/bin/sh
# Rever AV1 (Steam Frame; GPL-2.0-only, source: https://github.com/ReverVR/rever-av1-frame): installed once by the PC's setup assistant, which copies this folder
# to the headset and runs it with the player's password (sudo -S, the password never stored). It puts the helper in
# /etc/rever/av1 and the module's source in /home/.rever-av1 (both root-owned: the player's account cannot change what
# root runs), the sudo rule for the helper's four commands, and builds the module for the running kernel. Undo:
# uninstall-rever-av1.sh.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=/etc/rever/av1
[ "$(id -u)" = "0" ] || { echo "run with sudo" >&2; exit 77; }
[ -f "$HERE/rever-av1" ] && [ -d "$HERE/src" ] && [ -f "$HERE/sudoers.rever-av1" ] || { echo "incomplete bundle" >&2; exit 2; }
visudo -cf "$HERE/sudoers.rever-av1" >/dev/null || { echo "the sudo rule does not parse: nothing installed" >&2; exit 3; }
# the helper (9 KB) in /etc; the module's source and builds in /home/.rever-av1 (on the Frame /etc lives on a 224 MB
# partition)
STATE=/home/.rever-av1
install -d -m 0755 -o root -g root "$ROOT" "$STATE" "$STATE/modules"
rm -rf "$STATE/src"
cp -a "$HERE/src" "$STATE/src"
chown -R root:root "$STATE/src"
chmod -R go-w "$STATE/src"
install -m 0755 -o root -g root "$HERE/rever-av1" "$ROOT/rever-av1"
# zz-: sudo takes the last matching rule and reads sudoers.d in name order - before SteamOS' own "wheel"
# (%wheel ALL=(ALL) ALL, a password) the rule would never apply on a player's Frame
install -m 0440 -o root -g root "$HERE/sudoers.rever-av1" /etc/sudoers.d/zz-rever-av1
# sudo's whole configuration read the way sudo reads it, with the rule in place, and the rule seen: anything wrong
# and it goes at once (sudo never broken). Not "visudo -c": it fails on SteamOS' own sudoers.d/wheel (mode 0644,
# 2026-11-03), which sudo itself accepts
if ! sudo -l -U steamos 2>/dev/null | grep -q "/etc/rever/av1/rever-av1 on"; then
    rm -f /etc/sudoers.d/zz-rever-av1
    echo "sudo did not take the rule: taken away, nothing else changed" >&2
    exit 3
fi
"$ROOT/rever-av1" build
# the check the apps run as the player (rever-av1-check: no root) and the stamp it compares the system with - both in
# /home, which a SteamOS update keeps while it leaves /etc behind (KB AV1D-012)
install -m 0755 -o root -g root "$HERE/rever-av1-check" "$STATE/rever-av1-check"
. /etc/os-release
echo "${VERSION_ID:-?} ${BUILD_ID:-?} $(uname -r)" > "$STATE/installed"
chmod 0644 "$STATE/installed"
echo "Rever AV1 installed: $("$ROOT/rever-av1" status | tr '\n' ';')"
