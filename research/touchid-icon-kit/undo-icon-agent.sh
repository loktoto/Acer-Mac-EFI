#!/bin/bash
# Restore the original com.apple.LocalAuthentication.UIAgent launchd job.
set -u
HERE=$(cd "$(dirname "$0")" && pwd -P)
UID_N=$(id -u)
LABEL=com.apple.LocalAuthentication.UIAgent
SYS=/System/Library/LaunchAgents/$LABEL.plist
DST="$HOME/Library/LaunchAgents/$LABEL.plist"
BAK="$HOME/Library/LaunchAgents/$LABEL.plist.acerfp-bak"
echo "=== undo icon agent ==="
launchctl bootout gui/$UID_N/$LABEL 2>&1 || true
/bin/rm -f "$DST"
if [ -f "$BAK" ]; then mv "$BAK" "$DST" && echo "restored previous user plist"; fi
launchctl bootstrap gui/$UID_N "$SYS" 2>&1 || echo "bootstrap system job returned $?"
sleep 1
launchctl print gui/$UID_N/$LABEL 2>&1 | grep -E "state =|program =" | head -3
echo "original UI agent restored"
