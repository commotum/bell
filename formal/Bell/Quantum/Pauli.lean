module

public import Bell.Quantum.Basic
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Pauli spin observables

The computational basis is ordered `|0⟩, |1⟩`. Coordinates `0`, `1`, and `2`
of a real three-vector multiply the Pauli x, y, and z matrices respectively.
-/

@[expose] public section

namespace Bell.Quantum

/-- Real three-space used for spin measurement directions. -/
abbrev Direction := EuclideanSpace ℝ (Fin 3)

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

end Bell.Quantum
