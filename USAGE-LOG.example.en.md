# USAGE-LOG — Central Logbook (Example)

> This is an **example file with fabricated data: format only, never written
> to**. Manual install: copy it to your logbook path (default
> `~/.autopilot/USAGE-LOG.md`, a fixed location outside any repo) as
> your first book; the driver appends only there, never here. The one-command
> installer creates the first book automatically. Pick one language and keep
> it for the whole book — one book per install.
>
> Rules: append-only, one entry per task, never write logs inside the skill
> package itself. When several agents run concurrently, append the whole
> entry in one write.
>
> After each skill upgrade, the maintainer appends a watermark entry marking which entries have been
> consumed by which version, so the next upgrade only reads fresh material.
>
> Chinese edition: [`USAGE-LOG.example.md`](./USAGE-LOG.example.md)

## Format

One entry per task, five aspects, as detailed as needed:

```markdown
## <date> <one-line task description> (project: <where it ran>)
- What happened: end to end — what the user said, which skills the driver
  invoked, in order.
- Why each skill fired: which entry condition in `core-triggers.md` was
  matched.
- Friction: where it hesitated, detoured, or produced weak output; any user
  correction (quote it).
- Missed-skill self-check: checked the 8 core triggers — anything that should
  have fired but didn't? Name it and why; otherwise write "none".
- Result: delivered? (three-piece set complete?) verify output green? user
  hand-checked?
```

Use your operating language consistently across all entries — the reference
implementation writes Chinese entries; English works the same way.

## Example entry (fabricated)

## 2026-01-15 Sidebar collapse button dead — check and fix (project: demo-app)
- What happened: user said "the sidebar collapse button doesn't respond, fix
  it". Driver self-bootstrapped → T0 ask-matt routed to the bug lane →
  diagnosing-bugs (symptom text satisfies entry; feedback loop first) → tdd
  (red seam before fix) → code-review (fast-track two-axis) → three-piece
  delivery.
- Why each skill fired: diagnosing-bugs matched "user symptom text"; tdd
  matched "before swallowing a seam"; code-review matched "before every
  commit (never exempt)".
- Friction: repo has no test runner — fell back to an invented seam assert;
  expected values taken from the README contract section (independent truth),
  guard expectations differ from the buggy output.
- Missed-skill self-check: grill family / to-spec / to-tickets not applicable
  (bug lane exempts); wayfinder not matched (no fog). Conclusion: none.
- Result: delivered. Three-piece set complete: one-sentence change ✓,
  hand-check (paste one command, read output) ✓, verify red→green same
  command with pasted output ✓. User did not hand-check (AFK).

## Example watermark entry (fabricated)

## [watermark] 2026-02-01 V2.00N consumed

- Scope: every entry above this line has been consumed by V2.00N; rule
  mappings live in the corresponding CHANGELOG entry inside the skill
  package.
- The next upgrade reads only entries below this watermark; entries above
  serve as rule provenance only.

## Reflection entries

Every 3 engineering rounds the driver appends a reflection entry (fixed goal
preamble + five evidence-based questions: invocation timing / vague rules /
self-invented workarounds / biggest gap to the goal / other). Same format and
append-only rules.
