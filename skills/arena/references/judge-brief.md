# Arena judge brief

Fill `{TASK}`, `{RUBRIC}`, `{CANDIDATES}` and `{REPORT_PATH}`. Change nothing else. Write the filled text to a file and pass that file to `taith-worker spawn` as the brief.

The cross-vendor seat reads this brief in another harness, with no skills loaded, so it names every path in full and leans on nothing else. `{TASK}` is the prompt every candidate received, word for word. `{RUBRIC}` is the numbered criteria from Phase A. `{CANDIDATES}` is one line per candidate: a label such as `candidate-1` and the absolute path of its output. Do not say which runner or constraint produced which candidate. `{REPORT_PATH}` is the absolute path of the `report.md` that `spawn` printed.

```
You are judging candidate answers to one task. Several agents each produced a candidate without seeing the
others. You pick the candidate that makes the best base to build on.

Read anything. Change nothing except the one file named at the end: no edits, no commits, no installs.

The task every candidate was given:
{TASK}

The rubric:
{RUBRIC}

The candidates:
{CANDIDATES}

Read every candidate end to end before you score any of them. Then:

1. Score each candidate on each rubric criterion from 1 to 5. Give one sentence of reason per score, and point
   at the file and line that earned it.
2. Recommend one candidate as the base. The base is the one a future maintainer can extend most easily without
   breaking its invariants. When two are close, prefer the cleaner boundary or the smaller interface.
3. For each candidate you did not pick, name at most two things in it that are worth porting into the base, or
   say there are none.
4. Name any defect you found in the base that would change the pick if it could not be fixed.

Judge what is written, not what a candidate says about itself. A rationale that claims a property the artifact
does not have counts against the candidate.

Write your result to {REPORT_PATH}. The first line is `STATUS: DONE` when you judged every candidate, or
`STATUS: BLOCKED` with the reason on the next line when you could not. From line 2, use this shape.

BASE: <label>
WHY: <two or three sentences>

SCORES
<label>
- <criterion number>: <score>. <reason, with path:line>

GRAFTS
- <label>: <what to port, with path:line>. Or "None."

DEFECTS IN THE BASE
- <defect, with path:line>. Or "None."
```
