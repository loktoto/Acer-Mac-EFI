#!/bin/bash
# STAGING ONLY. This script does NOT run anything.
#
# After the user has physically disabled SIP and authenticated-root, this can
# replace com.apple.biometrickitd with a wrapper that injects the fake bridge.
# It needs a reboot first, because SIP changes require Recovery.
#
# Run (only after SIP is off):
#   sudo bash install-experiment.sh
# Rollback:
#   sudo bash uninstall-experiment.sh
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd -P)
[ "$(id -u)" -eq 0 ] || { echo "run as root" >&2; exit 1; }
csrutil status 2>/dev/null | grep -q "disabled" || {
    echo "SIP is still enabled. Do not install." >&2
    exit 1
}

STATE="/Library/Application Support/AcerFakeBridge"
WRAPPER="$STATE/biometrickitd-wrapper"
DYLIB="$STATE/libfake-bridge.dylib"
PLIST=/Library/LaunchDaemons/com.acerfakebridge.biometrickitd.plist
ORIGINAL=/System/Library/LaunchDaemons/com.apple.biometrickitd.plist

mkdir -p "$STATE"
cp "$HERE/libfake-bridge.dylib" "$DYLIB"
chmod 644 "$DYLIB"
chown root:wheel "$DYLIB"

cat > "$WRAPPER" <<SH
#!/bin/bash
exec /usr/bin/env DYLD_INSERT_LIBRARIES="$DYLIB" /usr/libexec/biometrickitd --launchd
SH
chmod 755 "$WRAPPER"
chown root:wheel "$WRAPPER"

# Override launchd's job: same label and MachService, but our wrapper starts it.
cp "$ORIGINAL" "$STATE/original.plist"
/usr/libexec/PlistBuddy -c "Set :ProgramArguments:0 $WRAPPER" "$STATE/original.plist"
# The IOKit LaunchEvents still work; the daemon is started with our wrapper.
cp "$STATE/original.plist" "$PLIST"
chown root:wheel "$PLIST"
chmod 644 "$PLIST"

launchctl bootout system/com.apple.biometrickitd 2>/dev/null || true
launchctl bootstrap system "$PLIST" 2>/dev/null || true
echo "installed; log: /private/tmp/acerfp-fake-bridge.log"
