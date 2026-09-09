# context-hygiene — Lane 上下文

> 来源：瘦身前 SKILL.md §3（第 541–556 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 3. Context hygiene (Lane B vs Lane C vs Lane D)

- Lane B: grill → spec (+ embedded slices) in ONE unbroken window (no
  clear/compact until the spec publishes). The spec file is the seed if a
  fresh turn is ever needed.
- Lane C: the map + child tickets ARE the checkpoints. Charting may compact
  after the map is written; each closed ticket is a compact boundary.
- Lane D: exempt from the single-window rule. Diagnosis writes `NOTES.md`
  only until a fix is approved; commits happen for fixes, one per fix.
- Implement ticket-by-ticket, frontier order (blockers first), FRESH context
  per ticket = a new turn (or subagent) seeded ONLY by that ticket file. Every
  ticket must be self-contained: one-line location anchors required (see §4).
- Never resolve more than one wayfinder decision ticket per turn. Solo repos:
  research serially by default; parallel subagents write only their own ticket
  file, never `map.md` concurrently (the main loop merges).

