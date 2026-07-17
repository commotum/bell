module

public import Bell.HiddenVariable.PerfectAnticorrelation

/-!
# Bell's original inequality

This module proves equation (15) of Bell's 1964 paper for an arbitrary
probability measure on hidden variables. It contains no quantum or geometric
assumption.
-/

@[expose] public section

open MeasureTheory

namespace Bell.Inequality

open HiddenVariable

variable {Setting Ω : Type*} [MeasurableSpace Ω]

private theorem binaryProduct_integrable
    {μ : Measure Ω} [IsFiniteMeasure μ] {f g : Ω → ℝ}
    (hfmeas : AEMeasurable f μ) (hgmeas : AEMeasurable g μ)
    (hfbin : IsAEBinaryValued μ f) (hgbin : IsAEBinaryValued μ g) :
    Integrable (fun ω => f ω * g ω) μ := by
  apply Integrable.of_bound (hfmeas.mul hgmeas).aestronglyMeasurable 1
  filter_upwards [hfbin, hgbin] with ω hfω hgω
  rw [Real.norm_eq_abs, abs_mul, hfω.abs_eq_one, hgω.abs_eq_one, one_mul]

private theorem binaryBellPointwise
    {x y z : ℝ}
    (hx : IsBinaryOutcome x) (hy : IsBinaryOutcome y) (hz : IsBinaryOutcome z) :
    |x * y - x * z| ≤ 1 - y * z := by
  rcases hx with rfl | rfl <;>
    rcases hy with rfl | rfl <;>
      rcases hz with rfl | rfl <;> norm_num

/-- Bell's original inequality from perfect anticorrelation at the two settings
where it is actually used.

All measurability and binary hypotheses are fixed-setting assumptions. -/
theorem bell_original_of_perfectAnticorrelationAt
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAmeasA : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAmeasB : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hAmeasC : AEMeasurable (model.aliceResponse c) model.hiddenMeasure)
    (hAbinA : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbinB : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hAbinC : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse c))
    (hantiB : PerfectAnticorrelationAt model b)
    (hantiC : PerfectAnticorrelationAt model c) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c := by
  have hAB : Integrable
      (fun ω => model.aliceResponse a ω * model.aliceResponse b ω)
      model.hiddenMeasure :=
    binaryProduct_integrable hAmeasA hAmeasB hAbinA hAbinB
  have hAC : Integrable
      (fun ω => model.aliceResponse a ω * model.aliceResponse c ω)
      model.hiddenMeasure :=
    binaryProduct_integrable hAmeasA hAmeasC hAbinA hAbinC
  have hBC : Integrable
      (fun ω => model.aliceResponse b ω * model.aliceResponse c ω)
      model.hiddenMeasure :=
    binaryProduct_integrable hAmeasB hAmeasC hAbinB hAbinC
  have hpointwise : ∀ᵐ ω ∂model.hiddenMeasure,
      |model.aliceResponse a ω * model.aliceResponse b ω -
          model.aliceResponse a ω * model.aliceResponse c ω| ≤
        1 - model.aliceResponse b ω * model.aliceResponse c ω := by
    filter_upwards [hAbinA, hAbinB, hAbinC] with ω hAω hBω hCω
    exact binaryBellPointwise hAω hBω hCω
  have hRhs : Integrable
      (fun ω => 1 - model.aliceResponse b ω * model.aliceResponse c ω)
      model.hiddenMeasure :=
    (integrable_const (1 : ℝ)).sub hBC
  have hcore :
      |(∫ ω, model.aliceResponse a ω * model.aliceResponse b ω
            ∂model.hiddenMeasure) -
        ∫ ω, model.aliceResponse a ω * model.aliceResponse c ω
            ∂model.hiddenMeasure| ≤
      1 - ∫ ω, model.aliceResponse b ω * model.aliceResponse c ω
            ∂model.hiddenMeasure := by
    calc
      |(∫ ω, model.aliceResponse a ω * model.aliceResponse b ω
            ∂model.hiddenMeasure) -
        ∫ ω, model.aliceResponse a ω * model.aliceResponse c ω
            ∂model.hiddenMeasure| =
          |∫ ω, model.aliceResponse a ω * model.aliceResponse b ω -
              model.aliceResponse a ω * model.aliceResponse c ω
              ∂model.hiddenMeasure| := by
            rw [integral_sub hAB hAC]
      _ ≤ ∫ ω, 1 - model.aliceResponse b ω * model.aliceResponse c ω
              ∂model.hiddenMeasure := by
            simpa [Real.norm_eq_abs] using
              (norm_integral_le_of_norm_le (μ := model.hiddenMeasure) hRhs hpointwise)
      _ = 1 - ∫ ω, model.aliceResponse b ω * model.aliceResponse c ω
              ∂model.hiddenMeasure := by
            rw [integral_sub (integrable_const (1 : ℝ)) hBC]
            simp
  rw [correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
    model a b hantiB]
  rw [correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
    model a c hantiC]
  rw [correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
    model b c hantiC]
  simpa [sub_eq_add_neg, abs_neg, add_comm] using hcore

/-- Bell's original inequality with perfect anticorrelation derived from the
two required diagonal correlations rather than assumed. -/
theorem bell_original_of_diagonal_correlation_eq_neg_one
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAmeasA : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAmeasB : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hAmeasC : AEMeasurable (model.aliceResponse c) model.hiddenMeasure)
    (hBmeasB : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hBmeasC : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAbinA : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbinB : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hAbinC : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse c))
    (hBbinB : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b))
    (hBbinC : IsAEBinaryValued model.hiddenMeasure (model.bobResponse c))
    (hcorrB : correlation model b b = -1)
    (hcorrC : correlation model c c = -1) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c := by
  have hantiB := perfectAnticorrelationAt_of_correlation_eq_neg_one
    model b hAmeasB hBmeasB hAbinB hBbinB hcorrB
  have hantiC := perfectAnticorrelationAt_of_correlation_eq_neg_one
    model c hAmeasC hBmeasC hAbinC hBbinC hcorrC
  exact bell_original_of_perfectAnticorrelationAt model a b c
    hAmeasA hAmeasB hAmeasC hAbinA hAbinB hAbinC hantiB hantiC

end Bell.Inequality
