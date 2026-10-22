import TPMahler.UncondK
import TPMahler.CorReal

/-!
# Corollary 1.2 of the paper, track K

Every computational fact is checked by the kernel: the corollary follows from the kernel-only, hypothesis-free
Theorem 1.1 (`TPMahler.K.tp_main_unconditional`) by `TPMahler.Cor.cor_real_of`, which uses `β ↦ β²` and
`log Ω(β²) ≤ 2 log Ω(β)`. The statements are the propositions of `TPMahler.StatementCor`.
-/

open Polynomial AuxCommon

namespace TPMahler.K

/-- **Corollary 1.2** (track K, no hypotheses). -/
theorem corReal : CorReal :=
  Cor.cor_real_of tp_main_unconditional

/-- **Corollary 1.2**, decimal form for the height (track K, no hypotheses). -/
theorem corRealDec : CorRealDec :=
  Cor.cor_real_dec_of tp_main_unconditional

/-- **Corollary 1.2**, decimal form for `Ω` (track K, no hypotheses). -/
theorem corRealOmega : CorRealOmega :=
  Cor.cor_real_omega_of tp_main_unconditional

end TPMahler.K
