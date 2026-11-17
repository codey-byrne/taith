### Program

**You run the program, never the code. Decide which worker does each piece of work, then check what each one produces.** For work that needs several PRs. One owner carries each PR from build to merge-ready. Nothing is called ready until a verifier that never wrote the code has proven it. The person merges.

Work that one worker could finish inside one PR is not a program. Use Feature. One task driven to a predicate is Autonomous run.

#### Before code

1. **Clarify and research**, as Feature steps 1 and 2.
2. **Design, with two sign-offs.** Run the **design** skill (`../design/SKILL.md`) and follow its Program tier section. The person signs off the system design before the program design starts, since a wrong contract invalidates every module sketch built on it.
3. **Settle open questions by prototype** before you outline. Run `playbooks/prototype.md` for each. Ask the person only about a product or preference call that no run can settle, and give options.
4. **Outline, one section per PR.** Run the **outline** skill (`../outline/SKILL.md`). At Program size the slices are grouped under one heading per PR. One PR is one change with its own evidence (the **principle-sequence-verifiable-units** skill). Each PR section adds four things to its slices.
   - **Depends on.** The PRs that must land first, or none.
   - **Files.** The paths this PR may write. Two PRs that can run side by side never share a path.
   - **Evidence.** A unit check, a live check and a perf check, each a command or a named scenario with its pass predicate. Tests alone are not sufficient verification. The live check drives the real surface, with the repo's verification skill or Claude Code's `run` skill. One live scenario runs on trunk and on the head, so a regression shows. The perf check names the metric, the probe, the trunk baseline measured first, and the number that fails. A PR that cannot move a number says so in one line with the reason.
   - **Review gate.** Whether the PR changes an interaction. If it does, its description carries screenshots of the change for the person.
5. **The outline check.** The person reviews `outline.md`. This is the one deep review before code. The build always starts from a fresh lead, which reads `outline.md` and nothing else. That fresh lead is the coordinator, and the rest of this playbook is its job.

#### Topology

- **One owner per PR.** The owner is the only writer of its branch and carries the PR from build to merge-ready. Only the owner pushes, rebases, or retargets it. Closing or retargeting a base PR orphans every PR above it, so the owner does that only on your call. You never author or edit code. Conflicted merges, chain rebases, and fixes go to owners.
- **Start an owner from its own folder.** Write `.planning/<feature>/prs/<pr>/outline.md` with the digest, that PR's slices and an empty `## Accepted deviations` section. Write `owner-brief.md` beside it from `../own-pr/references/owner-brief-template.md`. The brief carries everything the owner needs, including the report of each upstream owner it depends on, by path. Owners can't see their siblings. Then run `../../scripts/taith-worker spawn --role pr-owner --name <owner> --planning <dir> --brief <owner-brief> --worktree <path> --branch <branch> --base <base>`. The owner follows the **own-pr** skill (`../own-pr/SKILL.md`): it runs `build` for its PR, opens the PR when the brief says so, babysits it in `drive` mode, and reports.
- **Without hc there is no owner.** On `BACKEND: native`, run the **build** skill (`../build/SKILL.md`) for each PR folder yourself, one PR at a time. `build` still delegates every slice, so you still write no code.
- **Run owners in parallel off trunk.** Stack a PR only when it builds on another PR. Base it on that PR's branch, and it rebases onto its parent's branch while the stack root rebases onto trunk. A new head on the lower PR restacks the PRs above it. A PR whose `git patch-id` the restack leaves unchanged keeps its verdict.
- **Start with one PR.** Take it through brief, owner, verifier, and merge-ready before you fan out, so a flaw in the brief costs one owner instead of all of them. Then keep the independent PRs in flight together, and start the next owner as each finishes instead of waiting on a batch.
- **A fresh worker for new work.** A replacement owner gets consolidated scope: the brief, every later directive, and the previous owner's report and branch. Wait on owners with `taith-worker wait` as a background command. Never interrupt an owner to check on it.

#### Supervision

