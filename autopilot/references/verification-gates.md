# verification-gates — 验证门

> 来源：瘦身前 SKILL.md §4（第 557–613 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 4. Verification gates (no gate, no done)

- Every code change: run the repo's verify command; full suite once at the
  end. Lane D gate must exercise the seam (harness asserting the behaviour).
  Exception: when the boot crash IS the user symptom, headless boot may serve
  as the Phase-1 signal — but still add one seam assertion, else mark
  gate-blind. gate-blind is Lane-D-diagnosis-only; Build/Collapse ban it.
- No-harness fallback: seam priority is pure function > guard at call site >
  throwaway assert script + smoke run. A gitignored single-file throwaway
  asserting the seam (`red = non-zero exit + signal line, green = 0`) counts
  as red-green, NOT a "new pipeline". Seam-level red may substitute E2E red;
  `BLOCKED.md` only when even seam-level red is unbuildable (time-box: ~2
  rounds / 30 min). Perf gets its own gate: baseline + p95/worst-frame
  threshold + minimal direct-to-stage fixture; if unreachable, file
  trace/bisect + gate-blind instead of faking green.
- Flakes: split seedable RNG (MUST pin) from non-seed nondeterminism (IO
  timing, threads, GC, locale — list all, fix fixture / serialize / retry
  stats). Unpinned seedable-RNG repro rates are invalid; controlled-rate
  non-seed repros are valid. Targets: loop ≤ ~30s, flake rate from ~20 harness
  runs (`100×` is the stress ceiling, not the minimum), glance = 10 minutes.
- Every implement (Lanes B and C; Lane A exempt per §1): `tdd` red-green at
  pre-agreed seams (Testing Decisions first; no test at an unconfirmed seam),
  then `code-review` (Standards + Spec axes, parallel; red-line breach = hard
  violation) before commit.
- Content gates (data/i18n rows): schema-complete (fields/unique-id/bilingual
  non-empty) + count assertion + `Lang`-key-exists assertion + headless run.
  Per-class minimums: typo → `target==0 / expected>=1`; version strings →
  cross-file consistency; numbers → red-line range check.
- Display-wiring gate (v8): pure format-string/call-site changes (new `%`
  slot, new arg, reordered args — zero behaviour change) carry NO red-green:
  there is no seam to assert red at, and a throwaway asserting "the 7th arg
  exists" proves nothing the smoke run doesn't. The gate is instead: (1)
  bilingual slot parity (every locale's format string has exactly the slots
  the call site passes — count `%` per locale, iter123: cn/en both 7);
  (2) call-site arg alignment (arg count == slot count, types match —
  `%d` gets int); (3) headless smoke run (a `%`/arg mismatch crashes or
  misrenders at draw time, so smoke IS the seam test). Record all three in
  the ticket/NOTES; mismatch in (1)/(2) is a hard violation (same weight as
  red-line breach in review).
- Every bug fix: Phase-1 loop re-run green + regression test passes (or the
  documented no-correct-seam finding) + all `[DEBUG-*]` grepped clean +
  throwaways removed. Regression path: D = `NOTES.md` (diag + repro) → fix
  ticket (Provenance + Acceptance IS the regression) → repo's regression dir
  if any, else throwaway (never adopt a framework silently).
- Anchor rule (overrides the old no-paths ban): specs/tickets MUST carry
  one-line anchors (`path :: symbol`); large pastes banned. Lane D diagnosis
  may carry multiple candidate anchors, converging to one at fix time; a
  documented no-correct-seam finding is exempt but must chain the architecture
  finding. Specs additionally carry `Checks: i18n Pass/N-A + evidence / save
  Pass/N-A + evidence / BALANCE Pass/N-A + evidence` — N/A needs a reason.
- Slice E2E rule: every Lane C vertical slice needs end-to-end demo evidence;
  seam-red is a prerequisite, never the substitute.
