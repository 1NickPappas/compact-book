# The Compact Toolchain

You have a contract that compiles. This short chapter maps out everything
the toolchain gives you: the `compact` CLI, the project layout a real
Midnight app uses, and the artifacts a compile produces.

## The `compact` CLI

The `compact` command is a thin version manager around the compiler. The
commands you will use constantly are:

| Command | Alias | What it does |
|---------|-------|--------------|
| `compact compile <src> <out>` | `c` | Compile a `.compact` file into circuits |
| `compact update <version>` | `u` | Switch to a specific toolchain version |
| `compact list` | `l` | List installed/available versions |
| `compact check` | `ch` | Check the remote server for updates |
| `compact clean` | `cl` | Remove all installed versions |
| `compact -V` | | Print the CLI version |

Every project should pin its compiler with `compact update` — a contract's
`pragma language_version` declares the language, and the compiler version you
compile against should be the matching stable build (see
[Installation](ch01-01-installation.html)).

## Project layout

A full Midnight app pairs `.compact` contracts with a Node.js driver written
against **midnight-js**. The
[example-hello-world][hello-world] repo shows the canonical shape:

```text
my-dapp/
├── contracts/
│   └── hello-world.compact      # your Compact source
├── src/
│   └── ...                      # TypeScript that calls the circuits
├── compose.yml                  # local devnet + proof server
└── package.json
```

The `package.json` compile script points at a single source file and a
`managed/` output directory:

```json
"compile": "compact compile contracts/hello-world.compact contracts/managed/hello-world"
```

## Compilation artifacts

`compact compile <source> <out>` writes to `<out>` and produces four
directories, one per compiled circuit for the key material:

```text
managed/hello-world/
├── contract/        # JS + type declarations for the circuit
│   ├── index.js
│   └── index.d.ts
├── zkir/           # the compiled circuit (ZKIR)
│   └── storeMessage.zkir
├── keys/           # prover & verifier key material
│   └── storeMessage.prover
└── compiler/       # machine-readable build info
    └── contract-info.json
```

- **`contract/`** is what your TypeScript imports: each exported circuit
  becomes a typed entry point.
- **`zkir/`** is the compiled circuit — the thing the proof server proves.
- **`keys/`** holds the prover key (used to prove) and verifier key (used to
  check). Treat the prover key as sensitive.
- **`compiler/contract-info.json`** describes circuits and types for tools.

The `managed/` directory is a build product: it is regenerated on every
compile and is safe to delete and rebuild.

## What a compile looks like

For a one-circuit contract, `compact compile` reports the number of circuits
and prints nothing else on success:

```bash
Compiling 1 circuits:
```

Each `export circuit` you add becomes one of those compiled circuits — and
one set of artifacts under `zkir/` and `keys/`. That one-to-one mapping is
why the later chapters show contract size growing with every circuit you
write.

[hello-world]: https://github.com/midnightntwrk/example-hello-world
