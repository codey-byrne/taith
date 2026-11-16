---
name: review
description: "Review a change against its spec, the repo's documented rules and a structure baseline, with a comment check and a defect read by another model family. Use for /taith:review on a branch, a ref or someone else's PR, and as the review step that lead and build call in a loop until no blocker is open."
disable-model-invocation: true
---

# Review

Review the diff between a base ref and `HEAD`. Five lanes read it at once, and each lane judges one thing.

| Lane | Judges | Files under |
| --- | --- | --- |
| Spec | Does the change do what the spec asks? | Spec |
| Standards | Does the change follow the rules this repo has written down? | Standards |
| Comments | Does each comment earn its place, and does each public interface have its doc comment? | Standards |
| Structure | Is the change well built? | Structure |
| Defects | Does the change break anything, whether or not the spec mentions it? | Defects |

A change can pass one lane and fail another, so the lanes run apart and none of them sees another's findings. Review reports findings and a status. It never changes code.

Every finding is labelled `blocker (presumptive)` or `suggestion`. A blocker needs an objective trigger: a spec line the change does not meet, a written rule the change breaks, a file pushed past 1,000 lines, or a defect shown with a command or a traced path. Everything else is a suggestion. "Presumptive" means the session that runs the review can decline a blocker, with a reason it writes down.

Claude Code prints this skill's base directory when the skill is invoked. Every file named below lives under it. Give a lane the absolute path of each file it must read.

## Who calls it

**A person** types `/taith:review` with a ref, a PR number, a spec path, or nothing. Review finds what is missing and may ask. It runs one round.

**A skill** such as `build` supplies the base ref, the spec paths, the round number and the path of the findings file, as `docs/conventions.md` describes. Review asks nothing. A missing input ends the round with `STATUS: BLOCKED` and the name of the input.

The quick playbook asks for the single-reviewer mode, described at the end.

## 1. Settle the base, the head and the spec

Use each value the caller supplied as given. Do not confirm it or look for a better one. The routes below are only for a value the caller left out.

**Base.** A person names it. If they named a PR, read its base branch and head with the forge CLI the repo already uses, then check the head out in a detached git worktree and run every later step there. If they named nothing, ask.

**Spec.** Take the first route that gives one.

1. A path or a PR the person named. For a PR, the spec is its description and any issue it links.
2. A `.planning/<feature>/` folder that matches the branch. Use `outline.md`, the `slices/` folder and `design.md`. Confirm the match with the person.
3. A ticket key in the commit messages, fetched with a forge or tracker CLI that the session already uses. Confirm the ticket with the person. Never install a CLI to do this.
4. Ask the person.

With no spec, the Spec lane is `skipped` and never starts. The other lanes still run.

**Rules in force.** When the spec comes from a `.planning` folder, the change was built under taith's comment rule, and a breach of it can be a blocker. On any other change the Comments lane only suggests, unless the repo documents its own comment rule.

## 2. Gate

Run these before any lane starts, so a bad input fails once and not in five subagents.

- Check that `git rev-parse <base>` resolves and that `git diff <base>...HEAD` is not empty. Either failure ends the round as `BLOCKED`.
- Keep the literal string `git diff <base>...HEAD`. It fills `{DIFF_CMD}`. Keep the output of `git log <base>..HEAD --oneline`. It fills `{COMMIT_LIST}`.
- Run `python3 <base-dir>/scripts/file_size_gate.py <base>`. Exit code 2 ends the round as `BLOCKED` with the reason from stderr. Each line it prints is `path<TAB>before<TAB>after` for a file the change pushes past 1,000 lines. The lines fill `{PRESEEDED_FINDINGS}`, or `none`.
- List the rule documents with a glob, not a subagent: `CLAUDE.md` and `AGENTS.md` at the repo root, any root file named like `CONTRIBUTING`, `CODING_STANDARDS` or `STYLE`, and any file under the root `docs/` folder with such a name or `conventions`. The paths fill `{RULE_FILES}`. With none, the Standards lane is `skipped` and never starts.
- List the lint and format config files at the repo root, such as `.editorconfig`, `.eslintrc*`, `.prettierrc*`, `ruff.toml` and the ktlint or detekt configs. The names fill `{LINT_CONFIG_FILENAMES}`, or `none detected`.

## 3. Start the lanes

Read each template under `references/`, fill the placeholders its first lines name, and change nothing else. `{RETURN_CONTRACT}` is the full text of `references/return-contract.md`.

Start every lane in one message.

| Lane | Template | Started as |
| --- | --- | --- |
| Spec | `spec-prompt.md` | `Agent`, `subagent_type: "Explore"`, the `review axis` role |
| Standards | `standards-prompt.md` | the same |
| Structure | `structure-prompt.md` | the same |
| Comments | `comments-prompt.md` | `Agent`, `subagent_type: "taith:comment-sicko"` |
| Defects | `defects-brief.md` | the cross-vendor seat, below |

**The cross-vendor seat.** The Defects lane goes to a model from another vendor, because a second model family catches what the first one reads past. Write the filled brief to a file beside the findings file, or to a temporary file when there is no findings file. Start the seat with `scripts/taith-worker spawn` and the `vendor-reviewer` role, then `wait` on it. The seat's findings are the body of its `report.md`.

