# Prompts worth copying

Swap in the real paths, skills, and done checks. Informal wording works.

## Understand

- `/taith:in-your-own-words <long or messy ask>`
- `/taith:sharpen <the prompt you're about to send>`
- `/taith:how does <subsystem> handle <case>?`
- `/taith:why is <code> built this way?`
- `/taith:recall my work on <topic> from last week.`
- `/taith:teach me why you implemented it this way and not <other way>. what did you trade off?`
- `/taith:lead investigate why <symptom>. give me what we know, what data you used, and your best hypotheses. don't change any code yet.`

## Build

- Small fix: `/taith:lead quick: <symptom>. repro first, then fix and verify.`
- Feature: `/taith:lead add <behavior>. <current output> stays byte-identical. verify both.`
- Several PRs: `/taith:lead this is a program. migrate <library> to <target>. the result must match the original exactly.`
- Refactor: `/taith:lead move <code> into one module, zero behavior change. record the current output first and prove it's unchanged after.`
- Existing code that is hard to change: `/taith:improve-codebase-design <area>`

## One step alone

- `/taith:research <task>` writes the questions, answers them in parallel and saves `research.md`.
- `/taith:design` starts the design conversation from the saved research.
- `/taith:architect <change>` sketches the contracts and types and stops.
- `/taith:outline` cuts the settled design into slices for the outline check.
- `/taith:build` builds the approved outline from a fresh lead.

## Review and ship

- `/taith:review` on the current branch, or `/taith:review <PR link>` for someone else's PR.
- `/taith:interrogate the whole branch, but skeptically. don't change anything yet. no nitpicks unless it's a real bug or regression.`
- `/taith:create-formal-verification-skill prove <property> holds in <module>, even when <steps> interleave or retry.` After merges or refactors in that code: `/taith:maintain-formal-verification-skill`.
- `/taith:open-pr` with small ordered commits and the evidence in the description.

## Away and back

- `/taith:lead im going to bed. <goal>. done means <checks>. keep a decision log. open the PR when review is clean. if you're truly stuck after a few hours, stop and write up why.`
- `/taith:show-me-your-work catch me up on what you did last night.` Read its Attention section first.
- `/taith:catchup` covers this chat since your last message and lists every call that waits on you.
- `/taith:reflect capture what we learned so the next run doesn't repeat it.` Approve only edits that change a future decision.
- `/taith:bro` restates the last reply in plain words.
