// ==========================================================================
// RFQ Kanban — Architecture & MLOps Presentation
// ==========================================================================

#import "dbrx.typ": *

#show: dbrx-presentation.with(
  title: "RFQ Kanban",
  author: "Lucas Bruand",
  subject: "Architecture & MLOps Overview",
)

// Page numbers — bottom-right, vertically aligned with logo; hidden on title slide (page 1)
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

// --- Slide 1: Title ---
#title-slide(
  title: [RFQ Kanban],
  subtitle: [AI-Powered Quote Automation — Architecture & MLOps],
  author: [Lucas Bruand],
  date: [April 2026],
)

// --- Slide 2: Business Problem & Targets ---
#content-slide(title: [Business Problem & Targets])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5cm,
    [
      #text(size: 15pt, fill: dbrx-dark-teal)[Current State]
      - 500 quotes/month, 15 people
      - AOG response time: 24–48 hours
      - Standard quotes: 5 working days
      - Fully manual, email-driven workflow
      - 0% of quote lines automated today
    ],
    [
      #text(size: 15pt, fill: dbrx-green)[Targets]
      - AOG response: *< 4 hours*
      - Standard response: *< 24 hours*
      - Line automation: *≥ 70%*
      - Pricing accuracy: *≥ 90%* (within 5%)
      - Human review: *< 15 min* avg per quote
      - 2× volume capacity with same team
    ],
  )
]

// --- Slide 3: End-to-End Architecture ---
#content-slide(title: [End-to-End System Architecture])[
  #set align(center)
  #dbrx-mermaid("graph LR\nA[Email RFQ] --> B[Extraction]\nB --> C[Triage]\nC --> D[Lookup]\nD --> E[Pricing]\nE --> F[Excel Quote]\nF --> G[Review UI]\nG --> H[Send]\nclass A dbrxGray\nclass B dbrxRed\nclass C dbrxAmber\nclass D dbrxTeal\nclass E dbrxDarkTeal\nclass F dbrxNavy\nclass G dbrxDarkTeal\nclass H dbrxGreen")

  #v(0.5cm)
  #grid(
    columns: (auto, auto, auto, auto, auto),
    column-gutter: 1.2cm,
    align: center,
    text(size: 11pt, fill: dbrx-red)[*Claude Sonnet 4*\ FMAPI],
    text(size: 11pt, fill: dbrx-amber)[*Multi-dim*\ scoring],
    text(size: 11pt, fill: dbrx-teal)[*SAP mock*\ via Unity Catalog],
    text(size: 11pt, fill: dbrx-dark-teal)[*Rule-based*\ pricing],
    text(size: 11pt, fill: dbrx-green)[*Kanban UI*\ React 19],
  )
]

// --- Slide 4: Databricks Platform ---
#box-slide(
  title: [Databricks Platform Integration],
  boxes: (
    (label: [Foundation Model API], body: [
      Claude Sonnet 4 \
      OpenAI-compatible SDK \
      Deterministic (temp = 0.0) \
      Few-shot JSON extraction \
      Heuristic fallback on failure
    ]),
    (label: [Lakebase], body: [
      Managed PostgreSQL \
      OAuth token via Databricks SDK \
      Auto-injected env vars \
      18 SQLModel tables \
      SQLite fallback for local dev
    ]),
    (label: [Databricks Apps], body: [
      APX framework + DABs \
      Service principal M2M auth \
      FastAPI + React 19 stack \
      Dev & Prod bundle targets \
      CI/CD via GitHub Actions
    ]),
    (label: [Unity Catalog], body: [
      SAP data landing zone \
      Future real-data source \
      Governed access control \
      Data lineage tracking \
      Currently: seeded mock data
    ]),
  ),
)

// --- Slide 5: GenAI Extraction Agent ---
#two-column-slide(
  title: [GenAI Extraction Agent],
  left-heading: [Primary — Claude Sonnet 4 via FMAPI],
  right-heading: [Fallback — Heuristic Extractor],
)[
  - Databricks FMAPI endpoint
  - Temperature 0.0 for deterministic output
  - System prompt + 2 few-shot JSON examples
  - Max tokens: 2,048
  - Structured output schema:
    - `customer_name`, `customer_email`
    - `is_aog` urgency boolean
    - `line_items[]`:
      part ref, quantity, description
][
  - Activated when FMAPI is unavailable
  - Regex-based email header parsing
  - AOG keyword detection:
    - "AOG", "Aircraft on Ground"
    - "URGENT", "grounded"
  - Line item parsing strategies:
    - Numbered lists (1., 2., ...)
    - Bullet points (-, \*, •)
    - Tab-separated tables
]

