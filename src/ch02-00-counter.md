# Programming a Counter Contract

The hello-world contract stored a single value. This chapter builds a
contract with *state and behavior*: a counter that anyone can increment,
and a circuit that can read it back.

Create `counter.compact`:

```bash
mkdir counter && cd counter
touch counter.compact
```

Start with the smallest version:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger round: Counter;

export circuit increment(): [] {
  round += 1;
}
```

Four new ideas appear here:

* `import CompactStandardLibrary;` pulls in the language's standard library,
  which defines the built-in ledger types — `Counter` among them.
* `export ledger round: Counter;` stores a [Counter][ledger-adts] in
  on-chain state. A `Counter` is not a raw integer: it is a ledger ADT with
  its own operations — `increment(amount)`, `decrement(amount)`, `read()`,
  and others.
* `round += 1;` is *shorthand* for `round.increment(1)`. Any ledger
  operation that writes state has an assignment form: `=` for `write`,
  `+=` for `increment`, `-=` for `decrement`.
* The circuit returns `[]` — nothing. It only changes state.

Compile it:

```bash
compact compile counter.compact managed/counter
```

Now add a way to read the value back. `read()` retrieves the current value
of the counter, and a circuit can return it as a plain public value:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger round: Counter;

export circuit increment(): [] {
  round += 1;
}

export circuit readCount(): Uint<64> {
  return round.read();
}
```

Two entry points means two compiled circuits, so the compiler now reports:

```bash
Compiling 2 circuits:
```

The `Counter` also exposes `decrement(amount)`, `lessThan(threshold)`, and
`resetToDefault()`; see the [full ledger ADT reference][ledger-adts] for
every operation. Note that returning `round.read()` makes the stored value
*visible to anyone* holding the proof — the choice of what you can return,
and how, is the heart of privacy in Compact, which the next chapter
unpacks.

[ledger-adts]:
  https://docs.midnight.network/compact/data-types/ledger-adt
