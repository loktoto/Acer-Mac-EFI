#!/bin/bash
# Replace biometrickitd's launchd job with an injected copy, then leave it
# running for a short experiment. Run this in Terminal (it asks for sudo there).
#
#   sudo bash override-install.sh
#
# Rollback:
#   sudo bash override-undo.sh
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd -P)

state="/Library/Application Support/AcerFakeBridge"
plist=/Library/LaunchDaemons/com.acerfakebridge.biometrickitd.plist
system_plist=/System/Library/LaunchDaemons/com.apple.biometrickitd.plist
label=com.apple.biometrickitd
log=/private/tmp/acerfp-override.log

: > "$log"
exec > >(tee -a "$log") 2>&1
echo "=== $(date) install ==="
id

mkdir -p "$state"
cp "$HERE/../biometrickitd-copy/biometrickitd" "$state/biometrickitd"
cp "$HERE/libfake-bridge.dylib" "$state/libfake-bridge.dylib"
chmod 755 "$state/biometrickitd"
chmod 644 "$state/libfake-bridge.dylib"
chown root:wheel "$state" "$state/biometrickitd" "$state/libfake-bridge.dylib"
codesign --force --sign - "$state/biometrickitd" 2>&1 || true

cat > "$state/biometrickitd-wrapper" <<WRAP
#!/bin/bash
exec /usr/bin/env DYLD_INSERT_LIBRARIES="$state/libfake-bridge.dylib" \\
    "$state/biometrickitd" "\$@"
WRAP
chmod 755 "$state/biometrickitd-wrapper"
chown root:wheel "$state/biometrickitd-wrapper"

cat > "$plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.apple.biometrickitd</string>
  <key>MachServices</key><dict><key>com.apple.biometrickitd</key><true/></dict>
  <key>ProgramArguments</key>
  <array>
    <string>/Library/Application Support/AcerFakeBridge/biometrickitd-wrapper</string>
    <string>--launchd</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>EnableTransactions</key><true/>
  <key>POSIXSpawnType</key><string>Interactive</string>
  <key>StandardOutPath</key><string>/private/tmp/acerfp-daemon-stdout.log</string>
  <key>StandardErrorPath</key><string>/private/tmp/acerfp-daemon-stderr.log</string>
</dict>
</plist>
PLIST
chmod 644 "$plist"
chown root:wheel "$plist"

echo "--- bootout original ---"
launchctl bootout "system/$label" 2>&1 || true
echo "--- bootstrap injected copy ---"
launchctl bootstrap system "$plist" 2>&1 || true
sleep 3
echo "--- state ---"
launchctl print "system/$label" 2>&1 | head -20 || true
echo "--- processes ---"
pgrep -lf biometrickitd 2>&1 || true
echo "--- fake bridge log ---"
tail -20 /private/tmp/acerfp-fake-bridge.log 2>/dev/null || true
echo "install finished"
