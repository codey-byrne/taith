# Comments lane prompt

Fill `{DIFF_CMD}`, `{RULE_STATUS}`, `{RULE_FILES}` and `{RETURN_CONTRACT}`. Change nothing else. Start the lane with `subagent_type: "taith:comment-sicko"`. The agent file carries the comment rule, so this prompt does not repeat it.

`{RULE_STATUS}` is one of these two lines.

- `IN FORCE. This change was built under the comment rule.` Use it when the spec comes from a `.planning` folder.
- `NOT IN FORCE. This repo never adopted the comment rule.` Use it for any other change.

`{RULE_FILES}` is the gate's list of rule documents, one absolute path per line, or `none`.

```
Review the comments in one change. Report only. Edit nothing and delete nothing.

Run exactly this command and read the whole diff: {DIFF_CMD}

Judge only lines the diff adds or changes. Report two kinds of finding.

- a comment that your rule would remove, with the keep clause you checked and why it does not apply
- a public interface that the diff adds or changes and that has no doc comment

The comment rule: {RULE_STATUS}

The repo's rule documents:
{RULE_FILES}
If one of them states a rule about comments, that rule wins over yours wherever they differ. Cite it.

Labels for this lane:
- When the rule is IN FORCE, a breach is `blocker (presumptive)`.
- When the rule is NOT IN FORCE, every finding is `suggestion`, unless it breaks a comment rule in the repo's own
  documents. That one is `blocker (presumptive)`.
- A suppression such as `eslint-disable` or `@ts-ignore` on a rule that protects correctness is
  `blocker (presumptive)` in both cases.

If the diff adds or changes no comment and no public interface, the whole return is the SKIPPED line below with the
reason `no comments or public interfaces in the diff`.

cite line for this lane: quote the comment or the undocumented signature, and name the clause of the rule.

{RETURN_CONTRACT}
```
