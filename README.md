# claude-skills

Personal collection of [Claude Code](https://claude.com/claude-code) skills, kept here so I can pull them onto any machine I work on.

## Skills

| Skill | What it does |
|---|---|
| [`academic-paper-reviewer/`](./academic-paper-reviewer) | Multi-perspective academic paper review. Simulates EIC + 3 peer reviewers + Devil's Advocate with field-specific expertise. Supports full review, re-review (verification), quick assessment, methodology focus, Socratic guided, and calibration modes. |
| [`shared/`](./shared) | Cross-skill reference docs: cross-model verification protocol, handoff schemas, mode spectrum, style calibration. Referenced by `academic-paper-reviewer` (and any future skills that need the same primitives). |

## Install

Skills live in `~/.claude/skills/` (user-level) or `<project>/.claude/skills/` (project-level). Claude Code loads anything it finds there. To install this collection on a new machine, clone the repo once and symlink the skills you want into `~/.claude/skills/`:

```bash
# 1. Clone somewhere persistent
git clone https://github.com/fbdeme/claude-skills.git ~/repos/claude-skills

# 2. Symlink into ~/.claude/skills/
mkdir -p ~/.claude/skills
ln -s ~/repos/claude-skills/academic-paper-reviewer ~/.claude/skills/academic-paper-reviewer
ln -s ~/repos/claude-skills/shared                  ~/.claude/skills/shared

# 3. Pull updates whenever
cd ~/repos/claude-skills && git pull
```

Symlinks (rather than `cp`) so edits in either place stay in sync, and `git pull` is enough to update everywhere.

To install only one skill, symlink just that directory and skip `shared/` if the skill doesn't depend on it. `academic-paper-reviewer` does depend on `shared/`, so install both together.

## Verifying installation

After symlinking, start a new Claude Code session and check that the skill appears in the available-skills list. You can also manually inspect:

```bash
ls -la ~/.claude/skills/
# Should show the symlinks pointing into the cloned repo.
```

## Updating a skill

Edit the file in the cloned repo (not in `~/.claude/skills/`, even though the symlink makes them appear identical). Then:

```bash
cd ~/repos/claude-skills
git add -A && git commit -m "..." && git push
```

Other machines pick up changes with `git pull` — no re-link needed.

## Adding a new skill

1. Create a new top-level directory with a `SKILL.md` at its root. Frontmatter must include `name` and `description` (the `description` is what Claude Code matches against user intent).
2. If the skill depends on docs in `shared/`, reference them by relative path from `SKILL.md`.
3. Add a row to the table above.
4. Commit + push.

## License

MIT. See [`LICENSE`](./LICENSE).
