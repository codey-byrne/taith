### Visual parity

**You own pixel-exact equivalence. The baseline is the spec. You do not touch it.** Equivalence is verified by image diff, not by eye.

1. Establish the baseline first, before any migration: a visual regression harness that screenshots the current component across its states, plus the target when matching two implementations. No baseline, no parity claim. This is a blocking prerequisite, not a follow-up.
2. State the anti-shortcut clauses in every brief, and hold them: no harness modifications, no baseline tampering, no component restructuring to make a diff pass. A worker that thinks the baseline is wrong writes `BLOCKED` and stops. Bring that to the person. Do not edit the baseline.
3. Migrate one component at a time. Write the outline with one slice per component, and run the **build** skill (`../build/SKILL.md`). Each component gets its own worker and worktree (the **principle-separate-before-serializing-shared-state** skill). Shared primitives migrate first, as a slice the others depend on.
4. Each slice's verify command is the image diff against its baseline, on the matching surface. A nonzero diff is a fail. The worker investigates the pixel delta and repeats until the diff is zero.
5. Run the **open-pr** skill (`../open-pr/SKILL.md`) per component or per safe batch, with the person's consent.

**Reply:** components migrated, the diff result for each, the baseline harness location, what's left.