If the script prints `BACKEND: native`, or the seat fails to start, or `wait` times out, start an `Explore` subagent with the same brief. Record the lane as `same family` so the reader knows no second vendor read the change. Never hold the round for the seat.

## 4. Check what came back

Check each lane's return. A failed check earns one repair run.

- **Usable.** The return is a `NO FINDINGS:` line, a `SKIPPED:` line, or at least one entry with a legal `label`.
- **Paths in the diff.** For Standards, Comments, Structure and Defects, every `where` path appears in `git diff --name-only <base>...HEAD`. A Spec finding may point outside the diff, because a missing requirement has no hunk.
- **Size findings kept.** Every path the size gate printed comes back from Structure as a `blocker (presumptive)`.
- **Legal skip.** Only Standards and Comments may return `SKIPPED:`.

The repair prompt is the original filled prompt, the previous return word for word, the list of failed checks, and this instruction: "Repair the listed defects. Keep every finding whose substance is sound. Do not review again from the start." An unusable return has nothing to repair, so run the original prompt again as it is. A second failure marks the lane `not reviewed`. That state belongs to this session. No lane ever returns it.

If Structure ends `not reviewed`, write the size gate's lines into the findings as Structure blockers yourself. A finding from a script must not be lost because a subagent failed.

Pass through anything else odd with a one-line note under the lane: an unknown label, a heading, an opening or closing remark.

## 5. Merge and sort

- **Merge.** A problem that two lanes found becomes one finding. Keep the stronger label, the clearest sentence, and both citations, and list both lanes.
- **Conflicts.** When two findings ask for opposite changes, keep both and mark each with the other's id. A Structure finding that conflicts with the spec is still a finding. It says the spec was met with a shape that will cost later.
- **Number.** Give each finding an id of the form `R<round>-<n>`, blockers first. A finding keeps its id in later rounds.
- **Sort.** A person gets the findings as they are. In a loop, decide each finding now, because nobody is there to ask:
  - A blocker is `fix`, unless a numbered decision in `design.md` or a line under `## Accepted deviations` in `outline.md` answers it. Then it is `declined`, with that citation as the reason.
  - A suggestion is `fix` when it touches only lines the change already touches and needs no design decision. Otherwise it is `for the PR`, and `open-pr` lists it for the person.

## 6. Write the result

In a loop, write the findings file at the path the caller gave, in the layout of `references/findings-file.md`. Its first line is the status.

- `STATUS: DONE`. No blocker is open. A blocker is open until a later round finds it resolved or this session declines it.
- `STATUS: ISSUES`. At least one blocker is open.
- `STATUS: BLOCKED`. The review could not run. The second line says why.

The status counts open blockers and nothing else. It is not an opinion of the change.

Then reply with a summary of at most about 150 words: the status, the count of findings by label, each lane that was `skipped`, `not reviewed` or `same family`, whether the loop continues, and anything only the person can decide.

For a person with no `.planning` folder, write no file. Reply with the same summary and then every finding in full, blockers first, grouped under Spec, Standards, Structure and Defects, followed by the Spec lane's account of the change. Post nothing to the PR unless the person asks.

## The loop

`build` calls review again after each fix round, with the next round number. Review decides when the loop ends.

**Round 1** is the full review above.

**Rounds 2 and 3** read only what the fix changed. Read the previous round's findings file, which sits at the same path with the previous round number. Its `head` line is the commit that round reviewed. Run the size gate against `<previous head>`. Fill `references/recheck-prompt.md` with the gate's output, the `fix` findings from that file and the command `git diff <previous head>...HEAD`, and start one `Explore` subagent with the `review axis` role. It answers two questions.

1. Is each `fix` finding resolved? It gives the evidence for each.
2. Did the fix introduce a blocker? It reads the fix diff against every lane's rubric.

It raises no suggestions. A full review each round would never come back clean, because a fresh reader always has one more opinion, so the later rounds are held to those two questions. Run step 4's checks on the return, then write the new findings file. A finding that is still open keeps its id and gains a line that says what the fix missed. New blockers get ids for the current round and are sorted as in step 5.

If the fix rewrote the change instead of patching it, run a full round. It still counts as round 2 or 3.

**The end rule.**

- The loop ends at the first round whose status is `DONE`.
- The loop ends at round 3 whatever the status. Round 3's summary says "loop ended at the cap" and lists each open blocker. `build` starts no further fix round, tells the person, and carries the open blockers into the PR description.
- A round that ends `BLOCKED` ends the loop.

A blocker that survives two fix rounds usually means the brief or the design is wrong, and a third try at the same patch would not help. That is why the cap is 3 and why the person sees what is left.

## Single-reviewer mode

For a change of one or two files, the quick playbook asks for one reviewer. Run steps 1 and 2, then fill `references/single-prompt.md` and start one `Explore` subagent with the `review axis` role. It reads the diff against every lane's rubric in one pass. No seat starts and no file is written. Run the "usable" and "paths in the diff" checks, then reply with the findings and a status counted the same way. If the reviewer returns a blocker, the caller fixes it and may ask once more. The second answer is final.
