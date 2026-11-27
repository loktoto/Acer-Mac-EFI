#!/bin/bash
set -u
HERE=$(cd "$(dirname "$0")" && pwd -P)
LABEL=com.apple.CoreAuthentication.daemon
SYS=/System/Library/LaunchDaemons/$LABEL.plist
DST=/Library/LaunchDaemons/$LABEL.plist
BAK=/Library/LaunchDaemons/$LABEL.plist.acerfp-bak
[ "$(id -u)" -eq 0 ] || { echo "run with sudo"; exit 1; }
launchctl bootout system/$LABEL 2>&1 || true
/bin/rm -f "$DST"
[ -f "$BAK" ] && { /bin/mv "$BAK" "$DST"; echo "restored prior plist"; }
launchctl bootstrap system "$SYS" 2>&1 || echo "bootstrap returned $?"
sleep 1
launchctl print system/$LABEL 2>&1 | grep -E "state =|program =" | head -2
echo "coreauthd restored"
