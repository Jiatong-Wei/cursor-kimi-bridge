#!/usr/bin/env python3
"""repo-pulse: 从 git log 生成双 Agent 对话 timeline。

Why: 验证「git log 即对话记录」的假设——不维护额外状态文件,
直接从 commit 历史重建 kimi:/cursor: 的往返节奏。
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "artifacts" / "timeline.md"
PAT = re.compile(r"^(kimi|cursor)\s*:", re.I)

def main():
    try:
        log = subprocess.run(
            ["git", "-C", str(ROOT), "log", "--reverse", "--format=%h|%cI|%s"],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except subprocess.CalledProcessError:
        log = ""  # 空 repo / 无 commit

    events, others = [], 0
    for line in log.splitlines():
        sha, date, subj = line.split("|", 2)
        m = PAT.match(subj)
        if m:
            events.append((date[:10], m.group(1).lower(), subj.strip(), sha))
        else:
            others += 1  # merge commit、无前缀杂项

    lines = [
        "# Repo Pulse · 对话 timeline", "",
        "> 由 `scripts/repo-pulse.py` 从 git log 自动生成，请勿手改。", "",
    ]
    if not events:
        lines.append("_尚无 kimi:/cursor: 前缀的 commit。_")
    for date, who, subj, sha in events:
        lines.append(f"- `{date}` **{who}** · {subj} (`{sha}`)")
    if others:
        lines += ["", f"_另有 {others} 个无前缀 commit（merge/杂项）未列出。_"]

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"wrote {OUT.relative_to(ROOT)} ({len(events)} events, {others} others)")


if __name__ == "__main__":
    sys.exit(main())
