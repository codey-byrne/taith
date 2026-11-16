# Architect runner prompt

The orchestrator passes this file to every candidate runner in Phase C and fills in the inputs around it: the task, the grounding, the runner's own constraint, the absolute paths of the skill files named below, the isolated working directory, and the path to write outputs to. The working directory is a git worktree when one is available, otherwise a directory per runner. What matters is that candidates are independent.

You are producing one candidate design in architect's parallel exploration. Read the **architect** skill and the **codebase-designing** skill in full first, at the paths you were given. Use the terms of codebase-designing exactly, and the project's own domain terms from `LANGUAGE.md` when that file exists.

Output a candidate design package:

1. The contracts between components that the change adds or alters: schemas, API and event shapes, the main flow.
2. The interface: types, methods and parameters, plus invariants, ordering constraints and error modes.
3. A usage example that shows how callers use it.
4. What the implementation hides behind the seam.
5. The dependency strategy and adapters, per `deepening.md` in codebase-designing.
6. A module map for larger work.
7. A rationale shaped per [`rationale-template.md`](rationale-template.md), including where leverage is high and where it is thin.

Hold to the constraint you were assigned. It exists to make the candidates differ.

Apply the following discipline. The orchestrator compares candidates on these axes to pick a base.

- Caller's usage first. Write the README-style usage and two or three real call sites before the types, then derive the type sketch from them. The usage is the spec. The two must agree, so reconcile the sketch to the usage, not the reverse.
- Contracts before code shape. Settle what crosses between components before you lay out modules.
- Data structures first. Get the core types right and the code becomes obvious. Trace each dominant access pattern through the proposed structure. If the answer is "we'll add a map / index / cache later," the structure is wrong.
- Interface depth. Compare the capability hidden behind the public surface relative to the size of that surface. Prefer a simple interface that pulls complexity into the callee, even when the implementation becomes less simple. Do not put transport or wire types on the public API. Parse into domain types behind the interface.
- Shared state: if two actors might both write, ask "what happens?" If the answer isn't "nothing," default to per-actor state with a merge at the read boundary, per the **separate-before-serializing-shared-state** principle skill.
- Make boundaries visible. `not implemented` errors for bodies, `// TODO` pseudocode for tricky logic, doc comments stating intent and invariants. A reader should trace data from input to output by reading types and signatures alone.
- Encode invariants in types: hard-to-misuse types > runtime checks > prose comments, per the **encode-lessons-in-structure** principle skill.
- Validate at boundaries, trust types inside, per the **boundary-discipline** principle skill. Business logic as pure functions. The shell stays thin.
- Single source of truth per invariant. Derive instead of sync.
- Idempotent state transitions where applicable, per the **make-operations-idempotent** principle skill. Ask what happens if the operation runs twice or crashes halfway.
- Short call chains. If tracing the flow needs more than three files, flatten the hierarchy, per the **laziness-protocol** and **minimize-reader-load** principle skills.
- One adapter means a hypothetical seam. Two adapters means a real one. Do not add a seam unless something varies across it.

You are one of the parallel runners. Produce the best design you can under your constraint. Don't hedge against the others. Differences between candidates are the signal used to pick a base and graft. Converging on a safe-looking middle defeats the exploration.
