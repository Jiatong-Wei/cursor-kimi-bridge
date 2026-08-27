#!/usr/bin/env bash
# Single poll: fetch origin/main; on new kimi: commit emit AGENT_LOOP_WAKE and exit 0.
# Designed for shell-exit wake (see scripts/arm-kimi-watcher.sh).
#
# Exit codes:
#   0 — kimi: commit detected; wake emitted; caller should stop polling
#   2 — idle (no new commit, or new commit not kimi:, already recorded)
#   1 — git fetch failed
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT_FILE="$REPO_ROOT/.cursor/kimi-bridge-loop-prompt.md"
LAST_SEEN_FILE="$REPO_ROOT/.cursor/last-seen-remote-sha"
LOG_FILE="$REPO_ROOT/.cursor/watcher.log"

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
cd "$REPO_ROOT"

if ! git fetch origin main --quiet 2>>"$LOG_FILE"; then
  log "git fetch failed"
  exit 1
fi

new_sha="$(git rev-parse origin/main 2>/dev/null || true)"
if [[ -z "$new_sha" ]]; then
  log "origin/main unresolved after fetch"
  exit 1
fi

if [[ ! -f "$LAST_SEEN_FILE" ]]; then
  echo "$new_sha" > "$LAST_SEEN_FILE"
  log "initialized last-seen=$new_sha"
  exit 2
fi

last_seen="$(cat "$LAST_SEEN_FILE")"
if [[ "$new_sha" == "$last_seen" ]]; then
  exit 2
fi

subject="$(git log -1 --format=%s "$new_sha")"
echo "$new_sha" > "$LAST_SEEN_FILE"
log "new commit $new_sha subject=$subject"

# 2026-08-27 起唤醒前缀扩为 kimi:/zcode:（ZCode 接任主导，见 threads/open/004）
if [[ "$subject" =~ ^([Kk]imi|[Zz]code): ]]; then
  log "emitting AGENT_LOOP_WAKE; exiting 0 for harness completion notify"
  emit_wake "$new_sha" "$subject"
  exit 0
fi

log "processed silently (non-kimi prefix)"
exit 2
