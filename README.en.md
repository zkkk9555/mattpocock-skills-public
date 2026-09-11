English | [简体中文](./README.md)

# autopilot

**One invocation, full autopilot.** A driver skill wrapping the
[mattpocock/skills](https://github.com/mattpocock/skills) workflow (25
sub-skills): one plain-language request — in English or Chinese — turns into a
complete, verified, delivered task. Routing, sharpening, spec, tickets,
implementation, red-green testing, two-axis review, verified delivery, all
driven by the skill itself with no mid-task questions.

> **Who this is for**: people who want the workflow but don't know how to use
> it. You don't need to know the 25 sub-skills or when to invoke which — just
> invoke this one skill and it calls the workflow skills automatically when
> needed. Beginner-friendly by design.

## Why

Bare agents skip steps when they feel confident: they jump straight to code,
skip the spec, forget the regression test. This driver turns "quality by
discipline" into "quality by process":

- **T0 routing every round** — `ask-matt` decides the lane before any work.
- **Real-skill-first** — installed sub-skills are always loaded before work;
  the bundled fallbacks exist only for missing skills.
- **Self-scan checkpoints** — after every slice, after every red→green, on
  repeated failures, on design forks.
- **Never-exempt review & verify** — every change ships with pasted,
  real-exit-code verification evidence. Tokens are spent instead of asking
  the human.
- **Delivery for non-coders** — every task closes with a one-sentence change
  summary, a paste-and-run hand-check, and the raw verify output.
- **Central logbook + scheduled reflection** — every task appends evidence to
  a logbook; every 3 engineering rounds the driver answers five upgrade
  questions. Upgrades are distilled from this data by a human-driven
  skill-creator round — the driver never edits itself.

## Install

> **Prerequisite**: this driver is the commander — the ones doing the work are
> the 25 upstream workflow skills
> ([mattpocock/skills](https://github.com/mattpocock/skills)). Install all 26
> together (anything less is a partial install); driver-only runs on built-in
> speed notes with weaker discipline.

**One-command install (driver + upstream, recommended)** — bash (macOS / Linux / Git Bash):

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash
```

Windows PowerShell (if execution policy blocks, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1)))
```

Default target is `~/.agents/skills/` (community convention honored by ZCode,
Cursor, OpenCode, and others); the script also writes to your detected harness
dir when unambiguous. **Verify in your tool that the skill list shows
autopilot** — otherwise it landed in the wrong place. Variants:

```bash
bash install.sh --harness zcode          # auto|claude|codex|cursor|opencode|zcode|all
bash install.sh --harness zcode --dry-run # preview only
bash install.sh --slim                    # driver only (offline/CI)
bash install.sh --dir /my/harness/skills  # unknown harness
bash install.sh --uninstall               # remove (keeps logbook)
```

**Alternative: official commands** — this repo works with `npx skills` as-is:

```bash
npx skills@latest add zkkk9555/autopilot-skill -g -a zcode -y   # -a: claude-code|codex|cursor
npx skills@latest add mattpocock/skills -g -a zcode --skill '*' -y  # upstream 25
```

Note: the CLI installs per-harness dirs (not `~/.agents/skills/`) and skips the
logbook — add one manually per the example file. Claude Code users can also use
the plugin marketplace: `/plugin marketplace add zkkk9555/autopilot-skill`,
then `/plugin install autopilot`.

**Manual install (unknown harness, 2-minute self-serve)**: (1) find your skills
dir (search your tool's docs/settings for `skills`; else try
`~/.agents/skills/`); (2) `git clone --depth 1
https://github.com/zkkk9555/autopilot-skill` and `git clone --depth 1
https://github.com/mattpocock/skills` (or download both zips); (3) driver
`autopilot/` → `<skills>/autopilot/`, upstream: every `SKILL.md`-bearing dir
under `skills/*/*/` flattened by its **last path segment**
(e.g. `skills/engineering/ask-matt/` → `<skills>/ask-matt/`); (4) verify:
`<skills>/autopilot/SKILL.md` starts with `name: autopilot`,
`<skills>/*/SKILL.md` count is at least 26 (including autopilot), restart the agent and say "The sidebar
toggle stopped working — check and fix it."

**Directory map** (each agent reads its own dirs — nothing is universal):

| Location | Applies to | One-command |
|---|---|---|
| `~/.agents/skills/` | ZCode, Cursor, OpenCode, etc. (community convention) | default target |
| `~/.zcode/skills/` | ZCode | `--harness zcode` |
| `~/.claude/skills/` | Claude Code | `--harness claude` (or marketplace) |
| `~/.codex/skills/` | Codex | `--harness codex` |
| `<project>/.agents/skills/` | current project only | `--dir` pointing at it |

## Use

Say it like a human, once:

- The sidebar toggle stopped working — check and fix it.
- Add a small button that does XX when clicked — make it solid and reliable.
- I want to build a small XX project.

The driver routes itself: symptoms/errors → feedback-loop-first bug flow;
small features → sharpen → spec → red-green → two-axis review; foggy projects
→ interview → map → staged stops. It only stops for destructive,
externally-visible, or scope-changing decisions.

## The usage logbook

Every task appends one evidence entry (what happened / why each skill fired /
friction / missed-skill self-check / result) to a central logbook whose
location **you** choose when installing — see
[`USAGE-LOG.example.en.md`](./USAGE-LOG.example.en.md) for the exact format
A Chinese edition of the example is available at [`USAGE-LOG.example.md`](./USAGE-LOG.example.md). Every three
engineering rounds the driver adds a reflection entry. When you have enough material, run a skill-creator
session against the logbook to produce the next version — that is the whole
upgrade loop; the driver only proposes, never self-modifies.

## Grow your own version

> This skill ships with a complete upgrade loop: central logbook + scheduled
> reflection + a new skill-creator round.
>
> Use it normally in your project for a while, and your logbook will collect
> dozens of real entries (what fired when, where it stumbled, what should have
> fired but did not). Feed the logbook to a skill-creator session (or your
> preferred skill-editing flow) in this repo and ship one new version of the
> rules from the highest-frequency friction — that is exactly how the driver
> author upgraded it from V2.001 to V2.008.
>
> The version you grow this way fits your codebase, your habits, and your
> model out of the box. The logbook and the skill package stay separate, so
> upgrades touch rules only, never the records.

## Status & contributing

> This skill is in **early development** — trigger timing may be off and
> sub-skill handoffs may be rough. You are welcome to:
>
> - File an [issue](https://github.com/zkkk9555/autopilot-skill/issues) with your scenario and what the driver actually did.
> - Open a [pull request](https://github.com/zkkk9555/autopilot-skill/pulls) against `main`.
>
> Every report helps — real-world feedback is exactly what carried it from
> V2.001 to where it is now.

## Versioning

Single scheme: `V2.00N` (see
[`autopilot/CHANGELOG.md`](./autopilot/CHANGELOG.md),
English version at
[`CHANGELOG.en.md`](./autopilot/CHANGELOG.en.md)).

## License

MIT — see [LICENSE](./LICENSE).
