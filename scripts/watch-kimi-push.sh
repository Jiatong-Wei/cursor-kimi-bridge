#!/usr/bin/env bash
# Poll origin/main for new kimi: commits and wake local Cursor via AGENT_LOOP_WAKE sentinel.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT_FILE="$REPO_ROOT/.cursor/kimi-bridge-loop-prompt.md"
LAST_SEEN_FILE="$REPO_ROOT/.cursor/last-seen-remote-sha"
LOG_FILE="$REPO_ROOT/.cursor/watcher.log"
INTERVAL="${WATCH_INTERVAL_SEC:-120}"

log() {
  echo "[$(date -Iseconds)] $*" >> "$LOG_FILE"
}

emit_wake() {
  local sha="$1"
  local subject="$2"
  python3 - "$sha" "$subject" "$PROMPT_FILE" <<'PY'
import json, sys, pathlib
sha, subject, prompt_path = sys.argv[1], sys.argv[2], sys.argv[3]
prompt = pathlib.Path(prompt_path).read_text(encoding="utf-8")
payload = json.dumps({"prompt": prompt, "sha": sha, "subject": subject}, ensure_ascii=False)
print(f"AGENT_LOOP_WAKE_kimi_bridge {payload}")
PY
}

mkdir -p "$REPO_ROOT/.cursor"
log "watcher started pid=$$ interval=${INTERVAL}s"

while true; do
  sleep "$INTERVAL"
  cd "$REPO_ROOT"
  if ! git fetch origin main --quiet 2>>"$LOG_FILE"; then
    log "git fetch failed"
    continue
  fi

  new_sha="$(git rev-parse origin/main 2>/dev/null || true)"
  [[ -z "$new_sha" ]] && continue

  if [[ ! -f "$LAST_SEEN_FILE" ]]; then
    echo "$new_sha" > "$LAST_SEEN_FILE"
    log "initialized last-seen=$new_sha"
    continue
  fi

  last_seen="$(cat "$LAST_SEEN_FILE")"
  [[ "$new_sha" == "$last_seen" ]] && continue

  subject="$(git log -1 --format=%s "$new_sha")"
  echo "$new_sha" > "$LAST_SEEN_FILE"
  log "new commit $new_sha subject=$subject"

  if [[ "$subject" =~ ^[Kk]imi: ]]; then
    log "emitting AGENT_LOOP_WAKE"
    emit_wake "$new_sha" "$subject"
  fi
done
