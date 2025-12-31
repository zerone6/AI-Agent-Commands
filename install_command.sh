#!/usr/bin/env bash
set -euo pipefail

FORCE=0
PRUNE=0
DO_CLAUDE=0
DO_GEMINI=0
DO_COPILOT=0
SKIP_CONFIRM=0
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
  -y, --yes       Skip confirmation prompt
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
    -y|--yes) SKIP_CONFIRM=1; shift ;;
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
GEMINI_WORKFLOWS_DIR="/Users/seonpillhwang/.gemini/antigravity/global_workflows"

# backup date (MMDDYY format)
BACKUP_DATE=$(date +%m%d%y)
# gemini backup date (MMYYDD format)
GEMINI_BACKUP_DATE=$(date +%m%y%d)

log() { printf "%s\n" "$*"; }
ensure_dir() { mkdir -p "$1"; }

# Backup existing file/symlink before overwriting
backup_file() {
  local file="$1"
  local base_dir="$2"
  local backup_dir="${base_dir}/backup/${BACKUP_DATE}"

  if [[ -e "$file" || -L "$file" ]]; then
    ensure_dir "$backup_dir"
    local filename
    filename="$(basename "$file")"
    if [[ -e "${backup_dir}/${filename}" ]]; then
      rm -rf "${backup_dir}/${filename}"
    fi
    mv "$file" "${backup_dir}/${filename}"
    log "Backed up: $file -> ${backup_dir}/${filename}"
  fi
}

# Check files that will be overwritten
collect_affected_files() {
  local affected=()

  if [[ $DO_CLAUDE -eq 1 ]]; then
    [[ -e "${CLAUDE_DIR}/CLAUDE.md" || -L "${CLAUDE_DIR}/CLAUDE.md" ]] && affected+=("${CLAUDE_DIR}/CLAUDE.md")
    [[ -e "${CLAUDE_DIR}/commands" || -L "${CLAUDE_DIR}/commands" ]] && affected+=("${CLAUDE_DIR}/commands")
  fi

  if [[ $DO_GEMINI -eq 1 ]]; then
    [[ -e "${GEMINI_DIR}/GEMINI.md" || -L "${GEMINI_DIR}/GEMINI.md" ]] && affected+=("${GEMINI_DIR}/GEMINI.md")
  fi

  if [[ $DO_COPILOT -eq 1 && -n "$TARGET_PROJECT" ]]; then
    [[ -e "${COPILOT_DIR}/copilot-instructions.md" || -L "${COPILOT_DIR}/copilot-instructions.md" ]] && \
      affected+=("${COPILOT_DIR}/copilot-instructions.md")
  fi

  printf '%s\n' "${affected[@]}"
}

show_warning_and_confirm() {
  local affected
  affected=$(collect_affected_files)

  echo ""
  echo "========================================"
  echo "  Files will be backed up and replaced"
  echo "========================================"
  echo ""

  if [[ -n "$affected" ]]; then
    echo "The following files will be backed up and replaced:"
    echo "$affected" | while read -r f; do
      [[ -n "$f" ]] && echo "  - $f"
    done
    echo ""
    echo "Backup location:"
    [[ $DO_CLAUDE -eq 1 ]] && echo "  - ~/.claude/backup/${BACKUP_DATE}/"
    [[ $DO_GEMINI -eq 1 ]] && echo "  - ~/.gemini/backup/${BACKUP_DATE}/"
    [[ $DO_COPILOT -eq 1 && -n "$TARGET_PROJECT" ]] && echo "  - ${COPILOT_DIR}/backup/${BACKUP_DATE}/"
    echo ""
  else
    echo "No existing files found. New files will be created."
    echo ""
  fi

  echo "IMPORTANT:"
  echo "  If you have custom agent rules, add them to the origin files"
  echo "  (they will be merged with AGENTS.md during build):"
  echo ""
  [[ $DO_CLAUDE -eq 1 ]] && echo "    - CLAUDE.origin.md   (for Claude rules)"
  [[ $DO_GEMINI -eq 1 ]] && echo "    - GEMINI.origin.md   (for Gemini rules)"
  [[ $DO_COPILOT -eq 1 ]] && echo "    - copilot-instructions.origin.md (for Copilot rules)"
  echo ""
  echo "  Origin files are located in: $REPO_ROOT"
  echo ""
  echo "========================================"
  echo ""

  if [[ "$SKIP_CONFIRM" -eq 1 ]]; then
    log "Skipping confirmation (--yes flag)"
    return 0
  fi

  read -rp "Do you want to proceed? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      log "Aborted."
      exit 0
      ;;
  esac
}

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
  backup_file "${CLAUDE_DIR}/CLAUDE.md" "$CLAUDE_DIR"
  backup_file "${CLAUDE_DIR}/commands" "$CLAUDE_DIR"
  safe_symlink "$CLAUDE_BUILT" "${CLAUDE_DIR}/CLAUDE.md"
  safe_symlink "$COMMANDS_SRC" "${CLAUDE_DIR}/commands"
}

install_gemini() {
  log "== Gemini (Antigravity, global) =="
  ensure_dir "$GEMINI_DIR"
  build_file "$GEMINI_ORIGIN" "$COMMON_RULES" "$GEMINI_BUILT"
  backup_file "${GEMINI_DIR}/GEMINI.md" "$GEMINI_DIR"
  safe_symlink "$GEMINI_BUILT" "${GEMINI_DIR}/GEMINI.md"

  log "== Gemini Workflows (global) =="
  ensure_dir "$GEMINI_WORKFLOWS_DIR"
  while IFS= read -r -d '' file; do
    local folder base target_name target_path
    folder="$(basename "$(dirname "$file")")"
    base="$(basename "$file" .md)"
    target_name="${folder}__${base}.md"
    target_path="${GEMINI_WORKFLOWS_DIR}/${target_name}"

    if [[ -e "$target_path" || -L "$target_path" ]]; then
      local b_dir="${GEMINI_WORKFLOWS_DIR}/backup/${GEMINI_BACKUP_DATE}"
      ensure_dir "$b_dir"
      mv "$target_path" "${b_dir}/${target_name}"
      log "Backed up workflow: $target_name -> ${b_dir}/${target_name}"
    fi

    cp "$file" "$target_path"
    log "Copied workflow: $target_name"
  done < <(find "$COMMANDS_SRC" -mindepth 2 -maxdepth 2 -type f -name '*.md' -print0)
}

install_copilot() {
  log "== GitHub Copilot (repo) =="
  ensure_dir "$COPILOT_DIR"
  ensure_dir "$COPILOT_PROMPTS_DIR"
  build_file "$COPILOT_ORIGIN" "$COMMON_RULES" "$COPILOT_BUILT"
  backup_file "${COPILOT_DIR}/copilot-instructions.md" "$COPILOT_DIR"
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

# Show warning and get confirmation
show_warning_and_confirm

[[ $DO_GEMINI -eq 1 ]] && install_gemini
[[ $DO_CLAUDE -eq 1 ]] && install_claude
[[ $DO_COPILOT -eq 1 ]] && install_copilot

log "Done."
