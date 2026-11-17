---
name: architect
description: "Produces the shape of a change before any code: contracts, types, signatures and module boundaries, with a written rationale. Runs design it twice through arena when the change adds or moves an interface or the shape is contested. Use for /taith:architect, 'architect this', or as the shape step of design."
disable-model-invocation: true
---

# Architect

Sketch the shape of a change: the contracts between components, then the types, function signatures and module boundaries in code, with `not implemented` bodies. The output is a design package and its rationale. Nothing is implemented here. Slices do that.

The **design** skill calls this step. The bug-fix, perf-issue and refactoring playbooks call it when a fix crosses a function boundary. A person can type it alone.

Read the **codebase-designing** skill (`../codebase-designing/SKILL.md`) first. Its terms are the language of every sketch and every comparison below. Read the **show-me** skill (`../show-me/SKILL.md`) for the views a design package is drawn with.

## Start

Open a todo list with one entry per phase.

1. Ground
2. Choose the path
3. Sketch
4. Write the rationale

## Phase A. Ground the problem

Build a real model of every system the new code touches. Naming a file is not grounding.

- In a feature, `research.md` is the grounding. Use the summaries you hold. For a gap, send one lookup through the **how** skill (`../how/SKILL.md`).
- Outside a feature, run a **how** walkthrough over the affected subsystems.
- If the design redefines ownership or layering, also run the **why** skill (`../why/SKILL.md`) on the existing shape, so that its rationale becomes a constraint and not a guess.

Skip this phase only for work with no surrounding system to fit into.

## Phase B. Choose the path

Say which path you took and why, in one or two sentences.

- **Follow the pattern.** The change fits a pattern the grounding found, adds no interface and moves none. Write one sketch that follows the pattern, and name the pattern with its file pointer. Go to Phase D.
- **Design it twice.** The change adds or moves an interface, or the shape is contested. Go to Phase C.

When in doubt between the two, ask whether a second engineer could reasonably draw the module boundary somewhere else. If so, design it twice.

## Phase C. Sketch through arena

Run the **arena** skill (`../arena/SKILL.md`) with the design-sketch task and the grounding. Pass `references/runner-prompt.md` as each runner's prompt. Runners are native subagents on the `architect runner` role in the role sheet (`../lead/references/roles.md`). The judge is the cross-vendor seat, so it is never from your own model family.

**At least two structurally distinct candidates.** Require whole-shape alternatives, not point fixes inside one shape, even when the first candidate looks sufficient. Give each runner a different constraint from this list, so the candidates diverge.

1. Minimise the interface. Aim for one to three entry points and the most leverage per entry point.
2. Maximise flexibility. Support many use cases and extensions.
3. Optimise for the most common caller. Make the default case trivial.
4. Design around ports and adapters for dependencies that cross a seam. Use this one when such dependencies exist.

**Each candidate covers contracts first, then code shape.** A feature gets one pass, and every candidate in it carries both the system design and the program design. At Program size the design skill calls this step twice, once for each, with a sign-off between.

**Screen every candidate** against `../codebase-designing/references/design-red-flags.md` before synthesis. Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Prefer the design where a change that looks right from one file is right for the whole repo.

**Compare on three things.** Depth: how much behaviour sits behind how small an interface. Locality: where change and knowledge concentrate. Seam placement: whether each seam is where something really varies. Prefer the design that hides more complexity behind a smaller, simpler interface.

Arena returns one synthesized design package. Its synthesis decision fills the rationale's "Synthesis decision" section. Give your own recommendation. If parts of two candidates combine well, propose the hybrid. The person wants a strong read, not a menu.

## Phase D. Write the rationale

Write the caller's usage first and derive the type sketch from it.

- For a small change, the output is one file of new types and signatures.
- For larger work, the output is a module map and the type definitions.
- The rationale follows `references/rationale-template.md`.

Draw the package with the show-me views.

- **Contracts between components.** A Mermaid diagram for each main flow. Endpoint and message shapes, and schemas in the project's own language or ORM. Show today's flow and the proposed one.
- **Code shape.** A file-tree diff, signatures, a dependency map, and a call tree or component tree where control flow or UI structure is the point. Choose the views that expose a decision. The outline carries the full file list.

Inside the design skill, fold the package into `design.md`: contracts into System design, code shape into Program design, and each choice with its rejected alternatives into Decisions. The rationale's open questions become the decision questions the design skill asks. Do not keep a second copy.

Typed alone, show the package and the rationale to the person and stop. Use the **interrogate** skill (`../interrogate/SKILL.md`) for adversarial pressure on a contested sketch.

## When the person rejects the shape

Treat the objection as grounding. Return to Phase A with it as a constraint, and run Phase C again. Do not patch the rejected sketch.

## When the build shows the shape is wrong

This rule is for the lead during the build. If slices keep producing friction the sketch cannot absorb, stop the build and throw the sketch out. Do not bolt fixes onto a wrong design.

The signal is a pattern, not a single case:

- The same kind of workaround appears in unrelated slices.
- Several unrelated edge cases each need a special-case branch.
- Types need escape hatches to compile: `any`, casts, or optional fields that are always set in practice.
- A worker reaches for a lock where the sketch said the state was not shared.
- Callers must know the module's internal rules to use it.
- Two or more workers report the same kind of deviation from a designed interface.

Use judgment. Some problems are complex in themselves, and a few edge cases do not condemn a design.

When you scrap the sketch:

1. Run a **how** walkthrough over what has been built.
2. Redesign as if the new constraints had been known on day one.
3. Remove before you add. The new sketch is smaller than the old one before it grows.
4. Return to Phase C, then to design's decision questions and the outline for the slices that remain.
