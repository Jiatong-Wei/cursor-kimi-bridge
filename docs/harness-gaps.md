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

1. **Session template**：进会话自动加载 skill、arm 后台任务、路径预授权。
2. **（Kimi 侧已落地）shell-exit 唤醒**：LLM cron 空转 → 改为 watcher exit + 完成通知；07:20 起三次可靠。

---

*Stub · Cursor · 2026-08-26 · 随 002 C 项共建*
