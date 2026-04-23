# CLAUDE.md — Databricks Typst Presentation Template

## What This Is

A Typst template (`dbrx.typ`) that reproduces the Databricks corporate slide deck. `example.typ` is a full demo presentation showing all slide types.

## Project Structure

```
dbrx.typ          # Template library — all slide functions, colors, layout constants
example.typ       # Example presentation (import dbrx.typ and use its functions)
rfq-kanban.typ    # RFQ Kanban architecture & MLOps presentation (10 slides)
compile.sh        # Build script: bundles fonts + embeds git commit ID
fonts/            # Barlow font family (5 weights) — required for compilation
assets/           # Logos, background images, icons
```

## Building

```bash
./compile.sh example.typ        # → example.pdf
./compile.sh my-deck.typ        # → my-deck.pdf
```

This runs `typst compile` with `--font-path fonts/` and `--input commit_id=<git-hash>`. Typst must be installed (`brew install typst`, currently v0.14.2).

## How Presentations Work

Every `.typ` presentation file follows this pattern:

```typ
#import "dbrx.typ": *

#show: dbrx-presentation.with(
  title: "...", author: "...", subject: "...",
)

#title-slide(title: [...], subtitle: [...], author: [...], date: [...])
#content-slide(title: [...])[body content]
// ... more slides
```

## Slide Functions (defined in dbrx.typ)

| Function | Background | Purpose |
|---|---|---|
| `title-slide` | Red halftone | Opening/cover slide |
| `section-slide` | Red halftone | Section divider |
| `section-slide-dark` | Dark navy + photo | Section divider (variant: 1/2/3) |
| `content-slide` | White | Title + body (most common) |
| `subtitle-content-slide` | White | Title + teal subtitle + body |
| `two-column-slide` | White | Two columns with optional headings |
| `three-column-slide` | White | Three columns with optional headings |
| `box-slide` | White | 2-4 colored category boxes |
| `quote-slide` | Red/dark/teal | Quote with attribution |
| `headline-slide` | Red | Impactful single statement |
| `image-slide` | White | Title + image + caption |
| `pdf-slide` | White | Embedded PDF page (uses muchpdf) |
| `freeform-slide` | White/dark | Manual layout (dark: true for navy) |
| `blank-dark-slide` | Dark navy | Branded blank |
| `blank-white-slide` | White | Branded blank |

## Utilities

- `dbrx-table(columns: ..., header: ..., ..rows)` — branded table with alternating rows
- `dbrx-qr-code(url, width: 5cm, color: dbrx-dark-navy, logo-width: 1cm)` — QR code with DB logo
- `dbrx-mermaid(definition)` — Mermaid diagram with Databricks theme (charcoal edges, brand node classes)

### dbrx-mermaid class names

Use `class NodeId className` in your diagram definition to color nodes:

| Class | Fill | Text | Maps to |
|---|---|---|---|
| `dbrxNavy` | #1b3038 | white | `dbrx-dark-navy` |
| `dbrxRed` | #ff3620 | white | `dbrx-red` |
| `dbrxTeal` | #618793 | white | `dbrx-teal` |
| `dbrxDarkTeal` | #1b5161 | white | `dbrx-dark-teal` |
| `dbrxGreen` | #00b379 | white | `dbrx-green` |
| `dbrxAmber` | #ffab00 | dark | `dbrx-amber` |
| `dbrxGray` | #f2f2f2 | dark | `dbrx-light-gray` |
| `dbrxCrimson` | #98102a | white | `dbrx-crimson` |

Example:
```typ
#dbrx-mermaid("graph LR\nA[Input] --> B[Process] --> C[Output]\nclass A dbrxGray\nclass B dbrxTeal\nclass C dbrxGreen")
```

## Brand Colors (exported variables)

| Variable | Hex | Common use |
|---|---|---|
| `dbrx-dark-navy` | #1b3038 | Dark backgrounds, titles on white |
| `dbrx-red` | #ff3620 | Brand red, accent bars |
| `dbrx-teal` | #618793 | Sub-headings, box fills |
| `dbrx-dark-teal` | #1b5161 | Subtitles, deep accent |
| `dbrx-charcoal` | #3a3838 | Body text on white |
| `dbrx-green` | #00b379 | Positive/success |
| `dbrx-amber` | #ffab00 | Warning/highlight |
| `dbrx-white`, `dbrx-light-gray`, `dbrx-blue-gray`, `dbrx-crimson`, `dbrx-teal-light` | — | See dbrx.typ |

## Layout Constants (exported)

- `slide-width` = 33.867cm, `slide-height` = 19.05cm (16:9)
- `margin-x` = 1.28cm, `margin-top` = 1.014cm

## Typst Dependencies (imported in dbrx.typ)

- `@preview/cades:0.3.1` — QR code generation
- `@preview/muchpdf:0.1.2` — PDF embedding
- `@preview/mmdr:0.1.0` — Mermaid diagrams (used by `dbrx-mermaid`)

Optional (used in example.typ only):
- `@preview/cetz:0.4.2` + `@preview/cetz-plot:0.1.3` — Charts/plots

## Brand Guidelines

- **Font**: Barlow only (bundled in `fonts/`)
- **No bold text**: Hierarchy via font size and color, not weight
- **Color pairing**: One secondary color + primary colors per slide; avoid mixing multiple secondaries
- Content text in `content` blocks is typically rendered in `dbrx-charcoal`; titles in `dbrx-dark-navy`

## Adding Page Numbers

Page numbers are not built into `dbrx.typ`. Add them per-presentation via `set page(foreground:)` after the show rule. This uses Typst's foreground layer (rendered on top of every slide) with `place()` to position the counter in the bottom-right, vertically aligned with the logo. Page 1 (title cover) is typically skipped.

```typ
#show: dbrx-presentation.with(...)

#set page(foreground: context {
  let n = counter(page).get().first()
  let total = counter(page).final().first()
  if n > 1 {
    place(
      bottom + right,
      dx: -1.28cm,
      dy: -0.83cm,
      text(size: 12pt, fill: dbrx-teal)[#n / #total]
    )
  }
})
```

## Key Conventions

- Slide content uses Typst content blocks `[...]`, not strings `"..."`
- Named parameters use kebab-case (e.g., `left-heading`, `box-color`, `text-content`)
- Internal helpers are prefixed with `_` (e.g., `_logo`, `_background-image`)
- `.pdf` files and `.idea/` are gitignored
- Commit messages are concise, imperative, describe the change
- Do not add `\n` inside Mermaid node labels (e.g., `A[line1\nline2]`) — use short single-line labels instead