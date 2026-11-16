# Brief: slice <N>. <Behaviour the slice delivers>

Goal of the whole change, in one or two sentences: <from the outline's opening lines>

## Your slice

<The slice's section from outline.md, copied word for word: Behaviour, Seam, Acceptance tests, Files likely touched, Change outline, Check by hand, Depends on.>

## Verify

```text
<the slice's verify commands, one per line, copied from the outline>
```

## Decisions that bind this slice

<Each digest decision this slice touches, copied with its number. An implementation that breaks one fails the slice even when the tests pass.>

- D2. <...>

## Patterns to follow

<The digest patterns that apply here, each with its file pointer.>

## What earlier slices landed

<For each slice this one depends on: the commit and the notes file. "Nothing. This is the first slice." otherwise.>

- Slice 1: commit `<sha>`, notes at `<absolute path>/slices/1-notes.md`

## Sections you may pull

<The slice's context line, as absolute paths with headings. Read one only when you need it. "None." when the brief is enough.>

## Where you work

- Worktree: `<absolute path>`
- Branch: `<branch>`
- Base commit: `<sha>`
- Model: `<sonnet | opus>`

## What you write at the end

- Notes: `<absolute path>/slices/<N>-notes.md`
- Report: `<absolute path>/runs/<worker>/report.md`

<For a fix round, add this section and nothing else new.>

## Findings to fix

Read the `## Fix` section of `<absolute path>/runs/review-<round>/report.md` and nothing else in that file. Each entry has a `done when` line. This brief replaces the slice sections above with: every earlier directive that still holds, and the notes of each slice the findings touch.
