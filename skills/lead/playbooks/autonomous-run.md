### Autonomous run

**You own the exit condition. Define done, then drive to it without stopping.**

**Who runs it.** The lead does step 1, then starts a loop runner through the **run-loop** skill (`../run-loop/SKILL.md`) with the predicate as the loop brief's exit condition. The loop runner starts at step 2 and has nobody to ask. Without hc the lead follows every step inline.

1. State the exit condition as a checkable predicate before the first iteration (tests green, repro fixed, every PR in the set merge-ready, pixel-diff zero).
2. Pick the wake mechanism with Claude Code's `/loop`. An event to watch (CI, a merge, a ref advancing) gets a background command that returns on the event, with a long time-based heartbeat as fallback. No event gets a fixed-interval heartbeat sized to when the result is worth re-checking.
3. Each iteration makes the smallest change the evidence justifies, verifies it against the predicate, commits if it advanced, and discards changes that didn't help. A change that "might help" gets reverted, not left to ride.
   Sequence the work via the **principle-sequence-verifiable-units** skill, verifying each unit before the next instead of batching checks at the end.
4. Mid-run discoveries that support the goal are yours. Address broken skills, related bugs, flaky verifiers, review noise, tooling failures, orphaned follow-ups, and fixable drift yourself, under the **lead** skill's rules (`../lead/SKILL.md`). Put out-of-band fixes on their own branch, and name each one in the report so the lead can open its PR. Do not park reversible work for the person. Stop with `BLOCKED` only for an irreversible action, a product or preference call no experiment can settle, or a real dead end. Keep the predicate as the main drive, and return to it after each side fix.
5. Checkpoint every iteration via the **show-me-your-work** skill (`../show-me-your-work/SKILL.md`), a row for what changed and whether the predicate moved.
6. Stop when the predicate is met. A plateau is not a stop, so keep going and pivot your approach to push past it. Report a genuine dead end rather than spinning, and never relax the predicate to declare victory.

**Reply:** the exit condition, iterations run, what landed, what was discarded, final predicate state.
