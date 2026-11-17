---
name: arena
description: "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. A model from another vendor judges. Use for /taith:arena, 'arena this', 'throw it in the arena', or when one attempt at a non-trivial artifact would lock in the wrong shape."
disable-model-invocation: true
---

# Arena

Open a todo list with one entry per phase (Frame, Fan out, Cross-judge, Pick, Graft, Verify) before launching anything.

## Phase A: Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive the rubric, 3-6 concrete gradeable criteria for what success looks like on *this* task. It is the picker's tool in Phase D. Candidates only see the task.
3. Pick the runners. A skill that calls arena names the runner role, as the **architect** skill does. Otherwise use the `arena runner` role in the role sheet (`../lead/references/roles.md`). Run at least two. Spawn more when the arena covers several design directions, and give each runner its direction. Every runner is a Claude subagent, because another vendor's model judges and never writes.
4. Give each candidate its own output location, per the **separate-before-serializing-shared-state** principle skill (`../principle-separate-before-serializing-shared-state/SKILL.md`). Use a git worktree for a code artifact, created with `git worktree add`. Otherwise use `<scratch>/arena-<slug>/candidate-<n>/`, where `<scratch>` is the session's scratch directory or `/tmp`.

## Phase B: Fan out

Spawn all N subagents in one message with the `Agent` tool. Take `subagent_type`, `model` and `effort` from the step 3 role's line in the role sheet. Each gets the task, the path to the shared grounding, its own output path, the absolute path of every skill file it must read, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.

If a candidate produces no output, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

The judge is the cross-vendor seat, so it is never from your own model family. A judge from your family shares your biases and confirms your pick.

After all Phase B candidates complete, fill `references/judge-brief.md` and write it to a file. The judge sees the rubric and the candidates by path label, scores each criterion, and recommends a base with rationale.

Start the seat with the worker script.

```text
<plugin>/scripts/taith-worker spawn --role vendor-reviewer --name arena-<slug>-judge --planning <dir> --brief <brief file>
```

`<dir>` is the feature's `.planning/<feature>/` folder when there is one. Otherwise it is `<scratch>/arena-<slug>/`. The folder must exist before `spawn` runs. The seat's verdict is the body of the `report.md` that `spawn` prints.

The judge runs while you read in Phase D. Don't start it while candidates are still writing. When your own scoring is done, run `taith-worker wait --planning <dir> --name arena-<slug>-judge --timeout 900`.

If `spawn` prints `BACKEND: native`, or the seat fails to start, or `wait` prints `STATUS: TIMEOUT`, skip the judge, pick the base alone in Phase D, and say so. Do not put a subagent from your own family in the judge's seat.

## Phase D: Pick a base

Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge when Phase C ran one. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API, per the Laziness Protocol.

## Phase E: Graft

Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the **redesign-from-first-principles** principle skill (`../principle-redesign-from-first-principles/SKILL.md`), so the result stays coherent under one mental model. Don't paste mechanically.

If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape. No graft is needed. If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F: Verify

Verify the synthesized artifact like any other output, per the **prove-it-works** principle skill (`../principle-prove-it-works/SKILL.md`). If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.

Remove each candidate worktree once the synthesized artifact is verified.

## Outputs

One synthesized artifact, with a short synthesis note alongside naming the base and why, the cross-judge's verdict or that Phase C skipped the judge, each graft with its source candidate, what was rejected and why, any convergence or dropouts, and the verification result.
