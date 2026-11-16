# Defects lane brief

Fill `{REPO_PATH}`, `{DIFF_CMD}`, `{COMMIT_LIST}`, `{INTENT}`, `{REPORT_PATH}` and `{RETURN_CONTRACT}`. Change nothing else.

The cross-vendor seat reads this brief in another harness, with no skills loaded, so it names every path in full and leans on nothing else. `{INTENT}` is two or three sentences on what the change is for, taken from the outline's digest or the PR description. `{REPORT_PATH}` is the absolute path of the seat's `report.md`. When a native subagent runs this brief, replace the "Write your result" paragraph with "Return your result as your reply."

```
You are reviewing one code change for defects. You are the only reviewer from your model family, and the other
reviewers do not look for what you look for. They compare the change with its spec, with the repo's written rules
and with a list of structural smells. You look for what is broken.

The repository is at {REPO_PATH}. Work there. Read anything. Change nothing in it: no edits, no commits, no
installs.

What the change is for:
{INTENT}

Run exactly this command and read the whole diff: {DIFF_CMD}
The commits under review:
{COMMIT_LIST}

Read the code around each hunk, and the callers of anything whose behaviour changed. Look for:

- wrong results: boundary values, empty and null input, off-by-one, wrong operator, wrong unit
- error paths: a failure that is swallowed, a resource left open, a partial write
- state and timing: a race, an update that can stop half way, a stale cache
- callers the change broke: a changed signature, return shape or default that an untouched caller still relies on
- unsafe handling of input from outside the program

Prove what you can. You may run the tests and write a throwaway script outside the repository. A finding you
proved with a command, or traced step by step from an input to the wrong result, is `blocker (presumptive)`. Put
the command and its output, or the trace, in `detail`. A risk you could not prove is `suggestion`.

Leave out style, naming, structure, comments, and anything that only matters after some future change.
No findings is a valid result.

cite line for this lane: quote the hunk, and give the command you ran or the path you traced.

Write your result to {REPORT_PATH}. The first line is `STATUS: DONE` when you finished the read, whatever you
found, or `STATUS: BLOCKED` with the reason on the next line when you could not. The findings follow from line 2,
in the format below.

{RETURN_CONTRACT}
```
