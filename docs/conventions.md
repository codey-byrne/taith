# Conventions

Rules that every skill, agent and script in this plugin follows. Read this before you add or change one.

The design behind these rules is the adaptation plan (`design/adaptation-plan.md` in the project files). Section numbers below refer to that plan.

## Layout

```text
.claude-plugin/
├── plugin.json            # the plugin manifest
└── marketplace.json       # lets the repo be added as a marketplace
agents/<name>.md           # native subagent definitions
docs/                      # explanation and reference for people
scripts/                   # executables that skills call
skills/<name>/
├── SKILL.md
├── references/            # templates and long reference text
└── playbooks/             # lead only
```

A skill owns its folder. A file that two skills read lives in the folder of the skill that owns the idea, and the other skill links to it by relative path.

## Skill frontmatter

Every `SKILL.md` starts with these three keys and no others.

```yaml
---
name: <folder name>
description: "<what it does and when to use it>"
disable-model-invocation: true
---
```

Every skill sets `disable-model-invocation: true` (section 4.6). The plugin has no startup hook. A skill runs because a person typed it or because another skill read it.

## How a skill loads another skill

The `Skill` tool refuses a skill that sets `disable-model-invocation`. A skill that needs another skill reads the file and follows it.

- Write the pointer as the skill name in bold with its path, such as "Read the **how** skill (`../how/SKILL.md`)". The path is relative to the folder of the skill that contains the pointer.
- Claude Code prints a skill's base directory when the skill is invoked. Resolve relative paths against it.
- A native subagent cannot see that base directory. Put the absolute path of the skill file in its prompt.
- An hc worker gets its skill as the slash command in its launch prompt, such as `/taith:build-slice <brief file>`. It then reads other skills by relative path.
- When you tell a person to run a skill, write `/taith:<name>`.

## Tool and agent names

Skills use Claude Code names.

| Use | Name |
| --- | --- |
| Spawn a native subagent | the `Agent` tool |
| Ask the person a multiple-choice question | `AskUserQuestion`, or plain text when it is absent |
| Track steps | `TodoWrite` when the session offers it, otherwise a list in the reply |
| Read-only fan-out with no special contract | `subagent_type: "Explore"` |
| Code lookup and research | `subagent_type: "taith:explorer"` |
| A helper that needs MCP tools | `subagent_type: "general-purpose"` |

A subagent runs in the background by default and notifies its parent when it finishes. Skills do not pass `run_in_background`.

## Kept skills

A skill marked "kept" in plan section 5 is copied from its source with only these changes.

| Source wording | Replace with |
| --- | --- |
| `Task` (the tool) | `Agent` |
| `generalPurpose` | `general-purpose` |
| `readonly: true` | `subagent_type: "Explore"`, or `taith:explorer` for code questions |
| `readonly: false` | `subagent_type: "general-purpose"` |
| `AskQuestion` | `AskUserQuestion` |
| `environment: "cloud"`, `cloud_base_branch` | a git worktree, with the branch named in the brief |
| a model slug such as `claude-opus-5-5-xhigh` or `grok-4.7-xhigh-fast` | the role name from the role sheet |
| `pstack-models.mdc` | the role sheet |
| `poteto-mode` | `lead` |
| `poteto-agent` | `taith:delegate` |
| `/setup-pstack` | `/taith:setup` |
| Cursor Automations, Bugbot, cloud agents | delete the step |

Do not reword a kept skill for style. Its prose is the source author's.

## Roles and models

A skill names a role and never a model. The role sheet at `skills/lead/references/roles.md` maps each role to a backend, a model and an effort level. A line in `~/.claude/rules/taith-roles.md` overrides the sheet. The `setup` skill writes that file.

## Artifacts

Each task keeps its files under `.planning/<feature>/` in the checkout where the lead runs. `<feature>` is a short kebab-case name.

```text
.planning/<feature>/
├── task.md                # lead writes. The task as given, with its source
├── questions.md           # lead writes. Research questions and key pointers
├── research/              # one section file per question, written by its explorer
├── research.md            # the section files joined in question order
├── design.md              # lead writes. Numbered decisions, not-doing list, rejected options
├── outline.md             # lead writes. Digest, then slices
├── slices/
│   ├── N-brief.md         # lead writes just before it delegates slice N
│   └── N-notes.md         # the slice N implementer writes at the end
└── runs/<worker>/
    ├── meta               # the script writes. Role, brief, worktree, branch
    └── report.md          # the worker's result
```

- Pass every `.planning` path to a worker as an absolute path. A worker in a git worktree has no `.planning` folder of its own.
- A worker never commits anything under `.planning/`.
- Each file has one writer. Two agents never write the same file.

## The report contract

Every worker ends by writing `runs/<worker>/report.md`. The first line is the status line and nothing else.

