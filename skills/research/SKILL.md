---
name: research
description: "Turns a task into research questions, answers them all at once with one explorer per question, and saves the cited answers to research.md before design starts. Use for /taith:research, or as step 2 of the feature playbook. Feature size and up only."
disable-model-invocation: true
---

# Research

Find out what exists before anyone designs anything. You write the questions. One explorer per question answers them in parallel. Each explorer files its full answer on disk and returns a short summary to you.

Research is a batch of **how** and **why** questions. It adds three things to those skills: it turns a task into questions, it runs them at once, and it files the answers. There is no synthesizer, because you are the reader.

Research finishes before the design conversation starts. The person's answers to design questions can change once they know what already exists, so ask none until every explorer has returned.

All paths below are under `.planning/<feature>/`. Pass them to subagents as absolute paths.

## 1. Capture the task

The task comes from the invocation, a ticket, a file, or the conversation. If `task.md` exists, read it. If it does not, pick a short kebab-case feature name, create `.planning/<feature>/`, and write `task.md`: the task as given, word for word where possible, and its source.

While you read the task, collect every concrete pointer it gives: URLs, repositories, libraries, packages, file paths and directories. Keep them exactly as written.

If the task is ambiguous, ask the person the few questions needed to pin down what is being asked. Do not ask how it should be built.

## 2. Write the questions

Write `questions.md` from `references/questions-template.md`. A good question set would let a stranger design this change.

- **Ask about what exists.** "How does session expiry work end to end?" "Where is tenancy enforced?" "What patterns exist for background jobs?" Never ask "how should we add X". A question that proposes a change gets a proposal back.
- **Point the explorer at where to look** when you know. "In `packages/ui`, how does..." "How do the WorkOS docs say a user is updated?"
- **Label each question** `how`, `why` or `web`. `how` asks what the code does. `why` asks for the history or the reason behind a shape. `web` asks about a library, an SDK or outside documentation.
- **Match the count to the task.** Two questions at the least. Fewer than eight, except for the largest tasks.
- **Copy the key pointers** into the Key pointers section, unchanged.
- **Cover testing.** Ask how the affected components are tested today, unless another question already covers it.
- **Cover the design system when the work may touch a UI.** Ask which component library and theme the product area uses, with its colours, type and spacing. Ask this even when the task does not mention the UI but may involve it.

Show the questions to the person in your reply. Do not wait for sign-off. Go to step 3 in the same turn.

## 3. Run the batch

Spawn every question in one message. Take `model` and `effort` from the role sheet (`../lead/references/roles.md`).

- **A `how` question** gets one `taith:explorer` subagent on the `explorer` role. Build its prompt from `references/explorer-brief.md`.
- **A `web` question** gets one `taith:web-researcher` subagent on the `web researcher` role. Give it the question, the key pointers, and the same output and reply rules as the brief. Tell it to include a link for every finding.
- **A `why` question** runs through the **why** skill (`../why/SKILL.md`). Follow its section "When research calls this skill".

Each explorer writes to its own file, `research/NN-<short-name>.md`, where `NN` is the question number with two digits. No two subagents write the same file.

The explorer is told the goal of the work. That lets it judge what is relevant and report anything that contradicts what the task assumes. It is still held to describing what exists.

Start nothing else while the batch runs.

## 4. Fill the gaps once

Read the summaries as they return. Each is short. Do not read the section files end to end.

If a summary lists an open question that the design needs, run one more round of targeted questions, as lookups through the **how** skill (`../how/SKILL.md`) or as rewritten section files. Run at most one extra round. Whatever is still open after it stays in the file as an open question.

## 5. Join and check

Run these from the repository root. `<skill-dir>` is this skill's base directory.

```bash
<skill-dir>/scripts/join-research.sh .planning/<feature>
<skill-dir>/scripts/check-citations.sh .planning/<feature>/research.md
git status --porcelain
```

- `join-research.sh` writes `research.md`: a header with the date, the commit and the branch, then the section files in question order.
- `check-citations.sh` prints every cited `path:line` that does not resolve to a real line. For each one, start a fresh explorer on that question with the bad citations named. Never fix a finding from your own knowledge.
- `git status` must show no change outside `.planning/`. An explorer that edited source broke its contract. Revert the edit and say so.

## 6. Hand over

Tell the person, in a few sentences: what the research found that bears on the task, each conflict between the code and what the task assumes, each open question, and the path of `research.md`. Then start the **design** skill (`../design/SKILL.md`) in the same session.

The summaries stay in your context for design. `research.md` stays on disk for the outline, the briefs and a fresh lead. Code is the truth for line numbers once the build starts, because slices move lines.
