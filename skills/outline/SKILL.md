---
name: outline
description: "Cuts a settled design into ordered vertical slices with acceptance tests, verify commands and dependencies, under a one-page decision digest. Writes outline.md, the one check the person makes before code. Use for /taith:outline, or as step 4 of the feature playbook."
disable-model-invocation: true
---

# Outline

Decide how the work is cut and ordered. The result is `outline.md`: a decision digest, then vertical slices. It is the last thing the person reviews before code, and the only thing a fresh lead reads to run the build. There is no plan after it.

The outline makes no design decision. If cutting the work shows that one is missing, stop and go back to the **design** skill (`../design/SKILL.md`). The outline never overrides `design.md`.

## 1. Load

Find `.planning/<feature>/`. Read `design.md`. If it lists an open question, stop and return to design. Slices cut around an open question get cut again when the answer lands.

Read the **codebase-designing** skill (`../codebase-designing/SKILL.md`) for the terms used below, and `../design/references/views.md` for the views.

You need the repo's test and verify commands. If research did not record them, send one lookup through the **how** skill (`../how/SKILL.md`): how to lint, typecheck, run one test by name, and run the full suite.

## 2. Write the digest

The digest is the first page of `outline.md`. An implementer reads its brief and nothing else, and the brief draws on the digest, so the digest holds what the design settled and nothing about how it got there.

- **Decisions.** Resolved decisions only, each in one line, with its number from `design.md`. No rejected options and no question history.
- **Patterns to follow.** Each with a file pointer.
- **Test and verify commands.** Exact commands.
- **Out of scope.** What this work does not do.

## 3. Cut vertical slices

Each slice is a thin vertical cut that touches as many layers as the behaviour needs. Wire everything together in a way that can be tested, then add behaviour slice by slice.

A horizontal cut looks like this, and leaves half-finished work between slices:

1. Build the schema
2. Build the API
3. Build the UI
4. Add tests

A vertical cut goes through the stack each time:

1. A user can create the simplest version of the thing end to end
2. A user can edit one field end to end
3. A user sees the first validation error end to end

Rules for every slice:

- **Name it for the behaviour it delivers**, not for a layer or a component.
- **It can be verified the moment it lands.** Slice N never needs slice N+1 to be verified.
- **Its acceptance tests are named**, with the seam they cross. The implementer writes exactly these tests first.
- **A command verifies it wherever a command can.** Do not list a check by hand for something a script, a test or an existing skill could check. Whatever truly needs a person goes under "Check by hand" and ends up in the PR description.
- **Size it by judgment.** There is no line count. If a slice cannot be checked on its own, it is probably too small or not vertical enough.
- **List files as paths only.** Show a signature where it is the clearest way to state intent. Never write a body. The outline is the header file.
- **Give it a context line** that names the exact sections of `design.md` or `research.md` worth pulling, by heading. Most slices need none beyond the digest.

Fill every field in `references/outline-template.md` for each slice.

**Coupling is fixed here, never during the build.** Slice N depending on slice N-1 is normal. It needs only N-1's commit and notes. But if you could not brief the second slice without the working knowledge of whoever built the first, the two are one slice. Merge them, or redraw the seam between them.

## 4. Say what runs in parallel

Each slice gets a fresh worker. Independent slices run at the same time in separate worktrees. Work through these four points and record the result in the table under Slices.

- **Blocking first steps.** Which slices must land before anything else can start.
- **Independent slices.** Slices with disjoint files, services or layers can run beside each other.
- **Shared state.** Two slices that write the same file, table, generated artifact or migration sequence cannot run beside each other. First try to split the target so they stop sharing it. Put them in order only when a real invariant needs it.
- **Smallest safe cut.** If one slice is the right answer, say why.

## 5. The outline check

Write `outline.md` and tell the person it is ready. This is the one deep review before code, and the digest is part of it. Ask the person to check two things:

1. The slices and their order make sense, and each can be verified on its own.
2. The digest states the decisions they made, and the verify commands are the ones the repo really uses.

Treat every piece of feedback as an instruction to change the document, not to start the build. When the person corrects a fact about the code, confirm it with a lookup before you rewrite around it. When the feedback is a design change, go back to design.

## 6. Hand over

When the person approves:

- Say whether you recommend starting the build from a fresh lead, by how much design conversation this session carries. The person can ask for the split either way. In the Program tier the build always starts from a fresh lead.
- With no split, run the **build** skill (`../build/SKILL.md`) now.
- With a split, tell the person to start a new lead session and type `/taith:build <feature>`. A fresh lead reads `outline.md` and nothing else.
