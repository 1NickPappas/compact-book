# Understanding Privacy

Every Compact contract is a zero-knowledge program. Before you write more
of them, it helps to understand what the language forces you to think about,
and why.

The core idea: **privacy is the default, disclosure is the exception, and
the compiler enforces it.**

A Compact contract does not run in the open the way a normal program does.
When Midnight executes one, it produces a *zk-proof* — a cryptographic
certificate that the circuit ran correctly on some inputs — plus the
resulting updates to the public ledger. The proof is what gets checked on
chain. The inputs that produced it are the part that can stay hidden.

This chapter names the three pieces of that model. Later chapters use these
words constantly.

## The three contexts

A Compact program splits its data across three places, each with a different
rule about who can see it:

1. **The ledger.** The contract's on-chain state — its `ledger` fields.
   It is shared, persistent, and part of Midnight's public record. What
   lives here is *visible*, but only in the sense the type allows.
2. **The circuit.** The private logic — an `export circuit` and the
   computations inside it. The circuit runs to produce a proof. It is
   *verified* by everyone, but its internal values are not revealed.
3. **The witness.** Values supplied from the user's local machine — secret
   keys, private inputs — provided through `witness` callbacks. These are
   *private inputs*: they are used to build the proof but are never
   published.

The compiler's job, for the most part, is to keep these contexts from
leaking into each other by accident.

## Privacy is enforced at compile time

This is the part that makes Compact feel unlike most languages. You cannot
silently leak private data. If a value that *might* be private is about to
be stored publicly, returned from an exported circuit, or passed to another
contract, the compiler **rejects the program** until you explicitly
declare the disclosure.

Consider the smallest case. `getBalance` is a witness, so its result is
private input. Storing it in the public ledger `balance` is a leak — unless
you say it is allowed:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

witness getBalance(): Bytes<32>;

export ledger balance: Bytes<32>;

export circuit recordBalance(): [] {
  balance = disclose(getBalance());
}
```

Remove `disclose` and the same contract fails to build:

```compact,ignore
export circuit recordBalance(): [] {
  balance = getBalance();  // missing disclose() — will not compile
}
```

The compiler's error is explicit about *what* would leak and *where*. That
single wrapper — `disclose(...)` — is the difference between "verified"
and "revealed", and it is the most important word in the language.

The next three pages take each of these in turn: the contexts in detail
(three-contexts), how witnesses work and why their output can't be trusted
blindly (witnesses), the full rules around `disclose` (disclose), and how
hashes and commitments let you prove a relationship *without* revealing the
value behind it (commitments).

For the complete, formal treatment of all of this, see the
[official page on explicit disclosure][explicit-disclosure].

[explicit-disclosure]:
  https://docs.midnight.network/compact/reference/explicit-disclosure
