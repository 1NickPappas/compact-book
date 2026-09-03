## Your First Contract

You have a working toolchain. Now create the simplest possible contract, and
compile it.

In a new directory, create a file named `hello-world.compact`:

```bash
mkdir contracts && cd contracts
touch hello-world.compact
```

Give it this content:

```compact
pragma language_version 0.23;

export ledger message: Opaque<"string">;

export circuit storeMessage(newMessage: Opaque<"string">): [] {
    message = disclose(newMessage);
}
```

Read it in three pieces:

* `pragma language_version 0.23;` declares which language version this
  contract is written against.
* `export ledger message: Opaque<"string">;` creates a state variable named
  `message` that lives in the contract's public on-chain state.

`storeMessage` is a circuit: the private logic that updates that state.
Its parameter, `newMessage`, is *private by default* — that is the point of
Compact. The one call `disclose(newMessage)` marks the value as public, so
the circuit is allowed to store it in `message`. Remove the `disclose` and
the compiler rejects the assignment. That single line is the whole idea:
what you don't `disclose` stays hidden, but Midnight still verifies the
circuit ran correctly.

Compile it:

```bash
compact compile hello-world.compact managed/hello-world
```

Expected output:

```bash
Compiling 1 circuits:

  circuit "storeMessage" (k=6, rows=26)
```

The compiler produces a set of artifacts under `managed/hello-world`:
TypeScript definitions, the compiled circuit, and the cryptographic keys that
Midnight needs to verify proofs of its execution. You do not need to read these
files by hand — the Midnight tooling consumes them.

To go further — deploying the contract to a local devnet and calling it from
a TypeScript app — see the
[official Hello World tutorial][hello-world-docs].

[hello-world-docs]:
  https://docs.midnight.network/getting-started/hello-world
