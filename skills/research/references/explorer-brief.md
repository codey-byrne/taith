# Explorer brief for a research question

Build each explorer's prompt from this template. Fill the placeholders and add nothing else.

---

Answer one research question about the codebase at `{REPO_PATH}`. Other explorers are answering other questions in parallel, so stay on yours.

## Goal of the work

{GOAL_FROM_QUESTIONS_MD}

Use the goal to judge what is relevant. Do not propose how to reach it.

## Your question

> {QUESTION}

## Starting points

{KEY_POINTERS_THAT_APPLY_OR "None given."}

## Write your full answer to a file

Write the full answer to `{SECTION_FILE_ABSOLUTE_PATH}` and to no other path. Read the views reference at `{VIEWS_REFERENCE_ABSOLUTE_PATH}` first, and use its views for current state only. Use no `diff` blocks and no `+` or `-` change markers.

Answer the question, not the whole subsystem. Shape the file like this.

````markdown
## Q{N}. {The question}

### {A heading that states a finding}

{Short prose that explains how this works, concept first, with citations in
parentheses such as (`src/app.ts:57-80`). Put a table, a call tree, a file tree,
a signature or pseudocode beside the prose it supports, when it shows the
structure faster than prose.}

### {The next finding}

...

### How it is tested

{Test file locations, the approach (unit, integration, end to end), mocking
patterns, fixtures. If there are no tests, say so.}

### Conflicts with the task

{Anything in the code that contradicts what the goal assumes, with its
citation. "None." when there are none.}

### Code references

- `path/to/file.ts:28-36`. What is there.
- `path/to/dir/`. What the directory holds. Say whether the list is complete.

### Open questions

{What you could not trace, and where you looked. "None." when there are none.}
````

Rules for the file:

- A heading states what is true, like a slide title. Write "Sessions persist to Postgres before the daemon acks the write". Do not write a topic ("Session storage") or the question again.
- Describe the concept, then cite where it lives. Do not list file paths with one fact each.
- Every claim has a citation that a developer can open.
- Describe what exists. Recommend nothing and critique nothing.

## Reply

After you write the file, reply in at most about 150 words: the answer in brief, each conflict with the task, each open question, and a confidence label (high, medium or low) with one sentence on why. Do not repeat the file.
