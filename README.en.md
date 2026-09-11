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
> ([mattpocock/skills](https://github.com/mattpocock/skills)). They must be
> installed into a skills directory for the driver to invoke them. Without
> them the driver still runs (built-in speed notes as fallback), but with
> weaker in-process discipline.

**One-command install (includes the 25 upstream skills, recommended)** — bash
(macOS / Linux / Git Bash):

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash -s -- --with-upstream
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1))) -WithUpstream
```

Default target is `~/.agents/skills/` (the cross-tool standard); override with
the `AUTOPILOT_SKILLS_DIR` environment variable.

**Manual install**: (1) upstream 25 skills: `git clone --depth 1
https://github.com/mattpocock/skills`, copy every `SKILL.md`-bearing directory
under `skills/*/*/` flattened by its **last path segment** into the skills
directory (e.g. `skills/engineering/ask-matt/` → `ask-matt/`); (2) this driver:
copy `autopilot/` into the same skills directory.

**Common skills directories** (pick one — agents discover them automatically):

| Location | Applies to |
|---|---|
| `~/.agents/skills/` | cross-tool standard (recommended) |
| `~/.zcode/skills/` | ZCode |
| `~/.claude/skills/` | Claude Code |
| `<project>/.agents/skills/` | current project only |

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
