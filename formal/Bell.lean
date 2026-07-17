module

public import Bell.HiddenVariable.Basic
public import Bell.HiddenVariable.Correlation
public import Bell.HiddenVariable.PerfectAnticorrelation
public import Bell.HiddenVariable.Reproduction
public import Bell.Inequality.Original
public import Bell.Quantum.Singlet
public import Bell.Geometry.Violation

/-!
# Bell

Public root for the Bell 1964 formalization.

The public abstract layer keeps the fixed hidden-variable measure, local
deterministic responses, normalization, binary outcomes, measurability, and
perfect anticorrelation, and correlation reproduction logically distinct.
Bell's original inequality is proved independently of quantum mechanics and
geometry. The finite-dimensional singlet calculation is exported from a
separate quantum-only dependency layer; the geometric violation is their first
public integration layer.
-/

namespace Bell

end Bell
