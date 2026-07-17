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

/-- Bell's original inequality from perfect anticorrelation at the one setting
where it is actually used.

All measurability and binary hypotheses are fixed-setting assumptions. -/
theorem bell_original_of_perfectAnticorrelationAt
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse c))
    (hanti : PerfectAnticorrelationAt model b) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c := by
  have haaInt : Integrable
      (fun ω => model.aliceResponse a ω * model.aliceResponse b ω)
      model.hiddenMeasure :=
    binaryProduct_integrable hAaMeas hAbMeas hAaBin hAbBin
  have habEq :
      (fun ω => -(model.aliceResponse a ω * model.aliceResponse b ω))
        =ᵐ[model.hiddenMeasure]
      fun ω => model.aliceResponse a ω * model.bobResponse b ω := by
    filter_upwards [hanti] with ω hantiω
    rw [hantiω]
    ring
  have habInt : Integrable
      (fun ω => model.aliceResponse a ω * model.bobResponse b ω)
      model.hiddenMeasure :=
    haaInt.neg.congr habEq
  have hacInt := responseProduct_integrable model a c
    hAaMeas hBcMeas hAaBin hBcBin
  have hbcInt := responseProduct_integrable model b c
    hAbMeas hBcMeas hAbBin hBcBin
  have hpoint : ∀ᵐ ω ∂model.hiddenMeasure,
      |model.aliceResponse a ω * model.bobResponse b ω -
          model.aliceResponse a ω * model.bobResponse c ω| ≤
        1 + model.aliceResponse b ω * model.bobResponse c ω := by
    filter_upwards [hanti, hAaBin, hAbBin, hBcBin] with ω hantiω ha hb hc
    have hBb : model.bobResponse b ω = -model.aliceResponse b ω := by
      linarith
    rw [hBb]
    rcases ha with ha | ha <;>
      rcases hb with hb | hb <;>
        rcases hc with hc | hc <;>
          norm_num [ha, hb, hc]
  calc
    |correlation model a b - correlation model a c| =
        |∫ ω, model.aliceResponse a ω * model.bobResponse b ω -
            model.aliceResponse a ω * model.bobResponse c ω
            ∂model.hiddenMeasure| := by
      rw [integral_sub habInt hacInt]
      rfl
    _ ≤ ∫ ω, |model.aliceResponse a ω * model.bobResponse b ω -
          model.aliceResponse a ω * model.bobResponse c ω|
          ∂model.hiddenMeasure :=
      abs_integral_le_integral_abs
    _ ≤ ∫ ω, 1 + model.aliceResponse b ω * model.bobResponse c ω
          ∂model.hiddenMeasure := by
      exact integral_mono_ae (habInt.sub hacInt).abs
        ((integrable_const (1 : ℝ)).add hbcInt) hpoint
    _ = 1 + correlation model b c := by
      rw [integral_add (integrable_const (1 : ℝ)) hbcInt]
      simp [correlation]

/-- Bell's original inequality with perfect anticorrelation derived from the
single diagonal correlation where the proof uses it. -/
theorem bell_original_of_diagonal_correlation_eq_neg_one
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hBbBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse c))
    (hcorrB : correlation model b b = -1) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c := by
  have hantiB := perfectAnticorrelationAt_of_correlation_eq_neg_one
    model b hAbMeas hBbMeas hAbBin hBbBin hcorrB
  exact bell_original_of_perfectAnticorrelationAt model a b c
    hAaMeas hAbMeas hBcMeas hAaBin hAbBin hBcBin hantiB

end Bell.Inequality
