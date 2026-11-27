#!/bin/bash
# Rollback override-install.sh. Run with sudo in Terminal.
set -euo pipefail
label=com.apple.biometrickitd
system_plist=/System/Library/LaunchDaemons/com.apple.biometrickitd.plist
echo "=== $(date) rollback ==="
launchctl bootout "system/$label" 2>&1 || true
rm -f /Library/LaunchDaemons/com.acerfakebridge.biometrickitd.plist
launchctl bootstrap system "$system_plist" 2>&1 || true
rm -rf "/Library/Application Support/AcerFakeBridge"
sleep 2
launchctl print "system/$label" 2>&1 | head -10 || true
echo "rollback finished"
