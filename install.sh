#!/usr/bin/env bash
# siml-skills installer — copies every skill in this repo into the right
# location for your AI agent. Safe to re-run; existing skills are overwritten
# with the latest version.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent cursor
#
# Supported agents (--agent flag):
#   claude-code (default) -> ~/.claude/skills/<name>/SKILL.md
#   codex                 -> ~/.codex/AGENTS.md (concatenated)
#   cursor                -> ./.cursor/rules/<name>.mdc (current directory)
#   windsurf              -> ./.windsurfrules (current directory, concatenated)
#   cline                 -> ./.clinerules/<name>.md (current directory)
#   continue              -> ./.continue/rules/<name>.md (current directory)
#   copilot               -> ./.github/instructions/<name>.instructions.md
#
# For any other agent, copy skills/*/SKILL.md manually — they're plain markdown.

set -euo pipefail

REPO_URL="https://github.com/SIML-Inc/siml-skills.git"
AGENT="claude-code"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    -h|--help)
      sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

TMP_DIR="$(mktemp -d -t siml-skills-XXXXXX)"
cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

echo "-> Cloning siml-skills..."
git clone --depth=1 --quiet "${REPO_URL}" "${TMP_DIR}/repo"

if [[ ! -d "${TMP_DIR}/repo/skills" ]]; then
  echo "x Repo layout unexpected — no skills/ directory found."
  exit 1
fi

install_claude_code() {
  local target="${HOME}/.claude/skills"
  mkdir -p "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/; do
    local name; name="$(basename "${skill_path}")"
    rm -rf "${target}/${name}"
    cp -R "${skill_path}" "${target}/${name}"
    echo "   v ${name} -> ${target}/${name}/"
  done
  echo ""
  echo "v Installed for Claude Code. Restart Claude Code (or run /skills) to see the new skills."
}

install_codex() {
  local target="${HOME}/.codex/AGENTS.md"
  mkdir -p "${HOME}/.codex"
  : > "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    echo "" >> "${target}"
    echo "---" >> "${target}"
    cat "${skill_path}" >> "${target}"
    echo "   v appended $(basename "$(dirname "${skill_path}")")"
  done
  echo ""
  echo "v Installed for OpenAI Codex CLI at ${target}"
}

install_cursor() {
  local target=".cursor/rules"
  mkdir -p "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    local name; name="$(basename "$(dirname "${skill_path}")")"
    cp "${skill_path}" "${target}/${name}.mdc"
    echo "   v ${name} -> ${target}/${name}.mdc"
  done
  echo ""
  echo "v Installed for Cursor in $(pwd)/${target}. Commit .cursor/rules to share with your team."
}

install_windsurf() {
  local target=".windsurfrules"
  : > "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    echo "" >> "${target}"
    echo "---" >> "${target}"
    cat "${skill_path}" >> "${target}"
    echo "   v appended $(basename "$(dirname "${skill_path}")")"
  done
  echo ""
  echo "v Installed for Windsurf at $(pwd)/${target}"
}

install_cline() {
  local target=".clinerules"
  mkdir -p "${target}"
  local i=1
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    local name; name="$(basename "$(dirname "${skill_path}")")"
    cp "${skill_path}" "${target}/$(printf '%02d' $i)-${name}.md"
    echo "   v ${name} -> ${target}/$(printf '%02d' $i)-${name}.md"
    i=$((i+1))
  done
  echo ""
  echo "v Installed for Cline in $(pwd)/${target}"
}

install_continue() {
  local target=".continue/rules"
  mkdir -p "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    local name; name="$(basename "$(dirname "${skill_path}")")"
    cp "${skill_path}" "${target}/${name}.md"
    echo "   v ${name} -> ${target}/${name}.md"
  done
  echo ""
  echo "v Installed for Continue.dev in $(pwd)/${target}"
}

install_copilot() {
  local target=".github/instructions"
  mkdir -p "${target}"
  for skill_path in "${TMP_DIR}/repo/skills/"*/SKILL.md; do
    local name; name="$(basename "$(dirname "${skill_path}")")"
    cp "${skill_path}" "${target}/${name}.instructions.md"
    echo "   v ${name} -> ${target}/${name}.instructions.md"
  done
  echo ""
  echo "v Installed for GitHub Copilot in $(pwd)/${target}"
}

case "${AGENT}" in
  claude-code|claude) install_claude_code ;;
  codex)              install_codex ;;
  cursor)             install_cursor ;;
  windsurf)           install_windsurf ;;
  cline)              install_cline ;;
  continue)           install_continue ;;
  copilot)            install_copilot ;;
  *)
    echo "x Unknown agent: ${AGENT}"
    echo "  Supported: claude-code, codex, cursor, windsurf, cline, continue, copilot"
    echo "  For any other agent, copy skills/*/SKILL.md manually — they're plain markdown."
    exit 1
    ;;
esac
