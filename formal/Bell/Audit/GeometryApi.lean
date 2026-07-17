module

import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.NormNum

/-!
# Euclidean geometry API probe

Compile-only checks for real three-space, coordinate basis vectors, inner
products, norms, and square-root arithmetic. This module is diagnostic and is
not imported by `Bell.lean`.
-/

set_option linter.privateModule false

namespace Bell.Audit.GeometryApi

abbrev DirectionProbe := EuclideanSpace ℝ (Fin 3)

#check EuclideanSpace.single
#check EuclideanSpace.norm_single
#check EuclideanSpace.inner_single_left
#check PiLp.inner_apply
#check Real.sqrt
#check Real.sq_sqrt

example : ‖EuclideanSpace.single (0 : Fin 3) (1 : ℝ)‖ = 1 := by
  simp

example (x y : DirectionProbe) :
    inner ℝ x y = ∑ i, x i * y i := by
  simp [PiLp.inner_apply, mul_comm]

example : (Real.sqrt 2) ^ 2 = 2 := by
  norm_num

end Bell.Audit.GeometryApi
