#!/usr/bin/env bash
set -euo pipefail

FORCE=0
PRUNE=0
TARGET_PROJECT=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--force] [--prune] <target-project-path>

Options:
  --force   기존 심볼릭 링크(또는 파일/폴더)가 있으면 덮어씀
  --prune   Copilot prompts 디렉터리에서 깨진 심볼릭 링크(원본이 없는 링크) 정리
EOF
}

# args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --prune) PRUNE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*)
      echo "Unknown arg: $1"
      usage
      exit 1
      ;;
    *)
      if [[ -n "$TARGET_PROJECT" ]]; then
        echo "Too many args: already have target '$TARGET_PROJECT', got '$1'"
        usage
        exit 1
      fi
      TARGET_PROJECT="$1"
      shift
      ;;
  esac
done

if [[ -z "$TARGET_PROJECT" ]]; then
  echo "Missing <target-project-path>"
  usage
  exit 1
fi

# paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

# common + origins (source of truth)
COMMON_RULES="${REPO_ROOT}/AGENTS.md"

CLAUDE_ORIGIN="${REPO_ROOT}/CLAUDE.origin.md"
COPILOT_ORIGIN="${REPO_ROOT}/copilot-instructions.origin.md"
GEMINI_ORIGIN="${REPO_ROOT}/GEMINI.origin.md"

# build outputs (generated)
CLAUDE_BUILT="${REPO_ROOT}/CLAUDE.md"
COPILOT_BUILT="${REPO_ROOT}/copilot-instructions.md"
GEMINI_BUILT="${REPO_ROOT}/GEMINI.md"

# commands source
COMMANDS_SRC="${REPO_ROOT}/commands"

# targets
CLAUDE_DIR="${HOME}/.claude"
GEMINI_DIR="${HOME}/.gemini"
COPILOT_DIR="${TARGET_PROJECT}/.github"
COPILOT_PROMPTS_DIR="${COPILOT_DIR}/prompts"

log() { printf "%s\n" "$*"; }
ensure_dir() { mkdir -p "$1"; }

remove_existing() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      rm -rf "$path"
    else
      return 1
    fi
  fi
  return 0
}

safe_symlink() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [[ "$cur" == "$src" ]]; then
      return 0
    fi
  fi

  remove_existing "$dst" || {
    log "ERROR: Exists: $dst"
    log "       Use --force to overwrite."
    exit 1
  }
  ln -s "$src" "$dst"
  log "Linked: $dst -> $src"
}

build_file() {
  local origin="$1"
  local common="$2"
  local out="$3"

  if [[ ! -f "$origin" ]]; then
    log "ERROR: Missing origin: $origin"
    exit 1
  fi
  if [[ ! -f "$common" ]]; then
    log "ERROR: Missing common rules: $common"
    exit 1
  fi

  log "Building $(basename "$out") (origin + common)..."
  cat "$origin" "$common" > "$out"
}

# 1) Gemini (Antigravity): global (~/.gemini)
install_gemini_global() {
  log "== Installing Gemini (Antigravity, global) =="
  ensure_dir "$GEMINI_DIR"

  build_file "$GEMINI_ORIGIN" "$COMMON_RULES" "$GEMINI_BUILT"

  # Gemini에서 commands 경로를 명시해야 하는 경우를 위해 placeholder 치환 지원
  # GEMINI.origin.md 안에 {{COMMANDS_PATH}} 또는 {{GEMINI_COMMANDS_PATH}}가 있으면 ~/.gemini/commands로 치환
  local gemini_commands_path="${GEMINI_DIR}/commands"
  if command -v perl >/dev/null 2>&1; then
    perl -0777 -i -pe "s/\{\{GEMINI_COMMANDS_PATH\}\}|\{\{COMMANDS_PATH\}\}/$gemini_commands_path/g" "$GEMINI_BUILT" || true
  else
    # perl이 없다면 sed로 간단 치환 (BSD sed)
    sed -i '' "s|{{GEMINI_COMMANDS_PATH}}|$gemini_commands_path|g; s|{{COMMANDS_PATH}}|$gemini_commands_path|g" "$GEMINI_BUILT" || true
  fi

  safe_symlink "$GEMINI_BUILT" "${GEMINI_DIR}/GEMINI.md"
  safe_symlink "$COMMANDS_SRC" "${GEMINI_DIR}/commands"
}

# 2) Claude: global (~/.claude)
install_claude_global() {
  log "== Installing Claude (global) =="
  ensure_dir "$CLAUDE_DIR"

  build_file "$CLAUDE_ORIGIN" "$COMMON_RULES" "$CLAUDE_BUILT"

  safe_symlink "$CLAUDE_BUILT" "${CLAUDE_DIR}/CLAUDE.md"
  safe_symlink "$COMMANDS_SRC" "${CLAUDE_DIR}/commands"
}

# 3) Copilot: per-repo (.github)
install_copilot_repo() {
  log "== Installing GitHub Copilot (repo) =="
  ensure_dir "$COPILOT_DIR"
  ensure_dir "$COPILOT_PROMPTS_DIR"

  build_file "$COPILOT_ORIGIN" "$COMMON_RULES" "$COPILOT_BUILT"

  safe_symlink "$COPILOT_BUILT" "${COPILOT_DIR}/copilot-instructions.md"

  # create flat prompt links: <folder>__<file>.prompt.md -> commands/<folder>/<file>.md
  local file folder base link_name link_path src_path

  if [[ ! -d "$COMMANDS_SRC" ]]; then
    log "ERROR: Missing $COMMANDS_SRC"
    exit 1
  fi

  while IFS= read -r -d '' file; do
    folder="$(basename "$(dirname "$file")")"
    base="$(basename "$file" .md)"
    link_name="${folder}__${base}.prompt.md"
    link_path="${COPILOT_PROMPTS_DIR}/${link_name}"
    src_path="$file"

    if [[ -L "$link_path" ]]; then
      local cur
      cur="$(readlink "$link_path" || true)"
      if [[ "$cur" == "$src_path" ]]; then
        continue
      fi
    fi

    remove_existing "$link_path" || {
      log "ERROR: Exists: $link_path"
      log "       Use --force to overwrite."
      exit 1
    }
    ln -s "$src_path" "$link_path"
  done < <(find "$COMMANDS_SRC" -mindepth 2 -maxdepth 2 -type f -name '*.md' -print0)

  log "Copilot prompts linked under: $COPILOT_PROMPTS_DIR"

  if [[ "$PRUNE" -eq 1 ]]; then
    log "Pruning broken symlinks in $COPILOT_PROMPTS_DIR ..."
    find "$COPILOT_PROMPTS_DIR" -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
  fi
}

log "Building and deploying instructions..."
log "Repo:   $REPO_ROOT"
log "Target: $TARGET_PROJECT"

install_gemini_global
install_claude_global
install_copilot_repo

log ""
log "Done. 공통 규칙(AGENTS.md)과 IDE별 특화 지침(*.origin.md)이 병합되어 배포되었습니다."
