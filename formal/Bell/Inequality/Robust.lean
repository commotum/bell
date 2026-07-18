module

public import Bell.HiddenVariable.Bounded
public import Bell.HiddenVariable.Correlation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Bell's robust bounded-response inequality

This module formalizes the post-factorization algebraic and measure-theoretic
core of Bell's equations (19)–(22). It does not construct the angular averages
or prove the Fubini factorization in equation (19). Responses need only be
bounded by one almost everywhere; there is no binary, perfect-anticorrelation,
quantum, or geometric premise.
-/

@[expose] public section

open MeasureTheory

namespace Bell.Inequality

open HiddenVariable

/-- The pointwise cancellation behind Bell's robust inequality. -/
theorem bounded_response_bell_pointwise {Aa Ab Bb Bc : ℝ}
    (hAa : |Aa| ≤ 1) (hAb : |Ab| ≤ 1)
    (hBb : |Bb| ≤ 1) (hBc : |Bc| ≤ 1) :
    |Aa * Bb - Aa * Bc| ≤ (1 + Ab * Bc) + (1 + Ab * Bb) := by
  have hAaBb : |Aa * Bb| ≤ 1 := by
    rw [abs_mul]
    exact mul_le_one₀ hAa (abs_nonneg _) hBb
  have hAaBc : |Aa * Bc| ≤ 1 := by
    rw [abs_mul]
    exact mul_le_one₀ hAa (abs_nonneg _) hBc
  have hAbBc : |Ab * Bc| ≤ 1 := by
    rw [abs_mul]
    exact mul_le_one₀ hAb (abs_nonneg _) hBc
  have hAbBb : |Ab * Bb| ≤ 1 := by
    rw [abs_mul]
    exact mul_le_one₀ hAb (abs_nonneg _) hBb
  have hAbBcNonneg : 0 ≤ 1 + Ab * Bc := by
    linarith [neg_le_of_abs_le hAbBc]
  have hAbBbNonneg : 0 ≤ 1 + Ab * Bb := by
    linarith [neg_le_of_abs_le hAbBb]
  calc
    |Aa * Bb - Aa * Bc| =
        |Aa * Bb * (1 + Ab * Bc) - Aa * Bc * (1 + Ab * Bb)| := by
      congr 1
      ring
    _ ≤ |Aa * Bb * (1 + Ab * Bc)| + |Aa * Bc * (1 + Ab * Bb)| :=
      abs_sub _ _
    _ = |Aa * Bb| * |1 + Ab * Bc| + |Aa * Bc| * |1 + Ab * Bb| := by
      rw [abs_mul (Aa * Bb), abs_mul (Aa * Bc)]
    _ = |Aa * Bb| * (1 + Ab * Bc) + |Aa * Bc| * (1 + Ab * Bb) := by
      rw [abs_of_nonneg hAbBcNonneg, abs_of_nonneg hAbBbNonneg]
    _ ≤ 1 * (1 + Ab * Bc) + 1 * (1 + Ab * Bb) :=
      add_le_add
        (mul_le_mul_of_nonneg_right hAaBb hAbBcNonneg)
        (mul_le_mul_of_nonneg_right hAaBc hAbBbNonneg)
    _ = (1 + Ab * Bc) + (1 + Ab * Bb) := by ring

variable {Setting Ω : Type*} [MeasurableSpace Ω]

