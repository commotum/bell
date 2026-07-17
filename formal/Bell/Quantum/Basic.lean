module

public import Mathlib.Analysis.Complex.Basic
public import Mathlib.LinearAlgebra.Matrix.DotProduct

/-!
# Finite quantum states and expectations

This module contains only reusable finite-dimensional coordinate vocabulary.
The inner product is conjugate-linear in its first argument, and a pure-state
expectation applies the operator before taking that inner product.
-/

@[expose] public section

open scoped Matrix

namespace Bell.Quantum

/-- Computational-basis index for one qubit. -/
abbrev QubitIndex := Fin 2

/-- A one-qubit ket in the computational basis. -/
abbrev QubitKet := QubitIndex → ℂ

/-- A one-qubit operator in the computational basis. -/
abbrev QubitOperator := Matrix QubitIndex QubitIndex ℂ

/-- The ordered computational-basis index `(first subsystem, second subsystem)`. -/
abbrev TwoQubitIndex := QubitIndex × QubitIndex

/-- A two-qubit ket ordered as `|00⟩, |01⟩, |10⟩, |11⟩`. -/
abbrev TwoQubitKet := TwoQubitIndex → ℂ

/-- A two-qubit operator with the same ordered product-basis convention. -/
abbrev TwoQubitOperator := Matrix TwoQubitIndex TwoQubitIndex ℂ

/-- Coordinate inner product `∑ i, conj (ψ i) * φ i`. -/
def ketInner {ι : Type*} [Fintype ι] (ψ φ : ι → ℂ) : ℂ :=
  dotProduct (star ψ) φ

/-- Pure-state matrix expectation `⟨ψ, M ψ⟩`. -/
def pureExpectation {ι : Type*} [Fintype ι]
    (ψ : ι → ℂ) (M : Matrix ι ι ℂ) : ℂ :=
  ketInner ψ (M *ᵥ ψ)

/-- A coordinate ket is normalized when its squared norm is exactly one. -/
def IsNormalizedKet {ι : Type*} [Fintype ι] (ψ : ι → ℂ) : Prop :=
  ketInner ψ ψ = 1

end Bell.Quantum
