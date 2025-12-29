#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Config (필요하면 수정)
# ----------------------------
CLAUDE_GLOBAL_DIR="${HOME}/.claude"

# Repo structure
COMMANDS_DIR="commands"
CLAUDE_MAIN_FILE="CLAUDE.md"

# Copilot targets
COPILOT_PROMPTS_DIR=".github/prompts"
COPILOT_INSTRUCTIONS_FILE=".github/copilot-instructions.md"

# Copilot 링크 파일명: <folder>__<file>.prompt.md
NAME_JOINER="__"

# ----------------------------
# Args
# ----------------------------
FORCE=0
PRUNE=0

usage() {
  cat <<EOF
Usage: $(basename "$0") [--force] [--prune]

  --force   : 기존 심볼릭 링크(또는 파일)가 있으면 덮어씀
  --prune   : Copilot prompts 디렉터리에서 깨진 심볼릭 링크(원본이 없는 링크) 정리
EOF
}

for arg in "${@:-}"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --prune) PRUNE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $arg"; usage; exit 1 ;;
  esac
done

# ----------------------------
# Helpers
# ----------------------------
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "%s\n" "$*"; }

relpath() {
  python3 - <<'PY' "$1" "$2"
import os, sys
src = sys.argv[1]
dst_dir = sys.argv[2]
print(os.path.relpath(src, start=dst_dir))
PY
}

ensure_dir() {
  local d="$1"
  mkdir -p "$d"
}

safe_ln_s() {
  # $1: target, $2: linkpath
  local target="$1"
  local linkpath="$2"

  if [[ -e "$linkpath" || -L "$linkpath" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      rm -rf "$linkpath"
    else
      # 이미 있으면 스킵 (요구사항)
      return 1
    fi
  fi

  ln -s "$target" "$linkpath"
  return 0
}

# ----------------------------
# 1) Claude: ~/.claude -> REPO_ROOT
# ----------------------------
install_claude_link() {
  log "== Claude symlink =="
  log "Target (repo root): $REPO_ROOT"
  log "Link  (~/.claude) : $CLAUDE_GLOBAL_DIR"

  if [[ -e "$CLAUDE_GLOBAL_DIR" || -L "$CLAUDE_GLOBAL_DIR" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      rm -rf "$CLAUDE_GLOBAL_DIR"
    else
      log "Skip: $CLAUDE_GLOBAL_DIR already exists (use --force to replace)"
      return
    fi
  fi

  ln -s "$REPO_ROOT" "$CLAUDE_GLOBAL_DIR"
  log "OK: $CLAUDE_GLOBAL_DIR -> $REPO_ROOT"
}

# ----------------------------
# 2) Copilot: instructions
#    CLAUDE.md -> .github/copilot-instructions.md (symlink)
# ----------------------------
install_copilot_instructions_link() {
  log ""
  log "== Copilot instructions symlink =="

  local src="${REPO_ROOT}/${CLAUDE_MAIN_FILE}"
  local dst="${REPO_ROOT}/${COPILOT_INSTRUCTIONS_FILE}"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if [[ ! -f "$src" ]]; then
    log "Skip: ${CLAUDE_MAIN_FILE} not found in repo root"
    return
  fi

  ensure_dir "$dst_dir"

  # 상대경로 링크
  local target_rel
  target_rel="$(relpath "$src" "$dst_dir")"

  if safe_ln_s "$target_rel" "$dst"; then
    log "Link: ${COPILOT_INSTRUCTIONS_FILE} -> ${CLAUDE_MAIN_FILE}"
  else
    log "Skip: ${COPILOT_INSTRUCTIONS_FILE} already exists"
  fi
}

# ----------------------------
# 3) Copilot: commands/**.md -> .github/prompts/<folder>__<file>.prompt.md
# ----------------------------
install_copilot_prompt_links() {
  log ""
  log "== Copilot prompt symlinks =="

  local src_base="${REPO_ROOT}/${COMMANDS_DIR}"
  local dst_base="${REPO_ROOT}/${COPILOT_PROMPTS_DIR}"

  if [[ ! -d "$src_base" ]]; then
    log "No commands dir: $src_base (skip)"
    return
  fi

  ensure_dir "$dst_base"

  while IFS= read -r -d '' src; do
    local rel="${src#${src_base}/}" # <group>/<name>.md 또는 <name>.md
    local group file

    if [[ "$rel" == *"/"* ]]; then
      group="${rel%%/*}"
      file="${rel#*/}"
    else
      group="root"
      file="$rel"
    fi

    local base="${file##*/}"     # name.md
    local name="${base%.md}"     # name

    local link_name="${group}${NAME_JOINER}${name}.prompt.md"
    local link_path="${dst_base}/${link_name}"

    local target_rel
    target_rel="$(relpath "$src" "$dst_base")"

    if safe_ln_s "$target_rel" "$link_path"; then
      log "Link: ${COPILOT_PROMPTS_DIR}/${link_name} -> ${COMMANDS_DIR}/${rel}"
    else
      log "Skip: ${COPILOT_PROMPTS_DIR}/${link_name} already exists"
    fi
  done < <(find "$src_base" -type f -name "*.md" -print0)

  if [[ "$PRUNE" -eq 1 ]]; then
    log ""
    log "== Prune broken symlinks in ${COPILOT_PROMPTS_DIR} =="
    while IFS= read -r -d '' lnk; do
      rm -f "$lnk"
      log "Pruned: ${lnk#${REPO_ROOT}/}"
    done < <(find "$dst_base" -type l ! -exec test -e {} \; -print0)
  fi
}

# ----------------------------
# Run
# ----------------------------
log "Repo root: $REPO_ROOT"
install_claude_link
install_copilot_instructions_link
install_copilot_prompt_links

log ""
log "Done."
log "Tip: 새 commands 파일 추가 후에는 다시 실행하면 Copilot 링크가 추가됩니다."