```text
STATUS: DONE | ISSUES | BLOCKED
```

- `DONE`. The work is complete and the evidence is in the report.
- `ISSUES`. The work is incomplete or a check fails. The report lists every issue the worker can prove.
- `BLOCKED`. The worker hit a decision it may not make. The report states the question and what the worker would choose.

The file is the result. Under hc, `hc send` only wakes the lead. A worker never asks the person a question. A short read-only checker returns `PASS`, `ISSUES` or `BLOCKED` in its reply and writes no file.

## The worker script

Skills never call `hc` directly. They call `scripts/taith-worker`, which has four verbs: `spawn`, `wait`, `status` and `reap`. Run it with `--help` for the arguments. A skill names the role and the brief. The script picks the backend.

When the lead is not running under hc, `spawn` prints `BACKEND: native` and the skill starts a native subagent in the worktree that the script created.

The hc path of the script is not verified. It was written from the herdr-core documentation on a machine with no hc. The seven spikes in plan section 9 must pass before anyone relies on it.

## What lead and build expect from review

The `review` skill is built in its own PR. `lead` and `build` call it through this contract.

**Who runs it.** The session that reads `../review/SKILL.md` runs the review. In the Feature tier that session is the lead. It starts every lane the review skill lists, such as the three axes and `comment-sicko`. `build` starts no review lane of its own.

**Inputs.** The caller supplies:

- the base ref that the diff is taken against
- the spec, as paths: `outline.md`, the `slices/` folder with its briefs and notes, and `design.md`
- the round number, starting at 1
- the absolute path of the findings file, `.planning/<feature>/runs/review-<round>/report.md`

`outline.md` ends with an `## Accepted deviations` section that `build` writes. Each line names a slice, what differs from the outline, and why the lead accepted it. Review treats an accepted deviation as part of the spec.

When a person types `/taith:review`, the skill finds the base and the spec for itself and may ask. With no `.planning` folder it reports in chat and writes no file. When a skill calls it with every input, it asks nothing.

**Lanes.** Review lanes are read-only native subagents with `subagent_type: "Explore"`, which keeps `Bash` for git. Each lane gets the absolute path of any skill file it must read. A lane returns its findings in its reply. The session that runs the review writes the findings file, so the file has one writer.

**Output.** The findings file follows the report contract above. Its layout is in `skills/review/references/findings-file.md`, which the review PR adds.

- `DONE` means no open blocker remains.
- `ISSUES` means at least one blocker is open. The `## Fix` section lists what a fix worker must change. Each finding has an id, a label, a lane, a `where`, one sentence, a citation and a `done when` line.
- `BLOCKED` means the review could not run, with the reason on line 2.

The session that runs the review also decides each finding: fix, declined, or for the PR. `build` does no triage of its own. `open-pr` reads only the last round's file.

The review also gives a summary of at most about 150 words: the status, the count of findings by label, whether the loop continues, and anything only the person can decide.

**The loop.** Review owns the rule for when the loop ends, and `build` follows it. The loop ends at the first round with no open blocker, and never runs past the cap that the review skill sets. On `ISSUES` with the loop still open, `build` points a fresh implementer at the `## Fix` section of the findings file inside a consolidated brief, then calls review again on the new head with the next round number. When the cap is reached with blockers open, `build` stops, lists them for the person, and carries them into the PR description.

**Quick tier.** The quick playbook calls the same skill and asks for its single-reviewer mode: one subagent that covers every lane in one prompt. The rubric lives in one place.

**What review does not do.** It does not change code.

## Writing

New prose follows the **unslop** and **technical-writing** skills. The rules that reviewers reject most often are these.

- Write short declarative sentences. One thought per sentence.
- Use no long dashes. End the sentence or use a comma.
- Use a colon before a list or an example, never to join two clauses.
- Write headings in sentence case.
- Use bold for a lead-in that names an item, and little else.
- Name the mechanism or the number. Cut a sentence that could appear unchanged in another project's docs.
- Call each thing by one name everywhere. The names are in the next section.
- Write whole sentences with their articles and verbs. Spell out arrows.

Text copied from a source repo keeps the source author's style.

## Names

| Name | Meaning |
| --- | --- |
| the person | the human who typed the command |
| lead | the one session the person talks to |
| worker | an hc session started for one job |
| subagent | a native subagent started with the `Agent` tool |
| explorer | the read-only subagent that answers a code question |
| slice | one vertical cut of the work in the outline |
| brief | the file a worker reads to do one slice |
| notes | the file a worker leaves for the next slice |
| report | the file that carries a worker's result |
| digest | the first page of `outline.md` |
| tier | Quick, Feature or Program |

## Where each core skill came from

