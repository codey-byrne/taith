# Role sheet

Each role has a backend, a model and an effort level. A skill names the role. Read the role's line here and pass its values to the `Agent` tool or to `scripts/taith-worker`.

A line for the same role in `~/.claude/rules/taith-roles.md` overrides the line here. The **setup** skill writes that file. Claude Code loads it into every session, so an override is already in context when it exists.

If the `Agent` tool rejects a model, omit `model` so the subagent runs on the session model, and say so.

## Native subagents

| Role | `subagent_type` | Model | Effort | Used by |
| --- | --- | --- | --- | --- |
| lookup | `taith:explorer` | haiku | low | `how` lookups from any skill |
| explorer | `taith:explorer` | sonnet | medium | `how` walkthroughs, `research` |
| how explainer | `taith:explorer` | opus | high | `how` walkthroughs |
| why investigator | `general-purpose` | sonnet | medium | `why` |
| why synthesizer | `general-purpose` | opus | high | `why` |
| web researcher | `taith:web-researcher` | sonnet | medium | `research` |
| architect runner | `general-purpose` | opus | high | `architect` through `arena` |
| slice checker | `taith:slice-checker` | sonnet | medium | `build` |
| review axis | `Explore` | sonnet | high | `review` lanes and its recheck |
| comment reviewer | `taith:comment-sicko` | sonnet | medium | `review` |
| native implementer | `general-purpose` | as the brief says | high | `build`, when hc is absent |
| arena runner | `general-purpose` | opus | high | `arena`, when the caller names no role |
| interrogate adversary | `general-purpose` | opus | high | `interrogate` |
| swarm worker | `general-purpose` | sonnet | medium | `swarm` lanes that write |
| swarm reader | `Explore` | sonnet | medium | `swarm` lanes that only read |

The lead, a coordinator, and design judging run on the strongest model available. That is the session model, so start the lead on it.

## hc workers

`scripts/taith-worker spawn --role <role>` starts these. The slash command is the worker's launch prompt.

| Role | Launch prompt | Model | Permission mode | Lives for |
| --- | --- | --- | --- | --- |
| implementer | `/taith:build-slice <brief file>` | sonnet for a routine slice, opus for a hard one. The brief says which | `acceptEdits`, plus the allowlist the script writes from the brief's verify commands | one slice |
| pr-owner | `/taith:own-pr <outline section>` | opus | as implementer | one PR, build to merge-ready |
| loop-runner | `/taith:run-loop <playbook> <target>` | opus | as implementer | one babysit, hillclimb, shipping or autonomous run |
| vendor-reviewer | a plain-text prompt that names a brief file by absolute path | another vendor's model, from the recipes below | read-only | one review, one `arena` judging pass or one `interrogate` attack |

The hc path is not verified. See `docs/conventions.md`.

## Cross-vendor seat recipes

The seat reads the repo, runs checks and writes one report file. It needs no skill and no slash command, because its brief is self-contained. The lead waits on the report file, not on a message from the seat.

None of these recipes has been run. Each needs one spike (plan section 9, item 6) to confirm that it launches unattended, stays read-only and writes its report.

| Harness | Launch command | Default |
| --- | --- | --- |
| opencode | `opencode run --model <provider/model> "<prompt>"` | yes |
| Codex CLI | `codex exec --sandbox read-only "<prompt>"` | no |
| Pi | `pi -p "<prompt>"` | no |

`<prompt>` is one sentence: "Read the brief at `<absolute path>` and follow it." The **setup** skill records which harness and model the person uses.
