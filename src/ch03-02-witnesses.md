# Witnesses and Private State

A `witness` is how a Compact circuit consumes data the client holds in
private — a signing key, a PIN, or a freshly generated nonce. The
declaration lives in the contract, but the *value* never does.

## Declaring a witness

A witness is declared with the `witness` keyword and **no body** — it is a
signature, not an implementation:

```compact
witness private$getPin(): Uint<64>;
```

Two things to notice:

* **No body.** Compact cannot compute a client-side secret; only the
  TypeScript caller can. The declaration simply names the value the circuit
  is allowed to ask for and states its type.
* **The `private$` prefix.** By convention, witnesses that carry genuinely
  private data are named `private$...`. The name has no special meaning to
  the compiler — it is a signal to the reader.

## Using a witness value

Inside a circuit, a witness is called like a function and returns a value
of its declared type:

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

## The client supplies the value

At proving time, the caller (typically via midnight-js) provides an
implementation for each witness of the circuit. Compact treats the returned
value as **untrusted input to the proof**, exactly like a circuit parameter:
the circuit can use it in its logic, but nothing about it is revealed unless
the circuit explicitly discloses it.

Because the witness value is private to the prover, any value that flows
from it into public state, an exported return value, or a cross-contract
call must pass through `disclose()` — the subject of the next section. The
one exception is data wrapped in a **commitment** (a
`persistentCommit`/`transientCommit` result), which is designed to hide
its input and so needs no disclosure.
