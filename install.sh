#!/usr/bin/env bash
# siml-skills installer — copies every skill in this repo into ~/.claude/skills/.
# Safe to re-run; existing skills are overwritten with the latest version.

set -euo pipefail

REPO_URL="https://github.com/loyaldept/siml-skills.git"
TARGET_DIR="${HOME}/.claude/skills"
TMP_DIR="$(mktemp -d -t siml-skills-XXXXXX)"

cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

echo "→ Cloning siml-skills…"
git clone --depth=1 --quiet "${REPO_URL}" "${TMP_DIR}/repo"

if [[ ! -d "${TMP_DIR}/repo/skills" ]]; then
  echo "✗ Repo layout unexpected — no skills/ directory found."
  exit 1
fi

mkdir -p "${TARGET_DIR}"

echo "→ Installing skills into ${TARGET_DIR}"
for skill_path in "${TMP_DIR}/repo/skills/"*/; do
  skill_name="$(basename "${skill_path}")"
  rm -rf "${TARGET_DIR}/${skill_name}"
  cp -R "${skill_path}" "${TARGET_DIR}/${skill_name}"
  echo "   ✓ ${skill_name}"
done

echo ""
echo "✓ Installed. Restart Claude Code (or run /skills) to see the new skills."
echo "  Skills installed to: ${TARGET_DIR}"
