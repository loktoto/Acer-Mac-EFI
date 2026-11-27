#!/bin/bash
# Run after locking/unlocking the screen to see whether the hook was reached.
L=/private/tmp/acerfp-icon-hook.log
echo "=== hook log ==="
if [ -f "$L" ]; then tail -40 "$L"; else echo "(no hook log - hooked agent was not started)"; fi
echo "=== forced keys seen ==="
grep -E "forced |MGCopyMultipleAnswers" "$L" 2>/dev/null | tail -25 || true
echo "=== agent state ==="
launchctl print gui/$(id -u)/com.apple.LocalAuthentication.UIAgent 2>&1 | grep -E "state =|program =|active count" | head -4
