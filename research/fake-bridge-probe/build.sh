#!/bin/bash
# Build the clean fake-bridge dylib. No admin, no SIP changes.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd -P)
/usr/bin/clang -shared -fPIC -fobjc-arc -O1 -undefined dynamic_lookup \
    "$HERE/fake-bridge.m" -framework Foundation -o "$HERE/libfake-bridge.dylib"
/usr/bin/codesign --force --sign - "$HERE/libfake-bridge.dylib" >/dev/null 2>&1 || true
echo "built $HERE/libfake-bridge.dylib"
