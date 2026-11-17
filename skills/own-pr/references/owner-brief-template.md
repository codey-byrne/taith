# Owner brief: PR <n>. <What the PR delivers>

Goal of the whole program, in one or two sentences: <from the program outline's opening lines>

## Your PR

<The PR's line from the program outline: what it delivers, and the slices it holds by number.>

## Where you work

- Planning folder: `<absolute path>/.planning/<feature>/prs/<pr>/`. It holds your `outline.md`. You are its only writer.
- Worktree: `<absolute path>`
- Branch: `<branch>`
- Base branch: `<trunk, or the parent PR's branch>`
- Base commit: `<sha>`

## What earlier PRs landed

<For each PR this one depends on: its branch, its head commit, and the seams it added that you build on. "Nothing. This PR does not depend on another." otherwise.>

## What you may and may not do

- Open the PR: <yes | no>
- Reply on review threads: <yes | no>
- Follow the parent when it merges: <yes | no. With yes, retarget to trunk and move your commits onto the merge result>
- You may write: <paths>
- You may not write: <paths that belong to another PR>
- You must not: merge, close or retarget this PR, or push to any branch but your own.

## Verify

The worker script reads the first code block under this heading and allows those commands in your worktree. Keep the heading and put one command on each line.

```text
<the program outline's full-suite and verify commands for this PR, one per line>
```

<The other evidence the coordinator will check: the expected result of each command, and the state the forge must report.>

## Directives from the person

<Anything the person said that binds this PR and is not in the outline. "None." otherwise.>

## What you write at the end

- Report: `<absolute path>/.planning/<feature>/runs/<worker>/report.md`

<For a fresh owner that continues an earlier owner's PR, add this section.>

## What the earlier owner left

- Its report: `<absolute path>`
- The head it reached: `<sha>`
- Why you were started: <the verifier's failure with its evidence, or the rebase that is needed>