// --- Slide 6: Processing Pipeline Stages ---
#three-column-slide(
  title: [Processing Pipeline Stages],
  headings: ([Triage Scoring], [Data Lookup], [Pricing Engine]),
)[
  Composite priority score (0–1):

  - *Urgency* (50%):
    AOG flag + time-to-SLA, non-linear
  - *Complexity* (25%):
    Line count + unknown-parts ratio
  - *Risk* (25%):
    No-contract + low-stock + build age

  Output: score + human-readable factor list to prioritise the review queue
][
  Part resolution chain:

  - Exact internal match (conf. 1.0)
  - Alias match (conf. 0.5)
  - Partial case-insensitive (conf. 0.3)

  Per-item checks:
  - Active supplier contract
  - Stock: IN_STOCK / LIMITED / UNAVAILABLE
  - Built within last 3 years

  Flags: PART_NOT_FOUND, NO_CONTRACT,
  LOW_STOCK, NOT_BUILT_RECENTLY
][
  Rules in priority order:

  + Contract price × 1.15
  + Historical quote × 1.20
  + Cost-plus by category × 1.25
  + Manual review (no price set)

  AOG surcharge applied on top

  Base costs (EUR):
  - AVIONICS: 8,000
  - STRUCTURAL: 5,000
  - HYDRAULIC: 3,500
  - ELECTRICAL: 2,000
  - CONSUMABLES: 50
]

// --- Slide 7: MLOps — Evaluation Framework ---
#content-slide(title: [MLOps — Evaluation Framework])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5cm,
    [
      #text(size: 15pt, fill: dbrx-dark-teal)[Eval Sets (`eval_sets/v1/`)]
      - 10 hand-crafted email scenarios
      - Difficulty: easy → hard
      - Covers: AOG, ambiguous part refs, large multi-line, plain-text tables
      - JSON format with expected extraction output

      #v(0.5cm)
      #text(size: 15pt, fill: dbrx-dark-teal)[Version Tracking]
      - `eval_runs` — model, prompt version, aggregate metrics
      - `eval_run_examples` — per-scenario pass/fail + error detail
      - Enables regression detection across prompt iterations
    ],
    [
      #text(size: 15pt, fill: dbrx-dark-teal)[Metrics per Eval Run]
      #v(0.3cm)
      #dbrx-table(
        columns: (auto, 1fr),
        header: ([Metric], [Definition]),
        [Line Item F1], [Precision & Recall on part refs],
        [AOG Accuracy], [Boolean match on urgency flag],
        [Customer Match], [Fuzzy name + exact email],
        [Overall F1], [0.5×F1 + 0.25×AOG + 0.25×cust],
        [Schema Validity], [Valid structured JSON output],
      )
    ],
  )
]

// --- Slide 8: Data Model ---
#content-slide(title: [Data Model — 18 Tables])[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.8cm,
    [
      #text(size: 14pt, fill: dbrx-red)[Operational]
      - `rfqs`
      - `rfq_line_items`
      - `line_item_flags`
      - `triage_scores`
      - `triage_factors`
      - `activity_log`
      - `corrections`
    ],
    [
      #text(size: 14pt, fill: dbrx-teal)[Reference (SAP mock)]
      - `parts_catalog`
      - `part_aliases`
      - `supplier_contracts`
      - `stock_levels`
      - `build_history`
      - `pricing_rules`
      - `customers`
    ],
    [
      #text(size: 14pt, fill: dbrx-dark-navy)[Evaluation & History]
      - `eval_runs`
      - `eval_run_examples`
      - `historical_quotes`
      - `historical_quote_lines`

      #v(0.5cm)
      `corrections` captures reviewer overrides as a training signal for future model fine-tuning
    ],
  )
]

// --- Slide 9: Human-in-the-Loop ---
#content-slide(title: [Human-in-the-Loop: Kanban Review])[
  #set align(center)
  #dbrx-mermaid("graph LR\nA[RECEIVED] --> B[PARSING]\nB --> C[LOOKUP]\nC --> D[PRICING]\nD --> E[REVIEW]\nE --> F[APPROVED]\nE --> G[REJECTED]\nF --> H[SENT]\nclass A dbrxGray\nclass B,C dbrxTeal\nclass D dbrxDarkTeal\nclass E dbrxAmber\nclass F,H dbrxGreen\nclass G dbrxRed")

  #v(0.4cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5cm,
    align: left,
    [
      - Drag-and-drop Kanban board
      - Auto-refresh, real-time state
    ],
    [
      - Manual override: part, price, qty, notes
      - Excel quote download at any stage
    ],
    [
      - Activity log for full audit trail
      - Corrections stored as fine-tuning signal
    ],
  )
]

// --- Slide 10: Summary & Roadmap ---
#content-slide(title: [Architecture Summary & Roadmap])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5cm,
    [
      #text(size: 15pt, fill: dbrx-dark-teal)[Architecture Highlights]
      - FastAPI + React 19 on Databricks Apps (APX)
      - Claude Sonnet 4 via FMAPI — deterministic extraction
      - Separation: LLM extraction + rule-based pricing
      - Lakebase PostgreSQL with OAuth token management
      - 20 REST endpoints, 43 data types, 18 DB tables
      - Eval framework + corrections for continuous improvement
    ],
    [
      #text(size: 15pt, fill: dbrx-teal)[Roadmap]
      + Connect real SAP data via Unity Catalog
      + Prompt versioning + A/B testing on eval sets
      + Fine-tune extraction model on corrections data
      + Streaming email ingestion pipeline
      + Multi-supplier competitive quoting
    ],
  )
]
