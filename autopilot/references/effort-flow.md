# Effort flow (Lane C, bundled fallback)

Big or foggy effort spanning sessions. Plan first, build later. Prefer the
installed `wayfinder`, `to-spec`, `to-tickets`, `implement` skills; this file
is the fallback order if any is missing.

1. **Chart (one turn, resolves nothing; 10-minute precheck first).** Name the
   Destination first. If no fog surfaces, stop — treat as Lane B. Else write
   `.scratch/<slug>/map.md` (Destination / Notes / Decisions-so-far /
   Not-yet-specified / Out-of-scope) and child decision tickets
   `issues/NN-<slug>.md` (`Type: research|prototype|grilling|task`, `Status:`,
   `Blocked by:` — wire blocking in a second pass). One Destination per map;
   second intent → second slug. Research serially on solo repos; parallel
   subagents write only their own ticket file. Type picker: outside facts →
   research (AFK); needs something to react to → prototype (with accept
   threshold — subjective work like visual polish MUST have one or BLOCK);
   human-only call → grilling (HITL); manual groundwork → task. Subjective
   tickets without a threshold never collapse.
2. **Resolve (one ticket per turn, frontier-first, ≤2 rounds each).** Claim
   (`Status: claimed`) before work; resolve with the Notes skill (default
   `grilling` + `domain-modeling`); record `## Answer`; mark resolved; append
   gist + pointer to the map. Graduate fog only when sharply statable; close +
   log past-destination tickets as out-of-scope; update/delete invalidated
   ones. Two consecutive unconverged tickets → whole effort STOP. New system /
   dependency / pipeline / service / cost / compliance discovered mid-resolve
   → STOP after charting (keep map, ban Collapse/Build) — the in-request case
   stops too. Stuck → `BLOCKED.md` / `NEEDS-HUMAN.md` per SKILL.md §2.
3. **Collapse (gate: zero open tickets + per-ticket verify declared).**
   Synthesise linked decisions into `spec.md` (with `Checks:` triple), then
   split into tracer-bullet vertical slices (complete path, end-to-end demo
   evidence required, one-window sized) with blocking edges, blockers first,
   one file per ticket. Shared-mutable-state refactors use expand–contract
   (expand → migrate batches → contract). New-mechanism tickets need a passing
   prototype first, else `NEEDS-HUMAN.md`. gate-blind banned here: seam-red is
   prerequisite, never substitute.
   **Parked-collapse (v9).** When every remaining open ticket is
   `ready-for-human` or `needs-triage`-grilling-behind-HITL (AFK ceiling:
   all AFK-workable tickets resolved, rest awaits human picks), the effort
   does NOT sit idle and does NOT fake-collapse. Write the conditional
   collapse plan instead: one `spec.md` skeleton per live candidate branch
   (e.g. combo K1 vs K2 vs K3 vs veto), each with its own slices + per-ticket
   verify, sharing the decided base (01/02/04 answers). Skeletons stay
   un-executed until the pick lands; the pick then deletes the losing
   branches (one commit: pick + prune). A parked-collapse skeleton never
   contains a self-answered numeric pick — that would launder a HITL
   decision through planning language. Verifier is grep-level: every
   parked `spec.md` names its branch in the title and its `NEEDS-HUMAN.md`
   pointer in the header.
4. **Build.** Frontier-order, fresh context per ticket (= new turn seeded only
   by that ticket file), per feature-flow steps for seams/implement/review.
   Never map → implement directly.
