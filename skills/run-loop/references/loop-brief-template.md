# Loop brief: <playbook> on <target>

The lead fills this in before it starts a loop runner. Settle everything that needs the person first, and write the answer here. The runner has nobody to ask.

Goal, in one or two sentences: <what the person wants from this loop>

## The loop

- Playbook: <babysit | shipping | hillclimb | autonomous-run>
- Target: <the PR or the stack from the bottom up, the metric, or the task>
- Exit condition: <a predicate the runner can check, such as "PR 12 is merge-ready", "p95 latency at least 30% below baseline and at least 10 iterations", or "the full suite passes">

<Keep the lines for the playbook in use and delete the rest.>

- Babysit mode: <drive | background | threads-only | check>
- Shipping stack: <each PR from the bottom up, with its branch>
- Hillclimb metric: <the metric, the direction that counts as better, the baseline when it is known, and the tests that must keep passing>
- Autonomous-run scope: <what the runner may change to reach the exit condition>

## Where you work

- Worktree: `<absolute path>`
- Branch: `<branch>`
- Base branch: `<branch>`

## What you may and may not do

- Push to: <branches, or "nothing">
- Open the PR: <yes | no>
- Reply on review threads: <yes | no>
- Rebase or retarget: <the branches the runner owns, or "none. Report it">
- You may write: <paths>
- You may not write: <paths>
- You must not: merge, deploy, delete data, or push to a branch that is not listed above.

## Verify

The worker script reads the first code block under this heading and allows those commands in the worktree. Keep the heading and put one command on each line.

```text
<each command the loop runs to check its work, one per line>
```

## What the runner should know

<Decisions and patterns that bind the work, each as a pointer to a file and a section. What an earlier runner left: its report, its trail and its resume note. "Nothing." otherwise.>

## Directives from the person

<Anything the person said that binds this loop. "None." otherwise.>

## What you write at the end

- Report: `<absolute path>/.planning/<feature>/runs/<worker>/report.md`
- Trail: `decisions.tsv` in the same folder