| Skill or agent | Kind | Sources |
| --- | --- | --- |
| `lead` | hybrid | pstack `poteto-mode`, riptide's workflow tiers, plan sections 4.2 and 4.8 |
| `lead` playbooks `quick`, `feature` | hybrid | pstack `feature` playbook, Codey's pipeline, riptide tiers |
| `research` | hybrid | Codey's `research`, riptide `create-research-questions` and `create-research` |
| `how` | hybrid | pstack `how`, the lookup contract in plan section 4.8 |
| `why` | kept | pstack `why` |
| `design` | hybrid | Codey's `design`, riptide `create-design-discussion`, `create-prd`, `create-tdd` |
| `design/references/views.md` | adapted | riptide `show-me` and the views in `create-tdd` and `create-research` |
| `architect` | hybrid | pstack `architect`, Codey's design-it-twice runner constraints |
| `codebase-designing` | adapted | Codey's `codebase-designing`, pstack `architect`'s design red flags |
| `outline` | hybrid | Codey's `structure`, riptide `create-structure-outline`, pstack's throughput checkpoint |
| `build` | hybrid | Codey's `implement`, riptide `implement-outline`, pstack `feature` step 4 and `orchestrate` |
| `build-slice` | hybrid | riptide `outline-implementer-agent`, pstack `poteto-agent`, Codey's implementer template |
| `principle-*` (24) | kept | pstack |
| `explorer` | hybrid | riptide `codebase-locator`, `codebase-analyzer`, `codebase-pattern-finder`, pstack's how explorer |
| `web-researcher` | kept | riptide `web-search-researcher` |
| `slice-checker` | new | plan section 4.2 step 5 |

## What the core PR leaves for later PRs

Core skills point at these by their agreed names. Each pointer resolves once the PR that adds the skill lands.

| Item | Pointed at from |
| --- | --- |
| `review` | `lead`, `build`, the feature playbook |
| `open-pr` | `lead`, `build`, both playbooks |
| `grill`, `domain-modelling` | `design` |
| `arena` | `architect` |
| `test-first`, `comments` | `build-slice`, the quick playbook |
| `interrogate`, `swarm`, `unslop`, `technical-writing`, `show-me-your-work`, `benchmark-checklist`, `figure-it-out` | `lead` |
| `own-pr`, `run-loop` and the program playbook | `lead` names the Program tier and points at `playbooks/program.md` |
| The other playbooks | Each PR that adds a playbook also adds its line to the list in `skills/lead/SKILL.md` |
| `delegate` agent | `lead` |
| `setup` | the role sheet |

## Utility skills

The utilities PR adds these. A kept skill is copied from cursor-pstack's `pstack/skills` with the changes in "Kept skills" above, plus the changes in the next table.

| Source wording | Replace with |
| --- | --- |
| `.cursor/skills/`, `~/.cursor/skills/` | `.claude/skills/`, `~/.claude/skills/` |
| the `agent-transcripts/` directory, `~/.cursor/projects/` | `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/<slug>/`, where `<slug>` is the workspace path with every character other than a letter or digit turned into "-" |
| Cursor's built-in `create-skill` | Anthropic's `skill-creator` plugin, `/skill-creator:skill-creator` |
| "pick each subagent's reasoning level and fast or standard speed" | the role sheet |
| `Shell` (the tool) | `Bash` |

| Skill | Kind | Sources and changes |
| --- | --- | --- |
| `unslop`, `technical-writing`, `sharpen`, `bro`, `in-your-own-words`, `benchmark-checklist`, `correct`, `teach` | kept | pstack, unchanged |
| `figure-it-out`, `recall`, `automate-me` | kept | pstack, with the wording changes above |
| `show-me-your-work` | kept | pstack. The cross-model reviewer is the `vendor-reviewer` role, with the `trail reviewer` role as the fallback (decision 18) |
| `statechart`, `create-formal-verification-skill`, `maintain-formal-verification-skill`, `create-verification-skill`, `maintain-verification-skill` | kept | pstack. `statechart/scripts` is unchanged, tests included |
| `catchup` | adapted | pstack `ketchup`. Draws nothing and uses text sketches until its visuals are decided (decision 16) |
| `reflect` | adapted | pstack. Also reads the transcripts of the hc workers named in `.planning/<feature>/runs/` |
| `setup` | hybrid | pstack `setup-pstack` for the roles, Codey's `initialise-docs` for the per-repo part with its scan removed (decision 17) |
| `help` | adapted | pstack `poteto-help`, rewritten for taith |
| `improve-codebase-design` | adapted | Codey's. Step 3 runs `architect` and the decision questions in place of its own design-it-twice |

Nothing in this PR comes from `riptide-skills` or from the `pstack-claude` port.

`ketchup-video` and `typescript-best-practices` are not shipped.
