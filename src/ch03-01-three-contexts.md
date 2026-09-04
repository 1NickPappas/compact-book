# The Three Contexts

Every value in a Compact program lives in one of **three contexts**, and the
context decides how much information the value leaks. This is the core
mental model of the language — and it is what makes Compact unlike almost
every other smart-contract language.

## Ledger: public, persistent, on-chain

A `ledger` field is the contract's on-chain state:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger round: Counter;
```

Values in the ledger are **public** — anyone with a node can read them — and
**persistent** — they survive between transactions. The circuit code in the
previous chapter mutated exactly this kind of state: `round += 1` rewrote a
ledger field.

## Circuit: provable logic

A `circuit` is a function compiled into a zero-knowledge circuit. Its code
is public (the compiler publishes it in `contract/`), but its
*computation* on specific data is not: running it produces a proof that the
logic executed correctly, without revealing the intermediate values unless
the circuit says so explicitly.

## Witness: private, off-chain

The third context holds data that never exists in a Compact file at all. A
`witness` is a declaration of a value the *client* holds locally — a key, a
PIN, a nonce — supplied by TypeScript at proving time. Witnesses are how a
circuit consumes genuinely private input.

## All three at once

A single contract can touch all three contexts. This ledger holds a
`Counter`, a witness supplies a private amount, and the circuit folds that
amount into the ledger:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger count: Counter;

witness private$input(): Uint<8>;

export circuit addInput(): [] {
  const n = private$input();
  count.increment(disclose(n));
}
```

Note where each piece lives: `count` is public ledger state, `private$input`
has no body here (the client provides one), and `addInput` is the provable
logic bridging the two. The `disclose(n)` call is doing real work — it
tells the compiler it is *okay* for this witness-derived value to reach the
ledger. Without it, this program would not compile; the next section shows
why that is the point.

## Why this matters


simple discipline: state that must be public lives in the ledger; logic
that must be verifiable lives in a circuit; data that must stay private
stays on the client as a witness — and the compiler rejects any program
that quietly moves a witness value into the other two.

The next two sections treat witnesses and disclosure in depth.
