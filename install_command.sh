#!/usr/bin/env bash
set -euo pipefail

# ============================
# Args
# ============================
FORCE=0
PRUNE=0
TARGET_PROJECT=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--force] [--prune] <target-project-path>

Example:
  bash $(basename "$0") ~/work/project-a

Options:
  --force   : 기존 파일/심볼릭 링크가 있으면 덮어씀
  --prune   : Copilot prompts 디렉터리에서 깨진 심볼릭 링크 정리
EOF
}

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --prune) PRUNE=1 ;;
    -h|--help) usage; exit 0 ;;
    *)
      if [[ -z "$TARGET_PROJECT" ]]; then
        TARGET_PROJECT="$arg"
      else
        echo "Unknown argument: $arg"
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$TARGET_PROJECT" ]]; then
  usage
  exit 1
fi

# ============================
# Paths
# ============================
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

COMMANDS_DIR="${REPO_ROOT}/commands"
CLAUDE_MAIN_FILE="${REPO_ROOT}/CLAUDE.md"

COPILOT_PROMPTS_DIR="${TARGET_PROJECT}/.github/prompts"
COPILOT_INSTRUCTIONS_FILE="${TARGET_PROJECT}/.github/copilot-instructions.md"

NAME_JOINER="__"

# ============================
# Helpers
# ============================
log() { printf "%s\n" "$*"; }

ensure_dir() {
  mkdir -p "$1"
}

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

# ============================
# 1) Copilot instructions
# ============================
install_copilot_instructions() {
  log "== Copilot instructions =="

  if [[ ! -f "$CLAUDE_MAIN_FILE" ]]; then
    log "Skip: CLAUDE.md not found in central repo"
    return
  fi

  ensure_dir "$(dirname "$COPILOT_INSTRUCTIONS_FILE")"

  local target_rel
  target_rel="$(relpath "$CLAUDE_MAIN_FILE" "$(dirname "$COPILOT_INSTRUCTIONS_FILE")")"

  if safe_ln_s "$target_rel" "$COPILOT_INSTRUCTIONS_FILE"; then
    log "Linked: .github/copilot-instructions.md -> CLAUDE.md"
  else
    log "Skip: copilot-instructions.md already exists"
  fi
}

# ============================
# 2) Copilot prompt links
# ============================
install_copilot_prompts() {
  log ""
  log "== Copilot prompts =="

  if [[ ! -d "$COMMANDS_DIR" ]]; then
    log "Skip: commands directory not found"
    return
  fi

  ensure_dir "$COPILOT_PROMPTS_DIR"

  while IFS= read -r -d '' src; do
    local rel="${src#${COMMANDS_DIR}/}"  # <group>/<file>.md
    local group="${rel%%/*}"
    local file="${rel#*/}"

    # commands 바로 아래 파일 대비
    if [[ "$rel" == "$file" ]]; then
      group="root"
      file="$rel"
    fi

    local name="${file%.md}"
    local link_name="${group}${NAME_JOINER}${name}.prompt.md"
    local link_path="${COPILOT_PROMPTS_DIR}/${link_name}"

    local target_rel
    target_rel="$(relpath "$src" "$COPILOT_PROMPTS_DIR")"

    if safe_ln_s "$target_rel" "$link_path"; then
      log "Linked: prompts/${link_name}"
    else
      log "Skip: prompts/${link_name} already exists"
    fi
  done < <(find "$COMMANDS_DIR" -type f -name "*.md" -print0)

  if [[ "$PRUNE" -eq 1 ]]; then
    log ""
    log "== Prune broken prompt links =="
    while IFS= read -r -d '' lnk; do
      rm -f "$lnk"
      log "Pruned: ${lnk#${TARGET_PROJECT}/}"
    done < <(find "$COPILOT_PROMPTS_DIR" -type l ! -exec test -e {} \; -print0)
  fi
}

# ============================
# Run
# ============================
log "Central repo   : $REPO_ROOT"
log "Target project : $TARGET_PROJECT"
log ""

install_copilot_instructions
install_copilot_prompts

log ""
log "Done."
log "Tip: 새 commands 파일 추가 후 다시 실행하면 자동으로 링크가 보강됩니다."
