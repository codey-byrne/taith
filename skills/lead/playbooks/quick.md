### Quick

**You do the work yourself.** No workers, no artifacts, no `.planning` folder. The lookup rule does not apply in this tier, so read the code directly.

Use this playbook only for one or two files with an obvious approach. If the change needs a design decision, touches an interface that other code calls, or grows past two files, say so and move to **Feature**.

1. Read the code you will change. Start one explorer through the **how** skill (`../how/SKILL.md`) only when the surrounding behaviour is unclear.
2. Write the test first, per the **test-first** skill (`../test-first/SKILL.md`). Run it once and see it fail for the right reason. When a test is impractical, use the closest executable check and say which.
3. Make the smallest change that passes. Follow the comment rule in the **comments** skill (`../comments/SKILL.md`).
4. Run the checks for the code you touched.
5. Run the **review** skill (`../review/SKILL.md`) in its single-reviewer mode on the diff. Fix what it finds.
6. Run the **open-pr** skill (`../open-pr/SKILL.md`) with the person's consent. Stop at merge-ready.

**Reply:** what changed and why, the failing-before and passing-after output, the review result, and the PR link.
