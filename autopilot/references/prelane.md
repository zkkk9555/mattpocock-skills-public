# pre-lane — 分流与 Gate 0

> 来源：瘦身前 SKILL.md §1（第 385–448 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 1. Pre-lane: split, shield, Gate 0, then one lane

**Split multi-intent first.** One message with two or more independent verbs /
systems ("联机对战，再顺手美化UI") is NEVER one effort. List the slugs, run
Gate 0 + lane per slug independently, one `.scratch/<slug>/` each. Ban
multiple Destinations in one map/spec. Trigger words 顺手/顺便/再/顺带 auto-
split: the trailer defaults to Out-of-scope of the first slug.

**Externality shield (before any spec/map/prototype).** Request containing
publish / submit / upload / release / spend / credential / store / compliance
/ 上架 / 提交 / 内购 / 支付 keywords → STOP immediately: write
`.scratch/<slug>/NEEDS-HUMAN.md`, end the turn. "Draft only, won't submit"
counts as a release-artifact change — same STOP. No spec/map/ticket first.

**Gate 0 — already-implemented check (runs before any lane).** Grep keywords +
read red-line docs. The hit claim must cite `file:line + behaviour-parity
assertion`; semantic duplicates (same table, same trigger channel, same
mechanism under another name) count as hits. Three exits:

- HIT → regression-hardening branch: zero code change + parity assertions in
  `NOTES.md` + throwaway script (deleted after). No grill/spec/tickets, no
  tdd/review. Gate = parity green + smoke green. A literal gap (e.g.
  "place-time reject" vs existing "runtime silence") gets a delta spec for the
  gap only, never a rewrite, never a same-meaning new file.
- BROKEN (V2.008) — the mechanism exists but the behaviour is wrong (symbol
  found, implementation faulty): not a HIT (nothing to harden) and more than
  a bare MISS — route to **Lane D** with the located anchor, gate verdict
  cited as `HIT-exists → BROKEN → D`.
- NOT-FOUND (e.g. typo string has zero hits) → report + grep-parity assertion,
  enter NO lane. Never route a not-found typo into Lane D's bug-flow.
- MISS → lane classification below.

Then pick exactly one lane:

- **Lane A — trivial**: typo / doc single line / single config or content row
  ONLY when ALL hold: Gate 0 located it, schema-complete, red-line range
  passes, duplicate-count == 1. Numbers are NEVER Lane A. Fix directly, run
  the per-class gate (§4), commit with a one-line Provenance anchor. No
  grill/spec/tickets; exempt from tdd red-green + code-review (the gate run is
  the review). Duplicate-count > 1 or schema-incomplete → forced Lane B.
- **Lane B — well-scoped feature or refactor**: `references/feature-flow.md`.
  Lane B embeds 1–3 slices as a spec checklist (no separate ticket files);
  a slice = one independently demoable vertical behaviour (data + trigger +
  verify closed loop); same-file batch rows = 1 slice; a pure horizontal
  layer is never a slice alone. More than 3 → escalate to Lane C.
- **Lane C — big or foggy effort**: `references/effort-flow.md`.
- **Lane D — hard bug**: `references/bug-flow.md`. Entry requires at least one
  of: user symptom text, repro path, location. Zero-info ("修一下那个bug")
  never enters hypothesise: write `NOTES.md` attempts + `BLOCKED.md` (what
  log/save/steps are needed) or `NEEDS-HUMAN.md` and stop. Self-invented
  repros to satisfy Phase-1 are banned.
- **Lane E — pile of raw incoming issues**: run `triage`; implement only what
  is already `ready-for-agent`. Never triage tickets `to-tickets` produced.

Priority: Gate 0 → shield → A (single located line) → B (stable, single-file,
multi-line) → D (flake / multi-system / no anchor). Log every downgrade in
`NOTES.md`.

**B-vs-D test (two stages, V2.008 pinned).** The two rules below answer
different questions and never compete:

- **User-reported bugs go to D, always.** If the task's subject is a bug
  (symptom text / error / "修一下那个 XX" in the user's message), it is Lane
  D — the diagnosing-bugs discipline (feedback loop first) applies regardless
  of how good the anchor looks. This overrides the glance.
- **Bugs *encountered mid-lane*** (a test fails while building a feature, a
  flake surfaces during verification) may be fixed inside the current lane
  when a one-round attribution lands with evidence; otherwise write
  `NOTES.md` and give it its own round. This is what the glance is for.

Trigger words (偶发/flake/竞态/时序/疑似/特定条件下偶现) → **D** immediately.
All bugs default to D means: when in doubt between B and D, D wins — it is a
tie-breaker, not a second route for user-reported bugs.

**B-vs-C test (10-minute chart precheck).** ① Can you write, NOW, every ticket
with `Anchors: path :: symbol` + verify command? ② Any cross-system change,
new mechanism, or undecided numbers? ③ Multiple turns/sessions? ② or ③ =
Yes, or ① unwritable → **C**. A session = one window, one goal.

