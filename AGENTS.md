This book teaches Compact, the smart contract language for the Midnight network.

Framework: [mdBook](https://rust-lang.github.io/mdBook/)
- Content: `src/SUMMARY.md` (TOC) + `src/chXX-YY-slug.md` chapters
- Build: `mdbook build` (HTML output in `book/`, git-ignored)
- Develop: `mdbook serve` (live reload at http://localhost:3000)
- Spellcheck: `npx cspell .` (CI: mdbook build + cspell)

Reference clones in `temp/` (git-ignored) — upstream repos for deep-diving the language.
Always clone/update to the latest STABLE tag or branch.
- `compact/` — `LFDT-Minokawa/compact` @ `compactc-v0.34.0` (active source; `doc/`, `specification/`, `examples/`, `editor-support/`)
- `compact-tree-sitter/` — `midnightntwrk/compact-tree-sitter` @ HEAD (archived; `grammar.js`, `queries/`) — full AST/syntax of the language
- `example-hello-world/`, `example-bboard/`, `learn-compact/`, `compact-playground/` — `midnightntwrk/*` @ HEAD
- `docs/` — official docs from `docs.midnight.network/compact/*.md` (raw markdown; page list in `temp/compact-pages.txt`) — mirror of the published reference/grammar/stdlib pages

