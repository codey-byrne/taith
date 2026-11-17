### Authoring or modifying a skill

**You own the skill's voice.**

taith ships no skill-authoring skill of its own. The authoring procedure is Anthropic's published `skill-creator` plugin.

1. Use the `skill-creator` skill from Anthropic's `skill-creator` plugin. If the session does not list it, tell the person to install that plugin from Anthropic's official marketplace, and stop until they have.
2. For a skill in this plugin, follow `../../docs/conventions.md`. The frontmatter has `name`, `description` and `disable-model-invocation: true`, and no other key. A pointer to another skill is its name in bold with its relative path. The skill names a role, never a model.
3. Validate the skill: the frontmatter is complete, referenced files exist, cross-skill links resolve.
4. Add test cases when the change is structural. Skip them when it is subjective.
5. Run the **open-pr** skill (`../open-pr/SKILL.md`) with the person's consent. A fix to a broken skill found mid-task goes in its own PR.

When in doubt, delete. Keep only prose that changes a decision. Tell the reader to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config) per the **principle-encode-lessons-in-structure** skill. Delegate to other skills by path. Don't restate them. When you keep hitting a workflow that no skill captures, propose a new skill.

**Reply:** summary of the skill, key design decisions, validation notes.
