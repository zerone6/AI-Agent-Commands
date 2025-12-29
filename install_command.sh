#!/usr/bin/env bash
set -euo pipefail

FORCE=0
PRUNE=0
TARGET_PROJECT=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--force] [--prune] <target-project-path>

Example:
  $(basename "$0") --force ~/GitHub/htarsp_site

Options:
  --force   : 기존 파일/심볼릭 링크가 있으면 덮어씀
  --prune   : Copilot prompts 디렉터리에서 깨진 심볼릭 링크 정리
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --prune) PRUNE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      if [[ -z "$TARGET_PROJECT" ]]; then
        TARGET_PROJECT="$1"
        shift
      else
        echo "Unknown arg: $1"
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$TARGET_PROJECT" ]]; then
  echo "Missing <target-project-path>"
  usage
  exit 1
fi

# Resolve paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

# Central repo inputs
COMMANDS_DIR="${REPO_ROOT}/commands"
CLAUDE_MAIN_FILE="${REPO_ROOT}/CLAUDE.md"

# Copilot outputs (in target project)
COPILOT_PROMPTS_DIR="${TARGET_PROJECT}/.github/prompts"
COPILOT_INSTRUCTIONS_FILE="${TARGET_PROJECT}/.github/copilot-instructions.md"

NAME_JOINER="__"

log() { printf "%s\n" "$*"; }
ensure_dir() { mkdir -p "$1"; }

# macOS에서도 동작하도록 python으로 상대경로 계산
relpath() {
  python3 - <<'PY' "$1" "$2"
import os, sys
print(os.path.relpath(sys.argv[1], start=sys.argv[2]))
PY
}

safe_ln_s() {
  local target="$1"
  local linkpath="$2"

  if [[ -e "$linkpath" || -L "$linkpath" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      rm -rf "$linkpath"
    else
      return 1
    fi
  fi

  ln -s "$target" "$linkpath"
  return 0
}

install_copilot_instructions() {
  log "== Copilot instructions =="

  if [[ ! -f "$CLAUDE_MAIN_FILE" ]]; then
    log "Skip: CLAUDE.md not found in central repo: $CLAUDE_MAIN_FILE"
    return
  fi

  ensure_dir "$(dirname "$COPILOT_INSTRUCTIONS_FILE")"

  local target_rel
  target_rel="$(relpath "$CLAUDE_MAIN_FILE" "$(dirname "$COPILOT_INSTRUCTIONS_FILE")")"

  if safe_ln_s "$target_rel" "$COPILOT_INSTRUCTIONS_FILE"; then
    log "Linked: ${COPILOT_INSTRUCTIONS_FILE#${TARGET_PROJECT}/} -> (central) CLAUDE.md"
  else
    log "Skip: copilot-instructions.md already exists"
  fi
}

install_copilot_prompts() {
  log ""
  log "== Copilot prompts =="

  if [[ ! -d "$COMMANDS_DIR" ]]; then
    log "Skip: commands directory not found: $COMMANDS_DIR"
    return
  fi

  ensure_dir "$COPILOT_PROMPTS_DIR"

  while IFS= read -r -d '' src; do
    local rel="${src#${COMMANDS_DIR}/}"  # <group>/<file>.md  또는 <file>.md
    local group file

    if [[ "$rel" == *"/"* ]]; then
      group="${rel%%/*}"
      file="${rel#*/}"
    else
      group="root"
      file="$rel"
    fi

    local base="${file##*/}"          # name.md
    local name="${base%.md}"          # name
    local link_name="${group}${NAME_JOINER}${name}.prompt.md"
    local link_path="${COPILOT_PROMPTS_DIR}/${link_name}"

    local target_rel
    target_rel="$(relpath "$src" "$COPILOT_PROMPTS_DIR")"

    if safe_ln_s "$target_rel" "$link_path"; then
      log "Linked: .github/prompts/${link_name}"
    else
      log "Skip: .github/prompts/${link_name} already exists"
    fi
  done < <(find "$COMMANDS_DIR" -type f -name "*.md" -print0)

  if [[ "$PRUNE" -eq 1 ]]; then
    log ""
    log "== Prune broken prompt symlinks =="
    while IFS= read -r -d '' lnk; do
      rm -f "$lnk"
      log "Pruned: ${lnk#${TARGET_PROJECT}/}"
    done < <(find "$COPILOT_PROMPTS_DIR" -type l ! -exec test -e {} \; -print0)
  fi
}

log "Central repo   : $REPO_ROOT"
log "Target project : $TARGET_PROJECT"
log ""

install_copilot_instructions
install_copilot_prompts

log ""
log "Done."
