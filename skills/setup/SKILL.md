---
name: setup
description: "Sets up taith for a person and for a repo. Chooses a model and effort for each role, records the harness for the cross-vendor seat, and writes the domain-docs pointer into the repo. Use for /taith:setup, 'configure taith models', or 'set up this repo for taith'."
disable-model-invocation: true
---

# Setup

Setup has two parts. The first is per person: which model each role runs on, and which harness the cross-vendor seat uses. The second is per repo: the file that tells agents where the domain docs are, and a pointer to it in `CLAUDE.md`.

Both parts are safe to run again. Each one reads what exists and changes only what the person asks for or what is missing.

Ask which part the person wants when the message does not say. Offer "models", "this repo" and "both". Outside a git repository, run the first part only and say so.

## Part 1. Roles and models

The role sheet (`../lead/references/roles.md`) holds the default for every role. This part writes `~/.claude/rules/taith-roles.md`, which overrides the sheet line by line. Claude Code loads every file in `~/.claude/rules/` into each new session.

### 1. Find the models

List the names that the `Agent` tool's `model` parameter accepts in this session. Those are family names such as `opus`, `sonnet` and `haiku`. A full model ID is rejected. Ask the person to confirm the list. Never write a name that you have not confirmed.

### 2. Load the current choices

Read the role sheet for the defaults. If `~/.claude/rules/taith-roles.md` exists, read it and treat its `# budget` line and its role lines as the current choices. Drop a line whose role is not in the sheet, and tell the person which lines you dropped.

### 3. Ask for a budget

Ask the person for a budget with `AskUserQuestion`, or plain text when it is absent. Offer these four labels, and name the current budget when the file records one.

- `unlimited`: every role at `max`
- `large`: every role at `xhigh`
- `medium`: every role at `high`
- `small`: every role at `medium`

Say that answering `sheet` keeps the effort the role sheet gives each role. With no file, that is the current state. `AskUserQuestion` takes at most four options, and the person can type `sheet` as their own answer.

A budget sets the effort of every native role to the same level. It changes no model. On a run after the first, a line whose model differs from the sheet, or whose effort differs from the recorded budget's level, was set by hand. It keeps its value.

### 4. Show the roles and confirm

Show every native role with its model and effort after the budget, and mark each one that differs from the sheet. Ask whether to accept the table or change specific roles. Use `AskUserQuestion`, or plain text when it is absent.

- A role takes one model and one effort level: `low`, `medium`, `high`, `xhigh` or `max`.
- The value `session` runs the role on the session model. The `Agent` call then omits `model`.
- Do not offer `implementer`, `native implementer`, `pr-owner` or `loop-runner`. The brief or the role sheet sets those per job.
- If cost is the worry, say where the tokens go. Research explorers, the architect runners and the review lanes are the fan-outs. A cheaper model on those roles saves the most.

### 5. Record the cross-vendor seat

The seat is a reviewer from another model family. `review` uses it for the defect read, `arena` uses it as the judge, and `show-me-your-work` uses it to review a decision trail. The recipes are in the role sheet.

Ask which harness the person has: opencode, Codex CLI, Pi, or none. For a harness, ask for the model it should run. Check that the command exists with `command -v`. If it does not, record nothing and say what is missing.

The seat is recorded in two places, and both must name the same command. Step 6 writes a `vendor-reviewer` line to the roles file, which is how a skill knows the seat exists. `scripts/taith-worker` reads the launch command from the `TAITH_VENDOR_CMD` environment variable and defaults to `opencode run`. Show the person the line to add to their shell profile, such as `export TAITH_VENDOR_CMD='opencode run --model <provider/model>'`. Add it yourself only when they say so.

With no harness, each skill that wants the seat falls back to a native subagent and says in its output that the read came from the same model family.

No recipe has been run under hc yet. Say so when you record one.

### 6. Write the file

Write `~/.claude/rules/taith-roles.md` in the shape below. Write a `# budget` line with the chosen label. The `vendor-reviewer` line holds the launch command from step 5 in place of a model and effort. Write any other line only for a role whose value differs from the sheet, so that a later change to the sheet still reaches the roles the person left alone. Skills read only the file and the sheet, not the budget, so under any budget other than `sheet` the file has a line for every role whose effort the budget changed. Overwrite the whole file on each run. If the budget is `sheet`, no role differs and no seat is recorded, delete the file.

```markdown
# taith roles

Overrides for the taith role sheet. One line per role, as `<role>: <model> @<effort>`.
Delete a line to return that role to the sheet's default. Written by /taith:setup.

# budget: sheet
explorer: haiku @low
review axis: opus @high
vendor-reviewer: opencode run --model <provider/model>
```

### 7. Confirm

Tell the person where the file is, which roles differ from the sheet, and that the file applies to new sessions.

## Part 2. This repo

This part gives a repo the domain-docs skeleton: `docs/agents/domain.md`, and a `## Domain docs` block in `CLAUDE.md` that points at it. It writes those two things and nothing else.

It does not scan the code. It does not draft `LANGUAGE.md`, a context map or an ADR, and it does not detect modules. The **domain-modelling** skill (`../domain-modelling/SKILL.md`) writes the glossary and the decisions later, when a design conversation settles a term.

### 1. Check what is missing

Check two things at the repository root.

- Does `docs/agents/domain.md` exist?
- Does `CLAUDE.md` or `AGENTS.md` hold a `## Domain docs` block?

If both exist, change nothing. Reply with one line: "This repo is already set up. Run `/taith:domain-modelling` to add or refine terms."

If one is missing, create that one. Do not ask the person to confirm the one that exists.

### 2. Write what is missing

Each seed file is the exact content. Copy it without changes.

- `docs/agents/domain.md` comes from `references/domain.md`.
- The `## Domain docs` block comes from `references/agent-pointer-block.md`.

Choose the file for the block by these rules.

- Only one of `CLAUDE.md` and `AGENTS.md` exists. Use that one.
- Both exist and one is a symlink to the other. Edit the real file, never the link.
- Both exist as separate files. Ask the person which one owns the block.
- Neither exists. Create `CLAUDE.md`.

Append the block at the end of the file. Leave every other section as it is. Never rewrite an existing `## Domain docs` block or an existing `docs/agents/domain.md`, even when it differs from the seed. The person may have edited it.

### 3. Report

List each file you created or changed. Commit nothing. The person reviews the two files and commits them.

## Offer the verification skills

Make each offer once, after the parts above, and move on when the person declines.

- **A verification skill.** Check whether the project has a way to drive the real app for proof: a `verify` or `verify-*` project skill, or an existing harness. If it has none, offer to generate one with the **create-verification-skill** skill (`../create-verification-skill/SKILL.md`). It gives agents a scripted way to use the app as a person does.
- **A formal verification skill.** Check whether the project has a skill that runs a model checker or a prover against the code. If it has none, offer the **create-formal-verification-skill** skill (`../create-formal-verification-skill/SKILL.md`).

On yes, read that skill's `SKILL.md` and follow it.
