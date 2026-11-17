# Word the prompt

A prompt states the intent and the check for done. The tier's playbook supplies the steps, so a few plain sentences beat a spec.

## Put in

- The goal. Say what is wrong or what the person wants.
- The done check. It can pass or fail. "Make it better" and a duration are not checks.
- The proof to show. Ask for the real command output, the stored value, or a before and after number.
- What the person already knows. A symptom, a repro step, a log, or a link saves the lead a lookup.
- The real constraints. "repro first", "don't change any code yet", and "zero behavior change" each change what the lead does.
- The tier, when the person already knows it. "quick" or "this is a program" skips the lead's guess.

## Leave out

- The how. Say what to achieve, and leave the design conversation room to find a better way.
- A list of skills or steps. A hand-written order drops or reorders steps the playbook keeps. Name a skill only to run one step alone.
- The person's theory of the cause, until the lead restates the problem. A stated guess narrows the search.
- Facts about the code. Research looks those up before the design conversation starts.

## Load the context first

- For a noisy report, ask the lead to restate the underlying issue in its own words before it does anything else. A misreading shows up before any code exists.
- In a fresh chat, `/taith:recall` earlier work on the topic. Old chats hold context that the new lead lacks.
- For one question about unfamiliar code, ask `/taith:how` for the mechanics or `/taith:why` for the reasons. A feature gets both through research.
- Ask `/taith:teach` to make the case for a choice, as in "convince me it fixes the cause and not the symptom". A case is easier to check than a summary.

## In the design conversation

- Answer the behaviour questions first. The lead asks them with the research in hand and proposes no solution yet.
- Expect a concrete shape to react to, with what was rejected and why. The person is not asked to pick between raw candidates.
- Send a fork that a run can settle to a prototype: "prototype both and show me". The result decides.
- Accept or override the batch of defaults in one message. Those are the low-stakes choices.
- Say "that is a fact, look it up" when a question is not a preference call.

## At the outline check

- This is the one deep review before code. Read the digest at the top of `outline.md` first. It holds every decision the workers will see.
- Check that each slice ends in something that can be checked, and that its acceptance tests are named.
- A new design decision found here goes back to design. Say "back to design on <point>".
- Ask for a fresh lead for the build when the design conversation ran long.

## Follow up short

- "do it", "continue", and "keep going until done" are whole prompts once the chat holds the task.
- Start with "new task" when the subject changes.

## Before stepping away

- Say "im going to bed" or "im stepping away" so the lead stops asking and applies defaults.
- Pre-answer what the lead would stop for, such as "open the PR when review is clean".
- Ask for a decision log to audit later. That is `/taith:show-me-your-work`.
- Give an exit: "if you're truly stuck after a few hours, stop and write up why".

## Steer in one line

- Restate the goal: "i said the goal is to repro. i did not ask for a fix yet."
- Name the tier: "this is quick, do it inline."
- Name the principle: "apply prove it works. show me the real output, not the build log."
- A principle name works because the lead already read the rule. Its reply names the decision the rule changed.
