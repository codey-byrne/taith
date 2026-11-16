---
feature: <feature>
git_commit: <commit the outline was written against>
base_branch: <branch the PR will target>
---

# <Title>

<Two or three sentences: what changes and for whom.>

## Digest

Everything an implementer needs from the design, on one page. Resolved decisions only.

### Decisions

- D1. <The decision, as a fact. One line.>
- D3. <...>

### Patterns to follow

- <What the pattern is>. See `path/to/file.ts:40-72`.

### Test and verify commands

```text
<lint command>
<typecheck command>
<how to run one test file or one test by name>
<full suite command, run once after the last slice>
```

### Out of scope

- <What this work does not do>

## Slices

- [ ] 1. <Behaviour the slice delivers>
- [ ] 2. <...>

| Slice | Depends on | Can run beside |
| --- | --- | --- |
| 1 | none | 3 |
| 2 | 1 | none |
| 3 | none | 1 |

Shared state: <each file, table or branch that two slices both write, and how the outline keeps them apart. "None." when there is none>

---

## Slice 1. <Behaviour the slice delivers>

**Behaviour.** <What a caller or user can do when this slice lands that they could not do before.>

**Seam.** <Where the acceptance tests cross, in codebase-designing terms. Which interface they exercise.>

**Acceptance tests.**

- `<test name>`. <What it proves.>
- `<test name>`. <What it proves.>

**Files likely touched.**

- `path/to/file.ts`
- `path/to/file.test.ts`

**Change outline.** <Optional. One or two views from the views reference, when a file-tree diff, a signature or a contract shows the slice faster than the lines above. Signatures only, never bodies.>

**Verify.**

```text
<each command that proves this slice, one per line>
```

**Check by hand.** <Anything no command can verify. It goes into the PR description. "Nothing." when there is nothing.>

**Depends on.** <Slice numbers, or "None.">

**Context.** <Exact sections worth pulling, such as design.md "D4" or research.md "Sessions persist to Postgres before the daemon acks the write". "None." when the digest is enough.>

**Model.** <sonnet for a routine slice, opus for a hard one, with one line on why when it is opus.>

---

## Slice 2. ...

---

## Accepted deviations

The build writes this section. Each line names a slice, what differs from the outline, and why the lead accepted it.

None.
