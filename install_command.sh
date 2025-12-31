#!/usr/bin/env bash
set -euo pipefail

FORCE=0
PRUNE=0
DO_CLAUDE=0
DO_GEMINI=0
DO_COPILOT=0
TARGET_PROJECT=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [options] [<target-project-path>]

Default (no args):
  Install Claude + Gemini (global)

Options:
  --claude        Install Claude only (global ~/.claude)
  --gemini        Install Gemini only (global ~/.gemini)
  --copilot       Install GitHub Copilot (requires <target-project-path>)
  --force         Overwrite existing files/symlinks
  --prune         Prune broken Copilot prompt symlinks
  -h, --help      Show this help

Examples:
  $(basename "$0")
  $(basename "$0") --force
  $(basename "$0") --copilot ~/work/my-project
  $(basename "$0") --claude --gemini
  $(basename "$0") --claude --copilot ~/work/my-project
EOF
}

# args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --prune) PRUNE=1; shift ;;
    --claude) DO_CLAUDE=1; shift ;;
    --gemini) DO_GEMINI=1; shift ;;
    --copilot) DO_COPILOT=1; shift ;;
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

# Default behavior: Claude + Gemini
if [[ $DO_CLAUDE -eq 0 && $DO_GEMINI -eq 0 && $DO_COPILOT -eq 0 ]]; then
  DO_CLAUDE=1
  DO_GEMINI=1
fi

# Validate Copilot requirement
if [[ $DO_COPILOT -eq 1 && -z "$TARGET_PROJECT" ]]; then
  echo "ERROR: --copilot requires <target-project-path>"
  usage
  exit 1
fi

# paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -n "$TARGET_PROJECT" ]] && TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

# common + origins
COMMON_RULES="${REPO_ROOT}/AGENTS.md"
CLAUDE_ORIGIN="${REPO_ROOT}/CLAUDE.origin.md"
COPILOT_ORIGIN="${REPO_ROOT}/copilot-instructions.origin.md"
GEMINI_ORIGIN="${REPO_ROOT}/GEMINI.origin.md"

# built outputs
CLAUDE_BUILT="${REPO_ROOT}/CLAUDE.md"
COPILOT_BUILT="${REPO_ROOT}/copilot-instructions.md"
GEMINI_BUILT="${REPO_ROOT}/GEMINI.md"

# commands
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
    [[ "$cur" == "$src" ]] && return 0
  fi

  remove_existing "$dst" || {
    log "ERROR: Exists: $dst (use --force)"
    exit 1
  }
  ln -s "$src" "$dst"
  log "Linked: $dst -> $src"
}

build_file() {
  local origin="$1"
  local common="$2"
  local out="$3"
  log "Building $(basename "$out")"
  cat "$origin" "$common" > "$out"
}

install_claude() {
  log "== Claude (global) =="
  ensure_dir "$CLAUDE_DIR"
  build_file "$CLAUDE_ORIGIN" "$COMMON_RULES" "$CLAUDE_BUILT"
  safe_symlink "$CLAUDE_BUILT" "${CLAUDE_DIR}/CLAUDE.md"
  safe_symlink "$COMMANDS_SRC" "${CLAUDE_DIR}/commands"
}

install_gemini() {
  log "== Gemini (Antigravity, global) =="
  ensure_dir "$GEMINI_DIR"
  build_file "$GEMINI_ORIGIN" "$COMMON_RULES" "$GEMINI_BUILT"
  local gemini_commands_path="${GEMINI_DIR}/commands"
  sed -i '' "s|{{GEMINI_COMMANDS_PATH}}|$gemini_commands_path|g; s|{{COMMANDS_PATH}}|$gemini_commands_path|g" "$GEMINI_BUILT" || true
  safe_symlink "$GEMINI_BUILT" "${GEMINI_DIR}/GEMINI.md"
  safe_symlink "$COMMANDS_SRC" "${GEMINI_DIR}/commands"
}

install_copilot() {
  log "== GitHub Copilot (repo) =="
  ensure_dir "$COPILOT_DIR"
  ensure_dir "$COPILOT_PROMPTS_DIR"
  build_file "$COPILOT_ORIGIN" "$COMMON_RULES" "$COPILOT_BUILT"
  safe_symlink "$COPILOT_BUILT" "${COPILOT_DIR}/copilot-instructions.md"

  while IFS= read -r -d '' file; do
    local folder base link_name link_path
    folder="$(basename "$(dirname "$file")")"
    base="$(basename "$file" .md)"
    link_name="${folder}__${base}.prompt.md"
    link_path="${COPILOT_PROMPTS_DIR}/${link_name}"

    if [[ -L "$link_path" ]]; then
      local cur
      cur="$(readlink "$link_path" || true)"
      [[ "$cur" == "$file" ]] && continue
    fi

    remove_existing "$link_path" || {
      log "ERROR: Exists: $link_path (use --force)"
      exit 1
    }
    ln -s "$file" "$link_path"
  done < <(find "$COMMANDS_SRC" -mindepth 2 -maxdepth 2 -type f -name '*.md' -print0)

  [[ "$PRUNE" -eq 1 ]] && find "$COPILOT_PROMPTS_DIR" -type l ! -exec test -e {} \; -delete || true
}

log "Repo: $REPO_ROOT"
[[ -n "$TARGET_PROJECT" ]] && log "Target project: $TARGET_PROJECT"

[[ $DO_GEMINI -eq 1 ]] && install_gemini
[[ $DO_CLAUDE -eq 1 ]] && install_claude
[[ $DO_COPILOT -eq 1 ]] && install_copilot

log "Done."
