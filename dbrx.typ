// ==========================================================================
// Databricks Corporate Presentation Template for Typst
// ==========================================================================

#import "@preview/cades:0.3.1": qr-code as _qr-code
#import "@preview/muchpdf:0.1.2": muchpdf as _muchpdf
#import "@preview/mmdr:0.1.0": mermaid as _mermaid

// ---------------------------------------------------------------------------
// Brand Colors
// ---------------------------------------------------------------------------
#let dbrx-dark-navy   = rgb("#1b3038")
#let dbrx-red         = rgb("#ff3620")
#let dbrx-white       = rgb("#ffffff")
#let dbrx-light-gray  = rgb("#f2f2f2")
#let dbrx-teal        = rgb("#618793")
#let dbrx-teal-light  = rgb("#6ca6bb")
#let dbrx-blue-gray   = rgb("#a0acbe")
#let dbrx-dark-teal   = rgb("#1b5161")
#let dbrx-charcoal    = rgb("#3a3838")
#let dbrx-crimson     = rgb("#98102a")
#let dbrx-green       = rgb("#00b379")
#let dbrx-amber       = rgb("#ffab00")

// Table colors
#let dbrx-table-header = rgb("#b3d4de")
#let dbrx-table-alt    = rgb("#dfecf2")
#let dbrx-table-border = rgb("#e7e6e6")

// ---------------------------------------------------------------------------
// Asset paths (relative to the template file)
// ---------------------------------------------------------------------------
#let _assets = "assets/"
#let _logo-light  = _assets + "logo-light.png"
#let _logo-dark   = _assets + "logo-dark.png"
#let _db-icon-red = _assets + "db-icon-red.svg"
#let _bg-red      = _assets + "bg-red.png"
#let _bg-dark     = _assets + "bg-dark.png"
#let _bg-teal     = _assets + "bg-teal.png"
#let _bg-headline-red    = _assets + "bg-headline-red.png"
#let _bg-headline-dark-1 = _assets + "bg-headline-dark-1.jpg"
#let _bg-headline-dark-2 = _assets + "bg-headline-dark-2.jpg"
#let _bg-headline-dark-3 = _assets + "bg-headline-dark-3.jpg"

// ---------------------------------------------------------------------------
// Dimensions (16:9 widescreen)
// ---------------------------------------------------------------------------
#let slide-width  = 33.867cm
#let slide-height = 19.05cm

#let margin-x = 1.28cm
#let margin-top = 1.014cm
#let logo-y = 17.639cm
#let logo-width = 3.707cm
#let logo-height = 0.582cm

// ---------------------------------------------------------------------------
// Document setup: call this at the top of your presentation
// ---------------------------------------------------------------------------
#let dbrx-presentation(
  title: none,
  author: none,
  subject: none,
  commit-id: sys.inputs.at("commit_id", default: none),
  body,
) = {
  set document(
    title: title,
    author: if author != none { (author,) } else { () },
    description: subject,
    keywords: if commit-id != none { ("commit:" + commit-id,) } else { () },
  )
  set page(
    width: slide-width,
    height: slide-height,
    margin: 0cm,
  )
  set text(
    font: "Barlow",
    size: 18pt,
    fill: dbrx-charcoal,
  )
  set par(leading: 0.5em)
  body
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

// Place the logo in the bottom-left corner
#let _logo(variant: "light") = {
  let src = if variant == "light" { _logo-light } else { _logo-dark }
  place(
    bottom + left,
    dx: 1.313cm,
    dy: -0.83cm,
    image(src, width: logo-width),
  )
}

// Full-bleed background image
#let _background-image(src) = {
  place(top + left, image(src, width: slide-width, height: slide-height))
}

// Full-bleed background color
#let _background-color(color) = {
  place(top + left, rect(width: slide-width, height: slide-height, fill: color, stroke: none))
}

