#!/usr/bin/env bash
# autopilot installer — harness-aware, verifying, idempotent.
# Targets: ~/.agents/skills/ always + detected harness dir (never project-local unless --dir).
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --harness zcode --dry-run
#   curl -fsSL .../install.sh | bash -s -- --slim --dir /my/harness/skills
# Flags: --harness auto|claude|codex|cursor|opencode|zcode|all  --dir PATH
#        --slim (driver only)  --with-upstream (legacy alias, default is full)
#        --logbook PATH | --no-logbook  --dry-run  --uninstall  --yes  -h|--help
# Env: AUTOPILOT_SKILLS_DIR (alias: explicit --dir wins)  AUTOPILOT_LOGBOOK
set -euo pipefail

PUB_URL="https://github.com/zkkk9555/autopilot-skill"
UPSTREAM_URL="https://github.com/mattpocock/skills"
# 25 upstream names, hardcoded manifest for count verification
UPSTREAM_NAMES="ask-matt code-review codebase-design diagnosing-bugs domain-modeling grill-me grill-with-docs grilling handoff implement improve-codebase-architecture prototype research resolving-merge-conflicts setup-matt-pocock-skills tdd teach to-questionnaire to-spec to-tickets triage wait-what wayfinder wizard writing-for-agents"

HARNESS="auto"; DIR=""; SLIM=0; LOGBOOK_ARG=""; NO_LOGBOOK=0; DRY=0; UNINST=0; YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --harness) HARNESS="${2:-auto}"; shift 2;;
    --dir) DIR="${2:-}"; shift 2;;
    --slim) SLIM=1; shift;;
    --with-upstream) shift;; # legacy alias: full install is now the default
    --logbook) LOGBOOK_ARG="${2:-}"; shift 2;;
    --no-logbook) NO_LOGBOOK=1; shift;;
    --dry-run) DRY=1; shift;;
    --uninstall) UNINST=1; shift;;
    --yes) YES=1; shift;;
    -h|--help) sed -n '2,12p' "$0"; echo; echo "Examples:"; echo "  bash install.sh --harness zcode --dry-run"; echo "  bash install.sh --harness zcode"; echo "  bash install.sh --slim --dir /my/harness/skills"; echo "  bash install.sh --uninstall"; exit 0;;
    *) echo "unknown flag: $1 (see --help)"; exit 1;;
  esac
done
[ -n "${AUTOPILOT_SKILLS_DIR:-}" ] && [ -z "$DIR" ] && DIR="$AUTOPILOT_SKILLS_DIR"

harness_dir() { # name -> dir or empty
  case "$1" in
    claude) echo "$HOME/.claude/skills";;
    codex) echo "$HOME/.codex/skills";;
    cursor) echo "$HOME/.cursor/skills";;
    opencode) echo "$HOME/.config/opencode/skills";;
    zcode) echo "$HOME/.zcode/skills";;
  esac
}
detect_harness() { # exactly one strong env signal -> name, else empty
  local found=""
  [ -n "${CLAUDECODE:-}${CLAUDE_CODE_ENTRYPOINT:-}" ] && found="$found claude"
  [ -n "${CODEX_HOME:-}${CODEX_THREAD_ID:-}" ] && found="$found codex"
  [ -n "${CURSOR_AGENT:-}${CURSOR_TRACE_ID:-}" ] && found="$found cursor"
  [ -n "${OPENCODE_CLIENT:-}" ] && found="$found opencode"
  # shellcheck disable=SC2154
  [ -n "${ZCODE_APP_VERSION:-}${ZCODE_SESSION_ID:-}" ] && found="$found zcode"
  set -- $found
  [ $# -eq 1 ] && echo "$1" || echo ""
}

TARGETS="$HOME/.agents/skills"
ask_menu() { # interactive 6-item menu; prints chosen harness or path; silent fallback
  [ -t 0 ] && [ -r /dev/tty ] || return 1
  local det="$1" def=2 i
  [ -n "$det" ] && def=1
  {
    echo "请选择安装位置（默认装通用目录；探测命中标 ★）："
    if [ -n "$det" ]; then echo "1) ★ 检测到：$det ($(harness_dir "$det"))"; else echo "1) 自动检测（未命中）"; fi
    echo "2) 通用目录 (~/.agents/skills/)"
    echo "3) Claude Code (~/.claude/skills/)"
    echo "4) Codex (~/.codex/skills/)"
    echo "5) Cursor (~/.cursor/skills/)"
    echo "6) 自定义路径（输入）"
    printf "请选择 [${def}]: "
  } >/dev/tty
  local ans=""; IFS= read -r ans </dev/tty 2>/dev/null || return 1
  ans="${ans:-$def}"
  case "$ans" in
    1) [ -n "$det" ] && { echo "HARNESS:$det"; return 0; }; return 1;;
    2) echo "HARNESS:generic"; return 0;;
    3) echo "HARNESS:claude"; return 0;;
    4) echo "HARNESS:codex"; return 0;;
    5) echo "HARNESS:cursor"; return 0;;
    6) { printf "请输入 skills 目录完整路径: " >/dev/tty; local p=""; IFS= read -r p </dev/tty 2>/dev/null || return 1; [ -n "$p" ] && { echo "DIR:$p"; return 0; }; return 1; };;
    *) return 1;;
  esac
}
if [ -n "$DIR" ]; then
  TARGETS="$DIR" # explicit dir wins, exclusive
elif [ "$HARNESS" = "all" ]; then
  for h in claude codex cursor opencode zcode; do TARGETS="$TARGETS $(harness_dir $h)"; done
