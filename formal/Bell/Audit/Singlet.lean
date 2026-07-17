module

import Bell
import Mathlib.Tactic.FinCases

/-!
# Singlet calculation audit

This private module checks the public quantum surface, the computational-basis
and Kronecker conventions, genuinely complex conjugation, independent Pauli
axis calculations, and headline theorem axioms.
-/

set_option linter.privateModule false

open scoped Kronecker Matrix

namespace Bell.Audit.Singlet

open Quantum

section PublicSurface

example (a b : Direction) : singletCorrelation a b = -inner ℝ a b :=
  singlet_spin_correlation a b

example (a b : Direction) :
    pureExpectation singletState (twoSpinObservable a b) =
      ((-(a 0 * b 0 + a 1 * b 1 + a 2 * b 2) : ℝ) : ℂ) :=
  singlet_spin_expectation_coordinates a b

end PublicSurface

section BasisConventions

example : singletState (0, 0) = 0 := singletState_00
example : singletState (0, 1) = (singletAmplitude : ℂ) := singletState_01
example : singletState (1, 0) = -(singletAmplitude : ℂ) := singletState_10
example : singletState (1, 1) = 0 := singletState_11

/-- Standard basis ket at a two-qubit product index. -/
def basisKet (p : TwoQubitIndex) : TwoQubitKet := fun q =>
  if q = p then 1 else 0

/-- The first Kronecker factor acts on the first product index: `σx ⊗ σz`
sends `|00⟩` to `|10⟩`, not `|01⟩`. -/
theorem kronecker_first_factor_order :
    (pauliX ⊗ₖ pauliZ) *ᵥ basisKet (0, 0) = basisKet (1, 0) := by
  funext ij
  rcases ij with ⟨i, j⟩
  fin_cases i <;> fin_cases j <;>
    simp [basisKet, Matrix.mulVec, dotProduct, pauliX, pauliZ]

/-- A genuinely complex test detects omission of conjugation in the first
argument of `ketInner`. -/
def imaginaryKet : QubitKet := fun i => if i = 0 then Complex.I else 0

def zeroBasisKet : QubitKet := fun i => if i = 0 then 1 else 0

theorem ketInner_conjugates_first :
    ketInner imaginaryKet zeroBasisKet = -Complex.I := by
  simp [ketInner, dotProduct, imaginaryKet, zeroBasisKet]

/-- This fixes the handed Pauli-y convention; equal-axis singlet correlations
alone would not distinguish `σy` from `-σy`. -/
theorem pauli_handedness :
    pauliX * pauliY = Complex.I • pauliZ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, pauliX, pauliY, pauliZ]

end BasisConventions

section DirectAxisCalculations

theorem singlet_xx_direct :
    pureExpectation singletState (pauliX ⊗ₖ pauliX) = -1 := by
  simp only [pureExpectation, ketInner, dotProduct, Pi.star_apply,
    singletState, Fin.isValue, RCLike.star_def, Matrix.mulVec, pauliX,
    Matrix.kroneckerMap_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_fin_one, mul_ite, mul_neg, mul_zero,
    Fintype.sum_prod_type, Prod.mk.injEq, Fin.sum_univ_two, zero_ne_one,
    and_false, ↓reduceIte, and_true, Matrix.cons_val_zero,
    Matrix.cons_val_one, one_ne_zero, zero_add, add_zero, mul_one, zero_mul,
    neg_zero, map_zero, Complex.conj_ofReal, one_mul, map_neg, neg_mul]
  rw [← pow_two, singletAmplitude_sq_complex]
  norm_num

theorem singlet_yy_direct :
    pureExpectation singletState (pauliY ⊗ₖ pauliY) = -1 := by
  simp only [pureExpectation, ketInner, dotProduct, Pi.star_apply,
    singletState, Fin.isValue, RCLike.star_def, Matrix.mulVec, pauliY,
    Matrix.kroneckerMap_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_fin_one, mul_ite, mul_neg, mul_zero,
    Fintype.sum_prod_type, Prod.mk.injEq, Fin.sum_univ_two, zero_ne_one,
    and_false, ↓reduceIte, and_true, Matrix.cons_val_zero,
    Matrix.cons_val_one, one_ne_zero, zero_add, add_zero, neg_mul, zero_mul,
    neg_zero, map_zero, Complex.conj_ofReal, Complex.I_mul_I, neg_neg,
    one_mul, map_neg]
  rw [← pow_two, singletAmplitude_sq_complex]
  norm_num

theorem singlet_zz_direct :
    pureExpectation singletState (pauliZ ⊗ₖ pauliZ) = -1 := by
  simp only [pureExpectation, ketInner, dotProduct, Pi.star_apply,
    singletState, Fin.isValue, RCLike.star_def, Matrix.mulVec, pauliZ,
    Matrix.kroneckerMap_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_fin_one, mul_ite, mul_neg, mul_zero,
    Fintype.sum_prod_type, Prod.mk.injEq, Fin.sum_univ_two, zero_ne_one,
    and_false, ↓reduceIte, and_true, Matrix.cons_val_zero,
    Matrix.cons_val_one, one_ne_zero, zero_add, add_zero, zero_mul, mul_one,
    neg_mul, neg_zero, map_zero, Complex.conj_ofReal, one_mul, map_neg,
    neg_neg]
  rw [← pow_two, singletAmplitude_sq_complex]
  norm_num

theorem singlet_xz_direct :
    pureExpectation singletState (pauliX ⊗ₖ pauliZ) = 0 := by
  simp [pureExpectation, ketInner, singletState, Matrix.mulVec, dotProduct,
    Fintype.sum_prod_type, Fin.sum_univ_two, pauliX, pauliZ]

end DirectAxisCalculations

#print axioms Bell.Quantum.pauliY_isHermitian
#print axioms Bell.Quantum.spinObservable_isHermitian
#print axioms Bell.Quantum.spinObservable_sq_eq_norm_sq_smul_one
#print axioms Bell.Quantum.spinObservable_sq_eq_one_of_norm_eq_one
#print axioms Bell.Quantum.singletState_normalized
#print axioms Bell.Quantum.twoSpinObservable_isHermitian
#print axioms Bell.Quantum.singlet_spin_expectation_coordinates
#print axioms Bell.Quantum.singlet_spin_expectation
#print axioms Bell.Quantum.singlet_spin_correlation

end Bell.Audit.Singlet
