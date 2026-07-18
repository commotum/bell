module

import Bell
import Mathlib.MeasureTheory.Measure.Dirac
import Mathlib.Tactic.NormNum

/-!
# Stage 7 robustness audit

This non-exported leaf checks the public root, a genuinely nonbinary bounded
model, sharp scalar algebra, explicit unit-setting domains, uniform-error
composition, headline signatures, and axioms.
-/

set_option linter.privateModule false

open MeasureTheory

namespace Bell.Audit.Robust

open Approximation Geometry HiddenVariable Inequality Quantum

section NonbinaryBoundedModel

/-- A normalized one-point factorized model with nonbinary responses `1/2` and
`-1/2`. It detects accidental reuse of the binary Stage 4 theorem. -/
noncomputable def halfResponseModel :
    DeterministicLocalModel (Fin 3) (Fin 3) Unit where
  hiddenMeasure := Measure.dirac ()
  aliceResponse := fun _ _ => 1 / 2
  bobResponse := fun _ _ => -1 / 2

noncomputable instance : IsProbabilityMeasure halfResponseModel.hiddenMeasure := by
  change IsProbabilityMeasure (Measure.dirac ())
  infer_instance

theorem halfResponseModel_aliceMeasurable :
    AliceAEMeasurable halfResponseModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem halfResponseModel_bobMeasurable :
    BobAEMeasurable halfResponseModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem halfResponseModel_aliceBounded :
    AliceBoundedByOne halfResponseModel := by
  intro setting ω
  norm_num [halfResponseModel]

theorem halfResponseModel_bobBounded :
    BobBoundedByOne halfResponseModel := by
  intro setting ω
  norm_num [halfResponseModel]

theorem halfResponseModel_not_aliceBinary :
    ¬AliceBinary halfResponseModel := by
  intro h
  have hvalue := h (0 : Fin 3) ()
  norm_num [halfResponseModel, IsBinaryOutcome] at hvalue

example (a b c : Fin 3) :
    |correlation halfResponseModel a b - correlation halfResponseModel a c| ≤
      2 + correlation halfResponseModel b c +
        correlation halfResponseModel b b :=
  bounded_response_bell_robust halfResponseModel a b c
    (halfResponseModel_aliceMeasurable a)
    (halfResponseModel_aliceMeasurable b)
    (halfResponseModel_bobMeasurable b)
    (halfResponseModel_bobMeasurable c)
    (halfResponseModel_aliceBounded.ae a)
    (halfResponseModel_aliceBounded.ae b)
    (halfResponseModel_bobBounded.ae b)
    (halfResponseModel_bobBounded.ae c)

end NonbinaryBoundedModel

-- The scalar robust inequality can be sharp with a nonbinary middle response.
example :
    |(1 : ℝ) * 1 - 1 * (-1)| =
      (1 + 0 * (-1)) + (1 + 0 * 1) := by
  norm_num

example :
    |(1 : ℝ) * 1 - 1 * (-1)| ≤
      (1 + 0 * (-1)) + (1 + 0 * 1) :=
  bounded_response_bell_pointwise (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

-- Binary responses enter the robust layer only through an explicit bridge.
example {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {f : Ω → ℝ}
    (h : IsAEBinaryValued μ f) : IsAEBoundedByOne μ f :=
  h.boundedByOne

-- Uniform error addition is exact for three constant functions.
example : UniformlyWithinOn (Set.univ : Set Unit) (Set.univ : Set Unit)
    (fun _ _ => (0 : ℝ)) (fun _ _ => 2) 2 := by
  have h01 : UniformlyWithinOn (Set.univ : Set Unit) (Set.univ : Set Unit)
      (fun _ _ => (0 : ℝ)) (fun _ _ => 1) 1 := by
    refine ⟨by norm_num, ?_⟩
    intro a _ b _
    norm_num
  have h12 : UniformlyWithinOn (Set.univ : Set Unit) (Set.univ : Set Unit)
      (fun _ _ => (1 : ℝ)) (fun _ _ => 2) 1 := by
    refine ⟨by norm_num, ?_⟩
    intro a _ b _
    norm_num
  simpa using h01.trans_add h12

-- The advertised physical domain includes Bell's vectors but excludes zero.
example : bellA ∈ unitDirectionSet := bellA_mem_unitDirectionSet
example : bellB ∈ unitDirectionSet := bellB_mem_unitDirectionSet
example : bellC ∈ unitDirectionSet := bellC_mem_unitDirectionSet
example : (0 : Direction) ∉ unitDirectionSet := by
  simp [unitDirectionSet]

#check IsAEBoundedByOne
#check boundedProduct_integrable
#check UniformlyWithinOn
#check UniformlyWithinOn.trans_add
#check bounded_response_bell_pointwise
#check bounded_response_bell_robust
#check target_bell_robust_of_four_errors
#check singlet_four_mul_error_lower_bound_at_bellDirections
#check singlet_error_lower_bound_at_bellDirections
#check singlet_uniform_error_lower_bound_on_unitDirections
#check bell1964_four_mul_total_error_lower_bound
#check bell1964_epsilon_lower_bound_of_uniform_averaging_errors
#check bell1964_epsilon_pos_of_uniform_averaging_errors

#print axioms Bell.HiddenVariable.boundedProduct_integrable
#print axioms Bell.HiddenVariable.IsAEBinaryValued.boundedByOne
#print axioms Bell.Approximation.UniformlyWithinOn.trans_add
#print axioms Bell.Inequality.bounded_response_bell_pointwise
#print axioms Bell.Inequality.bounded_response_bell_robust
#print axioms Bell.Inequality.target_bell_robust_of_four_errors
#print axioms Bell.Geometry.singlet_uniform_error_constant_pos
#print axioms Bell.Geometry.singlet_four_mul_error_lower_bound_at_bellDirections
#print axioms Bell.Geometry.singlet_uniform_error_lower_bound_on_unitDirections
#print axioms Bell.Geometry.bell1964_four_mul_total_error_lower_bound
#print axioms Bell.Geometry.bell1964_epsilon_lower_bound_of_uniform_averaging_errors
#print axioms Bell.Geometry.bell1964_epsilon_pos_of_uniform_averaging_errors

end Bell.Audit.Robust
