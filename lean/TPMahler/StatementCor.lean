import TPMahler.Statement

/-!
# Corollary 1.2 of the paper (totally real algebraic numbers): statements

For an algebraic number `β` with minimal polynomial `P ∈ ℤ[X]`, `log Ω(β) = logOmega P` (as in `TPMahler.Statement`),
and `β` is totally real when all roots of `P` in `ℂ` are real. Corollary 1.2: for every `ε > 0`, all but finitely many
totally real algebraic numbers `β` satisfy `log Ω(β) > m₀/2 - ε`; in particular all but finitely many satisfy
`log Ω(β) > 0.2721673` and `Ω(β) > 1.3128067` (the propositions `CorReal`, `CorRealDec`, `CorRealOmega`; proved in
`TPMahler.CorRealK`). The proof uses Theorem 1.1 for `β²`, which is totally positive, with `log Ω(β²) ≤ 2 log Ω(β)`.
-/

open Polynomial AuxCommon

namespace TPMahler

/-- All roots of `P` in `ℂ` are real. -/
def AllRootsReal (P : ℤ[X]) : Prop :=
  ∀ z ∈ (toC P).roots, z.im = 0

/-- Totally real algebraic numbers `β` with `log Ω(β) ≤ B`. -/
def TRLow (B : ℝ) : Set ℂ :=
  {β | ∃ P : ℤ[X], IsMinpolyZ P β ∧ AllRootsReal P ∧ logOmega P ≤ B}

/-- **Corollary 1.2.** For every `ε > 0`, only finitely many totally real algebraic numbers `β` satisfy
`log Ω(β) ≤ m₀/2 - ε`. -/
def CorReal : Prop :=
  ∀ ε : ℝ, 0 < ε → (TRLow (m0 / 2 - ε)).Finite

/-- **Corollary 1.2**, decimal form for the height: all but finitely many totally real algebraic numbers `β` satisfy
`log Ω(β) > 0.2721673`. -/
def CorRealDec : Prop :=
  (TRLow (2721673 / 10000000)).Finite

/-- **Corollary 1.2**, decimal form for `Ω`: all but finitely many totally real algebraic numbers `β` satisfy
`Ω(β) > 1.3128067`. -/
def CorRealOmega : Prop :=
  {β : ℂ | ∃ P : ℤ[X], IsMinpolyZ P β ∧ AllRootsReal P ∧
    (toC P).mahlerMeasure ^ ((P.natDegree : ℝ)⁻¹) ≤ 13128067 / 10000000}.Finite

end TPMahler
