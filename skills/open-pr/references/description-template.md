# PR description template

The body is the walkthrough of the change. It opens with one sentence on why, warns the reviewer of anything surprising, then shows the shape of the change as views. The diff carries the detail.

Use these `##` headings in this order and add no other. `Why the change`, `Special things to note`, `Change outline` and `Verification` always stay. Drop `Decisions` or `Review` when it has nothing to say.

````markdown
<Optional first line of links the reviewer needs, such as the ticket and a design document. Leave it out when there are none.>

## Why the change

<Exactly one sentence. The problem this PR solves and what becomes possible when it lands.>

## Special things to note

- <One to three bullets. A warning for the reviewer, a migration, a compatibility limit, something left out on purpose, or a surprising decision. Write "None." when there is nothing.>

## Change outline

<A short sentence that says what the next view shows.>

```diff
<A view. See "The views" below.>
```

<A short sentence, then the next view. Use only the views this PR needs, in the order that tells the story.>

## Decisions

- <A numbered decision from design.md that this diff carries out, and how.>
- <Each accepted deviation from the outline, with the reason the lead accepted it.>

## Verification

- Automated: <each command that was run, with its result line.>
- Check by hand: <each step no command could verify, written so the reviewer can follow it word for word. "Nothing." when there is none.>

## Review

- <The status of the last review round, and which lanes were skipped, not reviewed or read by the same model family.>
- Open blockers: <each blocker still open when the loop ended at the cap, with its id and `where`.>
- Left for you: <each suggestion under `For the PR` in the findings file, one line each.>
- Declined: <each declined blocker, with the reason.>
````

## The views

`Change outline` is a set of views, not prose and not a list of files. The **show-me** skill (`../../show-me/SKILL.md`) shows how to draw each one.

| When the PR changes | Show |
| --- | --- |
| A contract or a schema | The table, its key columns and relations, or the endpoint's request and response |
| A data structure the change rests on | The type, in the language of the code |
| Logic | Pseudocode for the changed behaviour |
| Which file owns what | A shallow file tree with each changed responsibility |
| UI structure | The component tree, with the hooks, state and package boundaries that matter |
| How control or data flows | A call tree or a data-flow diagram |

- Use a `diff` block for a change to a shape that already exists. Show the whole block, in the code's language or as `text`, when most of it is new or when diff notation would hide ownership or order.
- Order the views so the story is easy to follow. Sometimes the files come first. Sometimes a table or a contract has to be set up before anything else makes sense.
- Keep each view to the calls, files, fields and components a reviewer needs. Leave out a kind of view when nothing of that kind changed.
- Write as one person talking to another, in plain and short sentences.

## Where each section comes from

| Section | Source |
| --- | --- |
| Why the change | `design.md`, or `task.md` and the outline's opening lines |
| Special things to note | `Out of scope` in the digest, the migrations and limits in `design.md`, and whatever a reviewer would otherwise be surprised by |
| Change outline | The views in `design.md` and in each slice's "Change outline", corrected against the diff |
| Decisions | The digest, and `## Accepted deviations` in `outline.md` |
| Verification | The digest's verify commands with the results of the last whole-change check, each slice's "Check by hand", and "Not verified by a command" in each slice's notes |
| Review | The last round's findings file and nothing earlier: its header lines, `Fix` (open blockers only), `For the PR` and `Declined` |

With no `.planning` folder, write `Why the change`, `Special things to note`, `Change outline` and `Verification` from the diff and the conversation, and drop the rest.

## What stays out of the body

- A file-by-file list, a changelog, or a narrative of how the work went. The diff and the commits have those.
- Full commit ids, lane-by-lane review recitals and tables of metrics. Link an artifact instead.
- A performance claim with more than one primary number. Give one number with its unit as before and after.
- The history of the review loop. Only what is still open or left for the person belongs here.

The layout of the first three sections and the views are adapted from the `visual-pr` skill in humanlayer-skills (MIT, Copyright (c) 2026 HumanLayer).
