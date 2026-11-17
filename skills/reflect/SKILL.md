---
name: reflect
description: Spawn three parallel review subagents over the active transcript and the transcripts of the hc workers it started, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
disable-model-invocation: true
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

Invoke when the user says "reflect" or "/reflect". Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## 1. Locate the transcripts

Before fanning out, find this conversation's transcript in the active workspace's transcripts directory, `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/<slug>/`, where `<slug>` is the workspace path with every character other than a letter or digit turned into "-". Do not glob across `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/*/`. That crosses workspace boundaries and reads private chats from unrelated projects.

```bash
ls -t <transcripts>/*.jsonl <transcripts>/*/subagents/*.jsonl 2>/dev/null | head -10
```

That covers the session (`<id>.jsonl`) and subagent (`<parent>/subagents/<child>.jsonl`) layouts. Take the session file that contains the conversation's opening user prompt: `grep -lF` a distinctive fragment of it across the candidates. The first lines of a transcript can be session metadata, so do not match on line 1 alone. If none matches, pass a tight digest of the session instead.

Then collect the transcripts of the hc workers this conversation started. A worker is its own Claude Code session in its own worktree, so its transcript is not under the lead's directory.

- Each worker has a folder at `.planning/<feature>/runs/<worker>/`. Its `meta` file names the worktree. Its `report.md` is the worker's result.
- A worker's transcripts directory is `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/<slug>/` with `<slug>` built from the worktree path by the same rule. Take the newest `.jsonl` there.
- Read only the worktrees named in this conversation's `runs/` folders. Any other worktree's transcripts belong to another conversation.
- A `vendor-reviewer` worker runs on another harness and leaves no Claude Code transcript. Pass its `report.md` instead.
- A removed worktree keeps its transcripts directory. A missing one means the worker never started. Say so and carry on.

Skip this when the conversation started no worker.

## 2. Spawn three reviewers in parallel

One message, three `Agent` calls, `subagent_type: "general-purpose"`. Reviewers need MCP access to look up the tickets, chat threads, and observability traces the transcript references, and a read-only agent type strips MCPs.

Each reviewer and the synthesizer name a role in the role sheet (`../lead/references/roles.md`). Set `model` and `effort` from that role's line. If the `Agent` tool rejects a model, omit `model` so the subagent runs on the session model, and say so.

| Lens | Role | Prompt template |
|---|---|---|
| Judgment | `reflect reviewer` | `references/judgment-reviewer.md` |
| Tooling | `reflect reviewer` | `references/tooling-reviewer.md` |
| Divergent | `reflect reviewer` | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. When step 1 found worker transcripts, list their paths after the lead's, each labelled with its worker name and role, and tell the reviewer that the lead's transcript is the conversation and the others are the workers it started. Reviewers return findings in the `Agent` response body.

## 3. Synthesize

One `Agent` call, `subagent_type: "general-purpose"`, role `reflect synthesizer`. It spot-verifies citations through MCP, and a read-only agent type strips MCPs. Pass `references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. It returns an Accepted / Rejected / Backlog list.

## 4. Structural enforcement check

Move any Accepted item that a lint rule, script, metadata flag, or runtime check would enforce more reliably to Backlog. See the **encode-lessons-in-structure** principle skill.

## 5. Apply

Present the synthesizer's full Accepted / Rejected / Backlog output and wait for explicit approval before applying any Accepted edit. The user picks the subset and may redirect routings. Skill changes affect every future agent in the org. Do not auto-apply.

File each Backlog item to your team's devex or backlog tracker without waiting. Only the Accepted list waits for approval.

Never edit a skill under `plugins/cache/`. Before approval, show its destination, `.claude/skills/<skill>/` or `~/.claude/skills/<skill>/`. After approval, copy the skill folder there and edit the copy. Never open a PR or push.

Follow each approved row's Routing exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): the parent does it directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): hand to Anthropic's `skill-creator` plugin (`/skill-creator:skill-creator`) and run its draft / test / iterate loop. If it is not installed, tell the user to install it with `/plugin install skill-creator@claude-plugins-official`, and apply nothing substantive by hand.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): hand to `skill-creator` and run its description-optimization loop.
- `new skill via skill-creator: <kebab-name>`: hand creation to `skill-creator`. Do not invent the shape ad hoc.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done.

## 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