- **Each brief names the evidence that proves the work is done**, copied from the PR's section. It also names the goal, the paths the owner may and may not write, and the actions it must not take. If you can't name the evidence, the PR isn't scoped yet.
- **Read the verdict or the artifact, not only the owner's summary.** Green CI is an input to a verdict, not a verdict. Behavioural work needs more than a type check.
- **Send back work that drifts from scope or grows past what was asked.** Keep only the fixes that block the program, and park the rest as follow-ups.
- **Check a PR's live state before you report on it**, with `gh pr view` and `gh pr checks`, not the owner's last report. Account for every worker you started as done, replaced, or absorbed into another worker's scope.
- **Replace a worker that stalls or loops.** Judge it by its pushes and PR activity, not its status text. Retry by cause: a smaller scope after a context limit, the same brief after a dropped connection, and a different model after a tool error. After two retries, drop the PR and replan around it. When a replaced worker returns late, check its result against the PR's current state, and hand any unique findings to a fresh worker.
- **Ask the person only for a real decision or a blocker**: an irreversible action, a product or preference call that no experiment settles, or a dead end that survived a replan. Rebase mechanics, retries, CI flakes, review triage, and "should I keep going" never reach the person.

#### Verdicts

A verdict covers one patch, and green CI covers one head.

1. **The owner reports the code-ready head.** The code is ready after the owner's `build` has finished its review loop. The owner then rebases onto current trunk, or onto its parent's branch in a stack, and reports the head, so verification runs on the base the patch lands on. It reports every later head. Fix rounds stay on that base unless trunk conflicts, breaks CI, or lands a known concurrent change to the same files, because each rebase restarts CI.
2. **You verify, once, with lanes that never wrote the code.** At the code-ready head, fan out independent verifiers through the **swarm** skill (`../swarm/SKILL.md`). One lane re-runs the gates. The live lanes run the PR's live evidence on the real surface. One lane runs the perf check. At least two lanes audit the diff and the report's receipts, each with its own focus, and distrust the PR body. The verdict is not clean without a live lane. Another full swarm runs only for new behaviour, a redesign, or a large new diff. A rebase, a conflict resolution, or a minor fix gets a single verifier at the new head. A wording-only change gets none. The patch-id rule in `playbooks/shipping.md` decides which results carry over.
3. **Block a PR only for a problem you can show**, with a failing run at the head or a doc line the PR made wrong. A problem the PR's base already has doesn't block unless the PR copies it or newly reaches it. Only a bug a user would hit, a failed gate, or a wrong shipped doc blocks. Everything else goes in a follow-up.
4. **Anything that loosens a gate needs your countersign**, such as a raised budget or an allowlist entry. A verifier proves the loosening is right first, because the owner is the one who wants green. A disabled or soft-failed check always comes out, because it stops guarding every case. Never bypass an approval the forge enforces.
5. **Hand over at merge-ready.** A PR is merge-ready when your verdict is clean at its current head, CI is green and its babysit has ended. Nobody pushes to a merge-ready PR without the person's go. For a stack, run `playbooks/shipping.md` to give the person the landing order.

#### The audit tick

A long run drifts, and workers stall silently. On the person's go, arm Claude Code's `/loop 1h` with a prompt that names this file. Each tick re-reads this playbook and fixes drift, such as an unreported head or an unrecorded worker, by having its owner record it. It reads `taith-worker status` and judges each worker by its side effects, because status text and summaries can hide a stuck child. A worker is stuck when it errors or shows no new push and no new report line past the time its kind of work has taken before. A worker waiting on you is not stuck, so answer it. Replace a stuck worker at once. A tick that changed something for the person ends by catching them up through the **catchup** skill (`../catchup/SKILL.md`). A tick that changed nothing stays quiet. Keep the trail with the **show-me-your-work** skill (`../show-me-your-work/SKILL.md`).

**Stand down at once on the person's stop.** Start no new worker and no new verifier. The script has no verb that interrupts a running worker, so list the running workers from `taith-worker status` and tell the person which panes to stop. Each worker keeps its brief until the person releases it.

**Reply:** what is merge-ready against the goal, each PR's live state and verdict with its link, the landing order, countersigns and why, what was dropped and why, parked follow-ups, and the decisions waiting on the person.
