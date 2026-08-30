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
# `SNAPSHOT_RECORD=1` can't be set from here. Instead we temporarily flip the
# test's `recording` flag on, run (the library writes the fresh PNGs straight
# into `__Snapshots__/` and the run "fails" with a recorded message — expected),
# revert the flip, then run again to verify.
#
# Usage:  Scripts/record-snapshots.sh
# Then:   git diff --stat, eyeball the PNGs, commit.

set -uo pipefail

DEST='platform=iOS Simulator,name=iPhone 17,OS=26.5'
TEST_FILE="Tests/SnapshotTests/WKSnapshotTests.swift"

cd "$(dirname "$0")/../SnapshotTests"

run_tests() {
  xcodebuild test -scheme SnapshotTests-Package -destination "$DEST" \
    -only-testing:SnapshotTests
}

revert() { git checkout -- "$TEST_FILE" 2>/dev/null || true; }
trap revert EXIT

echo "→ Recording (temporarily forcing record mode; the run reports a failure per image — expected)…"
sed -i '' 's|ProcessInfo.processInfo.environment\["SNAPSHOT_RECORD"\] == "1"|true // record|' "$TEST_FILE"

if ! grep -q 'true // record' "$TEST_FILE"; then
  echo "✗ Couldn't flip the record flag — the test's 'recording' line changed shape." >&2
  exit 1
fi

run_tests >/tmp/wk-snapshot-record.log 2>&1 || true
revert

if ! grep -q "Record mode is on" /tmp/wk-snapshot-record.log; then
  echo "✗ No 'Record mode is on' lines — likely a compile error." >&2
  echo "  See /tmp/wk-snapshot-record.log" >&2
  exit 1
fi

echo "→ Verifying against the fresh references…"
if run_tests >/tmp/wk-snapshot-verify.log 2>&1; then
  echo "✓ Snapshot tests green. Review the PNGs (git diff), then commit."
else
  echo "✗ Still failing after recording — see /tmp/wk-snapshot-verify.log" >&2
  exit 1
fi
