---
feature: <feature>
git_commit: <commit the design was written against>
status: open | settled
---

# <Title>

## Problem

<What is being solved and for whom. What the person sees or cannot do today. No file paths.>

## Desired end state

<What is true when the work is done, as behaviour someone can observe. How it will be verified.>

## Not doing

- <Scope that was ruled out, each with one line on why>

## System design

<What the parts are and how they talk: data model, schemas, API and event contracts, the main flows. Show how this differs from today. Break it into subsections whose headings state a finding. Put each diagram or contract beside its prose.>

## Program design

<How the system design is laid out in code: modules, interfaces, types and signatures, where the seams go. Use the vocabulary of codebase-designing. Signatures only, no bodies. Say which path the architect step took and why.>

## Decisions

Numbered and durable. A brief refers to a decision by its number, so a number never changes once written.

### D1. <The decision, stated as a fact>

<One or two sentences of rationale.>

Rejected: <each option that lost, with one line on why>

### D2. ...

## Patterns to follow

- <What the pattern is>. See `path/to/file.ts:40-72`.
- <A pattern research found that this change must NOT follow, and why>

## Constraints from supplied context

<Each constraint from a document or link the person supplied, stated here in full with its status: binding, proposed, or unknown. Remove the section when there are none.>

## Open questions

<Each question that only the person can answer, with options and a recommendation. Empty when the design is settled.>

## Parked

<Items set aside on purpose, each with what would unblock it. Remove the section when there are none.>
