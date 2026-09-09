# self-answer — AFK 自答与 STOP

> 来源：瘦身前 SKILL.md §2（第 449–540 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 2. Self-answer policy (what makes this autopilot)

`grill-with-docs` / `grilling` normally interview the user. Here the user is
AFK: work the design tree in rounds but answer each frontier question yourself:

1. Repo, docs, or code already say it → take that, cite the file.
2. A tracker issue, spec, or ADR constrains it → take the constrained option.
3. Genuinely open → smallest reversible option, record as ADR, keep going —
   EXCEPT numeric self-answers (damage, cooldown, price, threshold): check
   each against the red-line anchors first; any breach → `NEEDS-HUMAN.md`,
   never ADR-and-continue. Finding facts is your job (explore, dispatch
   subagents); decisions default per this list.

**Irreversible list** (save format, core loop, numeric system, glossary term,
release branch, version/engine declaration, locked content manifest, new
system/dependency/pipeline/ external service/cost/compliance — whether inside
or outside the request):
involving any item with no covering ADR/red-line → forced `grilling` (HITL)
ticket, no self-answered ADR. Locked-manifest growth (e.g. a "30 items"
content lock becoming 31): allowed only with the reason recorded inline in the
manifest itself, plus every dependent counter (achievements, docs, counts)
migrated in the same change — a partial migration is a red-line breach.
Prototype-gated items need a passing prototype
before collapse. In-request new pipelines (mobile port + IAP SDK) STOP after
charting: keep the map, ban Collapse/Build.

**History rule.** Milestone/roadmap history rows are append-only records: never
rewrite what a milestone claimed at its time — annotate current status beside
it ("30 at M3; 31 now"). The present-tense pointers (README index, plan
manifest, BALANCE) always state the CURRENT count.

**Termination.** Grill ≤ 2 rounds; unconverged third round → `NEEDS-HUMAN.md`.
Per wayfinder ticket ≤ 2 resolve rounds; two consecutive unconverged tickets →
whole effort STOP. Review blocks only on hard violations (red build, red-line
breach, behaviour opposite the spec); smells are logged, not fixed in-lane.

**Ticket Status lifecycle (v7).** `needs-triage` → (`claimed` while worked) →
exactly one terminal state: `resolved` (Answer recorded, evidence cited),
`ready-for-human` (AFK work complete, a human pick/act remains — ticket MUST
point at its `NEEDS-HUMAN.md` / `BLOCKED.md`), or `wontfix` (with reason).
`needs-info` is a waiting-room, never a resolve: a ticket parked for a human
pick carries `ready-for-human`, not `needs-info` (iter121: combo03's pick was
recorded as needs-info and the map had to re-explain it — the Status line
lied). `resolved` with an open human pick inside is a contradiction; the
verifier for this is grep-level: no `resolved` ticket may contain an
unanswered "HUMAN DECISION NEEDED" / unpicked candidate list.

**Blocking semantics (v7).** `Blocked by:` lists true data dependencies only
(code facts or numbers this ticket consumes). A ticket whose work needs no
input from its listed blocker is a pseudo-dependency: resolve out of order
with a one-line note in the ticket, keep the listed blocker gating collapse
only (iter119: combo04's reader inventory needed nothing from the decay
formula, so it resolved ahead with the note; 03 still gates collapse).
Charting-time "combo-related therefore blocked-by" guesses do not bind
resolve order — re-check at claim time.

**Comment-truth rule (v7).** A code comment asserting visible behaviour
("shown dimmed", "audible cue", "logged") is a claim about the product, not
about intent: Gate 0 treats comment-vs-implementation mismatch as a finding
(iter117: `ward.gd` had no dim branch, so silent wards were invisible despite
the comment). The fix ticket closes the gap in either direction (implement
the behaviour OR delete the comment), and the ticket's Answer cites which.
No lane may quote a behaviour comment as evidence without checking the code
it describes. Verifier is grep-level: search behaviour verbs
(`shown|dimmed|audible|logged|displayed`) in comments, then confirm each
hit's implementation exists (iter125: full-sweep found only the closed
ward-dim comment plus a `shown` local-var false positive).

**JOURNAL draft discipline (v7).** A `## 发布后迭代#NNN` entry drafted in
the worktree but uncommitted is not iteration NNN — it is a draft. Two
commits must never share one iteration number (iter121 landed twice:
`0e32f78` half-round and `67fdb63` close-out — the second commit re-used
the number with a different scope note). If a committed entry's scope turns
out partial, the follow-up takes the NEXT number and cites the earlier one
("补账 iter121" → iter122), never rewrites the committed entry's meaning.
Before committing, grep JOURNAL for the number: exactly one entry.

STOP and write `.scratch/<slug>/NEEDS-HUMAN.md`, then end the turn, when:

- The step deletes data, rewrites published history, publishes/deploys
  externally, spends money, rotates credentials, touches compliance / legal /
  store submission, contradicts a verified version/engine declaration, or
  upgrades engine/dependencies.
- It introduces a new system, dependency, pipeline, runner, external service,
  cost, or compliance surface — inside or outside the request. Adopting a test
  framework or CI counts. A single gitignored throwaway assert script plus a
  handful of fixtures does NOT (whitelist, see §4).
- Two options are both irreversible and the repo gives no signal.

Otherwise: no questions, no hedging. Record the call (spec, ticket, or ADR)
and continue.

**Token-for-human principle (V2.006, user policy).** The user has plenty of
tokens and does not want to be involved: whenever extra tokens can replace a
human step — more verification runs, a background research agent, a wider
self-scan, re-running the suite twice — spend the tokens. Human involvement
is reserved for the STOP list only (destructive, externally visible, two
irreversibles, or information no amount of tokens can find). Never trim
verification, review, or research to save tokens.

