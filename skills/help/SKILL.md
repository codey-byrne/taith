---
name: help
description: "Guides a person through taith setup, /taith:lead, and picking the skill or playbook for a task. Use for /taith:help with a question."
disable-model-invocation: true
---

# Help

Answer the person's question about taith, hand them a prompt they can send, and link the file the answer came from. For a help question, do not start the work. The person asked how, and a taith run spends real tokens, so let them send the prompt.

A message that asks for work, such as "use taith to fix this bug", is not a help question. Read the **lead** skill (`../lead/SKILL.md`) and do the work under it.

This file maps questions to the skills that hold the answers. Those files own the details. Read the file you route to before you quote it, and trust it when it disagrees with this map. The paths here point into the installed plugin, which the person may not be able to open. Give them the public copy: `https://github.com/codey-byrne/taith/blob/main/` followed by the path.

## Find out what they need

Infer the need from the message and the conversation. A named situation, such as "which skill reviews a PR?", goes straight to its section. If the need is still unclear, ask one multiple-choice question with these options, then answer only the section they pick.

- Get set up
- Start a task with `/taith:lead`
- Pick a skill for a situation
- Fix a run that went wrong
- Make taith my own

Check the state that changes the answer, and mention it only when it does.

- No `~/.claude/rules/taith-roles.md` means every role runs on its default from the role sheet. That is a working state, not a fault.
- No `docs/agents/domain.md` in the repo means the per-repo part of `/taith:setup` has not run there.
- No `hc` on the path, or a session started outside hc, means workers run as native subagents. The person cannot watch or steer them.
- No `verify` skill or other app harness in the project means agents have no scripted way to drive the app. Mention `/taith:create-verification-skill` when the question is about proving a change works.
- No formal verification skill in the project means no property is checked past what tests reach. Mention `/taith:create-formal-verification-skill` when the question is about a race or an invariant.

## Get set up

1. Install with `/plugin marketplace add codey-byrne/taith`, then `/plugin install taith@taith`.
2. Run `/taith:setup` (`../setup/SKILL.md`). It sets a model for each role, records the harness for the cross-vendor seat, and writes the domain-docs pointer into the repo. It is optional. Without it every role uses the role sheet.
3. Start Claude Code on the strongest model available, inside hc when hc is installed. The lead runs on the session model.
4. Start a real task with `/taith:lead`, a goal, and a check that can pass or fail.

Installing changes nothing until the person types a skill. Every skill sets `disable-model-invocation`, and the plugin has no startup hook. The `README.md` at the plugin root has the details. Offer to word their first prompt with them, per `references/prompting.md`.

If cost is the worry, say where the tokens go. The fan-outs are the research explorers, the architect runners, the slice workers and the review lanes. `/taith:setup` can put a cheaper model on any of those roles. The Quick tier starts no worker at all, so name it for a small change.

## Start a task with `/taith:lead`

`/taith:lead` restates the goal, picks a tier by the size of the task, and carries on without waiting. The person can name a tier at the start or tell the lead to switch at any point.

| Tier | Use when | Where the person is involved |
| --- | --- | --- |
| Quick | One or two files and an obvious approach | The PR |
| Feature | New or changed behaviour that one PR can carry | The design conversation, the outline check, the PR |
| Program | Several PRs | Two design sign-offs, the outline check, each PR |

A good prompt states the goal and how to tell it is done. It does not list skills, because a hand-written sequence drops steps the playbook keeps. Read `references/prompting.md` before you help word one.

Each step of a feature can also start cold from the files in `.planning/<feature>/`: `/taith:research`, `/taith:design`, `/taith:outline`, `/taith:build`, `/taith:review`. Name these when a session ended mid-task or the person wants a fresh lead for the build.

The lead never merges. It opens a PR only with the person's consent and stops at merge-ready.

## Pick a skill

The default answer is `/taith:lead`, which runs most of the others when its steps need them. Name a skill directly when the person wants one step alone. Read the skill before you recommend it, and give one example prompt.

Each skill is at `../<name>/SKILL.md`. If a folder in this table is missing from the install, say that the skill has not shipped yet and do not describe it.

