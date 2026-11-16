# The findings file

The session that runs the review writes this file at `.planning/<feature>/runs/review-<round>/report.md`. It is the only writer. Three readers use it: `build` reads the status and the summary lines, a fix worker reads the `Fix` section inside its brief, and `open-pr` reads `For the PR`, `Declined` and `Account of the change`.

Keep the section names and their order. Write `None.` under a section with no entries. Do not drop the section.

````markdown
STATUS: ISSUES
round: 1 of 3
base: <sha>
head: <sha>
loop: continues | ended, no open blocker | ended at the cap
open blockers: 2
lanes: Spec reviewed. Standards skipped (no rule documents). Comments reviewed. Structure reviewed. Defects same family (seat timed out).

## Fix

### R1-1
- label: blocker (presumptive)
- lane: Spec, Defects
- bucket: not done
- where: src/import/parse.ts:88
- finding: `parseDate` returns `null` for an empty string and `importRow` dereferences the result.
- cite: outline.md, slice 2: "an empty date cell imports as no date". Hunk: `const d = parseDate(cell); row.day = d.getDay()`.
- done when: `bun test import/parse` passes with a case for an empty date cell, and `importRow` handles `null`.
- detail: ...
- conflicts with: none

## Declined

### R1-4
- label: blocker (presumptive)
- lane: Standards
- where: ...
- finding: ...
- cite: ...
- declined because: design.md decision 7 keeps the legacy import path until the migration ships.

## For the PR

### R1-6
- label: suggestion
- lane: Structure
- where: ...
- finding: ...
- cite: ...
- detail: ...

## Resolved

- R1-2: resolved in round 2. <evidence, with path:line>

## Account of the change

As planned:
- <requirement> (<path>)

Accepted deviations:
- <the line from the outline> (<path>)
````

## Rules for the file

- **Status.** `DONE` when `open blockers` is 0, otherwise `ISSUES`. A file that starts `STATUS: BLOCKED` has the reason on line 2 and nothing else.
- **Fix.** Blockers first, then suggestions. Every entry carries all of `label`, `lane`, `where`, `finding`, `cite` and `done when`, because the fix worker reads this section and nothing else from the review.
- **Open blockers.** The count of blockers under `Fix`. A blocker under `Declined` is not open.
- **Bucket.** Only Spec findings have this line.
- **Ids.** A finding keeps its id for the whole loop. In round 2 a finding that is still open stays under `Fix` as `R1-1` and gains a line: `still open after round 1 fix: <what the fix missed>`.
- **Later rounds.** Each round's file is complete. Copy `Declined`, `For the PR` and `Account of the change` forward from the previous round, so the last file is the only one `open-pr` needs.
- **Resolved.** Appears from round 2. One line per finding the recheck confirmed.
