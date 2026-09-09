# ground-truth — 起点事实

> 来源：瘦身前 SKILL.md §0（第 369–384 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 0. Ground truth first (silent if missing)

1. `AGENTS.md` / `CLAUDE.md` + `docs/agents/*.md` — tracker, labels, domain
   layout. If absent, default to local-markdown (`.scratch/<slug>/`,
   `spec.md`, `issues/NN-<slug>.md`) + single-context (`CONTEXT.md` +
   `docs/adr/`).
2. `README.md` / `CONTRIBUTING.md` / `CODING_STANDARDS.md` — run, verify, and
   style commands. The verify command found here becomes the lane gate.
3. `CONTEXT.md` (+ `CONTEXT-MAP.md`) + `docs/adr/` — vocabulary; use its
   terms, respect decisions, flag contradictions. If `CONTEXT.md` is missing,
   do NOT create it eagerly: park new terms in the spec's Glossary section and
   only call `domain-modeling` for genuinely irreversible vocabulary.
4. Domain red-lines before any value/content change (numbers doc, data-vs-code
   source decision, i18n + save-compat). Record the single source of truth
   when a constant is duplicated — and fix every copy (see §1 Lane A bar).

