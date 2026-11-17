### Prototype

**You own the design decision, not the code. The prototype is a throwaway instrument. The real build follows Feature.**

This is the one playbook where the Laziness Protocol's "smallest change" and the verification bar invert. Speed over polish, code quality does not matter, no planning. The rigor is in picking the right design cheaply. Propose variations the person didn't ask for, throw an approach away and try another.

The **design** skill sends an empirical fork here, so that a run settles it and the person is not asked.

1. Scope the decision the prototype exists to make: which layout, which interaction, which density, or for an empirical fork which behaviour, timing, or approach. No decision means no prototype. Route to Feature.
2. Gather references when the design space is open. Search for prior art, summarize a moodboard of themes, palettes, and layouts, and let the person pick directions before building. Skip this when the direction is set.
3. Build throwaway in an isolated scratch directory, separate from production source. Build it yourself when the person will react to it turn by turn. Otherwise hand it to a `taith:delegate` subagent in its own worktree, which returns the result and the scratch path. For a visual decision, use vanilla HTML, CSS and JS or the lightest stack that renders the idea, with CDN dependencies and a dev server with hot reload. For a behavioural or timing decision, write the smallest script that exercises the question. No production framework, no tests, no abstractions.
4. When comparing alternatives, build them behind one switcher (buttons or a keypress), each variant labeled. This is the **principle-exhaust-the-design-space** skill made cheap.
5. Verify on the matching surface. For a visual decision, screenshot each variant and drive the interaction, with the repo's verification skill or Claude Code's `run` skill. For a behavioural or timing decision, observe the thing you are deciding by logging the timing, printing the output, or watching the render. The observation is the test here, not an assertion.
6. Present the alternatives, the tradeoffs, and a recommendation. The output is the decision plus the throwaway artifact, not shippable code. Write the decision into `design.md` when a design is open. Hand the chosen direction to **Feature**, or to the **architect** skill (`../architect/SKILL.md`) for the shape.

**Reply:** the variants explored, the evidence (screenshots for a visual decision, the observed output or timing for a behavioural one), tradeoffs, your recommendation, and the scratch path. Say plainly that the prototype is throwaway.
