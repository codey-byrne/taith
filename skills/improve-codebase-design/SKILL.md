---
name: improve-codebase-design
description: "Scans a codebase for deepening opportunities, presents them as a visual HTML report, then runs the architect step and the decision questions on the one the person picks. Records terms and decisions as they settle. Use for /taith:improve-codebase-design."
disable-model-invocation: true
---

# Improve Codebase Design

Surface design friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones.
The aim is testability and AI-navigability.

Read the **codebase-designing** skill (`../codebase-designing/SKILL.md`) first — it owns the design vocabulary and
principles that every suggestion, subagent prompt, and report in this skill must use. Use its terms exactly; avoid its
banned substitutes.

This skill is the design step pointed at existing code. It keeps its own candidate scan and reuses the rest: the
**architect** skill produces the shape, and the decision questions follow the **design** skill.

## Process

### 1. Orient, then explore

Orient before exploring: read the project's domain glossary (`LANGUAGE.md`) and the ADRs for the areas you'll walk,
wherever the project keeps them. The domain language gives names to good seams; ADRs record decisions this skill
should not re-litigate. If the project documents neither, proceed silently.

Then delegate the walk to general-purpose subagents — one for a small codebase, fanned out by area for a large one.
Don't use `Explore` agents: they locate code from excerpts, and judging depth means reading whole interfaces against
whole implementations. Subagents start with fresh context — no loaded skills, no conversation — so everything the walk
depends on must travel in the prompt. Build each prompt from
[references/explore-prompt.md](references/explore-prompt.md). Each walker is an `Agent` call with
`subagent_type: "general-purpose"` on the `design walker` role in the role sheet (`../lead/references/roles.md`). Send
every walker in one message.

Aggregate the candidates across subagents, dedupe, and re-rank them yourself — subagent confidence is input, not
verdict.

### 2. Present candidates as an HTML report

Write a single HTML file to the OS temp directory so nothing lands in the repo. Resolve the temp dir from `$TMPDIR`,
falling back to `/tmp`, and write to `<tmpdir>/design-review-<timestamp>.html` so each run gets a fresh file. Open it
for the user — `open <path>` on macOS, `xdg-open <path>` on Linux — and tell them the absolute path.

The report uses **Tailwind via CDN** for layout and styling, and **Mermaid via CDN** for diagrams where a
graph/flow/sequence reliably communicates the structure — it needs network access to render. Mix Mermaid with
hand-crafted CSS/SVG visuals — Mermaid when relationships are graph-shaped (call graphs, dependencies, sequences),
hand-built divs/SVG when you want something more editorial (mass diagrams, cross-sections, collapse animations). Each
candidate gets a **before/after visualisation**. Be visual.

For each candidate, render a card with:

- **Files** — which files/modules are involved
- **Problem** — why the current design is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — explained in terms of locality and leverage, and how tests would improve
- **Before / After diagram** — side-by-side, custom-drawn, illustrating the shallowness and the deepening
- **Recommendation strength** — one of `Strong`, `Worth exploring`, `Speculative`, rendered as a badge
- **Dependency category** — the subagent's classification, one of the four categories from `codebase-designing`'s
  deepening reference

End the report with a **Top recommendation** section: which candidate you'd tackle first and why.

**Use LANGUAGE.md vocabulary for the domain, and the `codebase-designing` vocabulary for the design.** If `LANGUAGE.md`
defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to
warrant revisiting the ADR. Mark it clearly in the card (e.g. a warning callout: _"contradicts ADR-0007 — but worth
reopening because…"_). Don't list every theoretical refactor an ADR forbids.

See [references/html-report.md](references/html-report.md) for the full HTML scaffold, diagram patterns, and styling
guidance.

Do NOT propose interfaces yet. After the file is written, ask the user: "Which of these would you like to explore?"

### 3. Shape the chosen candidate

Run the **architect** skill (`../architect/SKILL.md`) on the candidate the person picked.

- **Grounding.** The walker's findings for that candidate are the grounding for Phase A. Send a gap through the **how**
  skill (`../how/SKILL.md`). Run the **why** skill (`../why/SKILL.md`) when the deepening changes who owns what.
- **Path.** A deepening moves an interface, so architect designs it twice through **arena** unless the new shape
  follows a pattern the walk already found. Say which path it took.
- **Constraints.** Pass the candidate's dependency category and any ADR it touches to every runner.

Architect returns one recommended shape with its rationale and what was rejected. It writes no implementation.

### 4. Ask the decision questions

Show the person the recommended shape, what was rejected and why. Then ask only the trade-offs that are preference
calls, one question per message, by the rules of the **grill** skill (`../grill/SKILL.md`). Look up a fact through
**how**. Put low-stakes choices in one batch of recommended defaults. Useful branches for a deepening are what sits
behind the seam, which callers change, and which tests survive.

As each decision settles, follow the **domain-modelling** skill (`../domain-modelling/SKILL.md`). It writes the
glossary terms and the ADRs. When the person rejects a candidate for a reason that will still hold later, record it as
a rejected alternative in an ADR. A later run of this skill reads the ADRs in step 1 and does not suggest it again.

### 5. Hand over

Save the agreed shape, its numbered decisions and the rejected options to `.planning/<feature>/deepening.md`, where
`<feature>` is a short kebab-case name for the deepening. Mark each decision the person agreed to as binding. Tell the
person the path.

This skill changes no code. To build the deepening, the person runs `/taith:lead` with the deepening as the task and
that file as its input. The design step copies each constraint from a supplied document into `design.md` with its
status, so the lead does not ask again about a decision marked binding.
