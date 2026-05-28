# claude-skills

Personal storage of [Claude Code](https://claude.com/claude-code) skills I've built or collected. Treated as an **archive to pull from on demand** — pick the skills that fit the current project rather than syncing everything everywhere.

## Skills

| Skill | What it does | Depends on |
|---|---|---|
| [`academic-paper-reviewer/`](./academic-paper-reviewer) | Multi-perspective academic paper review. Simulates EIC + 3 peer reviewers + Devil's Advocate with field-specific expertise. Supports full review, re-review (verification), quick assessment, methodology focus, Socratic guided, and calibration modes. | `shared/` |
| [`shared/`](./shared) | Cross-skill reference docs (cross-model verification protocol, handoff schemas, mode spectrum, style calibration). Not a skill on its own — install alongside skills that depend on it. | — |

## Install (per project, recommended)

Drop just the skill(s) you need into the current project's `.claude/skills/`. Claude Code loads anything it finds there for that project only.

**One skill at a time** (replace `<skill-name>` with the directory name above):

```bash
mkdir -p .claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C .claude/skills --strip-components=1 \
      claude-skills-main/<skill-name>
```

**With `shared/` if the skill depends on it:**

```bash
mkdir -p .claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C .claude/skills --strip-components=1 \
      claude-skills-main/<skill-name> \
      claude-skills-main/shared
```

Example — install `academic-paper-reviewer` (which needs `shared/`) into the current project:

```bash
mkdir -p .claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C .claude/skills --strip-components=1 \
      claude-skills-main/academic-paper-reviewer \
      claude-skills-main/shared
```

Files end up at `.claude/skills/academic-paper-reviewer/...` and `.claude/skills/shared/...`. Commit them to the project repo (or add `.claude/skills/` to `.gitignore`) — your call per project.

## Install (globally, for skills you want everywhere)

If a particular skill is something you use in *every* project, install it at user level instead — `~/.claude/skills/` is picked up by every session:

```bash
mkdir -p ~/.claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C ~/.claude/skills --strip-components=1 \
      claude-skills-main/<skill-name>
```

This is a one-shot copy, not synced. To update later, re-run the same command (it overwrites).

## Updating a skill in a project

Re-run the install command from the project root. It overwrites the existing copy. If you've made local edits you want to keep, commit them first and merge by hand.

## Pushing edits back to this repo

If you improve a skill in a project and want the change reflected in the library:

```bash
# From the project where you edited
cd /path/to/the/cloned-claude-skills
# Replace just the changed skill
rm -rf academic-paper-reviewer
cp -r /path/to/project/.claude/skills/academic-paper-reviewer .
git add -A && git commit -m "..." && git push
```

The repo is the canonical archive; project copies are working copies.

## Adding a new skill

1. Create a top-level directory with `SKILL.md` at its root. Frontmatter must include `name` and `description` (Claude Code matches the description against user intent).
2. If it depends on `shared/`, reference shared files by relative path from `SKILL.md`.
3. Add a row to the table above (including the `Depends on` column).
4. Commit + push.

## License

MIT. See [`LICENSE`](./LICENSE).
