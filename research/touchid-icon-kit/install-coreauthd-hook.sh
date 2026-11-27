#!/bin/bash
# OPTIONAL advanced step: override system coreauthd with a hooked copy.
# Requires: SIP off AND sudo. Do this ONLY after the UI-agent step has been
# tested and you are willing to reboot to recover if auth misbehaves.
set -u
HERE=$(cd "$(dirname "$0")" && pwd -P)
LABEL=com.apple.CoreAuthentication.daemon
SYS=/System/Library/LaunchDaemons/$LABEL.plist
DST=/Library/LaunchDaemons/$LABEL.plist
BAK=/Library/LaunchDaemons/$LABEL.plist.acerfp-bak
HOOK="$HERE/libicon-hook.dylib"
BIN="$HERE/daemon/coreauthd"
echo "=== coreauthd hook installer (ADVANCED) ==="
[ "$(id -u)" -eq 0 ] || { echo "run with sudo"; exit 1; }
csrutil status 2>/dev/null | grep -q enabled && { echo "SIP enabled - abort"; exit 2; }
[ -x "$BIN" ] && [ -f "$HOOK" ] || { echo "missing files"; exit 1; }
/bin/cp "$SYS" "$HERE/original-coreauthd.plist"
[ -f "$DST" ] && /bin/cp "$DST" "$BAK"
TMP=$(/usr/bin/mktemp /private/tmp/acerfp-coreauthd-plist.XXXXXX)
/usr/bin/python3 "$HERE/make-coreauthd-plist.py" "$SYS" "$BIN" "$HOOK" "$TMP" || exit 1
/bin/cp "$TMP" "$DST" && /bin/rm -f "$TMP"
plutil -lint "$DST" || exit 1
launchctl bootout system/$LABEL 2>&1 || true
launchctl bootstrap system "$DST" 2>&1 || { echo "bootstrap failed - run undo"; exit 1; }
sleep 2
launchctl print system/$LABEL 2>&1 | grep -E "state =|program =|active count" | head -4
echo "coreauthd hook installed. Undo: sudo bash $HERE/undo-coreauthd-hook.sh"
