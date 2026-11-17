---
name: interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Adversaries try to break a change or design, one of them from another vendor, and only findings proven by a run survive."
disable-model-invocation: true
---

# Interrogate

Adversaries try to break a change or a design. A finding survives only when a run proves it. Report the findings. Do not apply fixes.

## Frame

The scope is what the caller names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree.

State the intent with the **in-your-own-words** skill (`../in-your-own-words/SKILL.md`), from the person's message, the commits, and the PR description. In a feature, take the intent from the digest at the top of `outline.md`. Ask the person when the intent is unclear. When a skill calls this one and supplies the intent, ask nothing.

## Fan out

Fill `references/adversary-brief.md` once with the scope and the intent. Every adversary gets the same brief.

**Native adversaries.** Give each adversary its own git worktree at the scope's head, per Phase A step 4 of the **arena** skill (`../arena/SKILL.md`), and copy the scope's uncommitted changes into it. Spawn at least two in one message with the `Agent` tool, `subagent_type: "general-purpose"` and the `interrogate adversary` role in the role sheet (`../lead/references/roles.md`). If an adversary returns nothing, proceed without it and note the dropout.

**The cross-vendor seat.** One more adversary is a model from another vendor, because a second model family breaks what the first one reads past. Write the filled brief to a file and start the seat.

```text
<plugin>/scripts/taith-worker spawn --role vendor-reviewer --name interrogate-<slug>-seat --planning <dir> --brief <brief file>
```

`<dir>` is the feature's `.planning/<feature>/` folder when there is one. Otherwise it is a scratch directory that you create first. Run `spawn` from the checkout that holds the scope, so the seat reads the same tree. Then run `taith-worker wait --planning <dir> --name interrogate-<slug>-seat --timeout 900`. The seat's findings are the body of its `report.md`.

The seat is read-only and may be unable to write a repro file. The brief tells it to put the full text of each repro file in its report. You write that file and run its command in the Verify step.

If `spawn` prints `BACKEND: native`, or the seat fails to start, or `wait` prints `STATUS: TIMEOUT`, carry on with the native adversaries and say that no second vendor attacked the change. Never hold the verdict for the seat.

## Verify

Rerun each finding's command yourself, in a scratch worktree with the scope's changes applied. For a finding from the seat, first write each repro file it reported. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause.

There is no judge, no base and no graft. Adversaries find different failures, so the verdict keeps every verified finding, not one adversary's list.

Remove the worktrees when the verdict is written.

## Output

- **Intent**: the restatement.
- **Findings**: for each verified finding, the command, its output, how it breaks the intent, and the adversaries that found it. Say "no verified findings" when none survive.
- **Dropped**: for each adversary, the count of dropped findings and why.
- **Seat**: whether the cross-vendor seat ran.

Typed by a person, this is the reply.

When a skill calls this one and gives a report path, write the same content to that path under the report contract in `../../docs/conventions.md`. The first line is `STATUS: DONE` with no verified finding, `STATUS: ISSUES` with at least one, or `STATUS: BLOCKED` with the reason on line 2 when the adversaries could not run. In the build's review step, the lead gives each verified finding to the fix worker in the same consolidated brief as the `## Fix` section of the review's findings file.
