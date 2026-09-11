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

> **前置说明**：本 driver 是指挥官，真正干活的是上游 25 个工作流 skill（[mattpocock/skills](https://github.com/mattpocock/skills)）。必须连上游一起装（共 26 个，少一个都是残的），driver 才能完整调用；只装 driver 也能跑（内置速记版兜底），但过程纪律会打折。

**一键安装（默认装全 26 个，推荐）**——bash（macOS / Linux / Git Bash）：

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash
```

Windows PowerShell（若报执行策略错误，先跑 `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`）：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1)))
```

默认装到 `~/.agents/skills/`（ZCode、Cursor、OpenCode 等认的社区约定目录）；脚本会自动探测当前 harness（ZCode/Claude/Codex/Cursor/OpenCode），命中且唯一时多写一份到对应目录。装完**必须去你的工具里确认 skill 列表出现了 autopilot**，否则就是装错了地方。常用变体：

```bash
bash install.sh --harness zcode          # 指定 harness（auto|claude|codex|cursor|opencode|zcode|all）
bash install.sh --harness zcode --dry-run # 先预览，不动文件
bash install.sh --slim                    # 只要 driver（离线/CI 用）
bash install.sh --dir /my/harness/skills  # 冷门 harness 自定义目录
bash install.sh --uninstall               # 卸载（不动日志本）
```

**备选：官方命令**——本仓库已兼容 `npx skills` 生态（零改动实测通过）：

```bash
npx skills@latest add zkkk9555/autopilot-skill -g -a zcode -y   # -a 换 claude-code|codex|cursor
npx skills@latest add mattpocock/skills -g -a zcode --skill '*' -y  # 上游 25 个
```

注意：`npx skills` 按 harness 分目录安装（不在 `~/.agents/skills/`），且不建日志本——装完对照下面的手动步骤补一份日志本。Claude Code 用户也可用插件市场：`/plugin marketplace add zkkk9555/autopilot-skill` 后 `/plugin install autopilot`。

**手动安装（未知 harness 2 分钟自助）**：① 找你的 skills 目录（翻工具文档/设置搜 skills；找不到先试 `~/.agents/skills/`）；② `git clone --depth 1 https://github.com/zkkk9555/autopilot-skill` 和 `git clone --depth 1 https://github.com/mattpocock/skills`（或下载两 zip）；③ 本 driver `autopilot/` → `<skills>/autopilot/`，上游 `skills/*/*/` 下每个含 `SKILL.md` 的目录按**最后一级目录名**装平（如 `skills/engineering/ask-matt/` → `<skills>/ask-matt/`）；④ 验证：`<skills>/autopilot/SKILL.md` 首行含 `name: autopilot`，`<skills>/*/SKILL.md` 共 26 个，重启 agent 后说“切换按钮失效了，去检查修一下”。

**目录对照**（agent 只认自己的目录，不存在全宇宙通用）：

| 位置 | 适用 | 一键命令 |
|---|---|---|
| `~/.agents/skills/` | ZCode、Cursor、OpenCode 等（社区约定） | 默认即装这里 |
| `~/.zcode/skills/` | ZCode | `--harness zcode` |
| `~/.claude/skills/` | Claude Code | `--harness claude`（或插件市场） |
| `~/.codex/skills/` | Codex | `--harness codex` |
| `<项目>/.agents/skills/` | 仅当前项目 | `--dir` 指向它 |

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
