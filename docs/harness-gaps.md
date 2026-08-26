# Harness gaps（手谈 / thread 002 · C 项）

> 各 harness 产品化缺什么。协议无关，不阻塞 A+B。

## Cursor

1. **Loop / Watcher 一等能力**：无「会话模板一键 arm」；需 README 手抄 monitored background 步骤。
2. **Wake → Execute 链路不可靠**（2026-08-26 实测）：
   - `watch-kimi-push.sh` while-loop 模式下 stdout `AGENT_LOOP_WAKE_*` 已写入 monitored task，但 Agent **未自动开跑**（07:49 kimi commit）。
   - **缓解**：shell-exit 模式——`arm-kimi-watcher.sh` 在 kimi 检测后 **exit 0**，依赖后台任务**完成通知**作主唤醒；stdout sentinel 作备份。
   - **仍缺**：完成通知 + sentinel 双到时的优先级、以及「Agent 跑完 loop 后自动 re-arm」的一等能力。
3. **Run Mode 与跨 workspace git**：Smart Mode 仍可能拦 push；bridge 常需 dedicated window。
4. **Cloud vs Local 触发器混淆**：Automation = Cloud Agent；本地 loop 无 UI 入口。
5. **permissions.json + sandbox.json 模板化**：已有 preset（`84bb79a`），未内建到产品。
6. **会话存活**：chat 关则 loop 死；无「持久 watcher 会话」类型。

## Kimi Code

1. **Session template**：进会话自动加载 skill、arm 后台任务、路径预授权——三件事今天都要手工说一遍。
2. **（已落地）shell-exit 唤醒**：LLM cron 空转 → 改为 watcher exit + 完成通知；2026-08-26 07:20 起三次唤醒全部可靠。
3. **watcher 不能自维持**：后台任务完成即结束，re-arm 依赖 agent 记得做；现用 30 分钟兜底 cron 做健康检查 + 自愈重 arm，可用但属补丁。
4. **cron/watcher 是会话级资源**：会话退出即停，跨新会话不继承；recurring cron 另有 7 天 stale 自动过期。「选模板即协作」要求它们能随模板恢复。
5. **唤醒无定向注入**：后台任务完成通知是通用通道，watcher 事件和无关任务完成长得一样；理想形态是 watcher 事件可携带 prompt 定向注入。
6. **权限预授权粒度**：对特定 repo 的 git fetch/push 白名单需手工确认，无「bridge repo 协作」preset。

---

*Stub · Cursor · 2026-08-26 · 随 002 C 项共建*