- Edit hygiene (v18): before editing, re-read the anchor's ±5 lines and check
  block alignment (`if`/`else`, nesting depth); after editing, re-read the
  hunk before smoking (R59: an `else` shifted one level = parse error caught
  only by smoke — see JOURNAL #192).

## 6. Field-distilled additions (V2.008)

- **No-harness expected-value discipline.** Every invented assertion's
  expected value MUST cite an independent source in the NOTES (contract
  comment / upstream standard behaviour / the user's own words) — never
  derived by running the buggy code. At least one guard assertion must have
  an expectation that differs from the buggy output (the sum(10,-4)
  mis-derivation as 14 was exactly the buggy value; the red gate would have
  "passed" the bug). If the only truth source is an in-file comment, verify
  the contract itself per the comment-truth rule before locking red/green
  to it.
- **Test-registry discipline.** The moment a repo holds ≥2 standalone test
  scripts, create/adopt ONE unified entry (npm test / run-all) and register
  every test there. Every new test file is registered in the same round it
  lands — a test missing from the entry point is an incomplete delivery
  (v1.055 shipped a suite the entry point didn't run; v1.056 had to patch).
  Costly tests (paid APIs, real quotas) are tiered and labelled in the entry
  (free-full / smoke / paid-manual), never silently mixed in.
- **Windows/MSYS notes.** Subprocess tests redirect output to a FILE, not a
  pipe (a .bat's hidden grandchild process holds the pipe write-open and
  communicate() hangs forever). node under MSYS bash cannot
  require('/tmp/…') — cd into the directory and require relatively. Scripted
  edits (str.replace / regex) on files containing real escape characters
  silently no-op — use the Edit tool; when a scripted edit is unavoidable,
  assert the replacement hit count (a zero-match python replace once dropped
  a README version row silently).
- **Chore/metadata commits.** Driver-owned lifecycle files (WORKFLOW-ACTIVE.md,
  DRIVER-PROPOSAL.md, local log pointers) are chore: add/remove without
  bumping the project version, never as a standalone versioned commit — ride
  along with the next real commit or a plain chore commit per repo rules.

## 8. Destructive-guard (V2.011)

Paid for by a real production accident (24 local versions lost when a
SIGTERM hit a stash-triggered gc mid-red-phase):

- **Red-phase rollback prefers file-level backup.** `cp` the files first,
  then revert by hand. Never change git state to obtain red —
  `stash`/`reset`/`rebase`/`checkout --` are banned without a prior
  file-level backup. Before any history-rewriting command, ask "what happens
  if this gets interrupted" — then back up first.
- **Baselines before bulk changes.** Before the first `mv`/rename/batch edit
  of a round, take a count/snapshot baseline (`find . -type f | wc -l`,
  `git status` benchmark before running file-writing "tests"). Reconcile
  after: baseline + delta = final, or explain the gap.
- **Zero-hit means switch approach.** First grep version zero hits →
  constant tables / full dumps / two-way pincer — never bigger regexes.
  When fixing environment bugs, close by asking "which sibling risks share
  this hole" (same-class sweep, not just the one instance).

## 7. Closing audits (V2.009)

Before every commit, run these four cheap greps — each has caught a real
shipped defect in the field:

- **Version-string grep.** Search every version literal touched this round
  (package versions, doc headers, panel banners, footers); all copies must
  agree. Three field misses caught only by this audit.
- **Doc-template placeholders.** No path-shaped placeholder (`X.Y.Z`,
  `YYYY-MM-DD`, unfinished `TODO(path)`) may survive: templates reference
  "see <file>" instead of writing fake paths; the links-gate (below) is its
  machine form.
- **Assertion-string copy-paste.** Never hand-type an assertion string: copy
  it from the product file. Two consecutive red runs were both test-string
  typos, zero product changes.
- **Triple-source expected values.** Every invented expectation is checked
  against three independent sources where available (contract comment /
  sibling code / spec section) and hand-computed once — never derived by
  running the buggy code (see §6 no-harness discipline).

