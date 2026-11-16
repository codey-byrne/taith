---
name: how
description: "Answers what the code does, from a one-line fact to a subsystem walkthrough. Use for /taith:how, \"how does X work\", a lookup the lead needs instead of reading code itself, and placement or ownership questions such as \"where should this live\". Use why for motivation."
disable-model-invocation: true
---

# How

Answer a question about what the code does without reading the code yourself. An explorer reads it and returns a short, cited answer.

This skill has two modes. Pick by the question.

- **Lookup.** One question with a factual answer. "Where is the retry limit set?" "What does `SessionStore.append` return on a closed session?" This is the mode the lead uses in place of its own `Read` and `Grep`.
- **Walkthrough.** "How does X work?" about a module or a subsystem, asked by the person or needed before a change. The answer is an explanation that a senior engineer new to the area could work from.

When in doubt, use a lookup. A walkthrough costs more and returns more than most questions need.

Every spawn is an `Agent` call with `subagent_type: "taith:explorer"`. The explorer describes what exists, cites it, and recommends nothing. Take `model` and `effort` from the role sheet (`../lead/references/roles.md`). The roles are `lookup`, `explorer` and `how explainer`.

## Lookup

1. Write the question so that it has one answer. Add the goal in a sentence or two, so the explorer can judge what is relevant. Add any path or symbol you already have.
2. Build the prompt from `references/lookup-brief.md` and spawn one explorer on the `lookup` role.
3. Carry on with work that does not depend on the answer. The explorer runs in the background.
4. Keep the question and the answer. Do not open the cited files to check them. The excerpts in the answer exist so that you can quote the code to the person without reading it.

**Batch lookups.** When you have several questions, spawn them in one message, one explorer each. Do not give one explorer two unrelated questions.

**What comes back.** At most about 200 words: the answer with `path:line` citations, short excerpts where the exact text matters, pointers, any conflict with the task, and a confidence label.

**When the answer is not enough.** A `low` confidence answer, or one that lists an open question you need, gets one follow-up lookup with a narrower question. If the follow-up still falls short, the question needs a walkthrough or is not a fact. Say which.

A lookup that turns into "why is it this way" belongs to the **why** skill (`../why/SKILL.md`). A decision is never a lookup. Classify it with the fork rule in the **lead** skill.

## Walkthrough

### 1. Assess the size

If the scope is ambiguous, state your interpretation and explore. The person can redirect.

- **Simple.** A single module, a small utility, or a narrow question. Spawn one explorer on the `how explainer` role that explores and explains in one pass. Build its prompt from `references/explainer-prompt.md` without the explorer-findings section. Go to step 4.
- **Complex.** A subsystem that spans several files or services, a cross-cutting feature, or a full architectural overview. Go to step 2.

When in doubt, take the simple path.

### 2. Explore

Split the question into two to four angles, each a distinct slice of the subsystem. Spawn all the explorers in one message on the `explorer` role, each with `references/explorer-brief.md` and its angle filled in.

### 3. Synthesize

When every explorer has returned, spawn one explainer on the `how explainer` role with `references/explainer-prompt.md` and every explorer's findings filled in.

### 4. Present

Present the explainer's output. Light edits for clarity are fine. Do not substantially rewrite it.

The explanation uses the sections in `references/explainer-prompt.md` and drops any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.

**When the lead needs a walkthrough for itself,** tell the explainer to write the full output to a file under `.planning/<feature>/` and to reply with a summary of at most about 200 words. The lead keeps the summary and the path.
