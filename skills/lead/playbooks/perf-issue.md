### Perf issue

**You own the measurement story. Plan, review, verify the numbers.** Tie every fix to a measurement. Don't read source instead of measuring.

1. Capture a baseline trace on the matching surface, with the repo's verification skill or Claude Code's `run` skill. Vet the baseline, and each later number, with the **benchmark-checklist** skill (`../benchmark-checklist/SKILL.md`).
2. Ground the hypotheses with a lookup through the **how** skill (`../how/SKILL.md`). Don't claim a perf ceiling without running it first.
   Try the performance mantras in order, cheapest first:
   1. Don't do it. Stop work whose result nothing uses rather than cheapening it.
   2. Do it, but don't do it again.
   3. Do it less.
   4. Do it later.
   5. Do it when they're not looking.
   6. Do it concurrently.
   7. Do it cheaper.

   When an earlier mantra meets the target, stop.
3. Plan the fix from the trace. If it crosses a function boundary, run the **architect** skill (`../architect/SKILL.md`) first. Write one brief from `../build/references/brief-template.md` whose verify commands produce the number, and start one implementer as the **build** skill (`../build/SKILL.md`) describes in "Run one slice". A one or two file fix with an obvious approach goes inline, as in the Quick playbook. Read the checker's verdict on the diff. Capture a post-fix trace.
   Apply the **principle-sequence-verifiable-units** skill, verifying each attempt before trying the next.
4. Parse and compare the artifacts (JSON to sqlite, then diff). Parse a large artifact in a subagent and keep the reduced comparison. "Inconclusive" or wrong-surface is not a pass. Flag it.
5. Run the **review** skill (`../review/SKILL.md`), as in Bug fix step 7.
6. Run the **open-pr** skill (`../open-pr/SKILL.md`) with the person's consent. Cite the measurement in the PR description. Stop at merge-ready.

For sustained improvement against a metric rather than a one-off fix, use the Hillclimb playbook (`playbooks/hillclimb.md`).

**Reply:** baseline number, post-fix number, delta, artifact path.
