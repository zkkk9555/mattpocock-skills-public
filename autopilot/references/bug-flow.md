# Bug flow (Lane D, bundled fallback)

Discipline for hard bugs. Prefer the installed `diagnosing-bugs` skill; this
file is the fallback order if it is missing. Skip a phase only with a written
justification in `NOTES.md`. Lane D is exempt from the grill→spec→tickets
single-window rule: diagnosis writes `NOTES.md` only until a fix is approved.
Entry requires ≥1 of: user symptom text, repro path, location. Zero-info input
never enters hypothesise — `NOTES.md` attempts + `BLOCKED.md` (needed
log/save/steps) or `NEEDS-HUMAN.md`, then stop. Never self-invent a repro to
satisfy Phase-1. Bugs never go through grill/spec first. Verify-only branch:
when the fix already exists in the workspace (third-party / pre-sheltered),
skip hypothesise/instrument and run morphology A/B (baseline RED vs workspace
GREEN) + the repo's standard suite, then commit with the decision cited.

1. **Feedback loop FIRST.** One command red on THIS bug, green when fixed
   (failing test at seam → CLI + fixture/snapshot → replayed trace →
   throwaway harness → 100×/fuzz ceiling for flakes → bisect/differential →
   HITL script last resort — ordered preference, ~2 rounds / 30 min time-box
   each, don't exhaust blindly). Show invocation + output with the true exit
   code (`PIPESTATUS[0]` under bash pipes — `$?` after a pipe reports the
   last stage, usually tail, and lies about red/green); redact secrets.
   Stash discipline for A/B baselines: stash TRACKED files only (untracked
   throwaways never enter the stash — naming one in the pathspec can fail the
   whole push); never silence the push; echo the exit and re-verify the
   baseline morphology (e.g. grep-count == 0) BEFORE running it. A PASS on an
   unverified baseline is a false negative, not a green.
   Tighten: ~seconds, deterministic, agent-runnable. Separate seedable RNG
   (MUST pin + list all sources) from non-seed nondeterminism (IO timing,
   threads, GC, locale — list, fix fixture / serialize / retry stats).
   No-harness repos: a gitignored single-file throwaway assert (`red =
   non-zero exit + signal line, green = 0`) at the seam counts as red;
   seam-level red may substitute E2E red (diagnosis only). `BLOCKED.md` only
   when even that fails. Real user data is never deleted for repro (fixture
   copies only — deletion triggers STOP).
2. **Reproduce + minimise.** Confirm the USER's symptom (not a neighbour),
   reproducible, signal captured. Cut one element at a time until every
   remainder is load-bearing; the minimal repro becomes the regression test.
3. **Hypothesise.** 3–5 ranked, falsifiable ("If X, then changing Y removes /
   Z worsens it"). Split live-vs-cached / producer-vs-consumer seams first so
   hypotheses don't chase neighbour symptoms.
4. **Instrument.** One variable at a time; debugger/REPL over logs; targeted
   logs tagged `[DEBUG-<id>]`; perf → baseline + p95/worst-frame threshold +
   minimal direct-to-stage fixture, not logs.
5. **Fix.** Regression test BEFORE the fix at a correct seam (real call-site
   pattern; no correct seam IS the finding — flag for architecture). Fail →
   fix → pass → re-run the Phase-1 loop on the original scenario.
6. **Cleanup.** Loop green, regression passes, `[DEBUG-*]` grepped clean,
   throwaways removed, winning hypothesis in the commit message. One commit
   for the fix (diagnosis itself doesn't commit; a synthetic-bug fix that
   restores the baseline with an empty diff commits nothing — NOTES.md only).
   Regression path: `NOTES.md`
   (diag + repro) → fix ticket (Provenance + Acceptance IS the regression) →
   repo regression dir if any, else throwaway.
