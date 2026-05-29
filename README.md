# claude-skills

Personal storage of [Claude Code](https://claude.com/claude-code) skills I've built or collected. Treated as an **archive to pull from on demand** — pick the skills that fit the current project rather than syncing everything everywhere.

## Skills

### Native (authored here)

| Skill | What it does | Depends on |
|---|---|---|
| [`academic-paper-reviewer/`](./academic-paper-reviewer) | Multi-perspective academic paper review. Simulates EIC + 3 peer reviewers + Devil's Advocate with field-specific expertise. Supports full review, re-review (verification), quick assessment, methodology focus, Socratic guided, and calibration modes. | `shared/` |
| [`docs-pattern/`](./docs-pattern) | Bootstrap and maintain my personal project-docs pattern under `docs/`: `current_status.md`, `history.md`, `issues.md`, `todo.md`, optional `research_method.md`. Each file has a defined responsibility and update rule (no hooks, no auto-injection — explicit reads/writes only). | — |
| [`shared/`](./shared) | Cross-skill reference docs (cross-model verification protocol, handoff schemas, mode spectrum, style calibration). Not a skill on its own — install alongside skills that depend on it. | — |

### Commands (slash commands)

Custom slash commands. Unlike skills, these install into `.claude/commands/` (not `.claude/skills/`) and are invoked by typing `/<name>`.

| Command | What it does | Install to |
|---|---|---|
| [`pptx/`](./pptx) | `/pptx <description>` — generates professional PowerPoint via python-pptx with baked-in design rules (native paragraph-level bullets, `space_before` spacing, NAVY/BLUE single-accent palette, table styling, LibreOffice PNG preview). Ships copy-pasteable helpers (`set_para_indent`, `add_tb`, `set_cell_fmt`, `del_shape`). | `.claude/commands/` |

### Mirrored bundles (third-party)

Pinned snapshots of upstream skill bundles I've used. **Original LICENSE files are preserved inside each subdirectory**; both upstreams are MIT-licensed. Pull from upstream directly if you want the latest — these copies are not auto-synced.

| Bundle | Upstream | Contains | What it does |
|---|---|---|---|
| [`gstack/`](./gstack) | [garrytan/gstack](https://github.com/garrytan/gstack) | 50+ skills (`autoplan`, `benchmark`, `design-review`, `qa`, etc.) + supporting `bin/` scripts | Garry Tan's opinionated Claude Code stack — 23+ tools playing CEO / Designer / Eng Manager / Release Manager / Doc Engineer / QA roles. Many skills depend on the bundle's own `bin/` scripts, so install the whole `gstack/` rather than cherry-picking individual skill folders. |
| [`obsidian-wiki/`](./obsidian-wiki) | [Ar9av/obsidian-wiki](https://github.com/Ar9av/obsidian-wiki) | ~37 skills under `.skills/` (`llm-wiki`, `skill-creator`, `wiki-*`, `*-history-ingest`) + a Python package `obsidian_wiki/` | Framework for AI agents to maintain a "digital brain" via an Obsidian vault, following Karpathy's LLM Wiki pattern. The skills under `.skills/` are usable standalone; many also expect the Python package + `setup.sh` for full ingestion/sync functionality. |

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

**Pulling a single skill out of a mirrored bundle** — adjust `--strip-components` and the path inside the tarball:

```bash
# From gstack/ — path is claude-skills-main/gstack/<skill>, so strip=2
mkdir -p .claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C .claude/skills --strip-components=2 \
      claude-skills-main/gstack/<skill-name>

# From obsidian-wiki/.skills/ — path is claude-skills-main/obsidian-wiki/.skills/<skill>, so strip=3
mkdir -p .claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C .claude/skills --strip-components=3 \
      claude-skills-main/obsidian-wiki/.skills/<skill-name>
```

Heads up: gstack skills often call into `gstack/bin/*` scripts; pulling a single gstack skill without `bin/` may leave it half-broken. When in doubt, pull the whole `gstack/` directory (`--strip-components=1`, select `claude-skills-main/gstack`).

## Install (globally, for skills you want everywhere)

If a particular skill is something you use in *every* project, install it at user level instead — `~/.claude/skills/` is picked up by every session:

```bash
mkdir -p ~/.claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C ~/.claude/skills --strip-components=1 \
      claude-skills-main/<skill-name>
```

This is a one-shot copy, not synced. To update later, re-run the same command (it overwrites).

## Install (commands)

Slash commands under [`pptx/`](./pptx) install into `.claude/commands/`, not `.claude/skills/`:

```bash
# User-global (available in every project)
mkdir -p ~/.claude/commands
curl -sL https://raw.githubusercontent.com/fbdeme/claude-skills/main/pptx/commands/pptx.md \
  -o ~/.claude/commands/pptx.md
```

Then invoke with `/pptx <description>`. See [`pptx/README.md`](./pptx/README.md) for requirements (`uv`, `libreoffice`, `poppler`) and usage.

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
