module

public import Bell.Quantum.Pauli
public import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

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

theorem singletAmplitude_sq : singletAmplitude ^ 2 = (1 / 2 : ℝ) := by
  rw [singletAmplitude, inv_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

theorem singletAmplitude_sq_complex :
    (singletAmplitude : ℂ) ^ 2 = (1 / 2 : ℂ) := by
  rw [← Complex.ofReal_pow, singletAmplitude_sq]
  norm_num

theorem singletState_00 : singletState (0, 0) = 0 := by
  simp [singletState]

theorem singletState_01 :
    singletState (0, 1) = (singletAmplitude : ℂ) := by
  simp [singletState]

theorem singletState_10 :
    singletState (1, 0) = -(singletAmplitude : ℂ) := by
  simp [singletState]

theorem singletState_11 : singletState (1, 1) = 0 := by
  simp [singletState]

theorem singletState_normalized : IsNormalizedKet singletState := by
  rw [IsNormalizedKet, ketInner]
  simp only [dotProduct, Pi.star_apply, singletState, Fin.isValue,
    RCLike.star_def, mul_ite, mul_neg, mul_zero, Fintype.sum_prod_type,
    Prod.mk.injEq, Fin.sum_univ_two, zero_ne_one, and_false, ↓reduceIte,
    and_true, one_ne_zero, Complex.conj_ofReal, zero_add, map_neg, neg_mul,
    neg_neg, add_zero]
  rw [← pow_two, singletAmplitude_sq_complex]
  norm_num

theorem twoSpinObservable_isHermitian (a b : Direction) :
    (twoSpinObservable a b).IsHermitian := by
  rw [Matrix.IsHermitian, twoSpinObservable,
    Matrix.conjTranspose_kronecker,
    (spinObservable_isHermitian a).eq,
    (spinObservable_isHermitian b).eq]

/-- Coordinate form of the singlet calculation. No unit-vector hypothesis is
needed for this algebraic identity. -/
theorem singlet_spin_expectation_coordinates (a b : Direction) :
    pureExpectation singletState (twoSpinObservable a b) =
      ((-(a 0 * b 0 + a 1 * b 1 + a 2 * b 2) : ℝ) : ℂ) := by
  simp only [pureExpectation, ketInner, dotProduct, Matrix.mulVec,
    singletState, twoSpinObservable, spinObservable, pauliX, pauliY, pauliZ]
  rw [Fintype.sum_prod_type]
  simp [Fintype.sum_prod_type, singletState]
  ring_nf
  rw [singletAmplitude_sq_complex, Complex.I_sq]
  ring

/-- Bell's equation (3): the explicitly calculated singlet expectation is the
negative real Euclidean inner product, embedded in the complex scalars. -/
theorem singlet_spin_correlation (a b : Direction) :
    pureExpectation singletState (twoSpinObservable a b) =
      ((-(inner ℝ a b) : ℝ) : ℂ) := by
  rw [show inner ℝ a b =
      a 0 * b 0 + a 1 * b 1 + a 2 * b 2 by
    simp [PiLp.inner_apply, Fin.sum_univ_three, mul_comm]]
  exact singlet_spin_expectation_coordinates a b

end Bell.Quantum
