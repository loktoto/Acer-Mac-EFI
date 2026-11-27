#!/bin/bash
# Runs a COPY of biometrickitd as the current user with the fake-bridge dylib.
# No SIP changes, no launchd changes, no interaction with the real daemon.
# Usage: bash run.sh [seconds]
set -eu
HERE=$(cd "$(dirname "$0")" && pwd -P)
WORK=$(mktemp -d /private/tmp/acerfp-bioharness.XXXXXX)
trap 'kill ${PID:-} 2>/dev/null || true; rm -rf "$WORK"' EXIT
cp /usr/libexec/biometrickitd "$WORK/"
codesign --force --sign - "$WORK/biometrickitd" >/dev/null 2>&1
rm -f /private/tmp/acerfp-fake-bridge.log
DYLD_INSERT_LIBRARIES="${FAKE_DYLIB:-$HERE/libfakebridge.dylib}" "$WORK/biometrickitd" >"$WORK/out.log" 2>"$WORK/err.log" &
PID=$!
sleep "${1:-15}"
kill -9 "$PID" 2>/dev/null || true
echo "=== intercepted traffic ==="
cat /private/tmp/acerfp-fake-bridge.log 2>/dev/null || echo "(none)"
echo "=== stderr ==="
head -20 "$WORK/err.log"
