# Style Guide

## Prose

- Prefer title case for chapter/section headings.
- Prefer italics over single quotes when calling out a term (*smart
  contract*, not `’smart contract’`).
- When talking about a function in prose, do not include the parentheses
  (`call` rather than `call()`).
- Hard wrap at 80 characters.
- Do not mix code and non-code inside a single word (``we wrote `verify`d`` —
  no; write either `verify`d as prose or keep the code separate).

## Code

- State the file name before a code block when it is not obvious which file
  the snippet belongs to.
- Keep code lines short (aim for under 80 characters).
- Use `console`/`bash` syntax highlighting for command-line examples.

## Links

- Use markdown relative links for intra-book links so the book works both
  online and offline.
- Word links so they read well in plain text.

## Compact-specific

- Use the current Compact toolchain version for all examples; state that
  version on the title page.
- All contracts shown must compile with the pinned toolchain version.
