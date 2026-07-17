module

public import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring

/-!
# Uniform approximation on explicit setting domains

The radius is nonnegative and the absolute-error bound is pointwise in both
settings. Explicit domains prevent an accidental claim over ambient nonphysical
vectors when the intended settings form a subset such as the unit sphere.
-/

@[expose] public section

namespace Bell.Approximation

/-- Uniform absolute error at most `ε` on the product of two setting sets. -/
def UniformlyWithinOn {A B : Type*}
    (s : Set A) (t : Set B) (f g : A → B → ℝ) (ε : ℝ) : Prop :=
  0 ≤ ε ∧ ∀ a ∈ s, ∀ b ∈ t, |f a b - g a b| ≤ ε

variable {A B : Type*} {s : Set A} {t : Set B}
  {f g h : A → B → ℝ} {ε δ : ℝ}

theorem UniformlyWithinOn.nonneg
    (hfg : UniformlyWithinOn s t f g ε) : 0 ≤ ε :=
  hfg.1

theorem UniformlyWithinOn.bound
    (hfg : UniformlyWithinOn s t f g ε)
    {a : A} (ha : a ∈ s) {b : B} (hb : b ∈ t) :
    |f a b - g a b| ≤ ε :=
  hfg.2 a ha b hb

theorem UniformlyWithinOn.refl
    (s : Set A) (t : Set B) (f : A → B → ℝ) :
    UniformlyWithinOn s t f f 0 := by
  refine ⟨le_rfl, ?_⟩
  intro a _ b _
  simp

theorem UniformlyWithinOn.symm
    (hfg : UniformlyWithinOn s t f g ε) :
    UniformlyWithinOn s t g f ε := by
  refine ⟨hfg.nonneg, ?_⟩
  intro a ha b hb
  simpa [abs_sub_comm] using hfg.bound ha hb

/-- Uniform errors add under composition. This is the abstract triangle step
from Bell's equations (16) and (17) to equation (18). -/
theorem UniformlyWithinOn.trans_add
    (hfg : UniformlyWithinOn s t f g ε)
    (hgh : UniformlyWithinOn s t g h δ) :
    UniformlyWithinOn s t f h (ε + δ) := by
  refine ⟨add_nonneg hfg.nonneg hgh.nonneg, ?_⟩
  intro a ha b hb
  calc
    |f a b - h a b| = |(f a b - g a b) + (g a b - h a b)| := by
      congr 1
      ring
    _ ≤ |f a b - g a b| + |g a b - h a b| := abs_add_le _ _
    _ ≤ ε + δ := add_le_add (hfg.bound ha hb) (hgh.bound ha hb)

end Bell.Approximation
