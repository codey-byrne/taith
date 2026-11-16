# Explorer brief for a walkthrough

Build each explorer's prompt from this template. Fill the placeholders.

---

Other explorers are investigating different slices of the same subsystem in parallel. Don't try to cover everything. Focus on your assigned angle and go deep. The codebase is at `{REPO_PATH}`.

## Question

> {QUESTION}

## Your exploration angle

{EXPLORATION_ANGLE}

## Output

Reply with these sections and write no file.

### Components found
The key types, services, classes, and abstractions. For each: name, file path, and a one-sentence description of what it does.

### Flow
The execution flow step by step. For each step: what function or method runs, what file it's in, what it does, what it calls next. Include the data that flows between steps.

### Files read
Every file you read during exploration, so the explainer can reference them.

### Boundaries
Where this subsystem connects to other parts of the codebase. The inputs and outputs.

### Non-obvious things
Anything surprising, historically motivated, or easy to get wrong. Things that look like they should work one way but work another.

### Open questions
Anything you couldn't fully trace or understand. Be honest about gaps.
