# Continuation Prompt

```text
Work through goal-1/0-plan.md using the repeatable protocol and stage template in
goal-1/0-loop.md.

The objective is to turn J. S. Bell's 1964 paper “On the Einstein Podolsky Rosen
Paradox” into a correct, reusable, pinned Lean 4/mathlib library. The verified
minimum core must keep separate and then connect: (1) the abstract probabilistic
Bell inequality for deterministic local hidden-variable models, (2) a genuine
finite-dimensional calculation of the singlet-state correlation, and (3) an
explicit proved choice of unit directions yielding a contradiction. Pursue the
paper's quantitative non-approximation result afterward if practical, with its
approximation mode and constants made precise.

Start by syncing the actual repository, paper, tests, and Git state; update the
plan's current facts; select the first incomplete stage; create its stage file;
implement only that stage; add requirement-specific and no-cheating checks; run
focused and full verification as required; record exact evidence; and fold the
results back into the plan before continuing.

Treat the paper as a source rather than a specification. Independently verify
all definitions and calculations, record material corrections and unresolved
points, and never use sorry, admit, unsafe proof escape, fabricated proofs, or
unexplained project axioms. Keep locality, determinism, measurement-setting
independence, normalization, binary outcomes, perfect anticorrelation, and
quantum reproduction explicit. Audit pointwise versus almost-everywhere versus
expectation versus uniform claims, null-set quantifiers, measurability,
integrability, sign-zero cases, absolute values, geometry, and axiom output.
Do not elevate philosophical claims about signaling or Lorentz invariance into
the verified core without separate definitions and premises.

Completion means the original library objective is actually achieved and
reproducibly verified—not merely that a finite special case or unused abstraction
builds. Carry every open issue forward as explicit next work; if a scoped item
such as angular smearing is genuinely deferred, state the precise obstruction
and do not report that item as proved.
```
