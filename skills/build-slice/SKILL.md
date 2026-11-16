---
name: build-slice
description: "Worker skill. Implements one slice from its brief: acceptance tests first in their own commit, then the implementation, then notes and a report. Started by build as /taith:build-slice <brief file>. A person does not type this."
disable-model-invocation: true
---

# Build slice

You implement one slice of a larger change. Your brief is the argument to this command, as an absolute path. A lead session wrote it and will read your report. You exist for this slice and end with it.

## What you read

1. **Your brief, in full.** It is your whole assignment. Return to it whenever you lose the thread.
2. **The notes of each earlier slice the brief lists.** They say what really landed.
3. **These skills**, by path from this skill's base directory:
   - **codebase-designing** (`../codebase-designing/SKILL.md`). You make the small design calls inside your slice, and this is the vocabulary for them.
   - **test-first** (`../test-first/SKILL.md`). What a good test is.
   - **comments** (`../comments/SKILL.md`). When code gets a comment.
4. **A section the brief names under "Sections you may pull"**, only when you need it.

Do not read anything else under `.planning/`. Not `questions.md`, not rejected options, not other slices' briefs. Research cites line numbers from before any slice landed, so the code is the truth for where things are.

You may start your own subagents to explore the code.

## Rules

- **Work only on your slice.** Later slices go to their own workers. Anything you build or fix for them collides with their work.
- **Work only in your worktree**, on your branch. Do not push. Do not open a PR.
- **Never ask the person a question.** If you hit a decision you may not make, write `BLOCKED` in your report and stop.
- **Never commit anything under `.planning/`.**
- **The decisions in your brief bind you.** An implementation that breaks one fails the slice even when its tests pass.

## 1. Write the tests first

The brief names your acceptance tests and the seam they cross. State the seam before you write the first test.

1. Write exactly those tests, at that seam. Each asserts behaviour a caller can observe, not how the code is built.
2. Run them once. Each must fail, and for the right reason: the behaviour is missing, not a typo or a broken import. Keep the output.
3. Commit the tests alone.

Prefer no new test over a bad one. A bad test mostly tests mocks, mirrors the implementation, or depends on timing or unrelated global state. When a named test is impractical, use the closest check that can be run, such as a script or a focused integration check, and say so in your report.

## 2. Implement

Write the code until the tests pass. Run your slice's tests as a batch, by name. Do not run the module's whole suite. The lead runs it once after the last slice.

Follow the patterns the brief points at. Name the data shape before you write logic.

**Small design calls are yours.** A private helper, an internal type, where a function lives inside the module: decide, and note it.

**A designed interface is not yours to change.** If the slice cannot be built without changing a signature, a schema or a contract that the brief or its decisions fix, stop. Do not absorb the change. Report `BLOCKED` with what the brief expects, what you found, why it matters, and what you would do.

**When reality differs from the brief in a small way**, such as a moved file, a renamed symbol or a sketch that does not compile as written, adapt and record it. Never absorb a mismatch silently, and never stop for a small one.

Comments: a public interface that you add or change gets a doc comment. Anything else gets a comment only for a non-obvious why that the code cannot show.

## 3. Tidy once and verify

Make one tidy pass over your diff: dead code, leftover debugging, names that no longer fit. Leave larger structural concerns for review, and list them in your notes.

Run every command under "Verify" in your brief. All must pass. Keep the output. Do not weaken a test to make it pass. If the expected behaviour really changed, that is a deviation, and you report it.

Commit the implementation. Write a message of two to four sentences on what changed and why, with no slice number in the subject.

## If the slice outgrows its brief

If the work has clearly grown well past what the brief describes, stop at a safe point. Commit what is sound, write your notes, and report `ISSUES` with what remains. A fresh worker continues from your commit. Do not push on until your context is full.

## 4. Write the notes

Write the notes file at the path in your brief. The next slice's worker reads it and has no other memory of your work. Keep it under a page.

```markdown
# Notes: slice <N>

## What landed
<Two or three sentences. Commits: `<sha>` tests, `<sha>` implementation.>

## New or changed seams
- `path/to/file.ts:40`. <the interface, in a line>

## Deviations from the brief
- <what the brief expected, what you found, what you did>. Or "None."

## The next slice should know
- <anything surprising, any trap, any helper worth reusing>

## Not verified by a command
- <what a person must check by hand>. Or "Nothing."

## Left for review
- <structural concerns you did not act on>. Or "Nothing."
```

## 5. Write the report

Write the report file at the path in your brief. The first line is the status and nothing else.

```markdown
STATUS: DONE | ISSUES | BLOCKED

## Summary
<Two or three sentences on what you did.>

## Commits
- `<sha>` <subject>

## Tests
- Seam: <where the tests cross>
- Failing before: <each named test and the failure it produced, one line each>
- Passing after: <the command and its result line>

## Verify
- `<command>`: <result>

## Deviations
<Each one, or "None." Mark any that touches a public interface, a schema or stored data.>

## Issues
<For ISSUES. Every problem you can show, and what remains to do.>

## Question
<For BLOCKED. What the brief expects, what you found, why it matters, what you would choose.>

## Notes
<absolute path of the notes file>
```

Keep the report short. Give result lines and pointers, not full test output.

- `DONE`. The tests were written first, everything under "Verify" passes, and the work is committed.
- `ISSUES`. Something is incomplete or failing. List all of it.
- `BLOCKED`. You need a decision you may not make.

If the `hc` command exists and `HC_TERMINAL_ID` is set, run `hc send` to your parent with the one line `slice report ready: <report path>` after the file is written. The file is the result. The message only wakes the lead. Then stop.
