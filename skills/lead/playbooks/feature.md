### Feature

**You own the design and every decision. You delegate the reading and the code.** The person is involved at three points: the design conversation, the outline check, and the PR.

1. **Clarify.** Restate the goal. If the task is ambiguous, ask the few questions needed to pin down what is being asked. Ask no design questions yet. Write `task.md`.
2. **Research.** Run the **research** skill (`../research/SKILL.md`). Show the questions to the person and do not wait for sign-off. Start nothing else until every explorer has returned.
3. **Design, with the person.** Run the **design** skill (`../design/SKILL.md`). It asks behaviour questions with the research in hand, produces the shape through the **architect** skill, then asks only the preference calls on the recommended design. It ends when `design.md` has no open question.
4. **Outline check.** Run the **outline** skill (`../outline/SKILL.md`) in the same session. The person reviews `outline.md`, which opens with the decision digest. This is the one deep review before code. Say whether you recommend a fresh lead for the build.
5. **Build.** Run the **build** skill (`../build/SKILL.md`). It writes one brief per slice just before it delegates, starts a fresh worker per slice, runs independent slices in parallel, and has a checker read each diff. Do not pause for the person between slices.
6. **Review.** Run the **review** skill (`../review/SKILL.md`) against the diff and the outline, as `build` describes. Use the **interrogate** skill (`../interrogate/SKILL.md`) as well when the change is contested.
7. **Fix and PR.** `build` sends the findings to a fresh worker with consolidated scope and calls review again until the review skill ends the loop. Then run the **open-pr** skill (`../open-pr/SKILL.md`) with the person's consent. List everything a slice could not verify automatically in the PR description. Stop at merge-ready. The person reviews and merges.

Any step can start cold from `.planning/<feature>/` with its own command.

**Reply:** what was built against the goal, the decisions made and why, the review result, what the person must check by hand, the PR link, and open decisions. Use a table for design alternatives.
