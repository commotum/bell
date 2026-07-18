module

public import Bell.HiddenVariable.Bounded
public import Bell.HiddenVariable.Correlation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# The bounded-response CHSH inequality

This modern generalization is not a numbered result of Bell's 1964 paper. It
applies to four local effective responses bounded by one almost everywhere and
requires neither binary outcomes nor perfect anticorrelation. Quantum mechanics
and Euclidean geometry are not dependencies of this abstract leaf.
-/

@[expose] public section

open MeasureTheory

namespace Bell.Inequality

open HiddenVariable

/-- The standard signed sum of four bipartite correlations. -/
def chshCombination {SettingA SettingB : Type*}
    (target : SettingA → SettingB → ℝ)
    (a₀ a₁ : SettingA) (b₀ b₁ : SettingB) : ℝ :=
  target a₀ b₀ + target a₀ b₁ + target a₁ b₀ - target a₁ b₁

/-- The pointwise CHSH inequality for four real responses bounded by one. -/
theorem bounded_response_chsh_pointwise {A₀ A₁ B₀ B₁ : ℝ}
    (hA₀ : |A₀| ≤ 1) (hA₁ : |A₁| ≤ 1)
    (hB₀ : |B₀| ≤ 1) (hB₁ : |B₁| ≤ 1) :
    |A₀ * B₀ + A₀ * B₁ + A₁ * B₀ - A₁ * B₁| ≤ 2 := by
  have hB₀Icc := abs_le.mp hB₀
  have hB₁Icc := abs_le.mp hB₁
  have hsum : |B₀ + B₁| + |B₀ - B₁| ≤ 2 := by
    rcases le_total 0 (B₀ + B₁) with hplus | hplus
    · rw [abs_of_nonneg hplus]
      rcases le_total 0 (B₀ - B₁) with hminus | hminus
      · rw [abs_of_nonneg hminus]
        linarith
      · rw [abs_of_nonpos hminus]
        linarith
    · rw [abs_of_nonpos hplus]
      rcases le_total 0 (B₀ - B₁) with hminus | hminus
      · rw [abs_of_nonneg hminus]
        linarith
      · rw [abs_of_nonpos hminus]
        linarith
  calc
    |A₀ * B₀ + A₀ * B₁ + A₁ * B₀ - A₁ * B₁| =
        |A₀ * (B₀ + B₁) + A₁ * (B₀ - B₁)| := by
      congr 1
      ring
    _ ≤ |A₀ * (B₀ + B₁)| + |A₁ * (B₀ - B₁)| := abs_add_le _ _
    _ = |A₀| * |B₀ + B₁| + |A₁| * |B₀ - B₁| := by
      rw [abs_mul, abs_mul]
    _ ≤ 1 * |B₀ + B₁| + 1 * |B₀ - B₁| := by
      exact add_le_add
        (mul_le_mul_of_nonneg_right hA₀ (abs_nonneg _))
        (mul_le_mul_of_nonneg_right hA₁ (abs_nonneg _))
    _ = |B₀ + B₁| + |B₀ - B₁| := by ring
    _ ≤ 2 := hsum

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- CHSH for a normalized factorized model whose four fixed responses are a.e.
measurable and a.e. bounded by one. -/
theorem bounded_response_chsh
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a₀ a₁ : SettingA) (b₀ b₁ : SettingB)
    (hA₀Meas : AEMeasurable (model.aliceResponse a₀) model.hiddenMeasure)
    (hA₁Meas : AEMeasurable (model.aliceResponse a₁) model.hiddenMeasure)
    (hB₀Meas : AEMeasurable (model.bobResponse b₀) model.hiddenMeasure)
    (hB₁Meas : AEMeasurable (model.bobResponse b₁) model.hiddenMeasure)
    (hA₀Bound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a₀))
    (hA₁Bound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a₁))
    (hB₀Bound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b₀))
    (hB₁Bound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b₁)) :
    |chshCombination (correlation model) a₀ a₁ b₀ b₁| ≤ 2 := by
  let f₀₀ := fun ω => model.aliceResponse a₀ ω * model.bobResponse b₀ ω
  let f₀₁ := fun ω => model.aliceResponse a₀ ω * model.bobResponse b₁ ω
  let f₁₀ := fun ω => model.aliceResponse a₁ ω * model.bobResponse b₀ ω
  let f₁₁ := fun ω => model.aliceResponse a₁ ω * model.bobResponse b₁ ω
  have h₀₀Int : Integrable f₀₀ model.hiddenMeasure :=
    boundedProduct_integrable hA₀Meas hB₀Meas hA₀Bound hB₀Bound
  have h₀₁Int : Integrable f₀₁ model.hiddenMeasure :=
    boundedProduct_integrable hA₀Meas hB₁Meas hA₀Bound hB₁Bound
  have h₁₀Int : Integrable f₁₀ model.hiddenMeasure :=
    boundedProduct_integrable hA₁Meas hB₀Meas hA₁Bound hB₀Bound
  have h₁₁Int : Integrable f₁₁ model.hiddenMeasure :=
    boundedProduct_integrable hA₁Meas hB₁Meas hA₁Bound hB₁Bound
  have hpoint : ∀ᵐ ω ∂model.hiddenMeasure,
      |f₀₀ ω + f₀₁ ω + f₁₀ ω - f₁₁ ω| ≤ 2 := by
    filter_upwards [hA₀Bound, hA₁Bound, hB₀Bound, hB₁Bound]
      with ω ha₀ ha₁ hb₀ hb₁
    exact bounded_response_chsh_pointwise ha₀ ha₁ hb₀ hb₁
  change |(∫ ω, f₀₀ ω ∂model.hiddenMeasure) +
      (∫ ω, f₀₁ ω ∂model.hiddenMeasure) +
      (∫ ω, f₁₀ ω ∂model.hiddenMeasure) -
      (∫ ω, f₁₁ ω ∂model.hiddenMeasure)| ≤ 2
  have hAdd₀₁ :
      (∫ ω, (f₀₀ + f₀₁) ω ∂model.hiddenMeasure) =
        (∫ ω, f₀₀ ω ∂model.hiddenMeasure) +
          ∫ ω, f₀₁ ω ∂model.hiddenMeasure := by
    simpa only [Pi.add_apply] using integral_add h₀₀Int h₀₁Int
  have hAdd₁₀ :
      (∫ ω, (f₀₀ + f₀₁ + f₁₀) ω ∂model.hiddenMeasure) =
        (∫ ω, (f₀₀ + f₀₁) ω ∂model.hiddenMeasure) +
          ∫ ω, f₁₀ ω ∂model.hiddenMeasure := by
    simpa only [Pi.add_apply] using integral_add (h₀₀Int.add h₀₁Int) h₁₀Int
  have hIntegral :
      (∫ ω, f₀₀ ω ∂model.hiddenMeasure) +
          (∫ ω, f₀₁ ω ∂model.hiddenMeasure) +
          (∫ ω, f₁₀ ω ∂model.hiddenMeasure) -
          (∫ ω, f₁₁ ω ∂model.hiddenMeasure) =
        ∫ ω, (f₀₀ + f₀₁ + f₁₀ - f₁₁) ω ∂model.hiddenMeasure := by
    symm
    calc
      (∫ ω, (f₀₀ + f₀₁ + f₁₀ - f₁₁) ω ∂model.hiddenMeasure) =
          (∫ ω, (f₀₀ + f₀₁ + f₁₀) ω ∂model.hiddenMeasure) -
            ∫ ω, f₁₁ ω ∂model.hiddenMeasure :=
        integral_sub ((h₀₀Int.add h₀₁Int).add h₁₀Int) h₁₁Int
      _ = ((∫ ω, (f₀₀ + f₀₁) ω ∂model.hiddenMeasure) +
            ∫ ω, f₁₀ ω ∂model.hiddenMeasure) -
            ∫ ω, f₁₁ ω ∂model.hiddenMeasure := by
        rw [hAdd₁₀]
      _ = ((∫ ω, f₀₀ ω ∂model.hiddenMeasure) +
            (∫ ω, f₀₁ ω ∂model.hiddenMeasure) +
            (∫ ω, f₁₀ ω ∂model.hiddenMeasure)) -
            ∫ ω, f₁₁ ω ∂model.hiddenMeasure := by
        rw [hAdd₀₁]
  rw [hIntegral]
  calc
    |∫ ω, (f₀₀ + f₀₁ + f₁₀ - f₁₁) ω ∂model.hiddenMeasure| ≤
        ∫ ω, |(f₀₀ + f₀₁ + f₁₀ - f₁₁) ω| ∂model.hiddenMeasure :=
      abs_integral_le_integral_abs
    _ ≤ ∫ _ω, (2 : ℝ) ∂model.hiddenMeasure := by
      exact integral_mono_ae
        (((h₀₀Int.add h₀₁Int).add h₁₀Int).sub h₁₁Int).abs
        (integrable_const (2 : ℝ)) hpoint
    _ = 2 := by simp

