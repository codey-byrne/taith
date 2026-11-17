---
name: open-pr
description: "Opens the pull request for finished work, with a description grounded in the design, the outline and the last review round. Needs the person's consent before anything is pushed. Use for /taith:open-pr, as the last step of every playbook, and by a PR owner whose brief allows it."
disable-model-invocation: true
---

# Open PR

Deliver the work as a pull request. The description lets the reviewer confirm decisions they already approved, so they do not have to rediscover them in the diff. Everything before this step was a cheap review. The code is the review that matters, and the description exists to make it fast.

Opening a PR is the outward-facing step. Nothing is pushed and nothing is created until the person agrees.

## Who calls it

- **The lead**, at the end of `build` or of a playbook. It supplies the feature folder, the base branch, and every item a person must check by hand.
- **A person**, who types `/taith:open-pr` with a feature name or nothing. With one folder under `.planning/`, use it. With several, ask which.
- **A PR owner**, a worker that cannot ask anyone. Its brief carries the line `Open the PR: yes | no`, which records the consent the lead already got. See step 4.

With no `.planning` folder, as in the Quick tier, skip the files in step 1 and write the description from the diff and the conversation.

## 1. Load

Read these, and draft nothing until you have them.

1. **`outline.md`.** The opening lines, the digest, the slice list, each slice's "Check by hand", and the `## Accepted deviations` section. The frontmatter names the base branch.
2. **The last review round's findings file.** It is the `runs/review-<round>/report.md` with the highest round number. Each round's file is complete, so read no earlier one. Take the header lines, the open blockers under `Fix`, and the `For the PR`, `Declined` and `Account of the change` sections. Its layout is in `../review/references/findings-file.md`.
3. **"Not verified by a command"** in each `slices/<N>-notes.md`, unless the caller already gave you those items.
4. **`design.md`**, for the problem and the numbered decisions, when this session did not write it.
5. **The shape of the diff.** Run `git log <base>..HEAD --oneline` and `git diff <base>...HEAD --stat`.

Step 3 says who reads the full diff.

If no review has run on the current head, say so to the person before you go on. A PR owner writes it under `Review` in the description instead.

## 2. Settle the branch

- **Check that nothing else holds the worktree.** Run `<plugin>/scripts/taith-worker status --planning <dir>`, where `<plugin>` is two levels above this skill's base directory. A worker that is still running can change the tree under you. Wait for it or replace it first.
- **Commit what belongs to the change and is not yet committed.** Stage files by name. Never use `git add -A` or `git add .`.
- **Never commit `.planning/`**, a scratch script, or a generated file that the change did not cause.
- **Keep the slice commits as they are.** Each slice has a commit for its tests and one for its implementation. Review compared the two, and a squash erases that record. Reorder or amend only commits that have not been pushed.
- **Write each commit message for why.** Use the imperative mood. The body does not restate the subject.
- Run `git status` and read the result before you go on.

## 3. Write the title and the description

**Title.** Use Conventional Commits: `type(scope): subject`, with no full stop at the end. The type is one of `feat`, `fix`, `docs`, `refactor`, `test`, `chore` or `perf`. The scope is the area of the code. The subject is short and imperative, and names a real symbol when one carries the change.

**Description.** Fill `references/description-template.md` and do not grow the body past it. The body is the walkthrough of the change: one sentence on why, what the reviewer must be warned of, then the shape of the change as views. Three rules decide what goes in.

- **Show the shape, and leave the detail to the diff.** `Change outline` is a set of views from the **show-me** skill (`../show-me/SKILL.md`): a contract, a data structure, pseudocode, a file tree, a call tree. It is not prose and not a list of files.
- **Draw the views from the real diff.** They must match what landed, not what was planned. In the Quick tier, or with no findings file, read the whole diff and enough of the code around it yourself. In the Feature and Program tiers the lead does not read the diff. Start one subagent on the `explorer` role from the role sheet (`../lead/references/roles.md`). Give it the diff command, the absolute paths of `design.md`, `outline.md`, the **show-me** skill and the template, and ask for the `Change outline` section and nothing else. The `Account of the change` in the findings file tells you whether what it returns is complete.
- **Everything a person must check is in it.** That covers each "Check by hand" item, each item a slice could not verify with a command, each open blocker, and each suggestion review left for the person.

Write the title, the description and any new commit body to the **technical-writing** skill (`../technical-writing/SKILL.md`), then apply the **unslop** skill (`../unslop/SKILL.md`).

Save the description to `.planning/<feature>/pr-description.md`. With no `.planning` folder, keep it in a temporary file outside the repo.

## 4. Get consent, then open it

Show the person the title, the description, the base branch, and whether the PR opens ready or as a draft. Ask once, and wait for a yes. A change they ask for is an edit to the description, not consent.

**A PR owner does not ask.** Its brief says `Open the PR: yes` or `no`.

- `yes`. Go on. The brief also names the base branch.
- `no`, or no such line. Push nothing. Leave the title and the description in `pr-description.md`, and say in the report that the PR was not opened.

**Ready or draft.** Open the PR ready for review, because the review loop has already run. Open it as a draft only when the last findings file still has open blockers. The person can choose the other at the consent step.

**The base.** The outline's `base_branch`, or the branch the caller named. In a stack, the PR targets its parent's branch and the root PR targets trunk. Never retarget or close a PR that another PR is stacked on unless the person asks.

**The forge.** Choose once and keep the choice for every later PR operation.

1. A PR tool that the session provides. A PR made another way misses what that tool tracks.
2. A forge CLI or MCP server that is installed and already signed in, such as `gh` or `bkt`.
3. Neither. Print the title and the description for the person to paste, say which tool was missing, and stop. Never install one.

Push the branch with its upstream, then create the PR with the saved description as its body. Pass the body as a file, never as text inside a shell command. If the branch already has a PR, update its description and do not open a second one.

When the forge offers them, also set the default reviewers and close the source branch on merge.

Read the PR back from the forge before you report its state.

**Then stop.** Opening a PR does not start a babysit, and no session ever merges. The person reviews and merges. A PR owner goes on to babysit its own PR, because its brief says so.

## 5. The gate

End with the reminder that the whole workflow leads to: the earlier artifacts were the cheap reviews, and the code is the one that matters. Tell the person: **now read the code. No exceptions.**

**Reply:** the PR link written as `https://github.com/<owner>/<repo>/pull/<number>`, whether it is ready or a draft, what the person must check by hand, each blocker still open, and each suggestion left for them.
