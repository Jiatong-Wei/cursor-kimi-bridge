#!/usr/bin/env bash
# Outer poll loop: run watch-kimi-push.sh every WATCH_INTERVAL_SEC until kimi wake.
# On wake (inner exit 0), this script exits 0 so Cursor monitored-background
# completion notification wakes the agent — primary wake path (stdout sentinel is backup).
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WATCH="$REPO_ROOT/scripts/watch-kimi-push.sh"
LOG_FILE="$REPO_ROOT/.cursor/watcher.log"
INTERVAL="${WATCH_INTERVAL_SEC:-120}"

log() {
  echo "[$(date -Iseconds)] $*" >> "$LOG_FILE"
}

log "arm loop started pid=$$ interval=${INTERVAL}s mode=shell-exit"

while true; do
  set +e
  "$WATCH"
  rc=$?
  set -e

  if [[ "$rc" -eq 0 ]]; then
    log "arm loop exiting after kimi wake (watch exit 0)"
    exit 0
  fi

  if [[ "$rc" -eq 1 ]]; then
    log "poll failed (watch exit 1); retry in ${INTERVAL}s"
  fi

  sleep "$INTERVAL"
done
