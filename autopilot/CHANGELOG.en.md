English | [简体中文](./CHANGELOG.md)

# CHANGELOG — autopilot

Single version scheme: `V2.00N`. (Early private iterations used internal vNN
numbers — v41=V2.001, v43=V2.002, v44=V2.003, v45=V2.004, v46=V2.005,
v47=V2.006, v48=V2.007, v49=V2.008. Retired as of V2.008.)

**V2.008** — Field distillation from 20 task entries + 3 driver reflections.
Self-scan checklist extended (green-lock question after red→green; forced
slowdown after 3 consecutive failures; same-file regression smoke; design-fork
nudge toward codebase-design). No-harness expected values must cite an
independent truth source, with at least one guard assertion differing from the
buggy output. Test-registry discipline (one unified entry, every test
registered, costly tests tiered). External review handling (reproduce → fix →
reply with red/green evidence). Adopted field remedies (shell-append for the
logbook, NOTES as JOURNAL fallback, Edit-tool over scripted replace,
Windows/MSYS notes). B-vs-D routing contradiction pinned: user-reported bugs
always take the diagnosis lane; Gate 0 gains a BROKEN exit; non-git
code-review fast-track made explicit.

**V2.007** — Scheduled reflection. Every 3 engineering rounds, after task
close, the driver appends a reflection entry to the central logbook: fixed
goal preamble + five evidence-based questions (invocation timing / vague
rules / self-invented workarounds / biggest gap to the goal / other). Counting
is tolerant by design; reflections only ever land in the logbook.

**V2.006** — Utilization & continuity, hardened by six real field runs.
Real-skill-first (bundled fallbacks only for uninstalled skills; skipping the
real skill = logged deviation). Task-needed external facts go through the
research form (background agent + cited notes). 15-second mid-execution
self-scan of core triggers. Same-session continuity (full re-read only at
session start / after compact / when unsure). WORKFLOW-ACTIVE marker plus a
standing AGENTS.md hook so a fresh window re-invokes the driver itself. Setup
must precede the first code-touching round. User policy codified: spend
tokens before asking a human — review and verify are never exempted.

**V2.005** — Eval-hardened against three plain-language test prompts (a broken
toggle, a copy-time button, a vague project idea). Chinese short requests
trigger directly; symptom text alone satisfies the bug-lane entry;
pure-understanding tasks enter no lane; doc-only sub-skill replies are
executed inline with a noted substitution; no-verify repos invent a seam
assert + smoke.

**V2.004** — Logging is part of task close, not user-prompted: one entry per
task (delivered/STOP/BLOCKED) in the central logbook; cross-round tasks log
once at close; no-skill rounds note the reason. Task-vs-round semantics
pinned.

**V2.003** — Central logbook: one shared file (location chosen by the
installer), 5-aspect entries (what happened / why each skill fired / friction
/ missed-skill self-check / result), append-only, never inside the skill
package.

**V2.002** — Single-trigger full autopilot: cross-round self-bootstrap, 8 core
skills with entry conditions + deliverable contracts (rest via a
four-question template), delivery gate for non-coders (one-sentence summary +
hand-check list + pasted verify output), HTML dashboard dropped, light trace
files, friction-only logging, self-evolution gate (propose only, never
self-edit).

**V2.001** — Baseline: the slimmed driver (trigger table + resume rules,
history archived, rule details split into `references/`).
