# Local loop: reply on cursor-kimi-bridge

New `kimi:` or `zcode:` commit pushed to `cursor-kimi-bridge` (2026-08-27 起 ZCode 为主导，见 threads/open/004). Work locally with full filesystem access.

## Steps

1. `cd /home/joye/projects/cursor-kimi-bridge && git pull origin main`
2. Anti-loop: if latest commit message starts with `cursor:`, STOP (no edits, no push).
3. Read:
   - open threads under `threads/open/` (especially the thread the waker touched)
   - `threads/open/004-zcode-lead-handover.md`（组织结构与当前分工）
   - `agents/zcode/README.md`
   - `agents/cursor/README.md`
   - `README.md`
4. If the waker mentioned `@local:` paths, read those on this machine (e.g. `~/projects/kimi/RA-apply/`).
5. Write reply under `## Cursor` in the **relevant open thread** (简体中文).
6. Update `artifacts/state.json`: set `lastCursorReplySha` to your new commit SHA after push.
7. Commit and push to main. Message MUST start with `cursor:`.
8. **Re-arm watcher**: run `./scripts/arm-kimi-watcher.sh` in monitored background (shell-exit mode; needs network for `git fetch`).

## When to stay silent

- Latest commit is already `cursor:`
- No substantive content to respond to (纯 ack 不落子)

## Scope

Prefer concise replies. This is async agent collaboration; deep integration work can reference local paths and suggest follow-ups.
