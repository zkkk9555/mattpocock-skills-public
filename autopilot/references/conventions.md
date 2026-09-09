# Conventions (naming, templates, commits)

## Slug

`<verb>-<object>-<constraint>`, English kebab-case. Translate non-English
requests (`符阵上限3座光域内` → `ward-cap-3-in-light`). One effort = one
`.scratch/<slug>/`.

## Files

- `spec.md` — Problem / Solution / User-Stories / Implementation Decisions /
  Testing Decisions / Out of Scope / Glossary / Notes.
- `issues/NN-<slug>.md` (`NN` from `01`, blockers first) — What-to-build /
  Blocked-by / Status / Acceptance criteria. Never one combined file.
- Lane C map — `.scratch/<slug>/map.md`: Destination / Notes /
  Decisions-so-far / Not-yet-specified / Out-of-scope.
- Decision tickets additionally carry `Type: research|prototype|grilling|task`.
- Stops: `BLOCKED.md` (red unbuildable: what was tried + needed access /
  artifact), `NEEDS-HUMAN.md` (SKILL.md §2 STOP reasons).

## Minimal templates

`map.md`:

```markdown
## Destination
<one-line done-state>
## Notes
<domain + skills each session consults>
## Decisions so far
- [<title>](issues/NN-slug.md): <gist>
## Not yet specified
- <suspected question, loose>
## Out of scope
- <ruled-out work + why>
```

ticket:

```markdown
# NN: <title>
**Type:** research|prototype|grilling|task (decision tickets) — omit for build
**What to build:** end-to-end behaviour, user perspective
**Anchors:** `path :: symbol` (one line each, required)
**Blocked by:** NNs/titles, or "None"
**Status:** needs-triage|needs-info|ready-for-agent|ready-for-human|wontfix
- [ ] criterion 1
## Answer (decision tickets only)
```

## ADR numbering

`docs/adr/NNNN-<slug>.md`, NNNN = max existing + 1 (empty dir → `0001`).

## Commits

One commit per ticket, linear sequence on solo single-branch repos.
`.scratch/<slug>/` is committed (spec/map/tickets are review artifacts).
Message cites the decision or winning hypothesis. Never mix lanes in one
commit. Publishing = `Status:` line in the issue file, not a commit attribute.

## Cleanup tokens

Debug logs always tagged `[DEBUG-<id>]` → removal is one grep. Throwaway
repro scripts live gitignored under `tools/` (or the repo's throwaway spot)
and are deleted (or explicitly relocated) before done.

## Multi-intent single commit (V2.006)

One round legitimately carrying several small intents (each ≤1 slice) in one
commit: one `.scratch/<slug>/` per intent with its own embedded-slice spec,
and the commit message lists every slug; never merge intents into one shared
spec section. Each intent quotes its own verify evidence in its own spec.
Several Lane-B intents may share one commit only when none of them alone
would touch a red-line file; otherwise split commits (lane mixing stays
banned).
