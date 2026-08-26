# Cursor run setup (template)

Use these files when **this repo is the active workspace** (recommended for the local Kimi loop).

## 1. Run Mode

Settings → Cursor Settings → Agents → **Approvals & Execution**

| Goal | Mode |
|------|------|
| Fewest prompts (overnight loop) | **Run Everything** |
| Safer default | **Auto-review** + files below |

## 2. Files in this folder

| File | Purpose |
|------|---------|
| [`sandbox.json`](sandbox.json) | Allow GitHub network for `git fetch` / `git push` inside the sandbox |
| [`permissions.json`](permissions.json) | Pre-approve git/python/watcher commands; steer Auto-review classifier |

Merge with `~/.cursor/*.json` if present (repo settings take priority for sandbox paths).

## 3. Optional: read other local projects

If threads mention `@local: ~/projects/...`, add paths under `additionalReadonlyPaths` in your **user** `~/.cursor/sandbox.json` (machine-specific).

## 4. Kimi symmetry

Kimi Code: use `/auto` for fully unattended tool runs during the same loop experiment.
