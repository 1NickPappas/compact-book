## Installation

Compact development requires the `compact` command-line tool, which bundles
the compiler, formatter, and related utilities. It is supported on Linux and
macOS (on Windows, use WSL).

Install the pre-built binary with this one-liner:

```bash
curl --proto '=https' --tlsv1.2 -LsSf \
  https://github.com/midnightntwrk/compact/releases/latest/download/compact-installer.sh | sh
```

The installer adds Compact to your shell `PATH`. If the shell still can't find
the command afterwards, reload your shell configuration, for example:

```bash
source ~/.zshrc   # or source ~/.bashrc
```

Select the compiler version you want to use with `compact update`. This book
is written against compiler `0.31.1`:

```bash
compact update 0.31.1
```

Verify the installation:

```bash
compact --version      # command-line tool version
compact compile --version   # compiler version
which compact          # installation path
```

You should see `0.31.1` reported for the compiler.

[For the full official installation guide, including the proof server and the
VS Code extension, see the Midnight documentation.][install-docs]

The next section puts the toolchain to work with your first contract.

[install-docs]:
  https://docs.midnight.network/getting-started/installation
