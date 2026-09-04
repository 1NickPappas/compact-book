# Commitments, Hashing, and Nullifiers

Compact's standard library offers four functions for hiding witness data:
two **hashes** and two **commitments**. The distinction between them is the
key to designing private contracts.

## Hashes: compress, but don't hide

```text
circuit transientHash<T>(t: T): Field;
circuit persistentHash<T>(t: T): Bytes<32>;
```

* `persistentHash` is the **SHA-256** of its argument — stable across
  contract upgrades, so it is the right choice for state that outlives a
  single deployment.
* `transientHash` is a faster, circuit-optimized variant, but its output
  may change between upgrades. Do not use it to derive persistent state.

Both are **one-way** but **not private**: anyone who guesses (or is given)
the input can check the hash. Because a hash of a witness is still
witness-derived, a hash result that reaches public state or a return value
requires `disclose()` — as the previous section showed.

## Commitments: hide with a random opener

```text
circuit transientCommit<T>(t: T, rand: Field): Field;
circuit persistentCommit<T>(t: T, rand: Bytes<32>): Bytes<32>;
```

A commitment mixes the value with a secret *opener* (`rand`), usually
randomly chosen by the client. Unlike a hash, a commitment output **need
not be disclosed** — the random opener is what makes the output
indistinguishable from noise, even to an attacker who can guess the
witness.

This is the whole point, in one compilable contract:

```compact
pragma language_version 0.23;

import CompactStandardLibrary;

witness private$getSecret(): Uint<64>;

export circuit commit(): Bytes<32> {
  const secret = private$getSecret();
  return persistentCommit<Uint<64>>(secret, persistentHash<Uint<64>>(secret));
}
```

`commit` returns a value *directly derived from a witness* — yet no
`disclose()` appears anywhere. Replace `persistentCommit` with
`persistentHash` in that same contract and the compiler rejects it. The
`rand` argument does the hiding; the compiler checks that you used it.

(Note this example is simplified: in a real contract the opener should be a
fresh random value, and the commitment stored somewhere you can match it
against later.)

## What you can do with a commitment

A commitment is a promise to reveal a value later. Because the same value
committed with the same opener produces the same output, commitments
enable three standard patterns:

* **Verify without revealing** — prove internally (inside a circuit) that
  a committed value satisfies a property, while only the commitment is
  public.
* **Consistency** — prove that two references point at the same secret.
* **Merkle trees** — the election example in the reference repository
  commits votes into `MerkleTree` fields so eligibility can be checked
  from a public path without exposing who voted.

The complementary tool for preventing double-use is the **nullifier**: a
commitment-derived value that you can store in a `Set` to prove a secret
has been consumed, without proving *which* secret it was.

## Choosing between them

| Function | Persistent across upgrades | Hides input | Needs `disclose()` to publish |
|----------|:--:|:--:|:--:|
| `transientHash` | no | no | yes |
| `persistentHash` | yes | no | yes |
| `transientCommit` | no | yes (via `rand`) | no |
| `persistentCommit` | yes | yes (via `rand`) | no |

Two helper functions bridge the families: `degradeToTransient(x: Bytes<32>): Field`
converts a persistent result into a field element for use in transient
operations, and `upgradeFromTransient` does the reverse.
