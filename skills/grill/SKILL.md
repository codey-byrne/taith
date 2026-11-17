---
name: grill
description: "Interviews the person about an idea, design, plan or question until every decision in it is resolved or parked. Asks only preference calls, one at a time, each with a recommendation. Use for /taith:grill, 'grill me', 'stress-test this', or when another skill's workflow calls for a grill."
disable-model-invocation: true
---

# Grill

Interview the person about the subject under discussion until you and the person share one understanding of it. The subject can be an idea, a design, a plan or a question. If the person has not presented it yet, ask them to present it first.

Find every major decision point and assumption. Walk down each branch of the decision tree. When two decisions depend on each other, name the dependency, resolve the one the other rests on first, and confirm the pair with the person before you move on.

Do not implement anything during a grill. A grill collects decisions.

## Classify before you ask

Most questions that come up in a grill are not for the person. Sort each one before you put it to them.

- **A fact.** The code, the history or the docs can answer it. Look it up. A lead in the Feature or Program tier sends a lookup through the **how** skill (`../how/SKILL.md`) in the background and carries on with questions that do not depend on it. Any other session may read the code itself.
- **A fork a run could settle.** Behaviour, timing, layout or performance. Build the smallest prototype that settles it. The result decides.
- **A low-stakes choice.** Either answer is cheap to change later. It joins the batch of defaults below.
- **A preference call.** A product or taste decision that no lookup and no run can settle. This is a question for the person.

## Ask a preference call

- **One question per message.** Present one decision with its options, the trade-off between them and your recommended answer, then stop. Two or three options to choose between is one question. Two independent decisions are two questions.
- **Wait for the answer.** The person may push back, think aloud or ask a question of their own. That is discussion. Answer it and keep the decision open.
- **A preference call stays open until the person resolves it.** You may recommend. You may not close it yourself, even when the answer looks obvious from what you know. Any clear statement of the decision resolves it. The person does not have to say "resolved".
- **Use `AskUserQuestion`** when the options are short enough to fit it, and plain text otherwise.

## Batch the defaults

Collect the low-stakes choices as you go. Present them once, as a numbered list in one message. Each line has the choice, your default and one clause of reason.

The person accepts the batch or overrides single lines by number. A line the person wants to discuss becomes a preference call and follows the rules above. A line the person does not mention stands as your default.

Present the batch when the preference calls that shape it are resolved. A default that depends on an open preference call waits for it.

## Close the grill

The grill ends when every branch is resolved or parked by the person. Close with a decision record.

- One entry per topic: the resolution and one line of rationale that names what it replaced, if anything. A topic that changed position appears once, with its final position.
- Include a contract, such as an interface, a schema or an API shape, only when one was proposed and confirmed during the grill. Never invent one. A resolution reached in prose stays prose.
- Mark each accepted default as a default, so the person can see which entries they chose and which they let stand.
- Point at any glossary term or ADR written during the session. Do not restate its content.
- List the dependencies between topics, then every parked item with what would unblock it.

Get the person's confirmation of the record.

Typed alone, present the record in chat. Inside the **design** skill, `design.md` is the record. Design writes each resolved decision into it as the grill goes, so present no second copy at the end.

## With the domain model

To challenge the plan against the project's documented language while you grill, read the **domain-modelling** skill (`../domain-modelling/SKILL.md`) and keep its lenses on throughout. It writes a glossary term the moment the term resolves.