// ---------------------------------------------------------------------------
// SLIDE: Title / Cover
// Background: red with halftone pattern, white text
// ---------------------------------------------------------------------------
#let title-slide(
  title: none,
  subtitle: none,
  author: none,
  date: none,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-red)
  _background-image(_bg-red)
  _logo(variant: "light")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: 3.1cm,
    block(
      width: 25.4cm,
      text(size: 60pt, fill: dbrx-white, title),
    ),
  )

  // Subtitle / author / date
  place(
    top + left,
    dx: margin-x,
    dy: 10cm,
    block(width: 25.4cm)[
      #set text(size: 24pt, fill: dbrx-white)
      #if subtitle != none { subtitle; linebreak() }
      #if author != none { author }
      #if date != none { [, ]; date }
    ],
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Section Divider (red background)
// ---------------------------------------------------------------------------
#let section-slide(
  title: none,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-red)
  _background-image(_bg-red)
  _logo(variant: "light")

  place(
    top + left,
    dx: margin-x,
    dy: 7.7cm,
    block(
      width: 30.3cm,
      text(size: 40pt, fill: dbrx-white, title),
    ),
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Section Divider (dark navy background)
// ---------------------------------------------------------------------------
#let section-slide-dark(
  title: none,
  variant: 1,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-dark-navy)
  let bg = if variant == 2 { _bg-headline-dark-2 } else if variant == 3 { _bg-headline-dark-3 } else { _bg-headline-dark-1 }
  _background-image(bg)
  _background-image(_bg-red)
  _logo(variant: "light")

  place(
    top + left,
    dx: margin-x,
    dy: 7.7cm,
    block(
      width: 30.3cm,
      text(size: 40pt, fill: dbrx-white, title),
    ),
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Basic Content (white background, title + body)
// ---------------------------------------------------------------------------
#let content-slide(
  title: none,
  body,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Content
  place(
    top + left,
    dx: margin-x,
    dy: 4.4cm,
    block(width: 31.3cm, height: 12.75cm)[
      #set text(size: 28pt, fill: dbrx-charcoal)
      #set list(marker: text(fill: dbrx-charcoal, sym.bullet), indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
      #set enum(indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
      #body
    ],
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Title + Subtitle + Content (white background)
// ---------------------------------------------------------------------------
#let subtitle-content-slide(
  title: none,
  subtitle: none,
  body,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: 0.514cm,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Subtitle
  place(
    top + left,
    dx: margin-x,
    dy: 3.3cm,
    block(
      width: 31.3cm,
      text(size: 20pt, fill: dbrx-dark-teal, subtitle),
    ),
  )

  // Content
  place(
    top + left,
    dx: margin-x,
    dy: 5.9cm,
    block(width: 31.3cm, height: 11.2cm)[
      #set text(size: 24pt, fill: dbrx-charcoal)
      #set list(marker: text(fill: dbrx-charcoal, sym.bullet), indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
      #body
    ],
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Two Columns (white background)
// ---------------------------------------------------------------------------
#let two-column-slide(
  title: none,
  left-heading: none,
  right-heading: none,
  left-body,
  right-body,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  let col-width = 15cm

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Column headings
  if left-heading != none {
    place(top + left, dx: margin-x, dy: 4.4cm,
      block(width: col-width, text(size: 20pt, fill: dbrx-teal, left-heading)))
  }
  if right-heading != none {
    place(top + left, dx: 17.56cm, dy: 4.4cm,
      block(width: col-width, text(size: 20pt, fill: dbrx-teal, right-heading)))
  }

  let content-dy = if left-heading != none or right-heading != none { 6.3cm } else { 4.4cm }

  // Left column
  place(
    top + left,
    dx: margin-x,
    dy: content-dy,
    block(width: col-width, height: 10.8cm)[
      #set text(size: 24pt, fill: dbrx-charcoal)
      #set list(marker: text(fill: dbrx-charcoal, sym.bullet), indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
      #left-body
    ],
  )

  // Right column
  place(
    top + left,
    dx: 17.56cm,
    dy: content-dy,
    block(width: col-width, height: 10.8cm)[
      #set text(size: 24pt, fill: dbrx-charcoal)
      #set list(marker: text(fill: dbrx-charcoal, sym.bullet), indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
      #right-body
    ],
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Three Columns (white background)
// ---------------------------------------------------------------------------
#let three-column-slide(
  title: none,
  headings: (none, none, none),
  col1,
  col2,
  col3,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  let col-width = 9.65cm
  let col-xs = (1.28cm, 12.1cm, 22.9cm)

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Column headings
  for (i, heading) in headings.enumerate() {
    if heading != none {
      place(top + left, dx: col-xs.at(i), dy: 4.4cm,
        block(width: col-width, text(size: 20pt, fill: dbrx-teal, heading)))
    }
  }

  let content-dy = if headings.any(h => h != none) { 6.3cm } else { 4.4cm }
  let bodies = (col1, col2, col3)

  for (i, body) in bodies.enumerate() {
    place(
      top + left,
      dx: col-xs.at(i),
      dy: content-dy,
      block(width: col-width, height: 10.8cm)[
        #set text(size: 24pt, fill: dbrx-charcoal)
        #set list(marker: text(fill: dbrx-charcoal, sym.bullet), indent: 0.6cm, body-indent: 0.4cm, spacing: 0.5em)
        #body
      ],
    )
  }
}

// ---------------------------------------------------------------------------
// SLIDE: Box Layout (2, 3, or 4 colored boxes)
// ---------------------------------------------------------------------------
#let box-slide(
  title: none,
  boxes: (),  // array of (label: str, body: content) dictionaries
  box-color: dbrx-teal,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  let n = boxes.len()
  assert(n >= 2 and n <= 4, message: "box-slide supports 2 to 4 boxes")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Box dimensions
  let total-width = 30.2cm
  let gap = 0.5cm
  let box-width = (total-width - gap * (n - 1)) / n
  let box-height = 8.7cm
  let box-y = 5.8cm

  for (i, b) in boxes.enumerate() {
    let box-x = margin-x + (box-width + gap) * i

    // Category label
    place(top + left, dx: box-x, dy: 4.2cm,
      block(width: box-width, text(size: 18pt, fill: dbrx-teal, b.label)))

    // Colored box
    place(
      top + left,
      dx: box-x,
      dy: box-y,
      block(
        width: box-width,
        height: box-height,
        fill: box-color,
        inset: (x: 0.5cm, y: 0.5cm),
        radius: 0pt,
      )[
        #set text(size: 18pt, fill: dbrx-white)
        #set list(marker: text(fill: dbrx-white, sym.bullet), indent: 0.4cm, body-indent: 0.3cm, spacing: 0.5em)
        #b.body
      ],
    )
  }
}

// ---------------------------------------------------------------------------
// SLIDE: Quote (dark background)
// ---------------------------------------------------------------------------
#let quote-slide(
  quote: none,
  attribution: none,
  bg: "red",  // "red", "dark", "teal"
) = {
  pagebreak(weak: true)

  let bg-color = if bg == "dark" { dbrx-dark-navy } else if bg == "teal" { dbrx-teal-light } else { dbrx-red }
  _background-color(bg-color)

  if bg == "red" {
    _background-image(_bg-red)
  } else if bg == "teal" {
    _background-image(_bg-teal)
  }

  let is-light-bg = bg == "teal"
  _logo(variant: if is-light-bg { "dark" } else { "light" })

  // Giant quotation mark
  place(
    top + left,
    dx: margin-x,
    dy: 3.5cm,
    text(size: 107pt, fill: if bg == "red" { dbrx-white.transparentize(30%) } else { dbrx-red }, "\u{201C}"),
  )

  // Quote text
  let quote-color = if is-light-bg { dbrx-dark-navy } else { dbrx-white }
  place(
    top + left,
    dx: margin-x,
    dy: 6.2cm,
    block(
      width: 15.65cm,
      text(size: 28pt, fill: quote-color, quote),
    ),
  )

  // Attribution
  if attribution != none {
    let attr-color = if bg == "teal" { dbrx-dark-navy } else { rgb("#9eb7bf") }
    place(
      top + left,
      dx: margin-x,
      dy: 12.4cm,
      block(
        width: 16.9cm,
        text(size: 18pt, fill: attr-color, attribution),
      ),
    )
  }
}

// ---------------------------------------------------------------------------
// SLIDE: Headline / Tagline (red background, centered text)
// ---------------------------------------------------------------------------
#let headline-slide(
  text-content: none,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-red)
  _background-image(_bg-headline-red)
  _logo(variant: "light")

  place(
    top + left,
    dx: margin-x,
    dy: 7.7cm,
    block(
      width: 30.3cm,
      text(size: 40pt, fill: dbrx-white, text-content),
    ),
  )
}

