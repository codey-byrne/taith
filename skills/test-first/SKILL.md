---
name: test-first
description: "What a good test is, where tests go, and the order of work: the named tests first, seen failing for the right reason, then the code. Loaded by every session that writes code. Use for /taith:test-first, 'write the test first', a regression test for a bug, or TDD."
disable-model-invocation: true
---

# Test first

Make the wanted behaviour executable before you change production code. Write the tests, watch each one fail for the right reason, then write the code that passes them.

This skill covers what makes a test worth keeping, where it goes, and the order of work. It is an implementation skill. Design happens before it, in the **design** and **outline** skills.

Before the first test, read `LANGUAGE.md` if the repo has one, so that test names use the project's domain terms. Respect any ADR in the area you touch. Read the **codebase-designing** skill (`../codebase-designing/SKILL.md`) if you have not. Its terms, such as seam and interface, are used below as it defines them.

## What a good test is

A test verifies behaviour through a public interface, not an implementation detail. The code behind the interface can change entirely and the test still passes. A good test reads as a specification: "user can checkout with valid cart" names a capability that exists. When persisted state or an external side effect is itself the contract, assert that outcome directly.

Expected values come from an independent source: a known-good literal, a worked example, or the spec.

See [tests.md](references/tests.md) for examples and [mocking.md](references/mocking.md) for when to mock.

## Where tests go

Tests cross a **seam**. Seams are a design decision, so they exist before you start.

- **In a slice**, the brief names the acceptance tests and the seam. Write exactly those tests at that seam. State the seam before the first test.
- **In the Quick tier or a bug fix**, use the nearest test that already covers the code path: a unit, component, integration or regression test at the closest public interface.
- **Typed alone with no plan**, ask the person which public interface and which seams to test. List the behaviours to cover in priority order, critical paths and complex logic first, and confirm the list.
- **With nobody to ask**, derive the seam from the scope and the decisions you were given. State it before the first test and put it in your report.

When a test is hard to write at the agreed seam, because the setup is awkward or the behaviour cannot be observed, the design is wrong and the test is not. Do not design while you implement. A slice worker reports `BLOCKED` with what it found. Any other session takes the problem back to design.

## Order of work

1. **Write the tests first.** In a slice these are the acceptance tests the brief names. For a bug it is the smallest test that would have caught the bug. Each test encodes the intended behaviour and does not mirror the current implementation.
2. **Run them once before any production change.** Each must fail because the behaviour is missing. A test that passes, or fails on a typo or a broken import, is wrong. Correct it and run again. Keep the output.
3. **In a slice, commit the tests alone.** Review compares this commit with the final tests, so a test weakened later shows up in the diff. Outside a slice, commit the tests alone only when someone will compare them later. If a hook refuses the red commit, say so and commit the tests with the code.
4. **Implement until they pass.** Write direct, well-structured code and no more of it than the tests need. Preserve the contracts of nearby code. Do not add a feature that no test asks for. Run your tests as a batch, by name.
5. **Tidy once.** Remove duplication, fix names, extract private helpers behind the seam. Run the tests again. A tidy that needs a test changed is not a tidy. It is a design change, and it goes back to design or into your report as a deviation.

There is no red, green, refactor loop per test. The outline already cut the work into vertical slices, and each slice's tests were agreed at the outline check.

## When a test is impractical

Do not force a test. A test is impractical when it needs broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state, or large unrelated fixture churn.

Use the closest executable check instead: a targeted script, a manual reproduction command, browser automation, a snapshot comparison, a log assertion or a focused integration check. Say in your report which check you used and why.

Prefer no new test over a bad test. A bad test mostly tests mocks, encodes implementation details, depends on timing or unrelated global state, needs expensive infrastructure for a small fix, or would be deleted as soon as it proved the fix.

## Anti-patterns

- **Implementation-coupled.** The test mocks internal collaborators, tests private methods, or verifies through a side channel when a stable public interface exists. The tell is a test that breaks on a refactor when behaviour has not changed.
- **Tautological.** The assertion computes the expected value the way the code does, such as `expect(add(a, b)).toBe(a + b)`. It passes by construction and can never disagree with the code.
- **Tests ahead of the slice.** Tests written for a later slice, or beyond the ones named, verify imagined behaviour. They fix a test structure before anyone knows the implementation. Write the tests your slice names and stop.

## Guardrails

- Do not change a test to match a wrong implementation.
- Do not weaken an assertion unless the expected behaviour really changed and you can say why. In a slice that is a deviation, and you report it.
- Keep a regression test on the bug. Leave unrelated coverage and fixtures alone.
- Make a flaky bug's test deterministic where you can, and note the signal the test locks down.
- When a bug exposes a wider class of failures, land the focused regression test first. Then consider sibling coverage.

## Report the evidence

- Name each test or check that failed before the change, with the failure it produced.
- Name the run that passed after the change, with its result line.
- If you could not show a failure before the change, say why and name the closest check you used.

A slice worker puts this under "Tests" in its report. Give result lines, not full output.

## Comments

A public interface that you add or change gets a doc comment before you report. The **comments** skill (`../comments/SKILL.md`) has the rule.
