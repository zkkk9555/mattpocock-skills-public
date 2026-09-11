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

> **One-line install**: copy this prompt to your agent and it handles everything:
>
> ```
> Install this skill: https://github.com/zkkk9555/autopilot-skill
> Requirements: driver (autopilot) + 25 upstream workflow skills, 26 required
> items total, none missing; install into the current agent's user-level skills
> directory; take new upstream skills as they come; count <skills>/*/SKILL.md
> (at least 26) and report the result.
> ```
>
> This prompt is link-drop tested (clean agent installed 26/26 from the link
> alone). Advanced options below — skip if the prompt worked.

<details>
<summary>Advanced: one-command + variants</summary>

The driver is the commander; the 25 upstream workflow skills
([mattpocock/skills](https://github.com/mattpocock/skills)) do the work —
install all 26 together. Driver-only runs on built-in speed notes with weaker
discipline.

bash (macOS / Linux / Git Bash):

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash
```

Windows PowerShell (if execution policy blocks, run
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1)))
```

Default target is `~/.agents/skills/`; the script also writes to your detected
harness dir when unambiguous. **Verify in your tool that the skill list shows
autopilot.** Variants: `--harness zcode` (auto|claude|codex|cursor|opencode|
zcode|all), `--dry-run`, `--slim`, `--dir`, `--uninstall`.

</details>

<details>
<summary>Advanced: other methods (npx / marketplace / manual)</summary>

- `npx skills`: `npx skills@latest add zkkk9555/autopilot-skill -g -a zcode -y`
  (`-a`: claude-code|codex|cursor), then `npx skills@latest add
  mattpocock/skills -g -a zcode --skill '*' -y` for upstream. Installs
  per-harness dirs and skips the logbook — add one manually per the example.
- Claude Code marketplace: `/plugin marketplace add zkkk9555/autopilot-skill`,
  then `/plugin install autopilot`.
- Manual (unknown harness): find your skills dir → clone both repos → driver
  `autopilot/` over, upstream `skills/*/*/` flattened by last segment →
  verify 26+ → restart and say "The sidebar toggle stopped working — check
  and fix it."
- Directory map: `~/.agents/skills/` (ZCode/Cursor/OpenCode…)
  | `~/.zcode/skills/` (ZCode) | `~/.claude/skills/` (Claude Code)
  | `~/.codex/skills/` (Codex) | `<project>/.agents/skills/` (project only).
  Nothing is universal — always verify.

</details>
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
