---
name: build
description: "Runs the build from an approved outline: writes a brief per slice just before delegating it, starts a fresh worker per slice, has a checker read each diff, then runs the review and fix loop. Use for /taith:build, or as step 5 of the feature playbook."
disable-model-invocation: true
---

# Build

Turn an approved outline into reviewed code. You write no code. You brief a fresh worker for each slice, read a verdict on what it did, and decide what happens next. Nothing pauses for the person between slices, in review, or in the fix round.

All paths below are under `.planning/<feature>/`. Pass them to workers and subagents as absolute paths. `<plugin>` is two levels above this skill's base directory.

## 1. Load

Read `outline.md` and nothing else. A fresh lead needs no other file to run the build.

Put every slice on your todo list. A slice ticked in `outline.md` is done. Trust its commit and resume from the first slice that is not ticked. If a `runs/` folder holds a worker with no report, run `<plugin>/scripts/taith-worker status --planning <dir>` and decide whether to wait for it or replace it.

Create the feature branch from the base branch in the outline, unless you are already on it. Every slice merges into this branch.

## 2. Run one slice

Do these steps for each slice. Start every slice whose dependencies have merged and that the outline says can run beside the ones in flight. Each slice gets its own worktree and its own branch, `<feature>/slice-<N>`, cut from the feature branch's current tip.

### Write the brief

Write `slices/<N>-brief.md` from `references/brief-template.md` at the moment you delegate the slice, not before. An earlier slice may have changed what a later one should be told.

The brief holds the slice's section from the outline word for word, the digest decisions it touches with their numbers, pointers to what earlier slices landed (the commit and the notes file), the model, and the paths for the worker's notes and report. Expect 30 to 60 lines. Do not paste research or design text into it. Name the section instead.

If you cannot write the brief without knowledge that only the previous worker had, the outline is wrong. Stop and fix the outline. Do not keep a worker alive to carry that knowledge.

### Start the worker

```bash
<plugin>/scripts/taith-worker spawn --role implementer --name slice-<N> \
  --planning <dir> --brief <dir>/slices/<N>-brief.md \
  --worktree <path> --branch <feature>/slice-<N> --base <feature branch> --model <model from the brief>
```

- **`BACKEND: hc`.** The script started an hc worker with `/taith:build-slice <brief>` as its launch prompt. Run `taith-worker wait --planning <dir> --name slice-<N>` as a background command and carry on with other slices.
- **`BACKEND: native`.** The script created the worktree and started nothing. Start an `Agent` on the `native implementer` role from the role sheet (`../lead/references/roles.md`). Its prompt is one instruction: read the skill at the absolute path of `../build-slice/SKILL.md` and follow it with the brief at its absolute path, working only in the worktree.

A retry or a fix gets a new worker name, such as `slice-<N>-b`. The script refuses a name it has seen.

### Read the result

When the worker finishes, read the first line of its report, then the report. Reports are short. Never read raw test output or the diff yourself.

Then start a `taith:slice-checker` subagent on the `slice checker` role. Give it the brief, the report, the notes, the worktree, and the base and head commits. Read its verdict.

| Report | Checker | What you do |
| --- | --- | --- |
| `DONE` | `PASS` | Merge the slice branch into the feature branch. Tick the slice in `outline.md`. Start whatever this unblocks |
| `DONE` or `ISSUES` | `ISSUES` | Start a fresh worker with consolidated scope: the brief, the notes, and the checker's list |
| `ISSUES` | any | The same. If the worker stopped because the slice outgrew its brief, the fresh worker continues from its commit and notes |
| `BLOCKED` | not run | Answer the question, below |

A merge that conflicts means the outline wrongly called two slices independent. Give the conflict to a fresh worker with both slices' notes, and correct the table in the outline.

**A second failure on the same slice stops that slice.** Do not send a third worker at the same brief. Work out whether the brief, the outline or the design is wrong, and fix that.

### Answer a blocked worker