elif [ "$HARNESS" != "auto" ]; then
  d="$(harness_dir "$HARNESS")"; [ -n "$d" ] && [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"
else
  det="$(detect_harness)"
  if [ -t 0 ] || [ -r /dev/tty ]; then
    pick="$(ask_menu "$det" 2>/dev/null)" || pick=""
    case "$pick" in
      HARNESS:generic) :;;
      HARNESS:*) HARNESS="${pick#HARNESS:}"; d="$(harness_dir "$HARNESS")"; [ -n "$d" ] && [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d";;
      DIR:*) TARGETS="${pick#DIR:}";;
      *) [ -n "$det" ] && { d="$(harness_dir "$det")"; [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"; };;
    esac
  elif [ -n "$det" ]; then
    d="$(harness_dir "$det")"; [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"
  fi
fi

ALL_NAMES="autopilot $UPSTREAM_NAMES"
[ "$SLIM" = 1 ] && WANT="autopilot" || WANT="$ALL_NAMES"

if [ "$DRY" = 1 ]; then
  echo "plan: targets:$TARGETS"
  echo "plan: skills: $WANT"
  echo "plan: logbook: $([ "$NO_LOGBOOK" = 1 ] && echo skipped || echo "${LOGBOOK_ARG:-$HOME/.autopilot/USAGE-LOG.md}")"
  exit 0
fi

if [ "$UNINST" = 1 ]; then
  ndirs=$(echo "$TARGETS" | wc -w)
  if [ "$ndirs" -ge 2 ] && [ "$YES" != 1 ]; then echo "refusing: $ndirs targets without --yes"; exit 1; fi
  for t in $TARGETS; do
    case "$t" in /|"$HOME") echo "refusing dangerous target: $t"; exit 1;; esac
    for n in $ALL_NAMES; do [ -e "$t/$n" ] && { rm -rf "$t/$n"; echo "removed $t/$n"; }; done
  done
  echo "kept logbook (uninstall never deletes it)"; exit 0
fi

fetch() { # url outfile: retry 3
  curl -fsSL --retry 3 --retry-all-errors "$1" -o "$2"
}
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
echo "==> Downloading autopilot"
fetch "$PUB_URL/archive/refs/heads/main.tar.gz" "$TMP/pub.tar.gz"
tar -xzf "$TMP/pub.tar.gz" -C "$TMP"
[ -f "$TMP/autopilot-skill-main/autopilot/SKILL.md" ] || { echo "ERROR: driver payload broken"; exit 1; }
if [ "$SLIM" != 1 ]; then
  echo "==> Downloading upstream 25 workflow skills ($UPSTREAM_URL)"
  fetch "$UPSTREAM_URL/archive/refs/heads/main.tar.gz" "$TMP/up.tar.gz"
  tar -xzf "$TMP/up.tar.gz" -C "$TMP" --exclude='skills-main/AGENTS.md' || echo "!! extract warnings, continuing + verifying below"
fi

fail=0
for t in $TARGETS; do
  mkdir -p "$t" || { echo "ERROR: not writable: $t (set AUTOPILOT_SKILLS_DIR)"; exit 1; }
  rm -rf "$t/autopilot"; cp -r "$TMP/autopilot-skill-main/autopilot" "$t/autopilot"
  if [ "$SLIM" != 1 ]; then
    for d in "$TMP"/skills-main/skills/*/*/; do
      name="$(basename "$d")"; [ -f "$d/SKILL.md" ] || continue
      rm -rf "$t/$name"; cp -r "$d" "$t/$name"
    done
  fi
  # verify: driver frontmatter + count
  head -n 5 "$t/autopilot/SKILL.md" | grep -q "^name: autopilot" || { echo "ERROR: $t/autopilot/SKILL.md frontmatter wrong"; fail=1; }
  have=0; missing=""
  for n in $WANT; do
    if [ -f "$t/$n/SKILL.md" ]; then have=$((have + 1)); else missing="$missing $n"; fi
  done
  want_n=$(echo "$WANT" | wc -w)
  if [ "$have" -eq "$want_n" ]; then
    echo "OK $t: required $have/$want_n SKILL.md (plus any new upstream extras)"
  else
    echo "WARNING $t: only $have/$want_n (missing:$missing) — rerun full install"
    [ "$SLIM" = 1 ] || fail=0 # degraded but exit 0; driver alone still works only if autopilot OK
    [ -f "$t/autopilot/SKILL.md" ] || fail=1
  fi
done

if [ "$NO_LOGBOOK" != 1 ]; then
  LOGBOOK="${LOGBOOK_ARG:-${AUTOPILOT_LOGBOOK:-$HOME/.autopilot/USAGE-LOG.md}}"
  if [ ! -f "$LOGBOOK" ]; then
    mkdir -p "$(dirname "$LOGBOOK")"
    { echo "# autopilot 中央使用日志"; echo ""; echo "> 本本由安装脚本创建（$(date -u +%Y-%m-%d)）。规则：只追加、不改旧条；每次任务收尾追加一条；升级打水位线。格式见 USAGE-LOG.example.md。"; echo ""; } > "$LOGBOOK"
    echo "==> Logbook created -> $LOGBOOK"
  else echo "==> Logbook kept -> $LOGBOOK"; fi
fi

echo; echo "==> Done. Restart your agent and check the skill list shows autopilot,"
echo "    then say: \"The sidebar toggle stopped working — check and fix it.\""
[ "$fail" != 0 ] && exit 1 || true
