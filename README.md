[English](./README.en.md) | 简体中文

# autopilot

**点一次，说句人话，剩下的全自动。** 一个包着 [mattpocock/skills](https://github.com/mattpocock/skills) 工作流（25 个子 skill）的全自动 driver：用户说一句日常人话（中英文都行），它就把整个任务自己做完——分流、打磨、写 spec、拆票、实现、红绿测试、双轴评审、验证交付，中途不需要人参与。

> **给谁用的**：想用这套工作流、但不会用的人。你不需要认识 25 个子 skill，也不需要知道什么时候该调谁——你只需要调这一个 skill，它会在需要时自动调用工作流里的 skill，新手直接用就行。

## 为什么需要它

裸 agent 在"自以为拿得准"的时候会跳步：直接开写、跳过打磨、忘了回归测试。这个 driver 把"质量靠自觉"变成"质量靠流程"：

- **每轮 T0 分流**——动手前先由 `ask-matt` 判定走哪条路。
- **正身优先**——已安装的子 skill 必须先加载再干活；速记版 fallback 只留给未安装的 skill。
- **自扫检查点**——每干完一段、每次红转绿、连续失败、设计分叉，都有 15 秒自扫。
- **评审与验证永不豁免**——每次改动都贴真实退出码的验证证据；宁可多花 token，不让人参与。
- **给不会写代码的人的交付**——每个任务收尾三件套：一句话改动说明 + 照着点就能验的手工清单 + 验证原文输出。
- **中央日志本 + 定期反思**——每个任务往日志本追加一条证据记录；每 3 个工程轮 driver 自答五个升级问题。升级永远由人拿着日志开 skill-creator 出新版——driver 只提案，永不自改。

## 安装

> **前置说明**：本 driver 是指挥官，真正干活的是上游 25 个工作流 skill（[mattpocock/skills](https://github.com/mattpocock/skills)）。必须先把上游装进 skills 目录，driver 才能调用它们；没装时 driver 也能跑（内置速记版兜底），但过程纪律会打折。

**一键安装（含上游 25 skill，推荐）**——bash（macOS / Linux / Git Bash）：

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash -s -- --with-upstream
```

Windows PowerShell：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1))) -WithUpstream
```

默认装到 `~/.agents/skills/`（跨工具通用目录）；想换位置，设置环境变量 `MATTP_SKILLS_DIR`。

**手动安装**：① 上游 25 skill：`git clone --depth 1 https://github.com/mattpocock/skills`，把每个含 `SKILL.md` 的子目录复制进 skills 目录；② 本 driver：把 `mattpocock-skills/` 复制进同一个 skills 目录。

**常见的 skills 目录**（任选其一，agent 会自动发现）：

| 位置 | 适用 |
|---|---|
| `~/.agents/skills/` | 跨工具通用（推荐） |
| `~/.zcode/skills/` | ZCode |
| `~/.claude/skills/` | Claude Code |
| `<项目>/.agents/skills/` | 仅当前项目生效 |

## 使用

像说话一样说一次就够：

- 切换按钮失效了，去检查修一下。
- 给我加个新的小按钮，点一下能实现 XX，要稳定好用。
- 我想做个 XX 小项目。

driver 自己选路：报错/症状 → 先建反馈环再修的 bug 流；小功能 → 打磨 → spec → 红绿 → 双轴评审；大雾项目 → 先访谈画图、分阶段推进。只有删数据、花钱、对外发布这类高危动作才会停下来等你拍板。

## 中央日志本

每个任务收尾，driver 往一本中央日志追加一条证据记录（经过/为啥用/卡点/漏用自查/结果），日志本位置**由你在安装时自己定**——格式见 [`USAGE-LOG.example.md`](./USAGE-LOG.example.md)。每 3 个工程轮还会追加一条 `[反思]`。素材攒够后，你拿日志本开一轮 skill-creator 出下一个版本——这就是全部升级循环；driver 只提案，永不自改。

## 升级出你自己的版本

> 本 skill 自带一条完整的升级链：中央日志本 + 定期反思 + skill-creator 新版。
>
> 用法：在你的项目里正常使用本 skill 一段时间，你的日志本里会攒下几十条真实记录（什么时候调了谁、哪里卡住、哪里该调没调）。把日志本拿出来，在本仓库的目录下开一轮 skill-creator（或你喜欢的 skill 编辑流程），按日志里的高频卡点出一版新规则——这就是 driver 作者本人的升级方式，它已跑过 V2.001 → V2.008。
>
> 这样升级出来的版本天然适配你的代码库、你的工作习惯和你用的模型。日志本和 skill 包是分开的，升级时只改规则，不碰流水记录。

## 状态与贡献

> 本 skill 处于**早期开发阶段**，还可能存在触发时机不准、子 skill 衔接不顺之类的问题。欢迎：
>
> - 在 [Issues](https://github.com/zkkk9555/autopilot-skill/issues) 提交问题（附上你的使用场景和 driver 的实际行为）。
> - 在 [Pull Requests](https://github.com/zkkk9555/autopilot-skill/pulls) 提交修复（基于 `main` 分支）。
>
> 任何反馈都有帮助——正是来自真实使用的反馈，才推动了从 V2.001 走到现在。

## 版本

单一版本号 `V2.00N`，见 [`autopilot/CHANGELOG.md`](./autopilot/CHANGELOG.md)。

## 许可

MIT，见 [LICENSE](./LICENSE)。