// ---------------------------------------------------------------------------
// SLIDE: Blank (dark branded)
// ---------------------------------------------------------------------------
#let blank-dark-slide() = {
  pagebreak(weak: true)
  _background-color(dbrx-dark-navy)
  _background-image(_bg-dark)
  _logo(variant: "light")
}

// ---------------------------------------------------------------------------
// SLIDE: Blank (white)
// ---------------------------------------------------------------------------
#let blank-white-slide() = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")
}

// ---------------------------------------------------------------------------
// SLIDE: Free-form (white background, logo, full manual control)
// ---------------------------------------------------------------------------
#let freeform-slide(
  dark: false,
  body,
) = {
  pagebreak(weak: true)
  if dark {
    _background-color(dbrx-dark-navy)
    _logo(variant: "light")
  } else {
    _background-color(dbrx-white)
    _logo(variant: "dark")
  }
  body
}

// ---------------------------------------------------------------------------
// SLIDE: Image Slide (white background, title + image)
// ---------------------------------------------------------------------------
#let image-slide(
  title: none,
  img: none,
  caption: none,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Image
  place(
    top + left,
    dx: margin-x,
    dy: 4.4cm,
    block(width: 31.3cm, height: 11.5cm)[
      #set align(center + horizon)
      #img
    ],
  )

  // Caption
  if caption != none {
    place(
      bottom + left,
      dx: margin-x,
      dy: -1.5cm,
      block(
        width: 31.3cm,
        text(size: 14pt, fill: dbrx-teal, caption),
      ),
    )
  }
}

