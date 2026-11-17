---
name: swarm
description: "Fan out N parallel subagents, drain them, and return one report. Use for /taith:swarm, 'swarm this', or parallel coverage, races, gauntlets, and exploration."
disable-model-invocation: true
---

# Swarm

## Start

Open a todo list with one entry per phase before launching anything.

1. Frame
2. Fan out
3. Aggregate
4. Report

## Phase A: Frame

1. State the done predicate and the artifact or report the swarm must return.
2. Choose the shape. Partition into lanes, race N subagents on identical briefs, or mix both. For a race or mixed shape, declare `first pass`, `rank all`, or `best-of` before spawning.
3. Pick the role from the role sheet (`../lead/references/roles.md`). A lane that only reads uses the `swarm reader` role, which is `subagent_type: "Explore"` and cannot edit. A lane that writes or must run more than read-only commands uses the `swarm worker` role, which is `subagent_type: "general-purpose"`. A model race is the one case where a brief names a model. Name each arm's model up front.
4. Give each writing lane its own writable output: a git worktree created with `git worktree add`, or its own directory. When a lane must start from another branch, check that branch out in the lane's worktree and name the worktree path in its brief. When lanes verify or measure commits, each brief names the exact SHAs. A measurement brief also names the method (sample count, what one sample is, order). The lane records both in its result.

A swarm lane is a short native subagent whose result you consume. Work that writes a slice of a feature, owns a PR or runs a long loop is a worker's job and goes through the **build** skill (`../build/SKILL.md`).

## Phase B: Fan out

Spawn all N subagents in one message with the `Agent` tool and the step 3 role.

Every brief stands alone. Include the goal, scope, exact lane or race arm, how to verify, what to report, and the absolute path of any skill file the lane must read. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence. A lane that can prove a defect reports `ISSUES` and lists every issue it can prove, not only the first.

If a lane drops out, proceed with N-1 and note it.

## Phase C: Aggregate

Read the terminal results. Drop a result that does not record the SHAs and method its brief names, and respawn that lane once. After a second miss, record a gap. A gap does not count as a pass. For coverage, every required lane needs a result. For a race, apply the selection rule declared up front. Use first pass, rank all, or best-of. Do not paste raw subagent dumps.

Remove each worktree whose result you have taken.

## Phase D: Report

Return one consolidated in-chat report with a result table, issue one-liners, gaps or dropouts, and the race rule when used.