/-- Bell's robust inequality for a normalized factorized model whose four
required responses are measurable and bounded by one almost everywhere. -/
theorem bounded_response_bell_robust
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hAbBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse b))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (hBcBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse c)) :
    |correlation model a b - correlation model a c| ≤
      2 + correlation model b c + correlation model b b := by
  have habInt := boundedProduct_integrable hAaMeas hBbMeas hAaBound hBbBound
  have hacInt := boundedProduct_integrable hAaMeas hBcMeas hAaBound hBcBound
  have hbcInt := boundedProduct_integrable hAbMeas hBcMeas hAbBound hBcBound
  have hbbInt := boundedProduct_integrable hAbMeas hBbMeas hAbBound hBbBound
  have hpoint : ∀ᵐ ω ∂model.hiddenMeasure,
      |model.aliceResponse a ω * model.bobResponse b ω -
          model.aliceResponse a ω * model.bobResponse c ω| ≤
        (1 + model.aliceResponse b ω * model.bobResponse c ω) +
          (1 + model.aliceResponse b ω * model.bobResponse b ω) := by
    filter_upwards [hAaBound, hAbBound, hBbBound, hBcBound] with ω ha hab hbb hbc
    exact bounded_response_bell_pointwise ha hab hbb hbc
  calc
    |correlation model a b - correlation model a c| =
        |∫ ω, (model.aliceResponse a ω * model.bobResponse b ω -
          model.aliceResponse a ω * model.bobResponse c ω)
          ∂model.hiddenMeasure| := by
      rw [integral_sub habInt hacInt]
      rfl
    _ ≤ ∫ ω, |model.aliceResponse a ω * model.bobResponse b ω -
          model.aliceResponse a ω * model.bobResponse c ω|
          ∂model.hiddenMeasure :=
      abs_integral_le_integral_abs
    _ ≤ ∫ ω, ((1 + model.aliceResponse b ω * model.bobResponse c ω) +
          (1 + model.aliceResponse b ω * model.bobResponse b ω))
          ∂model.hiddenMeasure := by
      exact integral_mono_ae (habInt.sub hacInt).abs
        (((integrable_const (1 : ℝ)).add hbcInt).add
          ((integrable_const (1 : ℝ)).add hbbInt)) hpoint
    _ = ∫ ω, ((2 : ℝ) +
          model.aliceResponse b ω * model.bobResponse c ω) +
          model.aliceResponse b ω * model.bobResponse b ω
          ∂model.hiddenMeasure := by
      apply integral_congr_ae
      filter_upwards [] with ω
      ring
    _ = 2 + correlation model b c + correlation model b b := by
      have houter := integral_add
        ((integrable_const (2 : ℝ)).add hbcInt) hbbInt
      have hinner := integral_add (integrable_const (2 : ℝ)) hbcInt
      simp only [Pi.add_apply] at houter hinner
      rw [houter, hinner]
      simp [correlation]

/-- Four correlation-error bounds transfer the robust local inequality to an
arbitrary target with coefficient `4 * ε`, one contribution per error term. -/
theorem target_bell_robust_of_four_errors
    (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (target : Setting → Setting → ℝ) (ε : ℝ) (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hAbBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse b))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (hBcBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse c))
    (hAB : |correlation model a b - target a b| ≤ ε)
    (hAC : |correlation model a c - target a c| ≤ ε)
    (hBC : |correlation model b c - target b c| ≤ ε)
    (hBB : |correlation model b b - target b b| ≤ ε) :
    |target a b - target a c| ≤
      2 + target b c + target b b + 4 * ε := by
  have hmodel := bounded_response_bell_robust model a b c
    hAaMeas hAbMeas hBbMeas hBcMeas hAaBound hAbBound hBbBound hBcBound
  have htargetDiff : |target a b - target a c| ≤
      |correlation model a b - correlation model a c| + 2 * ε := by
    calc
      |target a b - target a c| =
          |(target a b - correlation model a b) +
            (correlation model a b - correlation model a c) +
            (correlation model a c - target a c)| := by
        congr 1
        ring
      _ ≤ |target a b - correlation model a b| +
          |correlation model a b - correlation model a c| +
          |correlation model a c - target a c| :=
        abs_add_three _ _ _
      _ ≤ ε + |correlation model a b - correlation model a c| + ε := by
        exact add_le_add
          (add_le_add (by simpa [abs_sub_comm] using hAB) le_rfl) hAC
      _ = |correlation model a b - correlation model a c| + 2 * ε := by
        ring
  have hbc : correlation model b c ≤ target b c + ε := by
    linarith [(abs_le.mp hBC).2]
  have hbb : correlation model b b ≤ target b b + ε := by
    linarith [(abs_le.mp hBB).2]
  linarith

end Bell.Inequality
