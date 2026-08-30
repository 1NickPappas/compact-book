# The Compact Programming Language

A practical guide to writing smart contracts in Compact for the Midnight
network, modeled after the structure of [the Rust Programming Language
book](https://doc.rust-lang.org/book/).

## Building the Book

This book is generated with [mdBook](https://rust-lang.github.io/mdBook/).

Install mdBook (pick one):

```sh
# via Homebrew (macOS)
brew install mdbook

# via Cargo
cargo install mdbook --locked
```

Then, from the repository root:

```sh
# build the static HTML book into ./book
mdbook build

# build and serve with a live-reloading local server
mdbook serve
```

Open `http://localhost:3000` (or `book/index.html` after a build) to read.

## Structure

- `book.toml` — mdBook configuration (title, authors, theme).
- `src/SUMMARY.md` — the table of contents; every chapter file must be
  listed here.
- `src/chXX-YY-slug.md` — chapter sources. Chapter files start with `##`
  headings (mdBook supplies the top-level title), while part/chapter wrappers
  are auto-numbered.

## License

This work is copyrighted. See [`LICENSE`](LICENSE) for terms. No part of this
book may be reproduced, printed, or sold without explicit written permission.
