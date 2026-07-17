module

import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure

/-!
# Probability API probe

Compile-only checks for the low-dependency hidden-variable layer. This module
is diagnostic and is not imported by `Bell.lean`.
-/

open MeasureTheory

set_option linter.privateModule false

namespace Bell.Audit.ProbabilityApi

variable {Ω : Type*} [MeasurableSpace Ω]

#check Measure
#check ProbabilityMeasure
#check IsProbabilityMeasure
#check AEMeasurable
#check Integrable
#check Integrable.of_bound
#check integrable_const
#check integral_congr_ae
#check Filter.Eventually.and

example (μ : Measure Ω) [IsProbabilityMeasure μ] : μ Set.univ = 1 := by
  simp

example (μ : Measure Ω) (P Q : Ω → Prop)
    (hP : ∀ᵐ ω ∂μ, P ω) (hQ : ∀ᵐ ω ∂μ, Q ω) :
    ∀ᵐ ω ∂μ, P ω ∧ Q ω :=
  hP.and hQ

noncomputable example (μ : Measure Ω) (f : Ω → ℝ) : ℝ :=
  ∫ ω, f ω ∂μ

end Bell.Audit.ProbabilityApi
