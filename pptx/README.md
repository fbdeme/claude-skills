# claude-pptx-skill

A [Claude Code](https://claude.ai/code) custom command (`/pptx`) that generates professional PowerPoint presentations using **python-pptx**, with consistent design rules baked in.

## What it does

Type `/pptx <description>` in Claude Code and it will:

1. Write a python-pptx script following the design rules
2. Execute it
3. Preview every slide as PNG (via LibreOffice)
4. Fix any layout issues automatically before reporting done

## Design rules enforced

| Rule | Detail |
|------|--------|
| **Text indentation** | Uses native pptx paragraph levels (`buChar`, `marL`, `indent`) — never spaces |
| **Spacing** | `space_before` in pt — never empty paragraphs |
| **Color palette** | NAVY header + BLUE accent + DARK body — ONE highlight color per deck |
| **Table style** | Black borders, white cell background, header row in NAVY |
| **Preview** | LibreOffice → PDF → PNG pipeline, every slide verified |

## Installation

### Option A — User-global (available in every project)

```bash
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/pptx.md \
  https://raw.githubusercontent.com/fbdeme/claude-skills/main/pptx/commands/pptx.md
```

### Option B — Clone and symlink

```bash
git clone https://github.com/fbdeme/claude-skills.git
ln -s $(pwd)/claude-skills/pptx/commands/pptx.md ~/.claude/commands/pptx.md
```

### Option C — Project-level only

```bash
mkdir -p .claude/commands
cp ~/.claude/commands/pptx.md .claude/commands/pptx.md
```

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- `uv` (for running python-pptx without a global install): `pip install uv`
- `libreoffice` (for preview): install via your OS package manager
- `pdftoppm` (poppler): `apt install poppler-utils` / `brew install poppler`

## Usage

```
/pptx Create a 5-slide project kickoff deck with these sections:
      1. Background and goals
      2. Timeline (Gantt-style table, 4 months)
      3. Team and roles
```

```
/pptx Based on /tmp/outline.md, generate a presentation.
      Use company colors: accent=#2E75B6. Save to ~/Desktop/kickoff.pptx
```

## Helper functions included

The skill ships with copy-pasteable helpers:

- `set_para_indent(para, level)` — native pptx bullet formatting
- `add_tb(slide, l, t, w, h, lines)` — textbox with level-aware bullets
- `set_cell_fmt(cell, text, ...)` — table cell with color/bold/align
- `del_shape(shape)` — safe XML removal

## Example output structure

```
Slide 1: Cover (title + date + author)
Slide 2: Agenda / overview table
Slide 3–N: Content slides (title badge + summary table + bullet body + phase column)
Slide N+1: Milestone Gantt table (NAVY header, one accent color)
Slide N+2: Thank you
```

## Contributing

Issues and PRs welcome. If you add support for a new slide type (e.g. chart, image grid), please include a before/after PNG in the PR.

## License

MIT
