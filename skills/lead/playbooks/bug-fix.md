### Bug fix

**You own the diagnosis and the verdict. You delegate the reading and the fix.** A fix that passes the small-fix test below goes inline. Any other fix goes to one implementer worker.

Be scientific. Every shipped line traces to runtime evidence. A change that "might help" is a hypothesis, not a fix, and it does not ship. When evidence refutes a hypothesis, revert what it motivated. The smallest change the evidence justifies ships, nothing more.

Select known non-sensitive fields before you print diagnostic configuration or a service response. Do not dump a whole configuration or environment.

1. **Reproduce it yourself** on the matching surface, even when a debug protocol says to ask the person to reproduce. Drive the surface with the repo's verification skill, or with Claude Code's `run` skill when the repo has none. Ask the person only with a stated, specific reason the surface cannot reach the target, and only after driving it as far as it goes. If it won't reproduce directly, synthesize the trigger, tighten conditions, or instrument until it fires. Write the report and the repro to `.planning/<bug>/task.md`.
2. **Binary-search the cause.** Form the candidate hypotheses, then rule them out until one survives. Seed them with a lookup over the affected subsystem through the **how** skill (`../how/SKILL.md`) and with the **why** skill (`../why/SKILL.md`) for regression history. Each pass, take the split that cuts the most remaining problem space, get runtime evidence, eliminate. When program state is unclear, add instrumentation or logging and read it as the code runs. Don't guess. Drive a long or stubborn hunt with Claude Code's `/loop`. Confirm the surviving mechanism with runtime evidence before step 3.
3. **Plan the fix.** Run the **architect** skill (`../architect/SKILL.md`) first when the fix crosses a function boundary. Run it even inside one function when the fix changes an interface, ownership, a schema, migration behaviour, a concurrency or transaction guarantee, or a deployment or routing contract.
4. **Fix.** When the small-fix test passes, make the change yourself, per the **test-first** skill (`../test-first/SKILL.md`). Otherwise write one brief from `../build/references/brief-template.md` with the repro as its acceptance test, and start one implementer as the **build** skill (`../build/SKILL.md`) describes in "Run one slice". A slice checker reads the diff.
5. **Verify on the same surface.** The original repro now passes. "Inconclusive" or wrong-surface is not a pass. Flag it. Unit tests show branch behaviour, not bug absence.
6. **Order the commits so the failing repro lands before the fix.** Skip the test commit when the test would be expensive, integration-heavy, or unclear. This is the **principle-sequence-verifiable-units** skill in its plainest form.
7. **Review.** Run the **review** skill (`../review/SKILL.md`), in its single-reviewer mode for an inline fix and in full for a worker's fix. A fix to code that enforces a security or data-integrity invariant gets the full review even when the fix is inline and preserves the invariant.
8. Run the **open-pr** skill (`../open-pr/SKILL.md`) with the person's consent. Stop at merge-ready.

#### The small-fix test

You may skip the lookups in step 2 and the architect step, read the code you change yourself, and fix inline only when all of these hold.

- Runtime evidence establishes the cause in one subsystem.
- The correction preserves interfaces and state semantics. It changes no signature, ownership, schema, migration, security, concurrency, transaction, or deployment and routing behaviour. Security covers authentication, authorization, cryptography and secret handling.
- A cheap regression check exercises the failure under the relevant runtime settings, and you can verify on the original surface.
- No competing design or contradictory evidence remains.

Record the evidence for each condition in your todo list before the skip. If a condition is false, stays unknown, or later evidence breaks it, go back to steps 2 and 3 in full. Patch size alone never qualifies a fix.

**Reply:** what was broken, the root cause, the fix, and how you verified. Quote the decisive failing and passing output, trimmed to the assertion and the counts. When a deploy or a publish is part of the task, also say what version and behaviour the affected runtime served afterwards. Missing or contradictory runtime evidence leaves the bug unresolved. Remove credentials and customer data from quoted evidence.
