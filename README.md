# claude-skills

Personal index of [Claude Code](https://claude.com/claude-code) skills and commands I use. **Each native skill lives in its own repo** — this archive curates them, plus keeps pinned snapshots of upstream bundles I rely on.

## Native skills

Each one is a standalone repo. Install with the command on its own README.

| Skill | Repo | What it does |
|---|---|---|
| `academic-paper-reviewer` | [fbdeme/academic-paper-reviewer](https://github.com/fbdeme/academic-paper-reviewer) | Multi-perspective academic paper peer review — EIC + 3 reviewers + Devil's Advocate, field-aware. Full / re-review / quick / methodology-focus / Socratic / calibration modes. (Ships with bundled `shared/` dependency.) |
| `docs-pattern` | [fbdeme/docs-pattern](https://github.com/fbdeme/docs-pattern) | Bootstrap and maintain a five-file project-docs pattern under `docs/` (`current_status` / `history` / `issues` / `todo` / optional `research_method`). Explicit reads/writes only — no hooks. |
| `typed-todo` | [fbdeme/typed-todo](https://github.com/fbdeme/typed-todo) | Cross-project personal task management as a typed property graph — 5 classes (Task/Project/Area/Person/Resource), 7 typed object properties with explicit cardinality, markdown vault at `~/todo/`. Companion to `docs-pattern` (per-project) and `obsidian-wiki` (knowledge): this one manages *intentions*. |

## Native commands (slash commands)

Commands install into `.claude/commands/` instead of `.claude/skills/` and are invoked by typing `/<name>`.

| Command | Repo | What it does |
|---|---|---|
| `/pptx` | [fbdeme/claude-pptx-skill](https://github.com/fbdeme/claude-pptx-skill) | Generate professional PowerPoint via python-pptx with baked-in design rules (NAVY/BLUE single-accent palette, native paragraph-level bullets, table styling, LibreOffice PNG preview). |

## Mirrored bundles (third-party)

Pinned snapshots of upstream skill bundles I use. **Original LICENSE files are preserved inside each subdirectory**; both upstreams are MIT-licensed. These copies are **not auto-synced** — pull from upstream directly if you want the latest.

| Bundle | Upstream | Contains | What it does |
|---|---|---|---|
| [`gstack/`](./gstack) | [garrytan/gstack](https://github.com/garrytan/gstack) | 50+ skills (`autoplan`, `benchmark`, `design-review`, `qa`, etc.) + supporting `bin/` scripts | Garry Tan's opinionated Claude Code stack — 23+ tools playing CEO / Designer / Eng Manager / Release Manager / Doc Engineer / QA roles. Many skills depend on the bundle's own `bin/` scripts, so install the whole `gstack/` rather than cherry-picking individual skill folders. |
| [`obsidian-wiki/`](./obsidian-wiki) | [Ar9av/obsidian-wiki](https://github.com/Ar9av/obsidian-wiki) | ~37 skills under `.skills/` (`llm-wiki`, `skill-creator`, `wiki-*`, `*-history-ingest`) + a Python package `obsidian_wiki/` | Framework for AI agents to maintain a "digital brain" via an Obsidian vault, following Karpathy's LLM Wiki pattern. The skills under `.skills/` are usable standalone; many also expect the Python package + `setup.sh` for full ingestion/sync functionality. |

## Install (per project)

For **native skills/commands**, use the install command on the skill's own README. They publish their own tarballs at the repo root, so the strip-components dance is simpler than going through this archive.

For a **single skill from a mirrored bundle**, pull it out of this archive's tarball:

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

Heads up: gstack skills often call into `gstack/bin/*` scripts; pulling a single gstack skill without `bin/` may leave it half-broken. When in doubt, pull the whole `gstack/` directory.

## Adding a new skill

For a new native skill: spin up a new `fbdeme/<skill>` repo with `SKILL.md` at its root, then add a row to the table above linking to it.

For a new mirrored bundle: drop a snapshot under `<name>/`, preserve the upstream `LICENSE`, and add a row to the bundles table with the upstream link and a one-liner.

## License

MIT for the index itself ([`LICENSE`](./LICENSE)). Mirrored bundles retain their own upstream licenses.
