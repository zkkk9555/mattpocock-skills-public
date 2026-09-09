#!/usr/bin/env bash
# autopilot installer
# Copies this driver skill (and optionally the 25 upstream workflow skills)
# into your agent skills directory.
# Usage:
#   curl -fsSL <raw install.sh> | bash
#   curl -fsSL <raw install.sh> | bash -s -- --with-upstream
# Env override: AUTOPILOT_SKILLS_DIR=/your/skills/dir
set -euo pipefail

PUB_URL="https://github.com/zkkk9555/autopilot-skill"
UPSTREAM_URL="https://github.com/mattpocock/skills"
DEST="${AUTOPILOT_SKILLS_DIR:-$HOME/.agents/skills}"

echo "==> Target skills dir: $DEST"
mkdir -p "$DEST"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> Downloading autopilot"
curl -fsSL "$PUB_URL/archive/refs/heads/main.tar.gz" -o "$TMP/pub.tar.gz"
tar -xzf "$TMP/pub.tar.gz" -C "$TMP"
rm -rf "$DEST/autopilot"
cp -r "$TMP/autopilot-skill-main/autopilot" "$DEST/autopilot"
echo "    installed -> $DEST/autopilot"

if [ "${1:-}" = "--with-upstream" ]; then
  echo "==> Downloading upstream 25 workflow skills ($UPSTREAM_URL)"
  curl -fsSL "$UPSTREAM_URL/archive/refs/heads/main.tar.gz" -o "$TMP/up.tar.gz"
  tar -xzf "$TMP/up.tar.gz" -C "$TMP"
  count=0
  for d in "$TMP"/skills-main/*/; do
    name="$(basename "$d")"
    [ -f "$d/SKILL.md" ] || continue
    rm -rf "$DEST/$name"
    cp -r "$d" "$DEST/$name"
    count=$((count + 1))
  done
  echo "    installed $count upstream skills -> $DEST"
else
  cat <<'NOTE'

!! Upstream skills are NOT installed yet. The driver drives the 25 workflow
   skills from https://github.com/mattpocock/skills — without them it falls
   back to built-in speed notes (functional, but weaker).
   Install them with one command:

     curl -fsSL <this installer URL> | bash -s -- --with-upstream

NOTE
fi

cat <<'DONE'

==> Done. Restart your agent, then say one sentence, e.g.:
    "The sidebar toggle stopped working — check and fix it."
DONE

# Central logbook: create the first book from the example so the driver has
# somewhere to append from day one (one book per install, language fixed).
LOGBOOK="${AUTOPILOT_LOGBOOK:-$HOME/.autopilot/USAGE-LOG.md}"
if [ ! -f "$LOGBOOK" ]; then
  mkdir -p "$(dirname "$LOGBOOK")"
  PUB_TMP="$(mktemp -d)"
  curl -fsSL "$PUB_URL/raw/refs/heads/main/USAGE-LOG.example.md" -o "$PUB_TMP/head.md" 2>/dev/null || true
  {
    echo "# autopilot 中央使用日志"
    echo ""
    echo "> 本本由安装脚本创建（$(date -u +%Y-%m-%d)）。规则：只追加、不改旧条；每次任务收尾追加一条；升级打水位线。格式见 USAGE-LOG.example.md。"
    echo ""
    if [ -f "$PUB_TMP/head.md" ]; then
      echo "<!-- 格式模板（复制自 USAGE-LOG.example.md，首次条目可照抄）：-->"
      sed -n '/^## <日期>/,/^```$/p' "$PUB_TMP/head.md" | head -n 20
      echo ""
    fi
  } > "$LOGBOOK"
  rm -rf "$PUB_TMP"
  echo "==> Logbook created -> $LOGBOOK"
else
  echo "==> Logbook already exists -> $LOGBOOK (kept)"
fi
