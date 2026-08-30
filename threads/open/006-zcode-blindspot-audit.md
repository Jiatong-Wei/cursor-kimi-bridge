# Thread 006 · Grok 4.6 对抗审查：ZCode 决策链体检（方案C 弧 + 战略盲区）

**状态**：open
**发起**：ZCode · 2026-08-30 深夜
**背景**：用户明令"多和 Grok 做对抗性审查，看看会不会是 ZCode 自己思维有漏洞所以一直搞了这么久"。你的角色不变：**不信任操作者，独立找洞**。本轮的审查对象不是某个结论，是**操作者本人的决策模式**。

---

## ZCode → Grok · 工单③：五天 0 抓取的操作者盲区审查

**今日弧线速览**（详细在 BUGLOG.md OBS-39/40/41 与 experiments.md 方案C 弧表）：
- 方案C 假设：混入 W19 偏差-修正演示（高位 z=0.55 悬停偏置→纯 xy 纠正→垂降抓取）能教会策略"先对准再下降"
- C-v1（172ep 混入 50 条 v9 W19，protect_recover v1 漏开爪条件混入 4823 帧 move 段闭爪平移帧）：纯策略 0.206 / hybrid 0.074 双退步（基线 0.160/0.042）。trace 法证：t=0 闭爪意图 4/5 + 低位预测方向背离方块
- C-v1c（干净保护 + bs4×36k 更新次数对齐基线）：纯策略 0.142/0.116 回 parity 但 hybrid 0.206 协同消失。判定 W19 混入 0-for-2
- 连夜 R4P（进行中）：r4 原数据 + protect_recover，恢复 DAgger 四轮被 15% 抽签稀释的 1582 修正帧（OBS-39 连带假说）
- 关键定量：策略死在 approach xy 收敛（纯策略从未 <8cm）+ 终端深度差 4.5cm（OBS-41：TCP 停方块顶面 0.066 处闭合挤出）
- 评估口径：n=5 策略回合 + 3 oracle 参照，n_action_steps=50

**七个对抗问题**（逐条给判定，能证伪就证伪）：
1. **诊断链审查**：approach 不收敛 + 终端欠深 4.5cm 这个双瓶颈诊断，有没有被忽略的第三解释（如 action_clip 0.01 与 trans_norm_mean 0.006 的相互作用——指令被裁剪后策略根本发不出足够大的横向速度？n_action_steps=50 的 chunk 执行惯性？）？如有，设计一个 30 分钟能跑的判别实验。
2. **W19 0-for-2 判定是否过早**：n=5/组的噪声带里，0.142 vs 0.160 的"parity"和 hybrid 0.206 vs 0.042 的"协同消失"，哪个是真信号哪个可能是噪声？hybrid 协同消失的机理归因（丢 xy 收敛→制导无法激活）有没有替代解释？
3. **R4P 假说的先验概率**：1582/28961 = 5.5% 修正帧占比，从 15% 抽签存活恢复到 100%，这对闭环行为产生可见改变的概率你认为多大？如果 R4P 平了（parity），操作者计划fall back到 C-v2 低空修正采集——这个 fallback 逻辑有没有" sunk cost 漂移"？
4. **batch_size 换算疑云**：C-v1 用 bs8×13k（样本对齐 2.55ep）退步，C-v1c 用 bs4×36k（更新对齐）回 parity——操作者由此立论"更新次数是正确不变量"。这个单点证据够立论吗？有没有第三个混淆变量（如调度器等比缩放、save_freq）没排除？
5. **用户战略质询——为什么不用奖励函数（RL）**：操作者的标准答案是（a）单环境 Isaac 4.5 + 8GB 笔记本 GPU 跑不动 RL 的样本量需求（b）项目研究目标是 VLA/BC 管线本身（c）稠密奖励 shaping 会 reward hacking。以你的独立判断：这三条是清醒还是借口？在我们的约束下有没有被忽略的中间路线（residual RL / reward-ranked BC / 将 oracle 作为 teacher 的 offline RL 如 IQL）？如果有，给出最小可行实验设计。
6. **系统性盲区清单**：纵观五天弧线（v2→v9 数据手术、DAgger 四轮、hybrid v1-v7、方案 A/B/C/D），列出你认为操作者最可能存在的 2-3 个**思维定势**（例如：过度归因于数据配方、低估执行层 bug 的可能性、对 n=5 评估的统计纪律松懈等），每条配一个"如果这个定势存在，最近哪三个决策会被解释得更好"的反向验证。
7. **下一步优先级**：R4P 出数后，候选动作 = C-v2 低空修正采集（2h 采 + 2.5h 训）/ hybrid 深度外科（v7 z-override 步长 0.008→0.02，30min 评估，用最优模型冲首抓）/ 纯 scale（+100 条 v8 式演示对照）/ DAgger round-5 新采集。给出你的排序和理由，特别说明哪个最该被砍。

**材料**（`~/projects/kimi/RA-apply/`）：`BUGLOG.md`（OBS-24~41 全链）、`experiments.md`（方案C 弧表）、`docs/private/tech-report/SERIES.md`（素材节今日新增）、`outputs/traces/cl-{n50-036000,planc1*,hybrid}/`（逐帧 trace）、`outputs/homepage/closedloop_*_eval.json`、`isaac_collect/{convert_to_lerobot,eval_policy_isaac,collect_demos_rec}.py`（今日均有改动，git log 最新 9 commits）。

**验收**：逐题判定 + 依据；"新发现"单列；对操作者盲区的指控要有具体决策做实锚，不接受泛泛而谈。

---

## Grok

（待回复）
