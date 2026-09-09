#!/usr/bin/env bash
# Render resume.md to PDF through pandoc + typst.
#
#   ./build.sh              build every style
#   ./build.sh modern       build one style
#   ./build.sh --final      copy the chosen style to Jonathan-Chan-Resume.pdf
#
# Requires: pandoc >= 3.x, typst

set -euo pipefail
cd "$(dirname "$0")"

SRC=resume.md
OUT=out
TMP=build
FINAL_STYLE=modern          # which style --final ships
FINAL_NAME="Jonathan-Chan-Resume.pdf"

# Section routing for the two-column style.
SIDEBAR_SECTIONS="Education|Skills|Homelab|Spoken Languages"

mkdir -p "$OUT" "$TMP"

need() { command -v "$1" >/dev/null || { echo "missing: $1" >&2; exit 1; }; }
need pandoc
need typst

# Single-column styles: one pandoc call, typst as the PDF engine.
build_simple() {
  local style=$1
  pandoc "$SRC" --wrap=none \
    --template="styles/${style}.typ" \
    --pdf-engine=typst \
    -o "$OUT/resume-${style}.pdf"
  echo "  $OUT/resume-${style}.pdf"
}

# Two-column style: split the body into two fragments, then compile by hand.
build_twocol() {
  awk -v side="$SIDEBAR_SECTIONS" '
    NR == 1 && /^---$/ { in_yaml = 1; next }
    in_yaml { if (/^---$/) in_yaml = 0; next }
    /^## / {
      title = substr($0, 4)
      target = (title ~ "^(" side ")$") ? "side" : "main"
    }
    target == "side" { print > (tmp "/sidebar.md"); next }
    target == "main" { print > (tmp "/main.md") }
  ' tmp="$TMP" "$SRC"

  pandoc --wrap=none "$TMP/sidebar.md" -t typst -o "$TMP/sidebar.typ"
  pandoc --wrap=none "$TMP/main.md"    -t typst -o "$TMP/main.typ"

  pandoc "$SRC" --wrap=none --template=styles/twocol.typ -t typst -o "$TMP/resume-twocol.typ"
  typst compile "$TMP/resume-twocol.typ" "$OUT/resume-twocol.pdf"
  echo "  $OUT/resume-twocol.pdf"
}

build() {
  case $1 in
    twocol) build_twocol ;;
    *)      build_simple "$1" ;;
  esac
}

case ${1:-all} in
  --final)
    build "$FINAL_STYLE"
    cp "$OUT/resume-${FINAL_STYLE}.pdf" "$OUT/$FINAL_NAME"
    echo "  $OUT/$FINAL_NAME"
    ;;
  all)
    echo "building all styles:"
    for s in classic modern twocol; do build "$s"; done
    ;;
  *)
    build "$1"
    ;;
esac
