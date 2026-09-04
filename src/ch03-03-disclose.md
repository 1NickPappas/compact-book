# The `disclose()` Requirement

The compiler enforces privacy. If a value that *might* be private is about
to be sent somewhere public, the program is **rejected** until you write
`disclose()` around it. This chapter shows the rule with one contract and
the exact error it produces without it.

## The leaking version

Strip the `disclose()` from the example below and you get this compile
error, naming the witness and the disclosure:

```compact,ignore
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger round: Counter;

witness private$getAmount(): Uint<64>;

export circuit store(): Bytes<32> {
  const amt = private$getAmount();
  return persistentHash<Uint<64>>(amt);
}
```

```text
potential witness-value disclosure must be declared but is not:
  witness value potentially disclosed:
    the return value of witness private$getAmount
  nature of the disclosure:
    the value returned from exported circuit store might disclose a hash of the witness
```

`persistentHash` is a plain hash. Returning its output from an exported
circuit would let anyone verify *that the prover knew* the secret,
without revealing the secret itself — a partial leak that Compact still
flags.

## The disclosing version

Wrapping the expression in `disclose()` is your **statement of intent**:
you, the author, accept that this value will be made public. The compiler
then accepts the program. The corrected circuit is:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

export ledger round: Counter;

witness private$getAmount(): Uint<64>;

export circuit store(): Bytes<32> {
  const amt = private$getAmount();
  return disclose(persistentHash<Uint<64>>(amt));
}
```
(The `round` field is unused in this circuit — it's shown so the contract
has a ledger declaration, matching the pattern you saw in the counter
chapter.)

## What `disclose()` does not do

`disclose()` does not encrypt, mask, or hide anything at runtime. It is a
purely compile-time annotation. At execution time, the same bytes go to the
same places either way. The difference is that `disclose()` forces you to
look at the line, name the value, and **commit to its public status** in
the source code.

That is the design goal: unexpected leaks are compile errors, and a leaked
value that survived the compiler is one the author deliberately chose to
publish.

## Where disclosure is required

The rule fires whenever a witness-tainted value can reach:

* **public ledger state** — writing to an `export ledger` field;
* **an exported circuit's return** — returning a value out;
* **a cross-contract call** — passing a value to another contract.

The one exception, and the subject of the next section, is data wrapped
in a **commitment** — a value that is mathematically designed to hide what
produced it.
