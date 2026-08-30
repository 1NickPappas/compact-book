This book teaches Compact, the smart contract language for the Midnight network.

Framework: [mdBook](https://rust-lang.github.io/mdBook/)
- Content: `src/SUMMARY.md` (TOC) + `src/chXX-YY-slug.md` chapters
- Build: `mdbook build` (HTML output in `book/`, git-ignored)
- Develop: `mdbook serve` (live reload at http://localhost:3000)
- Spellcheck: `npx cspell .` (CI: mdbook build + cspell)
