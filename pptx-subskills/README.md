# pptx-subskills — content-quality sub-skill library for `/pptx`

Companion library for [fbdeme/claude-pptx-skill](https://github.com/fbdeme/claude-pptx-skill)'s **§0 content-structure gate**. The gate acts as a coordinator; at each stage it loads only the file it needs from these upstream skills (sub-agent-style progressive loading — do not preload everything).

Install location assumed by the coordinator: `~/.claude/skills/pptx-subskills/<name>/`.

## Stage → file map

| Stage | Source | What to load |
|---|---|---|
| 0.1 Deck brief | [addsumtech/slides_maker](https://github.com/addsumtech/slides_maker) @ `fa666c3` (MIT, **mirrored here**) | `skills/slide-maker/agents/content-planner.md` (comprehension brief, claim ledger), `references/content-plan-spec.md`, word-count checker `scripts/plan_wordcount.py` |
| 0.2 Titles / governing messages | [nraford7/Narrative-Engine](https://github.com/nraford7/Narrative-Engine) @ `3a7aa75` (**no license — not mirrored; clone from upstream**) | `deck-title-craft.md` (8 headline rules), `checklists.md` (failure modes, banlist) |
| 0.2 Outline approval gate | [Gabberflast/academic-pptx-skill](https://github.com/Gabberflast/academic-pptx-skill) @ `9f2b703` (MIT, **mirrored here**) | `SKILL.md` + `content_guidelines.md` + `slide_patterns.md` (assertion-evidence, ~40-word budget, cover tests, academic deck architecture) |
| 0.3 Vertical logic / storyboarding | [appautomaton/presentation](https://github.com/appautomaton/presentation) @ `3a39938` (**no license — not mirrored; clone from upstream**) | `consultant/references/method/communication.md`, `deck-design-pdf/SKILL.md` (ghost-deck gates), `deck-design-pdf/density-adaptation.md` (L1/L2 tables) |
| 0.4 Diagram / template choice | [seulee26/mckinsey-pptx](https://github.com/seulee26/mckinsey-pptx) @ `201ef49` (MIT, **mirrored here**) | `mckinsey_pptx/agent/CATALOG.md` (40 templates + selection logic); the Python package builds real decks (`PresentationBuilder`) |

Mirrored copies are pinned snapshots, not auto-synced. Original LICENSE files are preserved in each mirrored subdirectory. For the two unlicensed upstreams, clone directly:

```bash
cd ~/.claude/skills/pptx-subskills
git clone --depth 1 https://github.com/nraford7/Narrative-Engine
git clone --depth 1 https://github.com/appautomaton/presentation
```

Background research (why these five, what converged across 40+ sources): see the §0 section of claude-pptx-skill's `commands/pptx.md`.
