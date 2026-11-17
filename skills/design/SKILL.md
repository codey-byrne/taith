---
name: design
description: "Runs the design conversation with the person after research: behaviour questions, the code shape through architect, then the preference calls on a recommended design. Writes design.md with numbered decisions. Use for /taith:design, or as step 3 of the feature playbook."
disable-model-invocation: true
---

# Design

Decide what is being built and its shape, with the person. The result is `design.md`: the behaviour, the system design, the program design, the decisions, and what was rejected.

Design does not own the order of the work or which files belong to which slice. That is the **outline** skill's job.

## 1. Load

Find `.planning/<feature>/`. Take the name from the invocation. If none was given and one folder exists, use it. Otherwise ask.

- If you ran research in this session, you hold the summaries. Do not reread `research.md`.
- On a cold start, read `task.md`, then the section headings and the "Conflicts with the task" and "Open questions" parts of `research.md`. Pull a whole section only when a decision depends on it.
- With no `research.md`, tell the person and run the **research** skill (`../research/SKILL.md`) first, unless they say to design from the task alone.

Read these skills now. Naming a skill loads nothing.

- **codebase-designing** (`../codebase-designing/SKILL.md`). Its terms (module, interface, seam, depth) are the language for everything below.
- **grill** (`../grill/SKILL.md`). It owns how a question is put to the person.
- **domain-modelling** (`../domain-modelling/SKILL.md`). It records a glossary term or an ADR at the moment a decision makes one.

When the person supplies a document or a link, study it for constraints and earlier decisions. State each one in `design.md` itself with its status: binding, proposed or unknown. Later steps run without this conversation, so a constraint that exists only behind a link is one the implementer never sees.

## 2. Write the skeleton

Write `design.md` from `references/design-template.md` with the Problem section drafted and the rest empty. Keep it minimal, so that the first question reaches the person fast.

A choice the person already made in the task or in this conversation goes straight into Decisions. Do not ask it again.

## How the conversation works

These rules hold for every question in steps 3 and 5.

- **Ask preference calls only.** Before you ask anything, classify it.
  - A fact about the code, the history or the docs goes to a lookup through the **how** skill (`../how/SKILL.md`). Fire it in the background and carry on with questions that do not depend on it. When a decision rests on the answer, state the fact in `design.md` with its citation, because `research.md` does not hold it.
  - A fork that a run could settle (behaviour, timing, layout, performance) goes to a prototype. The result decides.
  - A low-stakes choice joins a batch of recommended defaults. Present the batch once. The person accepts it or overrides single lines.
  - A product or preference call that no run can settle is a question for the person.
- **One question per message.** Present one decision with its options, the trade-offs and your recommendation, then stop. Two or three options to choose between is one question. Two independent decisions is two. Never end with "any feedback?".
- **A preference call stays open until the person resolves it.** You may recommend. You may not close it yourself, even when the answer looks obvious.
- **Discuss before you write.** The person may push back, think aloud or ask a question of their own. That is discussion, not a decision. Answer it and leave the document alone. Write only when the decision is resolved.
- **Rewrite, never append.** Fold each resolved decision into the section it changes. Redraw the diagram. Remove what it made untrue. `design.md` always reads as a design someone wrote on purpose, never as a log of answers.
- **Record what lost.** Each decision in the Decisions section names the options that were rejected and why, in one line each.
- **Show the shape.** Use the views in the **show-me** skill (`../show-me/SKILL.md`) in place of paragraphs. Show today's shape and the proposed one, as a `diff` block where the surrounding shape already exists. Give each option its own block. A program design question with no code block is the rare exception.
- **Mock a UI decision.** Write one HTML file per decision in `.planning/<feature>/`, with the options side by side, in the product's own colours and components as research recorded them. Link it from `design.md` beside the text it supports. Update the mock when a later decision changes what it shows.
- **Headings state the finding.** Write "Sync runs as a background job after the write commits", not "Sync".

## 3. Behaviour questions

Settle what is being solved, with the research in hand. No solutions yet.

1. **The problem.** Quote your drafted Problem section and ask whether it is right. Iterate until it is.
2. **The desired end state.** What is true when the work is done, as behaviour a person can observe, and how it will be verified. For a change large enough to measure, agree how anyone will know it worked. For a small change, say that no measure makes sense and move on.
3. **Scope.** What is in and what is out. Each ruled-out item goes under Not doing.

Raise every conflict that research found between the code and what the task assumes. Ask only what a shared understanding of the problem needs. Stay in behaviour. A question about schemas or modules belongs to step 5.

## 4. Shape

Run the **architect** skill (`../architect/SKILL.md`). It produces the system design and the program design as one design package, contracts first.

Architect runs design it twice only when the change adds or moves an interface, or the shape is contested. A change that fits a pattern research found gets one sketch that follows the pattern. Tell the person which path it took and why.

The person is not asked to pick between raw candidates.

## 5. Decision questions on the recommended design

Show the recommended design: the shape, what was rejected and why. Then ask only the trade-offs in it that are preference calls, one at a time, under the rules above. The person reacts to a concrete design, not to abstract options.

When the person rejects the shape itself, treat that as new grounding. Run architect again with the objection as a constraint.

When a technical choice changes what the person will see or what is in scope, say so and ask. Then rewrite Desired end state, Not doing and any mock it touches. The behaviour sections never lag behind the shape.

## 6. Finish

`design.md` ends with no open question. A parked item is recorded as parked, with what would unblock it. Set `status: settled`.

Then edit the document once as a reader. Check it against the **show-me** skill and the writing rules in `../../docs/conventions.md`. Cut each sentence and section that the outline or an implementer would not use. Replace a dense paragraph with the smallest view that makes its point. Check that each heading states a finding and that each view sits beside its text.

Ask the person to read the System design and Program design sections top to bottom, because they have seen them only one decision at a time. Then run the **outline** skill (`../outline/SKILL.md`) in this session.

## Program tier

At Program size the design has two sign-offs.

1. Run architect for the system design alone. Ask its decision questions. Get the person's sign-off on the System design section.
2. Only then run architect for the program design, and ask its decision questions.

A wrong contract invalidates every module sketch built on it, so the contract is agreed first.
