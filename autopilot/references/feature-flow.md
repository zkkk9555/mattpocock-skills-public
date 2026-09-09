# Feature flow (Lane B, bundled fallback)

Well-scoped feature or refactor that fits in one session. Prefer the installed
`grill-with-docs`, `to-spec`, `implement`, `tdd`, `code-review` skills via the
Skill tool; this file is the fallback order if any is missing.

1. **Grill (self-answered, ≤2 rounds).** Work the design tree (whole frontier
   per round), answering per the SKILL.md self-answer policy. Mandatory checks
   for value/content repos: red-line doc (numbers — breach means STOP, not
   ADR), single-source-of-truth (fix every copy, not just record), i18n +
   save-compat. New terms → spec Glossary (do NOT create `CONTEXT.md`
   eagerly); hard-to-reverse calls → ADR, irreversible-list items → forced
   HITL grilling ticket instead of self-answer.
2. **Spec.** Synthesise into `.scratch/<slug>/spec.md`: Problem / Solution /
   long User-Stories / Implementation Decisions / Testing Decisions (seams
   written here FIRST) / Out of Scope / Glossary / Notes, plus the `Checks:`
   triple (i18n / save / red-line, each Pass/N-A + evidence). Anchor rule:
   one-line anchors (`path :: symbol`) required; large pastes banned.
   Decision-rich prototype snippets allowed trimmed with provenance.
3. **Slices.** 1–3 slices as a checklist inside the spec — no separate ticket
   files. Slice = one independently demoable vertical behaviour (data +
   trigger + verify closed); same-file batch rows = 1 slice; a pure
   horizontal layer is never a slice. More than 3 slices → escalate to Lane C
   (discard the B spec draft, chart a map).
4. **Implement.** One red-green vertical slice at a time at the agreed seams
   (one seam, one test, one minimal implementation; no speculative features;
   refactoring belongs to review). Back up single-line data files before
   editing (one `cp` — string edits on 4KB single-line JSON are fragile).
   Verify command regularly, full suite once.
5. **Review + commit.** Two-axis review of diff vs base: Standards (repo
   standards + Fowler smells as judgement calls, repo overrides; tooling-owned
   rules skipped) + Spec (missing/partial, scope creep, wrong-looking impl,
   each quoted; red-line breach = hard violation). Fix hard violations only;
   log smells. Commit with the decision cited; publishing = `Status:
   ready-for-agent` in the issue file.
