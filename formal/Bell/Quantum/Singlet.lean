module

public import Bell.Quantum.Pauli
public import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.Analysis.Real.Sqrt

/-!
# The two-qubit singlet correlation

The product basis is indexed by `(first qubit, second qubit)`, so the singlet
state is `( |01⟩ - |10⟩ ) / sqrt(2)`. The correlation theorem below is a direct
finite matrix calculation and does not import the hidden-variable inequality.
-/

@[expose] public section

open scoped Kronecker Matrix

namespace Bell.Quantum

/-- The real coefficient `1 / sqrt(2)` in the normalized singlet ket. -/
noncomputable def singletAmplitude : ℝ :=
  (Real.sqrt 2)⁻¹

/-- The antisymmetric two-qubit ket `( |01⟩ - |10⟩ ) / sqrt(2)`. -/
noncomputable def singletState : TwoQubitKet := fun ij =>
  if ij = (0, 1) then (singletAmplitude : ℂ)
  else if ij = (1, 0) then -(singletAmplitude : ℂ)
  else 0

/-- The first directional spin acts on the first index and the second on the
second index. -/
def twoSpinObservable (a b : Direction) : TwoQubitOperator :=
  spinObservable a ⊗ₖ spinObservable b

end Bell.Quantum
