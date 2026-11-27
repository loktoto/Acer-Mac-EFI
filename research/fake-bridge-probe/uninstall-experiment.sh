#!/bin/bash
# Rollback for install-experiment.sh. Removes the launchd override and restores
# Apple's original job. Does not touch SIP or authenticated-root settings.
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "run as root" >&2; exit 1; }
PLIST=/Library/LaunchDaemons/com.acerfakebridge.biometrickitd.plist
STATE="/Library/Application Support/AcerFakeBridge"
launchctl bootout system/com.acerfakebridge.biometrickitd 2>/dev/null || true
rm -f "$PLIST"
launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.biometrickitd.plist 2>/dev/null || true
rm -rf "$STATE"
echo "removed fake bridge; original biometrickitd restored"
