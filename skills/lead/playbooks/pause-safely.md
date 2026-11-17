### Pause safely

**You own a clean stop. Leave a checkpoint a cold-start session can resume from.** This is explicit only. On "keep going", "going to bed, keep going", or "don't stop", do not pause.

A session whose context is close to full also pauses this way, because auto-compaction stays off. A slice worker that outgrows its brief does the same inside its slice, as the **build-slice** skill describes.

1. **Stop at a safe boundary.** Finish the current atomic step or back out of it. Start nothing new. Let a running subagent finish only when its result is seconds away. An hc worker outlives you and ends with its own report, so leave it running unless the person said to stop everything.
2. **Take no irreversible action to pause.** No PR and no push unless you already had one out.
3. **Make the work durable.** Commit uncommitted edits as one clear `wip:` commit on the current branch so nothing is lost. If the tree is broken, say so in the commit body in one line. Nothing under `.planning/` is committed.
4. **Write the resume note** to `.planning/<feature>/resume.md`. Create the folder when the task has none. Capture intent, what you were doing, progress and what's verified, current state, next steps, key files, and gotchas. List each worker still running with its name and what it was sent to do. Point at `outline.md`, the reports and any show-me-your-work trail instead of repeating them.
5. **Preserve what the person asked to have after the resume**, such as questions, an acceptance checklist, or a procedure. Reuse the existing artifact when there is one. Otherwise save the material beside the resume note and link it. Keep exact wording, completeness, and order when requested. Then read the note back and check that everything requested is reachable from it alone. Ten requested questions means all ten.

**Reply:** where you are in the task, what's on disk and what is still only in your head (paths, no diff dumps), the commits you made and whether the tree is clean, the workers still running, and the first action on resume. This is a pause, not a final report.
