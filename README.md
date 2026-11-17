# taith

*taith* (Welsh): a journey, said like 'tithe'

taith is a Claude Code plugin for building software with one lead session. You give the lead a task. It researches the code, designs the change with you, cuts the work into slices you approve, delegates each slice to a fresh worker, and reviews the result. You are involved at three points: the design conversation, one outline check, and the PR.

It is an adaptation of [pstack](https://github.com/cursor/plugins/tree/main/pstack). It adds a design conversation and an outline check to pstack's model of a lead that delegates, and it can run its code-writing workers as [herdr-core](https://github.com/herdrdev/herdr-core) (`hc`) sessions that you can watch and steer.

## Status

This is the first cut of the core workflow. Read this section before you rely on it.

- **Nothing here has been run end to end.** The skills were written from an agreed design and have not yet been used on a real task.
- **The hc path is unverified.** `scripts/taith-worker` was written on a machine without hc. Its hc commands come from the herdr-core documentation. Without hc the script reports `BACKEND: native`, and the skills use native subagents in git worktrees. That path and the report-file wait are tested.
- **Some skills are not in the repo yet.** The core skills point at them by name. The list is in the last section of [docs/conventions.md](docs/conventions.md).

## Install

Add the repo as a marketplace, then install the plugin.

```text
/plugin marketplace add codey-byrne/taith
/plugin install taith@taith
```

Start Claude Code on the strongest model you have. The lead runs on the session model.

To get hc workers, start the lead's Claude Code session inside hc, so that hc records the lead as the parent of the workers it starts. Outside hc the same skills use native subagents. You lose the ability to watch and steer a worker, and nothing else.

## Use it

Type the entry command with your task.

```text
/taith:lead add CSV import to the reports page
```

The lead's first message restates your goal and names the workflow it picked. It does not wait for a reply. Tell it to switch if you disagree.

| Tier | Use when | What runs |
| --- | --- | --- |
| Quick | One or two files and an obvious approach | The lead does the work itself |
| Feature | New or changed behaviour that one PR can carry | Research, design, the outline check, a delegated build, review, one PR |
| Program | Several PRs | Feature, with two design sign-offs and one owner per PR |

### What a feature looks like

1. **Clarify.** The lead asks only what it needs to pin down what you are asking for.
2. **Research.** It writes research questions and runs one read-only explorer per question, all at once. Each explorer files a cited answer. Research finishes before design starts, so you are never asked something the code already answers.
3. **Design.** It asks you about behaviour first. It then produces the shape of the code, and compares at least two candidate shapes when the change adds or moves an interface. Last, it asks you only the trade-offs that are a matter of preference. Facts are looked up. Forks that a run can settle are prototyped.
4. **Outline check.** It writes `outline.md`: a one-page digest of the decisions, then vertical slices with named acceptance tests and verify commands. This is your one deep review before code.
5. **Build.** For each slice the lead writes a short brief and starts a fresh worker. The worker writes the slice's tests first, in their own commit, then the code. A checker reads each diff against its brief. Independent slices run in parallel. Nothing waits for you.
6. **Review and PR.** The review skill reads the whole change. A fresh worker fixes what it finds. The lead opens the PR with your consent and stops. You merge.

Each step can also start cold from the files on disk: `/taith:research`, `/taith:design`, `/taith:outline`, `/taith:build`.

### Where the files go

Each task keeps its files in `.planning/<feature>/` in your checkout.

```text
.planning/<feature>/
├── task.md          # the task as you gave it
├── questions.md     # research questions
├── research.md      # cited answers, one section per question
├── design.md        # the design and its numbered decisions
├── outline.md       # the digest and the slices
├── slices/          # one brief and one set of notes per slice
└── runs/            # one report per worker
```

Add `.planning/` to your `.gitignore`, or to `.git/info/exclude`, if you do not want it in the repo.

## What is in the repo

| Path | Holds |
| --- | --- |
| `skills/lead/` | The entry skill, its playbooks and the role sheet |
| `skills/research/`, `skills/how/`, `skills/why/` | Reading the code and its history |
| `skills/design/`, `skills/architect/`, `skills/codebase-designing/` | The design conversation, the shape step and the shared design vocabulary |
| `skills/outline/` | Slices and the decision digest |
| `skills/build/`, `skills/build-slice/` | The lead's build step and the worker that implements one slice |
| `skills/grill/`, `skills/domain-modelling/` | How a question is put to you, and the glossary and ADRs written as decisions land |
| `skills/test-first/`, `skills/comments/` | What every session that writes code follows for tests and comments |
| `skills/arena/`, `skills/interrogate/`, `skills/swarm/`, `skills/blast-radius/` | Parallel candidates with a judge, adversaries that must prove a finding, plain fan-out, and what a change breaks elsewhere |
| `skills/principle-*/` | pstack's 24 principles, unchanged |
| `agents/` | The `explorer`, `web-researcher` and `slice-checker` subagents |
| `scripts/taith-worker` | Starts, waits on and cleans up workers |
| `docs/conventions.md` | The rules every skill follows. Read it before you change one |

Every skill sets `disable-model-invocation`. A skill runs because you typed it or because another skill read it. The plugin has no startup hook.

## Models

Skills name a role and never a model. [The role sheet](skills/lead/references/roles.md) maps each role to a model. By default explorers run on Haiku or Sonnet, slice workers on Sonnet or Opus as the brief says, and the lead on the session model.

## Credits

taith is assembled from three bodies of work.

- **[pstack](https://github.com/cursor/plugins/tree/main/pstack)** by Lauren Tan. The lead that owns the design and delegates, the principles, `how`, `why`, `architect`, `arena`, `interrogate`, `swarm` and `blast-radius`, and the rule that every agent starts fresh with consolidated scope.
- **[humanlayer](https://github.com/humanlayer/humanlayer)**'s RPI workflow by Dex Horthy and the HumanLayer team. Research that describes and never recommends, the structure outline as the last check before code, vertical slices, the views used to show the shape of code, and the web researcher agent.
- **[codey-byrne/skills](https://github.com/codey-byrne/skills)**, itself adapted from HumanLayer's workflow and from [Matt Pocock's skills](https://github.com/mattpocock/skills). The research, design, structure and implement pipeline, `codebase-designing`, `domain-modelling`, and the sources of `grill`, `test-first` and `comments`.

[docs/conventions.md](docs/conventions.md) lists the sources of each skill.

## License

MIT. See [LICENSE](LICENSE).