/-- Four fixed correlation-error bounds transfer CHSH from a bounded local
model to an arbitrary target with the exact coefficient `4 * ε`. -/
theorem target_chsh_of_four_errors
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (target : SettingA → SettingB → ℝ) (ε : ℝ)
    (a₀ a₁ : SettingA) (b₀ b₁ : SettingB)
    (hA₀Meas : AEMeasurable (model.aliceResponse a₀) model.hiddenMeasure)
    (hA₁Meas : AEMeasurable (model.aliceResponse a₁) model.hiddenMeasure)
    (hB₀Meas : AEMeasurable (model.bobResponse b₀) model.hiddenMeasure)
    (hB₁Meas : AEMeasurable (model.bobResponse b₁) model.hiddenMeasure)
    (hA₀Bound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a₀))
    (hA₁Bound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a₁))
    (hB₀Bound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b₀))
    (hB₁Bound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b₁))
    (h₀₀ : |correlation model a₀ b₀ - target a₀ b₀| ≤ ε)
    (h₀₁ : |correlation model a₀ b₁ - target a₀ b₁| ≤ ε)
    (h₁₀ : |correlation model a₁ b₀ - target a₁ b₀| ≤ ε)
    (h₁₁ : |correlation model a₁ b₁ - target a₁ b₁| ≤ ε) :
    |chshCombination target a₀ a₁ b₀ b₁| ≤ 2 + 4 * ε := by
  have hmodel := bounded_response_chsh model a₀ a₁ b₀ b₁
    hA₀Meas hA₁Meas hB₀Meas hB₁Meas
      hA₀Bound hA₁Bound hB₀Bound hB₁Bound
  simp only [chshCombination] at hmodel ⊢
  rcases abs_le.mp hmodel with ⟨hmodelLower, hmodelUpper⟩
  rcases abs_le.mp h₀₀ with ⟨h₀₀Lower, h₀₀Upper⟩
  rcases abs_le.mp h₀₁ with ⟨h₀₁Lower, h₀₁Upper⟩
  rcases abs_le.mp h₁₀ with ⟨h₁₀Lower, h₁₀Upper⟩
  rcases abs_le.mp h₁₁ with ⟨h₁₁Lower, h₁₁Upper⟩
  apply abs_le.mpr
  constructor <;> linarith

end Bell.Inequality
