# siml-skills

> Claude Code skills for ecommerce builders. Drop them into `~/.claude/skills/` and Claude gets sharply better at writing product listings and shipping Shopify integrations.

Built and open-sourced by [SIML](https://trysiml.com) — the AI ops console for ecommerce sellers.

---

## What's in here

| Skill | What it does |
|---|---|
| [`listing-doctor`](./skills/listing-doctor) | Rewrites product listings for the specific marketplace they're going on. Knows Amazon's title formula, Shopify's SEO conventions, Etsy's tag rules, TikTok Shop's hook patterns, and eBay's keyword-density expectations. Auto-loads when Claude sees a product title / description / bullets and you ask for help. |
| [`shopify-developer`](./skills/shopify-developer) | Makes Claude an opinionated Shopify integrator. Activates when the repo has `shopify.app.toml`, `@shopify/*` imports, or `.liquid` files. Pushes you toward the GraphQL Admin API, leaky-bucket rate limiting, HMAC-verified webhooks, idempotent handlers, App Bridge action subjects, and the modern theme app extension pattern. |

More to come. PRs welcome — see [Contributing](#contributing).

---

## Install

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/loyaldept/siml-skills/main/install.sh | bash
```

This copies every skill in this repo into `~/.claude/skills/`. Re-run any time to pull updates.

### Manual

```bash
git clone https://github.com/loyaldept/siml-skills.git
cd siml-skills
mkdir -p ~/.claude/skills
cp -R skills/* ~/.claude/skills/
```

### Project-scoped (only this codebase)

If you only want a skill active inside one project:

```bash
mkdir -p /path/to/your/project/.claude/skills
cp -R skills/listing-doctor /path/to/your/project/.claude/skills/
```

Claude Code loads skills from both `~/.claude/skills/` (user-wide) and `<project>/.claude/skills/` (per-project).

---

## How Claude Code skills work

A skill is a single `SKILL.md` file inside a folder. The file has frontmatter:

```markdown
---
name: skill-name
description: One sentence on when this skill should be loaded.
---

# Body of the skill — instructions Claude follows when this skill is active.
```

Claude reads every skill's frontmatter on startup. When your prompt or the current task matches a skill's `description`, Claude loads the body and follows it. You don't need to invoke skills manually — Claude picks the relevant one based on context.

Read more: [Claude Code skills documentation](https://docs.claude.com/en/docs/claude-code).

---

## Verifying installation

After installing, open Claude Code and run:

```
/skills
```

You should see `listing-doctor` and `shopify-developer` in the list. Trigger them by asking something matching their description, e.g.:

- *"Rewrite this Amazon listing"* → loads `listing-doctor`
- *"Add a Shopify webhook handler that verifies HMAC"* → loads `shopify-developer`

---

## Contributing

We want this collection to stay sharp. Two rules:

1. **Every skill must be opinionated.** Generic advice doesn't beat the base model. Skills earn their slot by encoding *specific patterns that work* and *specific traps to avoid*.
2. **Every claim must be verifiable.** Link to the official vendor docs for any API behavior you reference. No hallucinated endpoints, no made-up rate limits.

Open a PR with:

- A new folder under `skills/<your-skill>/`
- A `SKILL.md` with proper frontmatter
- A one-line entry in this README's table
- Manual evidence the skill works (paste a before/after example in the PR description)

---

## License

MIT — see [LICENSE](./LICENSE). Use it, fork it, ship it.

If you build something cool on top, we'd love to see it: tag [@trysiml](https://twitter.com/trysiml).
