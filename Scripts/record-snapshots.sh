#!/usr/bin/env bash
#
# Regenerate the committed snapshot references in
# SnapshotTests/Tests/SnapshotTests/__Snapshots__/ after an intentional visual
# change.
#
# The snapshot tests live in their own nested package (SnapshotTests/) so the
# `swift-snapshot-testing` dependency never reaches a consumer of UIWorkouts.
#
# `xcodebuild` does not forward shell env vars into the simulator test runner, so
# `SNAPSHOT_RECORD=1` alone is a no-op there. Instead we run the tests once (they
# fail on the diff, expected), then copy the freshly-rendered PNGs the library
# leaves in the simulator's tmp dir over the references. Needs a booted
# "iPhone 17" simulator that stays up after the run — run from a machine with
# Xcode / the Simulator app open.
#
# Usage:  Scripts/record-snapshots.sh
# Then:   git diff --stat, eyeball the PNGs, commit.

set -euo pipefail

DEST='platform=iOS Simulator,name=iPhone 17,OS=26.5'
SNAP_DIR="Tests/SnapshotTests/__Snapshots__/WKSnapshotTests"

cd "$(dirname "$0")/../SnapshotTests"

run_tests() {
  xcodebuild test -scheme SnapshotTests-Package -destination "$DEST" \
    -only-testing:SnapshotTests "$@"
}

echo "→ Running snapshot tests (a diff here is expected)…"
if run_tests >/tmp/wk-snapshot-record.log 2>&1; then
  echo "✓ Snapshots already match the references — nothing to record."
  exit 0
fi

# The simulator that ran the tests is a booted "iPhone 17".
UDID=$(xcrun simctl list devices booted | grep -m1 'iPhone 17' | grep -oE '[0-9A-F-]{36}' || true)
TMP="${UDID:+$HOME/Library/Developer/CoreSimulator/Devices/$UDID/data/tmp/WKSnapshotTests}"

if [[ -z "$UDID" || ! -d "$TMP" ]] || ! compgen -G "$TMP/*.png" >/dev/null; then
  echo "✗ Tests failed but no re-rendered PNGs were found." >&2
  echo "  Either a compile error (see /tmp/wk-snapshot-record.log) or the" >&2
  echo "  simulator shut down before the copy — keep the Simulator app open." >&2
  exit 1
fi

cp "$TMP"/*.png "$SNAP_DIR"/
echo "→ Updated:"
for f in "$TMP"/*.png; do echo "    SnapshotTests/$SNAP_DIR/$(basename "$f")"; done

echo "→ Verifying…"
if run_tests >/tmp/wk-snapshot-verify.log 2>&1; then
  echo "✓ Snapshot tests green. Review the PNGs (git diff), then commit."
else
  echo "✗ Still failing after recording — see /tmp/wk-snapshot-verify.log" >&2
  exit 1
fi
