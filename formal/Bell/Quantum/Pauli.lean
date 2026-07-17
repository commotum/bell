module

public import Bell.Quantum.Basic
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.FinCases

/-!
# Pauli spin observables

The computational basis is ordered `|0⟩, |1⟩`. Coordinates `0`, `1`, and `2`
of a real three-vector multiply the Pauli x, y, and z matrices respectively.
-/

@[expose] public section

namespace Bell.Quantum

/-- Real three-space used for spin measurement directions. -/
abbrev Direction := EuclideanSpace ℝ (Fin 3)

/-- The real Euclidean inner product is the finite coordinate dot product. -/
theorem direction_inner_eq_sum (a b : Direction) :
    inner ℝ a b = ∑ i, a i * b i := by
  simp [PiLp.inner_apply, mul_comm]

/-- Pauli x matrix in the computational basis. -/
def pauliX : QubitOperator :=
  !![0, 1; 1, 0]

/-- Pauli y matrix in the computational basis. -/
def pauliY : QubitOperator :=
  !![0, -Complex.I; Complex.I, 0]

/-- Pauli z matrix in the computational basis. -/
def pauliZ : QubitOperator :=
  !![1, 0; 0, -1]

/-- Directional Pauli observable `a₀ σx + a₁ σy + a₂ σz`. -/
def spinObservable (a : Direction) : QubitOperator :=
  (a 0 : ℂ) • pauliX + (a 1 : ℂ) • pauliY + (a 2 : ℂ) • pauliZ

theorem pauliX_isHermitian : pauliX.IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pauliX, Matrix.conjTranspose_apply]

theorem pauliY_isHermitian : pauliY.IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pauliY, Matrix.conjTranspose_apply]

theorem pauliZ_isHermitian : pauliZ.IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pauliZ, Matrix.conjTranspose_apply]

theorem spinObservable_isHermitian (a : Direction) :
    (spinObservable a).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinObservable, pauliX, pauliY, pauliZ,
      Matrix.conjTranspose_apply]

theorem spinObservable_axisX :
    spinObservable (EuclideanSpace.single (0 : Fin 3) (1 : ℝ)) = pauliX := by
  simp [spinObservable]

theorem spinObservable_axisY :
    spinObservable (EuclideanSpace.single (1 : Fin 3) (1 : ℝ)) = pauliY := by
  simp [spinObservable]

theorem spinObservable_axisZ :
    spinObservable (EuclideanSpace.single (2 : Fin 3) (1 : ℝ)) = pauliZ := by
  simp [spinObservable]

/-- The square of a directional Pauli observable is its squared coordinate
length times the identity. -/
theorem spinObservable_mul_self (a : Direction) :
    spinObservable a * spinObservable a =
      ((a 0 * a 0 + a 1 * a 1 + a 2 * a 2 : ℝ) : ℂ) •
        (1 : QubitOperator) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinObservable, pauliX, pauliY, pauliZ, Matrix.mul_apply,
      Fin.sum_univ_two] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring

/-- Norm form of the directional Pauli square law. -/
theorem spinObservable_sq_eq_norm_sq_smul_one (a : Direction) :
    spinObservable a ^ 2 =
      ((‖a‖ ^ 2 : ℝ) : ℂ) • (1 : QubitOperator) := by
  rw [pow_two, spinObservable_mul_self]
  have hcoord : a 0 * a 0 + a 1 * a 1 + a 2 * a 2 = ‖a‖ ^ 2 := by
    calc
      a 0 * a 0 + a 1 * a 1 + a 2 * a 2 = ∑ i, a i * a i := by
        simp [Fin.sum_univ_three]
      _ = inner ℝ a a := (direction_inner_eq_sum a a).symm
      _ = ‖a‖ ^ 2 := real_inner_self_eq_norm_sq a
  rw [hcoord]

/-- A unit-length directional observable is an involution, the algebraic
certificate used for the binary `±1` spin interpretation. -/
theorem spinObservable_sq_eq_one_of_inner_self_eq_one (a : Direction)
    (ha : inner ℝ a a = 1) :
    spinObservable a ^ 2 = 1 := by
  rw [pow_two, spinObservable_mul_self]
  have hinter : inner ℝ a a = ∑ i, a i * a i := direction_inner_eq_sum a a
  rw [hinter] at ha
  have hcoord : a 0 * a 0 + a 1 * a 1 + a 2 * a 2 = 1 := by
    simpa [Fin.sum_univ_three] using ha
  rw [hcoord]
  norm_num

theorem spinObservable_sq_eq_one_of_norm_eq_one (a : Direction)
    (ha : ‖a‖ = 1) :
    spinObservable a ^ 2 = 1 := by
  rw [spinObservable_sq_eq_norm_sq_smul_one, ha]
  norm_num

end Bell.Quantum
