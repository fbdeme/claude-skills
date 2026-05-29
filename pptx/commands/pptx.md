Create a PPTX presentation based on the following description:

$ARGUMENTS

---

## How to execute this skill

1. Write a Python script (e.g. `/tmp/make_pptx.py`) using python-pptx following all design rules below
2. Run it: `uv run --with python-pptx python3 /tmp/make_pptx.py`
3. Preview: convert to PDF then PNG via LibreOffice, then Read each slide image
4. If layout issues are found, fix and re-run. Always confirm visually before reporting done.

Preview pipeline:
```bash
libreoffice --headless --convert-to pdf OUTPUT.pptx --outdir /tmp/
pdftoppm -r 150 -png /tmp/OUTPUT.pdf /tmp/preview/slide
```

---

## Design Rules (follow strictly)

### 1. Color palette — ONE accent color only

```python
from pptx.dml.color import RGBColor

NAVY  = RGBColor(0x1a, 0x4a, 0x8a)   # slide headers, table headers
BLUE  = RGBColor(0x1f, 0x75, 0xc4)   # section titles, phase headers (accent)
DARK  = RGBColor(0x33, 0x33, 0x33)   # body text
WHITE = RGBColor(0xff, 0xff, 0xff)   # text on dark backgrounds
# Pick ONE additional accent for highlights (e.g. GREEN_LIGHT for active cells)
# Never use more than one highlight color in a single presentation
```

### 2. Text indentation — paragraph level, NOT spaces

Do NOT simulate indentation with spaces or tab characters.
Use python-pptx paragraph properties (`marL`, `indent`, `buChar`).

```python
from lxml import etree

_NS_A = 'http://schemas.openxmlformats.org/drawingml/2006/main'

def set_para_indent(para, level):
    """
    level = -1 : section header  — no bullet, marL=88900
    level =  0 : 1st-level item  — '-' bullet, marL=457200, indent=-317500 (hanging)
    level =  1 : 2nd-level item  — '-' bullet, marL=914400, indent=-317500 (hanging)
    """
    pPr = para._p.get_or_add_pPr()
    for tag in ('buNone', 'buChar', 'buAutoNum', 'buFont', 'buFontTx'):
        for el in pPr.findall(f'{{{_NS_A}}}{tag}'):
            pPr.remove(el)
    if level < 0:
        pPr.set('marL', '88900')
        pPr.set('indent', '0')
        etree.SubElement(pPr, f'{{{_NS_A}}}buNone')
    else:
        pPr.set('marL', '457200' if level == 0 else '914400')
        pPr.set('indent', '-317500')
        etree.SubElement(pPr, f'{{{_NS_A}}}buChar').set('char', '-')
```

### 3. Spacing — use space_before, not empty paragraphs

```python
from pptx.util import Pt

# Before a section header (except the first): 8pt
p.space_before = Pt(8)

# Between bullet items: 1pt
p.space_before = Pt(1)
```

Never insert an empty `("")` paragraph just to add vertical space. Use `space_before`.

### 4. Textbox helper

```python
from pptx.util import Pt, Emu
from pptx.enum.text import PP_ALIGN

def add_tb(slide, l, t, w, h, lines, align=PP_ALIGN.LEFT):
    """
    lines: list of tuples
        (text, size_pt, bold, RGBColor)
        (text, size_pt, bold, RGBColor, space_before_pt)
        (text, size_pt, bold, RGBColor, space_before_pt, indent_level)

    indent_level: -1=header  0=bullet  1=indented bullet  None=no change
    """
    box = slide.shapes.add_textbox(Emu(l), Emu(t), Emu(w), Emu(h))
    tf  = box.text_frame
    tf.word_wrap = True
    first = True
    for item in lines:
        text, size, bold, color = item[:4]
        sp  = item[4] if len(item) > 4 else 0
        lvl = item[5] if len(item) > 5 else None
        p   = tf.paragraphs[0] if first else tf.add_paragraph()
        first = False
        p.alignment = align
        if sp:
            p.space_before = Pt(sp)
        if lvl is not None:
            set_para_indent(p, lvl)
        r = p.add_run()
        r.text, r.font.size, r.font.bold, r.font.color.rgb = text, Pt(size), bold, color
    return box
```

Usage pattern:
```python
lines = [
    ('Section Title',   12, True,  NAVY, 0,  -1),   # header, no bullet
    ('First point',     10, False, DARK, 1,   0),   # '-' bullet
    ('Sub point',       10, False, DARK, 1,   1),   # '-' indented bullet
    ('Next Section',    12, True,  NAVY, 8,  -1),   # 8pt gap before new section
    ('Another point',   10, False, DARK, 1,   0),
]
add_tb(slide, left, top, width, height, lines)
```

### 5. Table style — black border, white background, ONE accent color

```python
def set_cell_fmt(cell, text, bg=None, fg=DARK, size=10, bold=False,
                 align=PP_ALIGN.CENTER, wrap=True):
    if bg:
        cell.fill.solid()
        cell.fill.fore_color.rgb = bg
    tf = cell.text_frame
    tf.word_wrap = wrap
    para = tf.paragraphs[0]
    para.alignment = align
    run = para.runs[0] if para.runs else para.add_run()
    run.text, run.font.size, run.font.bold, run.font.color.rgb = text, Pt(size), bold, fg
```

Rules:
- Table borders: default python-pptx thin black lines — do not override unless necessary
- Cell background: leave unset (white) unless it is a header or highlighted cell
- Header row: `bg=NAVY, fg=WHITE, bold=True`
- Highlighted/active cell: ONE accent color only — never mix multiple highlight colors
- Empty/inactive cells: no background set

```python
# Good: header row + one accent
for ci, h in enumerate(headers):
    set_cell_fmt(tbl.cell(0, ci), h, bg=NAVY, fg=WHITE, bold=True)
set_cell_fmt(tbl.cell(2, 3), 'Active', bg=BLUE, fg=WHITE)

# Bad: multiple accent colors in same table
# set_cell_fmt(tbl.cell(1,1), '...', bg=GREEN)  ← don't do this if BLUE already used
# set_cell_fmt(tbl.cell(2,2), '...', bg=ORANGE) ← don't do this either
```

### 6. Shape deletion helper

```python
def del_shape(shape):
    shape._element.getparent().remove(shape._element)
```

### 7. Slide size

Standard widescreen: `prs.slide_width=9144000 EMU (10 in)`, `prs.slide_height=5143500 EMU (5.63 in)`
Wide (임재환 style): `W=9887040 (10.83 in)`, `H=6858000 (7.50 in)` — read from base file.

Always use `W, H = prs.slide_width, prs.slide_height` instead of hardcoded values.
Use fractional positioning: `Emu(int(W * 0.08))` rather than absolute EMU values.

---

## Checklist before finishing

- [ ] Ran the script successfully (no errors)
- [ ] Previewed every slide as PNG
- [ ] No text overlap with other shapes
- [ ] Table has at most ONE highlight color
- [ ] Indentation uses `set_para_indent()`, not spaces
- [ ] Spacing uses `space_before`, not empty paragraphs
- [ ] Output file saved to the requested path
