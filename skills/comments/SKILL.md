---
name: comments
description: "The comment rule and how to apply it: a doc comment on every public interface a change adds or alters, and nothing else except a non-obvious why. Also cleans the comments in a diff through the comment-sicko reviewer. Use for /taith:comments, 'how should I document this', 'is this comment good', or 'clean up the comments'."
disable-model-invocation: true
---

# Comments

## The rule

- A public interface that a change adds or alters gets a doc comment.
- Everything else gets a comment only for a non-obvious why that the code cannot show. Write no narration of what the code does.

Every session that writes code follows both halves. The `taith:comment-sicko` reviewer enforces both in the **review** skill: it flags a missing interface doc as well as a needless comment.

A public interface is anything a caller outside the module can use: an exported function, class, type or constant, an HTTP or event contract, a CLI flag. A private helper is not one.

## Write an interface doc comment

The comment gives a developer what they need to use the interface correctly without reading the code: intent, behaviour, parameters, return values, side effects.

Check for a language reference before you write, and follow it where it differs from the guidance here.

| Language | Reference file |
| --- | --- |
| Kotlin (KDoc) | `references/kdoc.md` |

For any other language, follow the conventions of its doc tool and the guidance below.

<should>

- **Document the interface, not the implementation.** Say what the element does for a caller and what the caller must supply.
- **Include sufficient detail.** A comment so terse that it conveys nothing is worse than no comment. "Gets the value" on a getter and "Constructor" on a constructor are filler.
- **Make the opening sentence count.** IDE tooltips, generated API references and package overviews show the first sentence alone. Write it as one clear statement of what the element does or is.
- **Separate the summary from the detail.** Where the format supports it, put the summary in the first block and the detail after a blank line.
- **Link to related symbols.** Where the toolchain supports it, use cross-reference syntax for types, parameters and related functions.
- **Document edge cases and non-obvious behaviour.** Nullability, empty-collection semantics, throwing conditions, thread safety and ordering constraints are what a caller needs and what the signature does not say.

</should>

<should-not>

- **Repeat the code.** A comment that restates the signature in prose adds nothing.
- **Run long.** A reader skips a long comment. Keep the summary short and the detail secondary.
- **State the obvious.** Do not document what the name already says, unless there is a nuance to add.

</should-not>

## Everything else

Inside a module the default is no comment. Before you write one, try to make the code say it: rename the symbol, extract a function, or encode the constraint in a type.

These comments stay.

- A legal or license header.
- A non-obvious behaviour forced by an external dependency, platform, vendor or protocol that you cannot reshape. Say what forces it.
- An issue or RFC link that explains a constraint the code cannot express.
- `// prettier-ignore`, and a lint suppression whose rule is faulty, pedantic or style-only.

These go.

- Narration of what the next line does.
- Banners and section dividers.
- Commented-out code.
- A justification for a workaround in your own code. Fix the code, or report the workaround as a deviation.
- A suppression such as `eslint-disable` or `@ts-ignore` on a rule that protects correctness or safety. Fix what the rule caught.

A surprise in your own code is a reason to reshape the code, not to explain it in a comment.

## Clean the comments in a scope

Use this when a person types `/taith:comments` on existing code. Inside the feature workflow the review skill runs the reviewer, so do not run it twice.

The scope is the files or diff the caller names. Otherwise it is the current diff against the base branch, `main` by default, including the working tree.

1. **Spawn the reviewer.** Use the `Agent` tool with `subagent_type: "taith:comment-sicko"` and the `comment reviewer` role in the role sheet (`../lead/references/roles.md`). Pass the scope. Do not restate its rules. It reports and changes nothing.
2. **Check its report.** Reject a flag outside the scope, a flag on a comment that a keep clause above protects, and a `MUST KILL` whose reason misstates the code. Check the scope yourself for lint and TypeScript suppressions the reviewer missed, and add any that protect correctness or safety as findings. Before you accept a flag or a keep on a thin `IMPORTANT` or `do not remove` comment, send a lookup on its symbol through the **how** skill (`../how/SKILL.md`), or the **why** skill (`../why/SKILL.md`) for its history. When the claim stays ambiguous after the lookup, the comment goes. If you reject the report as a whole, rerun the reviewer once with the failure named. Reject a second report, say so, and stop.
3. **Apply the accepted findings.** Delete each flagged comment. Write the doc comment for each undocumented public interface, per the section above. Fix a trivial `MUST KILL` directly: delete the dead path, drop the parameter, or call the real API. If a fix needs a new shape, run the **architect** skill (`../architect/SKILL.md`) once for the accepted set and stop at its sketch.
4. **Fix the root cause in scope.** Make the smallest change that removes each named workaround. If the root cause lies outside the scope, land the smallest fix inside it and report the rest as open. Do not widen the scope and do not add a guard for the symptom.
5. **Offer an encoding for each constraint comment.** A constraint comment says `do not remove`, `do not change wording` or `talk to X before changing`. Leave one that is about something you cannot change. For the others, offer the cheapest type, runtime check, test or lint rule that enforces the constraint, and wait for the person's approval. When approved, encode it and delete the comment. Otherwise delete the comment and report the constraint as unenforced. With nobody to ask, encode only what the caller approved in advance.
6. **Report.** Give the count of comments deleted, the doc comments added, any rerun, the architect sketch, the fixes, each encoding offered and made, each unenforced constraint and any other open work.
