# Lookup brief

Build the prompt for one lookup from this template. Fill the placeholders and add nothing else. Several lookups can go out in one message, one subagent each.

---

Answer one question about the codebase at `{REPO_PATH}`.

## Question

> {QUESTION}

## Why it is being asked

{GOAL_IN_ONE_OR_TWO_SENTENCES}

## Starting points

{PATHS_OR_SYMBOLS_OR "None given."}

## Reply

Reply in at most about 200 words, in this shape, and write no file.

```text
<the answer in plain sentences, each claim cited as path:line>

Excerpts:
<only where the exact text matters, such as a signature or a schema. A few lines each, with path:line>

Pointers: <path:line for each place a reader would open next>
Conflicts with the task: <each one with its citation, or "None.">
Confidence: high | medium | low. <one sentence on why>
```

Describe what exists. Recommend nothing.
