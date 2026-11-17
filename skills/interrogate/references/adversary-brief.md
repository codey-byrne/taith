# Adversary brief

Fill `{REPO_PATH}`, `{SCOPE}`, `{INTENT}`, `{REPRO_RULE}` and `{RESULT}`. Change nothing else. `{SCOPE}` and `{INTENT}` are the same for every adversary. The other three differ.

Native adversaries and the cross-vendor seat get the same text. The seat reads it in another harness, with no skills loaded, so it names every path in full and leans on nothing else.

- `{REPO_PATH}` is the adversary's own worktree for a native adversary, and the checkout that holds the scope for the seat.
- `{SCOPE}` is the exact command that prints the change, such as `git diff main...HEAD`, or the absolute path of the design or plan under attack.
- `{INTENT}` is the restated intent, in two or three sentences.
- `{REPRO_RULE}` is `Write repro files in the repository's working copy. It is yours alone.` for a native adversary. For the seat it is `Write nothing inside the repository, because someone else is working in it. Write repro files in a temporary directory outside it, or pass the script to the interpreter inline.`
- `{RESULT}` is `Return your result as your reply.` for a native adversary. For the seat it is the "Write your result" paragraph below, with `<dir>/runs/interrogate-<slug>-seat/report.md` as an absolute path, where `<dir>` is the folder you pass to `spawn`. Fill it before `spawn`, which needs the brief file to exist.

```
Break this change. You are one of several adversaries, and each of you works alone.

The repository is at {REPO_PATH}. Run your commands there.

The scope: {SCOPE}

What the change is meant to do:
{INTENT}

Prove each finding with a run against the real code, such as a failing test, a repro script, or command output
that shows the wrong behavior. For a design or plan, run a prototype or probe the current tree.

Commit nothing and install nothing. {REPRO_RULE} In every case, put the full text of each repro file in your
result, with the path it must be written to, so that someone else can run your command again.

Report each finding in this shape.

FINDING: <title>
COMMAND: <the exact command, run from the repository root>
FILES: <for each repro file, its path and its full text in a fenced block. Or "None.">
PRINTED: <the output the command printed, trimmed to the lines that show the failure>
REQUIRED: <the output the intent requires>

Leave out anything you did not run. That covers style, naming, structure, and risks that need a future change
to matter. No findings is a valid result. Say `NO FINDINGS: <what you tried>` in that case.

{RESULT}
```

The "Write your result" paragraph for the seat:

```
Write your result to <absolute path of report.md>. The first line is `STATUS: DONE` when you finished the
attack, whatever you found, or `STATUS: BLOCKED` with the reason on the next line when you could not. The
findings follow from line 2. Change no other file in the repository.
```
