# siml-skills

> Production-grade AI agent playbooks for ecommerce builders. Extracted from the agent team that runs [**SIML**](https://trysiml.com) — the AI ops console for ecommerce sellers. Works with **any** AI coding agent: Claude Code, OpenAI Codex, Cursor, Windsurf, Aider, Cline, GitHub Copilot, Continue, and anything else that reads a markdown instruction file.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Agents](https://img.shields.io/badge/agents-Claude%20Code%20·%20Codex%20·%20Cursor%20·%20Windsurf%20·%20Aider%20·%20Cline%20·%20Copilot-blue)]()

---

## What you get

| Skill | One-line | What activates it |
|---|---|---|
| [`listing-doctor`](./skills/listing-doctor) | Rewrites product listings per marketplace (Amazon, Shopify, Etsy, TikTok Shop, eBay, Walmart) using the actual structural rules each platform's algorithm rewards. | Product listing content (title / bullets / description) + marketplace mention. |
| [`shopify-developer`](./skills/shopify-developer) | Opinionated Shopify integration patterns — GraphQL-first, HMAC-verified webhooks, idempotency, leaky-bucket rate limiting, App Bridge 4.x, theme app extensions. | `shopify.app.toml`, `@shopify/*` imports, `.liquid` files, or Shopify mention. |

More skills shipping soon (review-mining, Klaviyo campaign authoring, supplier vetting, return-risk scoring).

---

## Why these are the best ecommerce skills you can install

Every skill in this repo was extracted from **real production code** that powers SIML's seven-agent team — not invented for a blog post. Each one earns its slot by meeting all six:

1. **Opinionated, not generic.** Every section says *do X, not Y*, with the reason. Generic "follow best practices" advice doesn't beat the base model; specific rules do.
2. **Production-tested.** These are patterns that survive real Shopify webhooks at scale, real marketplace algorithm changes, real customer escalations. Not toy examples.
3. **Verifiable.** Every API claim links to the authoritative vendor doc. Zero hallucinated endpoints. Zero made-up rate limits.
4. **Anti-patterns called out.** A great skill tells you what to *refuse*, not just what to do. Both skills here refuse explicitly named bad patterns (keyword stuffing, REST-first, hand-rolled OAuth, unverified webhooks, etc.).
5. **Agent-neutral.** The skill content is plain markdown. Whatever agent you use, the rules are the same. Switch tools, keep the playbook.
6. **Maintained.** This is part of SIML's open-source surface area. We dogfood it; we keep it current.

If a skill doesn't pass all six, we don't merge it.

---

## Install — pick your agent

The canonical content lives in [`skills/<name>/SKILL.md`](./skills). Below is the exact command for each major agent. The skill body is the same in every case — only the file location and frontmatter convention change.

<details open>
<summary><h3 style="display:inline">Claude Code (native format)</h3></summary>

One-line installer:

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash
```

Manual:

```bash
git clone https://github.com/SIML-Inc/siml-skills.git
mkdir -p ~/.claude/skills
cp -R siml-skills/skills/* ~/.claude/skills/
```

Verify: open Claude Code, type `/skills`, see `listing-doctor` and `shopify-developer` in the list.

</details>

<details>
<summary><h3 style="display:inline">OpenAI Codex CLI</h3></summary>

Codex reads `AGENTS.md` instruction files. Concatenate the skills you want into a global or per-project file:

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent codex
```

Or manually:

```bash
git clone https://github.com/SIML-Inc/siml-skills.git
mkdir -p ~/.codex
cat siml-skills/skills/*/SKILL.md > ~/.codex/AGENTS.md
```

Per-project (recommended for ecommerce repos):

```bash
cat path/to/siml-skills/skills/*/SKILL.md > ./AGENTS.md
```

</details>

<details>
<summary><h3 style="display:inline">Cursor</h3></summary>

Cursor uses `.cursor/rules/<name>.mdc` files per project. Each skill maps cleanly to one rule file:

```bash
# From your project root
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent cursor
```

Or manually:

```bash
git clone https://github.com/SIML-Inc/siml-skills.git
mkdir -p .cursor/rules
for s in siml-skills/skills/*/SKILL.md; do
  name=$(basename "$(dirname "$s")")
  cp "$s" ".cursor/rules/${name}.mdc"
done
```

The frontmatter in each `SKILL.md` (`name` + `description`) is already Cursor-compatible — Cursor auto-loads the rule when the user's prompt matches the description. Commit `.cursor/rules/` to share with your team.

</details>

<details>
<summary><h3 style="display:inline">Windsurf</h3></summary>

Windsurf reads `.windsurfrules` (project) or `~/.codeium/windsurf/memories/global_rules.md` (global):

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent windsurf
```

Or manually:

```bash
# Project-scoped
cat path/to/siml-skills/skills/*/SKILL.md > .windsurfrules

# Or global
mkdir -p ~/.codeium/windsurf/memories
cat path/to/siml-skills/skills/*/SKILL.md > ~/.codeium/windsurf/memories/global_rules.md
```

</details>

<details>
<summary><h3 style="display:inline">Aider</h3></summary>

Aider loads convention files via `--read`:

```bash
# Per-invocation
aider --read path/to/siml-skills/skills/listing-doctor/SKILL.md

# Or persist via .aider.conf.yml
cat >> .aider.conf.yml <<'EOF'
read:
  - path/to/siml-skills/skills/listing-doctor/SKILL.md
  - path/to/siml-skills/skills/shopify-developer/SKILL.md
EOF
```

</details>

<details>
<summary><h3 style="display:inline">Cline (VS Code)</h3></summary>

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent cline
```

Or manually:

```bash
mkdir -p .clinerules
cp siml-skills/skills/listing-doctor/SKILL.md .clinerules/01-listing-doctor.md
cp siml-skills/skills/shopify-developer/SKILL.md .clinerules/02-shopify-developer.md
```

</details>

<details>
<summary><h3 style="display:inline">Continue.dev</h3></summary>

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent continue
```

Or manually:

```bash
mkdir -p .continue/rules
cp siml-skills/skills/listing-doctor/SKILL.md .continue/rules/listing-doctor.md
cp siml-skills/skills/shopify-developer/SKILL.md .continue/rules/shopify-developer.md
```

</details>

<details>
<summary><h3 style="display:inline">GitHub Copilot</h3></summary>

Copilot reads `.github/copilot-instructions.md` (repo-wide) or `.github/instructions/<name>.instructions.md` (path-scoped):

```bash
curl -fsSL https://raw.githubusercontent.com/SIML-Inc/siml-skills/main/install.sh | bash -s -- --agent copilot
```

Or manually:

```bash
mkdir -p .github/instructions
cp siml-skills/skills/listing-doctor/SKILL.md .github/instructions/listing-doctor.instructions.md
cp siml-skills/skills/shopify-developer/SKILL.md .github/instructions/shopify-developer.instructions.md
```

</details>

<details>
<summary><h3 style="display:inline">Any other agent (ChatGPT, Gemini, custom)</h3></summary>

The skills are pure markdown — paste them as system prompts or persistent custom instructions:

1. Open any `SKILL.md` in the [`skills/`](./skills) directory.
2. Copy the content **including the frontmatter** (it's part of the instruction).
3. Paste into your agent's system prompt / custom instruction / project knowledge slot.

For ChatGPT projects: paste into Project Instructions. For Gemini Gems: paste into Gem instructions. For raw API calls: prepend as a system message.

</details>

---

## How skill content is structured (read this once)

Every skill file follows the same shape so it's portable across agents:

```markdown
---
name: skill-name
description: One sentence on when this skill should activate.
---

# Skill body
- When you activate
- Core principles
- Concrete patterns to reach for
- Anti-patterns to refuse
- Reference docs to verify against
```

The frontmatter is what tells most agents *when* to load the skill. The body is what tells the agent *how to behave* once loaded. Both matter.

---

## Verifying it's working

Pick one of these prompts after install. The agent should follow the skill's playbook (not just generic advice):

| Skill | Prompt to test | What you should see |
|---|---|---|
| `listing-doctor` | *"Rewrite this Amazon listing for a stainless steel water bottle..."* | Title that follows `[Brand] [Type] [Feature] [Size]` formula, 5 bullets with ALL-CAPS benefit prefixes, no promo language. |
| `shopify-developer` | *"Add a webhook handler for `orders/create`."* | Code that verifies HMAC on raw body bytes with `timingSafeEqual`, dedupes via `X-Shopify-Webhook-Id`, returns 200 within 5s. |

If the output looks generic, the skill isn't loaded — re-check the install path for your agent.

---

## Why we're open-sourcing this

These skills are slices of the production agents that run [**SIML**](https://trysiml.com):

- `listing-doctor` is the manual version of how **Riley**, SIML's listings agent, rewrites and cross-posts products across Amazon, Shopify, Etsy, TikTok Shop, eBay, and Walmart automatically.
- `shopify-developer` is the same integration playbook SIML's Shopify channel agent follows when it publishes listings, syncs orders, and verifies webhooks for sellers.

If you find yourself running these skills by hand on every product launch — rewriting the same listing six times, writing the same webhook handler for every new app, drafting the same campaign across Klaviyo and Mailchimp — that's exactly what SIML automates. Same playbooks. Triggered automatically. Approval-gated so nothing ships without you saying yes.

**Try SIML free at [trysiml.com](https://trysiml.com).**

---

## Contributing

We want this collection to stay sharp. Two rules:

1. **Every skill must be opinionated.** Generic advice doesn't beat the base model. Skills earn their slot by encoding *specific patterns that work* and *specific traps to avoid*.
2. **Every claim must be verifiable.** Link to the official vendor docs for any API behavior you reference. No hallucinated endpoints, no invented rate limits.

Open a PR with:

- A new folder under `skills/<your-skill>/` containing a `SKILL.md` with proper frontmatter.
- A one-line entry in this README's table.
- Manual evidence the skill produces better output than the base model (paste a before/after example in the PR description).

---

## License

MIT — see [LICENSE](./LICENSE). Use it, fork it, ship it, sell with it.

Built by [SIML](https://trysiml.com). Tag [@trysiml](https://twitter.com/trysiml) if you build something cool on top. — best, Zuhayr
