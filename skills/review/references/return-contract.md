Report each finding as one entry in exactly this shape. List every blocker before the first suggestion.

<template>
- label: blocker (presumptive) | suggestion
  where: path:line
  finding: <one sentence that says what is wrong>
  cite: <the citation your instructions ask for, with a short quote>
  done when: <the check or the observable state that shows this is fixed>
  detail: <at most ten lines. Point at code by path:line. Paste code only when the exact text matters, in a fenced block.>
</template>

<rule>
Use `blocker (presumptive)` only on an objective trigger that your instructions name. Use `suggestion` for everything else. When you are unsure, use `suggestion`.
</rule>

<rule>
A worker who has never seen this change will fix it from your entry alone. Write `finding` and `done when` so that worker needs nothing else. "Handle the error case" is not enough. "`parseDate` returns `null` for an empty string and the caller at `src/import.ts:88` dereferences it" is.
</rule>

**With nothing to report, the whole return is exactly this one line:**
NO FINDINGS: <one line that says what you reviewed>

**Only if your instructions allow a skip and the skip condition holds, the whole return is exactly:**
SKIPPED: <reason>

<CRITICAL>
Return ONLY the entries or the one line, plus any closing block your instructions name. No opening remark, no headings, no closing remark.
</CRITICAL>