A worker never asks the person. It writes `BLOCKED` with its question and what it would choose, and stops. Classify the question as you would any fork.

- The digest or `design.md` answers it. Start a fresh worker with the answer added to the brief.
- It needs a fact about the code. Send a lookup through the **how** skill (`../how/SKILL.md`), then start a fresh worker.
- A run could settle it. Prototype it, then start a fresh worker.
- It would change a designed interface, or it is a preference call. Only this reaches the person. Ask one question with your recommendation. Slices that do not depend on the answer keep running.

### Record deviations

A worker makes small design calls inside its slice and reports each one. It does not absorb a change to a designed interface. It reports that as `BLOCKED`.

For each deviation in a report, decide whether it stands.

- **Accept.** A moved file, a renamed private symbol, an extra helper, a test placed differently, or a sketch that did not compile as written. Add a line under `## Accepted deviations` in `outline.md`: the slice, what differs, and why you accepted it. Review treats that line as part of the spec.
- **Reject.** It breaks a decision or the slice's behaviour. Start a fresh worker with the correction.

## 3. Supervise

- **Judge a worker by its commits and its report file, not by its status text.** Use `taith-worker status` for one line per worker.
- **Replace a worker that stalls or loops.** `wait` prints `STATUS: TIMEOUT` with the pane's state when no report arrives. Retry by cause: a smaller scope after a context limit, the same brief after a dropped connection, a different model after a tool error.
- **Send back work that drifts** from its slice or grows past what was asked.
- **Account for every worker you started** as merged, replaced, or dropped with a reason.
- **Watch for a wrong design.** The same kind of deviation from two or more slices, or the same workaround in unrelated slices, means the shape is wrong. Stop the build and follow "When the build shows the shape is wrong" in the **architect** skill (`../architect/SKILL.md`).
- **The person may type into any worker's pane.** Treat what the worker then reports as a directive, and carry it into later briefs.

## 4. Check the whole

When every slice is ticked, start one `taith:slice-checker` subagent in the feature branch's checkout. Tell it to run the outline's full suite and verify commands and to return the verdict with only the failing lines. A failure goes to a fresh worker with the failing lines, the outline and the notes of the slices most likely responsible.

## 5. Review and fix

Read the **review** skill (`../review/SKILL.md`) and run it as its caller, under the contract in `../../docs/conventions.md`. Supply the base ref, the spec paths (`outline.md`, `slices/`, `design.md`), round `1`, and the findings file path `runs/review-1/report.md`.

Review decides each finding and decides when the loop ends. You do no triage of your own.

- **`DONE`.** Go to step 6.
- **`ISSUES`, loop continues.** Write a consolidated brief from `references/brief-template.md` that points at the `## Fix` section of the findings file. Start a fresh implementer on the feature branch with it. When its checker passes, run review again with the next round number.
- **`ISSUES`, loop ended at the cap.** Start no further fix round. Tell the person which blockers are open.
- **`BLOCKED`.** Tell the person why.

Use the **interrogate** skill (`../interrogate/SKILL.md`) as an extra lane when the change is contested.

## 6. Hand over

Run `<plugin>/scripts/taith-worker reap --planning <dir> --into <feature branch>`, and remove each worktree it lists as `remove`.

Then run the **open-pr** skill (`../open-pr/SKILL.md`), with the person's consent. It reads the last review round's findings file. Give it every "Check by hand" item from the outline and every item a worker's notes list as unverified, for the PR description. Stop at merge-ready. The person reviews and merges.

## Program tier

After the outline check a fresh lead coordinates and writes no code. Each PR in the outline gets one owner, started with `--role pr-owner`, that runs steps 2 to 6 for its PR and stops at merge-ready. A verifier that is not the author gives a verdict for each head commit. The program playbook (`../lead/playbooks/program.md`) has the detail.

**Reply:** what landed against the goal, each accepted deviation, the review status and what it left open, what the person must check by hand, every worker accounted for, and the PR link.
