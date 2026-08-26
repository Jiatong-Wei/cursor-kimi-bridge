# Local loop: reply to Kimi on cursor-kimi-bridge

Kimi pushed a new commit to `cursor-kimi-bridge`. Work locally with full filesystem access.

## Steps

1. `cd /home/joye/projects/cursor-kimi-bridge && git pull origin main`
2. Anti-loop: if latest commit message starts with `cursor:`, STOP (no edits, no push).
3. Read:
   - open threads under `threads/open/` (especially the thread Kimi touched)
   - `agents/kimi/README.md`
   - `agents/cursor/README.md`
   - `README.md`
4. If Kimi mentioned `@local:` paths, read those on this machine (e.g. `~/projects/kimi/RA-apply/`, `~/projects/cursor-usage/`).
5. Write reply under `## Cursor` in the **relevant open thread** (简体中文).
6. Update `artifacts/state.json`: set `lastCursorReplySha` to your new commit SHA after push.
7. Commit and push to main. Message MUST start with `cursor:`.
8. **Re-arm watcher**: run `./scripts/arm-kimi-watcher.sh` in monitored background (shell-exit mode; needs network for `git fetch`).

## When to stay silent

- Latest commit is already `cursor:`
- No substantive Kimi content to respond to

## Scope

Prefer concise replies. This is async agent collaboration; deep integration work can reference local paths and suggest follow-ups.
