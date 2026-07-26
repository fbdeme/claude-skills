# claude-skills

Personal index of [Claude Code](https://claude.com/claude-code) skills and commands I use. **Each native skill lives in its own repo** — this archive curates them, plus keeps pinned snapshots of upstream bundles I rely on.

## Native skills

Each one is a standalone repo. Install with the command on its own README.

| Skill | Repo | What it does |
|---|---|---|
| `academic-paper-reviewer` | [fbdeme/academic-paper-reviewer](https://github.com/fbdeme/academic-paper-reviewer) | Multi-perspective academic paper peer review — EIC + 3 reviewers + Devil's Advocate, field-aware. Full / re-review / quick / methodology-focus / Socratic / calibration modes. (Ships with bundled `shared/` dependency.) |
| `claude-state-migrate` | [fbdeme/claude-state-migrate](https://github.com/fbdeme/claude-state-migrate) | Migrate & merge Claude Code's own state — chat sessions (`.jsonl`) + auto-memory (`.md`) — between machines or project scopes without overwriting. Version-aware cwd path-encoding, scope-preserving memory merge with migration banners + perspective translation, optional in-transcript path rewrite. Helper script is dry-run by default. |
| `claude-tmux-ssh` | [fbdeme/claude-tmux-ssh](https://github.com/fbdeme/claude-tmux-ssh) | Durable, auto-named tmux workflow for Claude Code over SSH (Linux/systemd): SSH stays a plain shell, `claude` runs in its own disconnect-surviving tmux session auto-renamed to `claude-<id>` so `tmux ls` matches `claude --resume`. Bundles a user systemd `tmux.service`, a `claude` shell wrapper, and a SessionStart rename hook; idempotent dry-run installer. Companion to `claude-state-migrate`. |
| `docs-pattern` | [fbdeme/docs-pattern](https://github.com/fbdeme/docs-pattern) | Bootstrap and maintain a five-file project-docs pattern under `docs/` (`current_status` / `history` / `issues` / `todo` / optional `research_method`). Explicit reads/writes only — no hooks. |
| `typed-todo` | [fbdeme/typed-todo](https://github.com/fbdeme/typed-todo) | Cross-project personal task management as a typed property graph — 5 classes (Task/Project/Area/Person/Resource), 7 typed object properties with explicit cardinality, markdown vault at `~/todo/`. Companion to `docs-pattern` (per-project) and `obsidian-wiki` (knowledge): this one manages *intentions*. |
| `vast-gpu` | [fbdeme/vast-gpu](https://github.com/fbdeme/vast-gpu) | Rent, drive, and safely tear down [vast.ai](https://vast.ai) GPU instances from a GPU-less machine. One-file `remote.sh` wrapping the `vastai` CLI via `uv` (never installed); code is rsync'd not cloned (no git/vast/HF creds on the box), `uv sync` + a mandatory `cuda: True` check catches silent CPU fallback, detached `setsid` run pattern, and a **verify-before-trust `down`** (destroy `--yes` then re-query the API — a false "destroyed" once ran two idle boxes for hours). Gotchas doc = one wasted rental per rule. |
| `webprotege-selfhost` | [fbdeme/webprotege-selfhost](https://github.com/fbdeme/webprotege-selfhost) | Self-host [WebProtégé](https://github.com/protegeproject/webprotege) (Docker) to browse/visualize an OWL/RDF ontology. Pins `mongo:4.0` (the 2019 image's legacy driver breaks on mongo 5+) and seeds MongoDB for the two things that image needs before it's usable: clear "WebProtégé is not configured properly" (`ApplicationPreferences`) and enable the hidden Sign-up + project create/upload (`RoleAssignments` — account/project creation is RBAC-gated, not config). Ships a TBox+ABox→`.owl` (rdflib) merge helper and a decompiled `internals.md` so the seeds are trustworthy/adaptable. |
| `webprotege-cli` | [fbdeme/webprotege-cli-skill](https://github.com/fbdeme/webprotege-cli-skill) | Drive a self-hosted [WebProtégé](https://github.com/protegeproject/webprotege) from the CLI/agents (the 2019 image has no REST API) and edit OWL ontologies safely. `wp` (Node + Playwright headless browser) does signup/login/list/create-from-file/export/`apply-edits`; `onto` (Python rdflib + owlready2) is a structured, validated edit engine — add classes/properties/individuals/annotations + disjointness/characteristics/inverses, remove, `validate --reason` (auto-relaxes datatypes outside the OWL 2 map), SPARQL, and `diff` (a structural round-trip differential that exits non-zero on silent loss) — that **refuses to reference undeclared entities** (anti-hallucination) and preserves the ontology IRI. Hybrid loop: edit a canonical file, push to WebProtégé with `apply-edits`; the boundary is lossy by design (it silently mangles `@`-literals and drops RDF reification), so verify any round-trip with `onto diff`. Wraps [fbdeme/webprotege-cli](https://github.com/fbdeme/webprotege-cli) (the tool); companion to `webprotege-selfhost`. |

## Native commands (slash commands)

Commands install into `.claude/commands/` instead of `.claude/skills/` and are invoked by typing `/<name>`.

| Command | Repo | What it does |
|---|---|---|
| `/pptx` | [fbdeme/claude-pptx-skill](https://github.com/fbdeme/claude-pptx-skill) | Generate professional PowerPoint via python-pptx with baked-in design rules (NAVY/BLUE single-accent palette, native paragraph-level bullets, table styling, LibreOffice PNG preview). |

## Mirrored bundles (third-party)

Pinned snapshots of upstream skill bundles I use. **Original LICENSE files are preserved inside each subdirectory** (MIT or Apache-2.0). These copies are **not auto-synced** — pull from upstream directly if you want the latest.

| Bundle | Upstream | Contains | What it does |
|---|---|---|---|
| [`gstack/`](./gstack) | [garrytan/gstack](https://github.com/garrytan/gstack) | 50+ skills (`autoplan`, `benchmark`, `design-review`, `qa`, etc.) + supporting `bin/` scripts | Garry Tan's opinionated Claude Code stack — 23+ tools playing CEO / Designer / Eng Manager / Release Manager / Doc Engineer / QA roles. Many skills depend on the bundle's own `bin/` scripts, so install the whole `gstack/` rather than cherry-picking individual skill folders. |
| [`obsidian-wiki/`](./obsidian-wiki) | [Ar9av/obsidian-wiki](https://github.com/Ar9av/obsidian-wiki) | ~37 skills under `.skills/` (`llm-wiki`, `skill-creator`, `wiki-*`, `*-history-ingest`) + a Python package `obsidian_wiki/` | Framework for AI agents to maintain a "digital brain" via an Obsidian vault, following Karpathy's LLM Wiki pattern. The skills under `.skills/` are usable standalone; many also expect the Python package + `setup.sh` for full ingestion/sync functionality. |
| [`ponytail/`](./ponytail) | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | 6 skills under `skills/` (`ponytail`, `ponytail-audit`, `ponytail-review`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`) + LICENSE + README | "Laziest senior dev" anti-over-engineering. A decision ladder that writes the least code that solves the problem, plus repo/diff audits ranking what to `delete`/`shrink`/replace-with-`stdlib`. Skill folders only — the full upstream also ships plugin hooks/commands/MCP for auto-activation. Self-contained markdown skills; usable standalone. |
| [`frontend-design/`](./frontend-design) | [anthropics/skills](https://github.com/anthropics/skills) @ `fa0fa64` (Apache-2.0) | 1 skill, `SKILL.md` at dir root | Anthropic's official anti-"AI slop" design skill: act as an opinionated design lead — ground aesthetics in the subject's world, spend boldness in one place, avoid the three clustered defaults (cream+serif, near-black+neon, broadsheet). |
| [`interface-design/`](./interface-design) | [Dammyjay93/interface-design](https://github.com/Dammyjay93/interface-design) @ `2f9be32` (MIT) | 1 skill (`SKILL.md` + `agents/`) | Craft-first **product UI** design (dashboards/tools/data interfaces — not marketing). Persists decisions to `.interface-design/system.md` so spacing/tokens/component styles survive across sessions; `/interface-design:design-review` for hierarchy audits. |
| [`impeccable/`](./impeccable) | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) @ `4d849eb` v3.9.1 (Apache-2.0) | 1 skill (`SKILL.md` + `reference/` + `scripts/`) | Paul Bakaus' design guidance system: ~20 commands (`craft`, `audit`, `critique`, `polish`, `bolder`, `quieter`, `animate`, `harden`, …) + deterministic anti-pattern detectors (46 rules). Snapshot is the prebuilt plugin skill; upstream also ships hooks/agents via `npx impeccable install`. |
| [`ui-ux-pro-max/`](./ui-ux-pro-max) | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) @ `1307d97` v2.11.0 (MIT) | 1 skill (`SKILL.md` + `data/` CSVs + `scripts/search.py`) | Design-system generator: searchable local DB of 84 UI styles, 192 palettes, 74 font pairings, 98 UX guidelines, 25 chart types across 22 stacks. `scripts/search.py "<query>" --design-system` reasons out a full tailored system (pattern/style/colors/type/anti-patterns). Python stdlib only. |

## Install (per project)

For **native skills/commands**, use the install command on the skill's own README. They publish their own tarballs at the repo root, so the strip-components dance is simpler than going through this archive.

For a **single-skill mirror** (`frontend-design/`, `interface-design/`, `impeccable/`, `ui-ux-pro-max/` — `SKILL.md` at dir root), the dir itself is the skill, so strip=1:

```bash
mkdir -p ~/.claude/skills
curl -sL https://github.com/fbdeme/claude-skills/archive/main.tar.gz \
  | tar xz -C ~/.claude/skills --strip-components=1 \
      claude-skills-main/<skill-name>
```

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
