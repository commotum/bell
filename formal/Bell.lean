module

public import Bell.HiddenVariable.Basic
public import Bell.HiddenVariable.Correlation
public import Bell.HiddenVariable.PerfectAnticorrelation
public import Bell.HiddenVariable.Reproduction
public import Bell.HiddenVariable.Bounded
public import Bell.Approximation.Uniform
public import Bell.Inequality.Original
public import Bell.Inequality.Robust
public import Bell.Inequality.CHSH
public import Bell.Quantum.Singlet
public import Bell.Geometry.Violation
public import Bell.Geometry.RobustViolation
public import Bell.Geometry.CHSHViolation

/-!
# Bell

Public root for the Bell 1964 formalization.

The public abstract layer keeps the fixed hidden-variable measure, local
deterministic responses, normalization, binary outcomes, measurability, and
perfect anticorrelation, and correlation reproduction logically distinct.
Bell's original inequality is proved independently of quantum mechanics and
geometry. The finite-dimensional singlet calculation is exported from a
separate quantum-only dependency layer; the geometric violation is their first
public integration layer. The robust layer separately treats bounded effective
responses and uniform approximation on explicit setting domains. A final
modern leaf adds the bounded-response CHSH inequality and its independently
calculated four-direction singlet violation.
-/

namespace Bell

end Bell
