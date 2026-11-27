#!/bin/bash
# User-domain override of the LocalAuthentication UI agent with a MobileGestalt
# hook that forces every Touch ID / biometry capability answer to true.
# No root, no SIP change, no /System file modified.
set -u
HERE=$(cd "$(dirname "$0")" && pwd -P)
UID_N=$(id -u)
LABEL=com.apple.LocalAuthentication.UIAgent
SYS=/System/Library/LaunchAgents/$LABEL.plist
DST="$HOME/Library/LaunchAgents/$LABEL.plist"
BAK="$HOME/Library/LaunchAgents/$LABEL.plist.acerfp-bak"
AGENT="$HERE/agent/coreautha.bundle/Contents/MacOS/coreautha"
HOOK="$HERE/libicon-hook.dylib"

echo "=== icon agent installer ==="
if csrutil status 2>/dev/null | grep -q enabled; then
  echo "SIP IS ENABLED. macOS will refuse to bootout the system UI agent."
  echo "You must reboot -> Recovery (Cmd-R) -> Terminal -> csrutil disable -> reboot,"
  echo "then run this script again. Nothing has been changed."
  exit 2
fi
[ -x "$AGENT" ] || { echo "missing agent copy"; exit 1; }
[ -f "$HOOK" ] || { echo "missing hook dylib"; exit 1; }
[ -f "$SYS" ] || { echo "missing system plist"; exit 1; }

# Back up any existing user override, then the system plist is recorded too.
if [ -f "$DST" ]; then cp "$DST" "$BAK" && echo "backed up existing plist -> $BAK"; fi
cp "$SYS" "$HERE/original-uiagent.plist"
echo "system plist copied -> $HERE/original-uiagent.plist"

cat > "$DST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>$LABEL</string>
<key>ProgramArguments</key><array><string>$AGENT</string></array>
<key>MachServices</key><dict>
  <key>com.apple.LocalAuthentication.Assertions</key><dict/>
  <key>com.apple.LocalAuthentication.DFR</key><dict/>
  <key>com.apple.LocalAuthentication.UI</key><dict/>
</dict>
<key>LimitLoadToSessionType</key><array><string>Aqua</string><string>LoginWindow</string></array>
<key>POSIXSpawnType</key><string>App</string>
<key>EnableTransactions</key><true/>
<key>EnablePressuredExit</key><true/>
<key>RunAtLoad</key><false/>
<key>EnvironmentVariables</key><dict>
  <key>DYLD_INSERT_LIBRARIES</key><string>$HOOK</string>
  <key>ACERFP_FORCE_GESTALT</key><string>1</string>
</dict>
<key>StandardOutPath</key><string>/private/tmp/acerfp-uiagent.out</string>
<key>StandardErrorPath</key><string>/private/tmp/acerfp-uiagent.err</string>
</dict></plist>
PLIST
plutil -lint "$DST" || exit 1

echo "stopping system UI agent in gui/$UID_N"
launchctl bootout gui/$UID_N/$LABEL 2>&1 || echo "bootout: $? (may already be stopped)"
echo "starting hooked UI agent"
launchctl bootstrap gui/$UID_N "$DST" 2>&1 || { echo "bootstrap FAILED - restoring"; bash "$HERE/undo-icon-agent.sh"; exit 1; }
sleep 2
launchctl print gui/$UID_N/$LABEL 2>&1 | grep -E "state =|program =|active count" | head -4
echo "=== hook log ==="
head -20 /private/tmp/acerfp-icon-hook.log 2>/dev/null
echo "installed. Lock the screen (Ctrl-Cmd-Q) and look for the Touch ID icon."
echo "Then run: bash $HERE/check-icon.sh"
echo "Undo: bash $HERE/undo-icon-agent.sh"