| The person wants to | Skill |
| --- | --- |
| Do any task, from a one-line fix to a feature | `/taith:lead` |
| Check that the agent understood the goal before it starts | `/taith:in-your-own-words` |
| Get a prompt rewritten deeper, not bigger, before sending it | `/taith:sharpen` |
| Know how code works now, from one fact to a subsystem walkthrough | `/taith:how` |
| Know why code is shaped this way, from history, issues and docs | `/taith:why` |
| Answer a batch of code questions and save the answers before a design | `/taith:research` |
| Understand a change or subsystem, explained plainly | `/taith:teach` |
| Settle what is being built and its shape, in conversation | `/taith:design` |
| Be questioned until a plan has no open branch | `/taith:grill` |
| Record the project's terms and decisions | `/taith:domain-modelling` |
| Settle contracts, types and module boundaries before code | `/taith:architect` |
| Find shallow modules in existing code and deepen one | `/taith:improve-codebase-design` |
| Cut a settled design into vertical slices | `/taith:outline` |
| Build an approved outline with a fresh worker per slice | `/taith:build` |
| Review a diff against its spec, the repo's standards and its structure, including someone else's PR | `/taith:review` |
| Have different models try to break a change | `/taith:interrogate` |
| Know what a small diff could break outside itself | `/taith:blast-radius` |
| Get several attempts at one brief, merged into the best one | `/taith:arena` |
| Run parallel checks over slices of a repo | `/taith:swarm` |
| Write tests before the code of a change | `/taith:test-first` |
| Apply the comment rule to a diff | `/taith:comments` |
| Open a PR with ordered commits and evidence | `/taith:open-pr` |
| Clean AI tells out of prose | `/taith:unslop` |
| Write docs, a README, a PR description or a commit message to a standard | `/taith:technical-writing` |
| Hear the last reply again in plain words | `/taith:bro` |
| Catch up on this chat since their last message, with every call that waits on them | `/taith:catchup` |
| Catch up on their own recent work on a topic, across chats | `/taith:recall` |
| Vet a performance number before reporting it | `/taith:benchmark-checklist` |
| Run a large change that fits no playbook, and audit it afterwards | `/taith:figure-it-out` |
| Keep a decision log during a run, and review it afterwards | `/taith:show-me-your-work` |
| Give agents a scripted way to drive the app and prove behaviour | `/taith:create-verification-skill` |
| Bring that verification skill back in line with the app | `/taith:maintain-verification-skill` |
| Formally verify a race, an invariant or another property tests rarely reach | `/taith:create-formal-verification-skill` |
| Bring a formal verification back in line after the code changed | `/taith:maintain-formal-verification-skill` |
| See a flow as a chart checked by a TLA+ model, with the shortest path to each broken rule | `/taith:statechart` |
| Choose models per role, or set up a repo's domain docs | `/taith:setup` |
| Turn their own working habits into a personal mode skill | `/taith:automate-me` |
| Turn what a finished task taught into skill edits | `/taith:reflect` |
| Stop agents from repeating the same mistakes in this repo | `/taith:correct` |

If a skill folder next to this one is missing from the table, read its frontmatter and route by its description. `build-slice`, `own-pr` and `run-loop` are worker skills. The lead starts them, and a person does not type them. The `principle-*` folders are covered below.

These skills are easy to confuse.

- `/taith:how` explains what the code does. `/taith:why` explains the reasons. `/taith:research` runs several of both at once and saves the answers. `/taith:teach` runs one or both and explains the result plainly.
- `/taith:design` decides what is built. `/taith:outline` decides how the work is cut and ordered, and makes no design decision.
- `/taith:architect` produces a shape and stops. It writes no implementation.
- `/taith:review` reads a diff against a spec. `/taith:interrogate` attacks it with other models. `/taith:blast-radius` looks for breakage outside the diff.
- `/taith:arena` gives every runner the same brief and merges the best parts. `/taith:swarm` splits work into slices and returns one report.
- `/taith:recall` rebuilds context across recent chats. `/taith:catchup` covers only this chat since the person's last message.

taith leaves out two things on purpose.

- taith has no plan skill. The outline carries a one-page digest of the decisions, and the lead writes a short brief for each slice when it delegates.
- taith ships no skill for writing skills. `/taith:reflect` and `/taith:automate-me` hand that to Anthropic's `skill-creator` plugin.

## Playbooks and principles

Playbooks are step lists inside `/taith:lead`, not skills, so they have no slash command. Describing the task picks one. The list is at the end of the lead skill (`../lead/SKILL.md`). Read that list before you name a playbook, because it holds only the playbooks this install has.

Principles are one-rule skills that the lead reads and cites in its replies. The person rarely types one. They steer with the names instead, as in "apply prove it works. show me the real output." Typing `/taith:principle-<name>` still loads one. The Principles section of the lead skill lists all 24.

## Fix a run that went wrong

| Symptom | Fix |
| --- | --- |
| The lead picked the wrong tier | Name the tier. The lead keeps the files it already wrote |
| The lead asks something the code could answer | Say "look it up". Facts go to a lookup, and only preference calls come to the person |
| The lead is reading source files itself in a feature | Say "ask, do not browse". The lead skill sends code questions to `how` |
| A new model choice had no effect | `~/.claude/rules/taith-roles.md` applies to new sessions. Start one |
| A skill did not load on its own | No skill does. A person types it, or the lead reads it |
| A worker cannot be watched | The lead was started outside hc, so workers are native subagents |
| A worker stopped with `BLOCKED` | Its question is in `.planning/<feature>/runs/<worker>/report.md`. The lead answers it from `design.md` or brings it to the person |
| The session ended mid-feature | Type the command for the next step. Each one starts from the files in `.planning/<feature>/` |
| The review loop keeps finding things | It stops at round 3. Blockers still open go into the PR description |
| The reply claims success from a green build | Ask for the real command, flow or stored value. That is the prove-it-works principle |
| Runs cost more than expected | See the cost paragraph under Get set up |

`references/prompting.md` has one-line steers for a run that drifts.

## Make taith my own

- `/taith:setup` changes the model and effort of any role.
- `/taith:automate-me` drafts a personal mode skill from the person's own history, to use beside `/taith:lead`.
- `/taith:reflect` after a session turns its lessons into skill edits that the person approves.
- `/taith:correct` finds the mistakes agents repeat in a repo and encodes the fix.
- Fix a misbehaving skill in its own PR, not inside the feature work where it went wrong. `docs/conventions.md` at the plugin root holds the rules every skill follows.

## Reply

Lead with the answer. Give at most one example prompt in a code block, adapted from `references/recipes.md` when one fits, then the link to the file the answer came from. Keep it short unless the person asked for the whole map.
