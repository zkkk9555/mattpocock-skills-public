# trace-discipline — 追踪纪律

> 来源：瘦身前 SKILL.md §5（第 614–626 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 5. Trace discipline

- One effort per `.scratch/<slug>/` (multi-intent → multiple slugs):
  `spec.md`, `issues/NN-*.md`, `NOTES.md`, `map.md` (Lane C), `BLOCKED.md` /
  `NEEDS-HUMAN.md` when stopped. `.scratch/<slug>/` is committed
  (spec/map/tickets are review artifacts); solo single-branch repos push a
  one-commit-per-ticket linear sequence; diagnosis itself doesn't commit.
- Publishing = writing `Status: ready-for-agent` into the issue file (a file
  line, not a commit attribute).
- Never mix lanes or slugs in one commit. Never invent vocabulary: reuse
  `CONTEXT.md` terms; genuine gaps go to the spec Glossary →
  `domain-modeling`, not synonyms.
- WORKFLOW-ACTIVE marker (V2.006/V2.007, V2.011 counter): at the first engineering round of a task,
  write `.scratch/WORKFLOW-ACTIVE.md` (one line: active slug(s) + start date
  + driver version + `工程轮次: N` + `已反思 M 次`); when a prior task closed this session,
  rebuild the marker with the carried count +1 and the carried reflection count
  (both live in session context — the marker is deleted at every task close, so it is
  rebuilt per task, never updated in place; count and reflection bit die and revive together);
  delete it again when the task
  closes (delivered/STOP/BLOCKED + logbook entry written). The count feeds
  the V2.007 reflection trigger (`references/usage-log.md`). setup
  (`setup-matt-pocock-skills`) adds one standing line to the project's
  AGENTS.md: 若 `.scratch/WORKFLOW-ACTIVE.md` 存在 → 先调 autopilot
  再继续；新任务开局拿不准走哪条路时 → 也先调它分流 — this is how a fresh window re-invokes the driver without the
  user asking, and how an unsure opening routes through T0 without re-reading
  the whole driver (a dozen words, not 8k tokens).
- No-JOURNAL repos (V2.008): when the workspace has no JOURNAL, write the
  `Skills called:` line at the top of the task's NOTES.md so the grep-level
  audit survives (three-round eval precedent).
- External PRs / forks (V2.008): upstream OSS PR work (fork → branch → push →
  CodeRabbit loop) counts as engineering rounds in the WORKFLOW-ACTIVE
  counter; PR follow-up rounds re-using an existing evidence chain stay
  Lane-D-disciplined (reproduce → red → fix → green → reply in review
  thread). Project commit rules (one-commit-per-ticket) apply to the repo's
  own history, not to fork branches — fork history serves the PR.
- Steady-heartbeat rounds (V2.009): when Gate 0 finds no new seam in an AFK
  long task, the round re-runs the unified entry + package-hash check and
  commits nothing. Fresh run-all + hash evidence IS the Gate 0 verdict for
  that round — not idling. Log it as a task entry like any other round.
- Negative evidence (V2.011): proving "absent" needs N zero-hit evidences —
  which places, which keys, how many hits each — never "not found". Three
  zero-hits across independent surfaces outranks one eloquent absence claim.
- T0-no-verdict counter (V2.011): when the T0 ask-matt call returns a generic
  doc with no lane verdict, log `T0 空转第 N 次` in JOURNAL/NOTES. Three
  consecutive no-verdict rounds = a repair signal for skill-creator (the
  ask-matt routing needs fixing), not a driver failure — keep routing via
  prelane self-decision meanwhile.
- Duplicate-PR pre-check (V2.009): before opening any upstream PR — (1) open
  the target issue's timeline and read cross-referenced PRs; (2) search the
  repo for `close #<issue>` / `closes #<issue>`; (3) confirm no OPEN
  competitor PR exists. A closed old attempt is not "nobody is working on
  it". If an OPEN competitor exists, discuss in its thread first instead of
  opening a new PR.
