module

public import Bell.Quantum.Pauli
public import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.NormNum

/-!
# Concrete Bell directions

This module constructs Bell's three coplanar unit directions. It contains only
Euclidean geometry and square-root arithmetic; hidden-variable models, Bell's
inequality, and the singlet state are not dependencies.
-/

@[expose] public section

namespace Bell.Geometry

open Quantum

/-- The common coordinate `1 / sqrt(2)` of the diagonal direction. -/
noncomputable def bellScale : ℝ :=
  (Real.sqrt 2)⁻¹

/-- Bell's first direction, the x coordinate axis. -/
noncomputable def bellA : Direction :=
  EuclideanSpace.single (0 : Fin 3) 1

/-- Bell's third direction, the y coordinate axis. -/
noncomputable def bellC : Direction :=
  EuclideanSpace.single (1 : Fin 3) 1

/-- Bell's intermediate direction `(bellA + bellC) / sqrt(2)`. -/
noncomputable def bellB : Direction :=
  bellScale • (bellA + bellC)

theorem sqrtTwo_pos : 0 < Real.sqrt 2 := by
  exact Real.sqrt_pos.2 (by norm_num)

theorem sqrtTwo_ne_zero : Real.sqrt 2 ≠ 0 :=
  ne_of_gt sqrtTwo_pos

theorem bellScale_pos : 0 < bellScale := by
  exact inv_pos.mpr sqrtTwo_pos

theorem bellScale_ne_zero : bellScale ≠ 0 :=
  ne_of_gt bellScale_pos

theorem bellScale_eq_one_div_sqrt_two :
    bellScale = 1 / Real.sqrt 2 := by
  simp [bellScale]

theorem bellScale_sq : bellScale ^ 2 = (1 / 2 : ℝ) := by
  rw [bellScale, inv_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

/-- The numerical strict inequality responsible for the Bell violation. -/
theorem one_sub_bellScale_lt_bellScale :
    1 - bellScale < bellScale := by
  nlinarith [bellScale_pos, bellScale_sq,
    sq_nonneg (bellScale - (1 / 2 : ℝ))]

theorem bellA_inner_bellC : inner ℝ bellA bellC = 0 := by
  rw [direction_inner_eq_sum]
  simp [bellA, bellC]

theorem bellA_inner_bellB : inner ℝ bellA bellB = bellScale := by
  rw [direction_inner_eq_sum]
  simp [bellA, bellB, bellC]

theorem bellB_inner_bellC : inner ℝ bellB bellC = bellScale := by
  rw [direction_inner_eq_sum]
  simp [bellA, bellB, bellC]

theorem bellA_norm : ‖bellA‖ = 1 := by
  simp [bellA]

theorem bellC_norm : ‖bellC‖ = 1 := by
  simp [bellC]

theorem bellB_inner_self : inner ℝ bellB bellB = 1 := by
  rw [direction_inner_eq_sum]
  simp [Fin.sum_univ_three, bellA, bellB, bellC]
  nlinarith [bellScale_sq]

theorem bellB_norm : ‖bellB‖ = 1 := by
  have hsq : ‖bellB‖ ^ 2 = (1 : ℝ) := by
    rw [← real_inner_self_eq_norm_sq]
    exact bellB_inner_self
  nlinarith [norm_nonneg bellB]

end Bell.Geometry
