# Recheck prompt, for rounds 2 and 3

Fill `{FIX_DIFF_CMD}`, `{FIX_COMMITS}`, `{FIX_FINDINGS}`, `{SPEC_SOURCE}`, `{VOCABULARY_PATH}`, `{BASELINE_PATH}`, `{PRESEEDED_FINDINGS}` and `{RETURN_CONTRACT}`. Change nothing else.

`{FIX_DIFF_CMD}` is `git diff <previous head>...HEAD`. `{FIX_COMMITS}` is the output of `git log <previous head>..HEAD --oneline`. `{FIX_FINDINGS}` is every finding marked `fix` in the previous round's findings file, copied whole with its id. `{SPEC_SOURCE}` is filled as in the Spec lane prompt. `{PRESEEDED_FINDINGS}` is the output of `file_size_gate.py <previous head>`, or `none`.

```
You are rechecking a code change after a fix round. An earlier review raised the findings below, and a worker
changed the code to fix them. Answer two questions and nothing else.

The findings that were sent for fixing:
{FIX_FINDINGS}

Run exactly this command and read the whole diff: {FIX_DIFF_CMD}
The fix commits:
{FIX_COMMITS}

Question 1. Is each finding resolved?
Check each one against its `done when` line, in the code as it is now. Read the file, and run the check if the
line names one. Open your return with one line per finding:

  <id>: RESOLVED | STILL OPEN. <the evidence, with path:line>

A finding is STILL OPEN when the fix is missing, covers part of it, or meets `done when` by weakening a test or
removing the behaviour.

Question 2. Did the fix introduce a blocker?
Read only the lines the fix diff adds or changes, against these four rubrics.

- Spec. The spec is: {SPEC_SOURCE}
  A fix that breaks a spec line, or loosens or removes a test assertion, is a blocker.
- Standards. A fix that breaks a rule in the repo's CLAUDE.md, AGENTS.md or contributing and style documents is a
  blocker.
- Structure. Read {VOCABULARY_PATH} and {BASELINE_PATH}. A script lists the files that the fix pushes past
  1,000 lines, or `none`: {PRESEEDED_FINDINGS}
  Return each listed file as a blocker. Nothing else under this rubric is a blocker.
- Defects. A fix that produces a wrong result you can show with a command or a traced path is a blocker.

Report each new blocker as an entry in the format below, after the lines for question 1. Report no suggestions.
Report nothing about code the fix did not touch, even if you see something. With no new blocker, add the line
`NO NEW BLOCKERS`.

{RETURN_CONTRACT}
```