// ---------------------------------------------------------------------------
// SLIDE: PDF Embed (white background, title + embedded PDF page)
// ---------------------------------------------------------------------------
#let pdf-slide(
  title: none,
  pdf-path: none,
  page: 0,
  caption: none,
  pdf-width: 31.3cm,
  pdf-scale: 1.0,
  pdf-align: top + center,
  pdf-dy: 0cm,
  content-height: 11.5cm,
  content-dy: 4.4cm,
) = {
  pagebreak(weak: true)
  _background-color(dbrx-white)
  _logo(variant: "dark")

  // Title
  place(
    top + left,
    dx: margin-x,
    dy: margin-top,
    block(
      width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy, title),
    ),
  )

  // Embedded PDF page (clip overflow)
  place(
    top + left,
    dx: margin-x,
    dy: content-dy,
    box(width: 31.3cm, height: content-height, clip: true,
      move(dy: pdf-dy,
        align(pdf-align,
          _muchpdf(read(pdf-path, encoding: none), pages: page, width: pdf-width, scale: pdf-scale)
        )
      )
    ),
  )

  // Caption
  if caption != none {
    place(
      bottom + left,
      dx: margin-x,
      dy: -1.5cm,
      block(
        width: 31.3cm,
        text(size: 14pt, fill: dbrx-teal, caption),
      ),
    )
  }
}

// ---------------------------------------------------------------------------
// Utility: Corner ribbon (rotated banner in the top-right corner)
// ---------------------------------------------------------------------------
#let dbrx-ribbon(
  label: "ROADMAP",
  color: dbrx-red,
  text-color: dbrx-white,
) = {
  // Ribbon centered on the top-right corner diagonal
  // Slide is 33.867cm × 19.05cm; ribbon center ~3.5cm inward from corner
  let ribbon-w = 16cm
  let d = -2cm
  let cx = (ribbon-w / calc.sqrt(2) - d)/2
  let cy = d
  place(
    top + right,
    dx: cx,
    dy: cy,
    rotate(45deg, origin: center,
      block(
        width: ribbon-w,
        fill: color,
        inset: (x: 0.5cm, y: 0.45cm),
      )[
        #set align(center)
        #text(size: 18pt, fill: text-color, weight: "bold", tracking: 0.15em, upper(label))
      ]
    )
  )
}

// ---------------------------------------------------------------------------
// Utility: Databricks-styled table
// ---------------------------------------------------------------------------
#let dbrx-table(columns: (), header: (), ..rows) = {
  let n-cols = columns.len()

  table(
    columns: columns,
    inset: 8pt,
    stroke: 0.5pt + dbrx-table-border,
    fill: (_, row) => {
      if row == 0 { dbrx-table-header }
      else if calc.rem(row, 2) == 1 { dbrx-white }
      else { dbrx-table-alt }
    },
    // Header row
    ..header.map(h => table.cell(text(weight: "medium", fill: dbrx-dark-navy, h))),
    // Data rows
    ..rows.pos().flatten(),
  )
}

// ---------------------------------------------------------------------------
// Mermaid diagram with Databricks brand theme
// ---------------------------------------------------------------------------
#let _dbrx-mermaid-theme = "%%{init:{'theme':'base','themeVariables':{'lineColor':'#3a3838','edgeLabelBackground':'#f2f2f2'}}}%%"
#let _dbrx-mermaid-classes = (
  "classDef dbrxNavy fill:#1b3038,stroke:#1b3038,color:#fff",
  "classDef dbrxRed fill:#ff3620,stroke:#ff3620,color:#fff",
  "classDef dbrxTeal fill:#618793,stroke:#618793,color:#fff",
  "classDef dbrxDarkTeal fill:#1b5161,stroke:#1b5161,color:#fff",
  "classDef dbrxGreen fill:#00b379,stroke:#00b379,color:#fff",
  "classDef dbrxAmber fill:#ffab00,stroke:#ffab00,color:#1b3038",
  "classDef dbrxGray fill:#f2f2f2,stroke:#3a3838,color:#3a3838",
  "classDef dbrxCrimson fill:#98102a,stroke:#98102a,color:#fff",
).join("\n")

#let dbrx-mermaid(definition) = {
  _mermaid(_dbrx-mermaid-theme + "\n" + definition + "\n" + _dbrx-mermaid-classes)
}

// ---------------------------------------------------------------------------
// QR Code with Databricks logo overlay
// ---------------------------------------------------------------------------
#let dbrx-qr-code(url, width: 5cm, color: dbrx-dark-navy, logo-width: 1cm) = {
  box[
    #_qr-code(url, width: width, color: color, error-correction: "H")
    #place(center + horizon)[
      #box(fill: white, inset: 0pt, radius: 0pt)[
        #image(_db-icon-red, width: logo-width)
      ]
    ]
  ]
}
