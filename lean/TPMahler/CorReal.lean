import TPMahler.StatementCor
import TPMahler.Assembly

/-!
# Corollary 1.2 from Theorem 1.1

`cor_real_of`: if for every `ε > 0` only finitely many totally positive algebraic numbers `α` have
`log Ω(α) ≤ m₀ - ε` (Theorem 1.1, `TPLow`), then for every `ε > 0` only finitely many totally real algebraic numbers
`β` have `log Ω(β) ≤ m₀/2 - ε` (`TRLow`). The decimal forms follow (`cor_real_dec_of`, `cor_real_omega_of`).

The key step is `exists_minpoly_sq`: for a totally real `β ≠ 0` with minimal polynomial `P`, the number `β²` has a
minimal polynomial `R` with all roots positive and `logOmega R ≤ 2 logOmega P`. If `P(-x) = P(x)`, then
`P(x) = T(x²)` and `R = T`. Otherwise `P(x)` and `P(-x)` are not associated, `P(x) P(-x) = S(x²)` with `deg S = deg P`,
and `R` is an irreducible factor of `S` vanishing at `β²`; it has degree `deg P` because `P(x) P(-x) ∣ R(x²)`.
In both cases `M(R) ≤ M(S) = M(P)²` (Mahler measures of `p(x²)` and `p(-x)` equal that of `p`).
-/

open Polynomial AuxCommon

namespace TPMahler.Cor

/-! ## Mahler measures of `p(x²)` and `p(-x)` -/

theorem mahlerMeasure_X_pow_two_sub_C (a : ℂ) : (X ^ 2 - C a : ℂ[X]).mahlerMeasure = max 1 ‖a‖ := by
  obtain ⟨s, hs⟩ := IsAlgClosed.exists_pow_nat_eq a two_pos
  have hf : (X ^ 2 - C a : ℂ[X]) = (X - C s) * (X + C s) := by
    rw [← hs, C_pow]
    ring
  rw [hf, mahlerMeasure_mul, mahlerMeasure_X_sub_C, mahlerMeasure_X_add_C]
  have hn : ‖a‖ = ‖s‖ ^ 2 := by rw [← hs, norm_pow]
  rw [hn]
  rcases le_total ‖s‖ 1 with h | h
  · rw [max_eq_left h, max_eq_left (by nlinarith [norm_nonneg s])]
    norm_num
  · rw [max_eq_right h, max_eq_right (by nlinarith [norm_nonneg s])]
    ring

theorem mahlerMeasure_expand_two_prod (s : Multiset ℂ) :
    (expand ℂ 2 (s.map fun a => X - C a).prod).mahlerMeasure = ((s.map fun a => X - C a).prod).mahlerMeasure := by
  induction s using Multiset.induction_on with
  | empty => simp
  | cons a s ih =>
    rw [Multiset.map_cons, Multiset.prod_cons, map_mul, mahlerMeasure_mul, mahlerMeasure_mul, ih, map_sub,
      expand_X, expand_C, mahlerMeasure_X_pow_two_sub_C, mahlerMeasure_X_sub_C]

theorem mahlerMeasure_expand_two (p : ℂ[X]) : (expand ℂ 2 p).mahlerMeasure = p.mahlerMeasure := by
  have hroots : Multiset.card p.roots = p.natDegree := (IsAlgClosed.splits p).natDegree_eq_card_roots.symm
  have hp := C_leadingCoeff_mul_prod_multiset_X_sub_C hroots
  rw [← hp, map_mul, expand_C, mahlerMeasure_mul, mahlerMeasure_mul, mahlerMeasure_expand_two_prod]

theorem mahlerMeasure_comp_neg_X (p : ℂ[X]) : (p.comp (-X)).mahlerMeasure = p.mahlerMeasure := by
  rw [mahlerMeasure_eq_leadingCoeff_mul_prod_roots, mahlerMeasure_eq_leadingCoeff_mul_prod_roots, roots_comp_neg_X,
    comp_neg_X_leadingCoeff_eq, Multiset.map_map]
  simp [Function.comp_def]

theorem toC_expand (S : ℤ[X]) : toC (expand ℤ 2 S) = expand ℂ 2 (toC S) := map_expand

theorem toC_comp_neg_X (P : ℤ[X]) : toC (P.comp (-X)) = (toC P).comp (-X) := by
  unfold toC
  rw [map_comp, Polynomial.map_neg, map_X]

theorem toC_mul (A B : ℤ[X]) : toC (A * B) = toC A * toC B := Polynomial.map_mul _

/-! ## Even integer polynomials -/

theorem coeff_comp_neg_X (p : ℤ[X]) (n : ℕ) : (p.comp (-X)).coeff n = (-1) ^ n * p.coeff n := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => rw [add_comp, coeff_add, coeff_add, hp, hq, mul_add]
  | monomial k a =>
    rw [← C_mul_X_pow_eq_monomial, mul_comp, C_comp, X_pow_comp, neg_pow,
      show ((-1 : ℤ[X]) ^ k) = C ((-1 : ℤ) ^ k) by simp, ← mul_assoc, ← C_mul, coeff_C_mul, coeff_C_mul,
      coeff_X_pow]
    split_ifs with h
    · subst h
      ring
    · simp

theorem expand_contract_of_even {E : ℤ[X]} (hE : E.comp (-X) = E) : expand ℤ 2 (contract 2 E) = E := by
  ext n
  rw [coeff_expand two_pos]
  split_ifs with h
  · rw [coeff_contract two_ne_zero, Nat.div_mul_cancel h]
  · have h1 := congrArg (fun q => q.coeff n) hE
    simp only [coeff_comp_neg_X] at h1
    have hodd : (-1 : ℤ) ^ n = -1 := Odd.neg_one_pow (Nat.odd_iff.mpr (by omega))
    rw [hodd] at h1
    linarith

theorem expand_comp_neg_X (S : ℤ[X]) : (expand ℤ 2 S).comp (-X) = expand ℤ 2 S := by
  rw [expand_eq_comp_X_pow, comp_assoc]
  congr 1
  simp [X_pow_comp, neg_sq]

/-! ## Minimal polynomials -/

/-- Gauss: the minimal polynomial divides every integer polynomial vanishing at the number. -/
theorem dvd_of_aeval_eq_zero {P : ℤ[X]} {β : ℂ} (hP : IsMinpolyZ P β) {Q : ℤ[X]} (hQ : aeval β Q = 0) :
    P ∣ Q := by
  have hdvd := hP.map_rat_dvd_of_aeval_eq_zero hQ
  have hprim := hP.1.isPrimitive hP.2.1.ne'
  rw [← algebraMap_int_eq] at hdvd
  exact (Polynomial.IsPrimitive.dvd_iff_fraction_map_dvd_fraction_map ℚ hprim).mpr hdvd

theorem irreducible_comp_neg_X {P : ℤ[X]} (hP : Irreducible P) : Irreducible (P.comp (-X)) := by
  let σ : ℤ[X] ≃ₐ[ℤ] ℤ[X] := algEquivOfCompEqX (-X) (-X) (by simp) (by simp)
  have hσ : σ P = P.comp (-X) := by
    simp [σ, algEquivOfCompEqX, comp_eq_aeval]
  rw [← hσ]
  exact (MulEquiv.irreducible_iff (σ : ℤ[X] ≃* ℤ[X])).mpr hP

theorem mul_dvd_of_not_associated {p q f : ℤ[X]} (hp : Irreducible p) (hq : Irreducible q)
    (hpq : ¬ Associated p q) (h1 : p ∣ f) (h2 : q ∣ f) : p * q ∣ f := by
  obtain ⟨g, rfl⟩ := h1
  rcases (UniqueFactorizationMonoid.irreducible_iff_prime.mp hq).dvd_or_dvd h2 with h | h
  · exact absurd (hq.associated_of_dvd hp h).symm hpq
  · exact mul_dvd_mul_left p h

theorem eval_toC_comp_neg_X (P : ℤ[X]) (w : ℂ) : eval w (toC (P.comp (-X))) = eval (-w) (toC P) := by
  rw [toC_comp_neg_X, eval_comp]
  simp

theorem eval_toC_expand (S : ℤ[X]) (w : ℂ) : eval w (toC (expand ℤ 2 S)) = eval (w ^ 2) (toC S) := by
  rw [toC_expand, expand_eval]

/-- Roots of a minimal polynomial of a totally real `β ≠ 0` are real and nonzero. -/
theorem root_real_ne_zero {P : ℤ[X]} {β : ℂ} (hP : IsMinpolyZ P β) (hreal : AllRootsReal P)
    (h0 : P.coeff 0 ≠ 0) {w : ℂ} (hw : eval w (toC P) = 0) : w.im = 0 ∧ w ≠ 0 := by
  refine ⟨hreal w ((mem_roots (toC_ne_zero hP.ne_zero)).mpr hw), ?_⟩
  rintro rfl
  rw [← coeff_zero_eq_eval_zero, toC, coeff_map] at hw
  exact h0 (by simpa using hw)

theorem allRootsPos_of {R : ℤ[X]} (hR : R ≠ 0) (h : ∀ w : ℂ, eval (w ^ 2) (toC R) = 0 → w.im = 0 ∧ w ≠ 0) :
    AllRootsPos R := by
  intro z hz
  obtain ⟨w, hw⟩ := IsAlgClosed.exists_pow_nat_eq z two_pos
  have hz0 : eval z (toC R) = 0 := (mem_roots (toC_ne_zero hR)).mp hz
  obtain ⟨him, hne⟩ := h w (by rw [hw]; exact hz0)
  have hre : w.re ≠ 0 := fun h0 => hne (Complex.ext h0 him)
  rw [← hw]
  constructor
  · rw [pow_two, Complex.mul_re, him, mul_zero, sub_zero]
    exact mul_self_pos.mpr hre
  · rw [pow_two, Complex.mul_im, him, mul_zero, zero_mul, add_zero]

theorem coeff_zero_ne_zero {P : ℤ[X]} {β : ℂ} (hP : IsMinpolyZ P β) (hβ : β ≠ 0) : P.coeff 0 ≠ 0 := by
  intro h0
  have hX : (X : ℤ[X]) ∣ P := X_dvd_iff.mpr h0
  obtain ⟨u, hu⟩ := (irreducible_X.associated_of_dvd hP.1 hX)
  have h := hP.2.2
  rw [← hu, map_mul, aeval_X] at h
  rcases mul_eq_zero.mp h with h | h
  · exact hβ h
  · obtain ⟨r, hr, hrC⟩ := Polynomial.isUnit_iff.mp u.isUnit
    rw [← hrC, aeval_C, algebraMap_int_eq, eq_intCast, Int.cast_eq_zero] at h
    exact hr.ne_zero h

theorem logOmega_le_of {R S P : ℤ[X]} (hRS : R ∣ S) (hS0 : S ≠ 0) (hdeg : R.natDegree = P.natDegree)
    (hP0 : 0 < P.natDegree) (hM : (toC S).mahlerMeasure = (toC P).mahlerMeasure ^ 2) :
    logOmega R ≤ 2 * logOmega P := by
  obtain ⟨T, hT⟩ := hRS
  have hR0 : R ≠ 0 := by rintro rfl; rw [zero_mul] at hT; exact hS0 hT
  have hT0 : T ≠ 0 := by rintro rfl; rw [mul_zero] at hT; exact hS0 hT
  have hMR : (toC R).mahlerMeasure ≤ (toC S).mahlerMeasure := by
    rw [hT, toC_mul, mahlerMeasure_mul]
    have h1 := one_le_mahlerMeasure_of_ne_zero hT0
    have h2 : 0 ≤ (toC R).mahlerMeasure := mahlerMeasure_nonneg _
    nlinarith
  have hMR0 : 0 < (toC R).mahlerMeasure := lt_of_lt_of_le one_pos (one_le_mahlerMeasure_of_ne_zero hR0)
  have hsq : Real.log ((toC P).mahlerMeasure ^ 2) = 2 * Real.log (toC P).mahlerMeasure := by
    rw [Real.log_pow]
    norm_num
  have hlog : Real.log (toC R).mahlerMeasure ≤ 2 * Real.log (toC P).mahlerMeasure := by
    rw [← hsq, ← hM]
    exact Real.log_le_log hMR0 hMR
  have hd : (0 : ℝ) < P.natDegree := by exact_mod_cast hP0
  unfold logOmega
  rw [hdeg, mul_div_assoc']
  exact div_le_div_of_nonneg_right hlog hd.le

/-- **The square of a totally real algebraic number `β ≠ 0`** has a minimal polynomial `R` with all roots positive and
`logOmega R ≤ 2 logOmega P`. -/
theorem exists_minpoly_sq {P : ℤ[X]} {β : ℂ} (hP : IsMinpolyZ P β) (hreal : AllRootsReal P) (hβ : β ≠ 0) :
    ∃ R : ℤ[X], IsMinpolyZ R (β ^ 2) ∧ AllRootsPos R ∧ logOmega R ≤ 2 * logOmega P := by
  have h0 := coeff_zero_ne_zero hP hβ
  have hP0 := hP.ne_zero
  have hroot : ∀ w : ℂ, eval w (toC P) = 0 → w.im = 0 ∧ w ≠ 0 := fun w hw => root_real_ne_zero hP hreal h0 hw
  set Pm := P.comp (-X) with hPm
  by_cases hassoc : Associated P Pm
  · -- `P(-x) = ± P(x)`
    obtain ⟨u, hu⟩ := hassoc
    obtain ⟨r, hr, hrC⟩ := Polynomial.isUnit_iff.mp u.isUnit
    rcases Int.isUnit_iff.mp hr with rfl | rfl
    · -- `P` even: `P = T(x²)`
      have hPe : P.comp (-X) = P := by rw [← hPm, ← hu, ← hrC, C_1, mul_one]
      set T := contract 2 P with hT
      have hPT : expand ℤ 2 T = P := expand_contract_of_even hPe
      have hTdeg : P.natDegree = T.natDegree * 2 := by rw [← hPT, natDegree_expand]
      have hT0 : T ≠ 0 := by
        rintro h
        rw [h, map_zero] at hPT
        exact hP0 hPT.symm
      refine ⟨T, ⟨of_irreducible_expand two_ne_zero (hPT ▸ hP.1), by have := hP.2.1; omega, ?_⟩, ?_, ?_⟩
      · rw [← expand_aeval, hPT]
        exact hP.2.2
      · refine allRootsPos_of hT0 fun w hw => hroot w ?_
        rw [← hPT, eval_toC_expand]
        exact hw
      · have hM : (toC T).mahlerMeasure = (toC P).mahlerMeasure := by
          rw [← hPT, toC_expand, mahlerMeasure_expand_two]
        have hTd : (T.natDegree : ℝ) ≠ 0 := by
          have : 0 < T.natDegree := by have := hP.2.1; omega
          exact_mod_cast this.ne'
        apply le_of_eq
        unfold logOmega
        rw [hM, hTdeg]
        push_cast
        field_simp
    · -- `P` odd: then `P(0) = 0`, impossible
      exfalso
      have hPo : P.comp (-X) = -P := by
        rw [← hPm, ← hu, ← hrC]
        simp
      have h1 := congrArg (fun q => q.coeff 0) hPo
      simp only [coeff_comp_neg_X, pow_zero, one_mul, coeff_neg] at h1
      exact h0 (by linarith)
  · -- `P(x)` and `P(-x)` not associated: `E = P(x) P(-x) = S(x²)`
    have hPmirr : Irreducible Pm := irreducible_comp_neg_X hP.1
    set E := P * Pm with hE
    have hEe : E.comp (-X) = E := by
      rw [hE, mul_comp, hPm, comp_neg_X_comp_neg_X]
      exact mul_comm _ _
    set S := contract 2 E with hS
    have hSE : expand ℤ 2 S = E := expand_contract_of_even hEe
    have hPm0 : Pm ≠ 0 := hPmirr.ne_zero
    have hE0 : E ≠ 0 := mul_ne_zero hP0 hPm0
    have hS0 : S ≠ 0 := by
      rintro h
      rw [h, map_zero] at hSE
      exact hE0 hSE.symm
    have hPmdeg : Pm.natDegree = P.natDegree := by
      rw [hPm, natDegree_comp]
      simp
    have hSdeg : S.natDegree = P.natDegree := by
      have h1 : E.natDegree = S.natDegree * 2 := by rw [← hSE, natDegree_expand]
      have h2 : E.natDegree = P.natDegree + Pm.natDegree := natDegree_mul hP0 hPm0
      omega
    have hSβ : aeval (β ^ 2) S = 0 := by
      rw [← expand_aeval, hSE, hE, map_mul, hP.2.2, zero_mul]
    -- an irreducible factor `R` of `S` vanishing at `β²`
    obtain ⟨R, hRmem, hRβ⟩ : ∃ R ∈ UniqueFactorizationMonoid.factors S, aeval (β ^ 2) R = 0 := by
      obtain ⟨u, hu⟩ := UniqueFactorizationMonoid.factors_prod hS0
      have h := hSβ
      rw [← hu, map_mul, map_multiset_prod] at h
      rcases mul_eq_zero.mp h with h | h
      · obtain ⟨R, hR, hR0⟩ := Multiset.mem_map.mp (Multiset.prod_eq_zero_iff.mp h)
        exact ⟨R, hR, hR0⟩
      · exfalso
        obtain ⟨r, hr, hrC⟩ := Polynomial.isUnit_iff.mp u.isUnit
        rw [← hrC, aeval_C, algebraMap_int_eq, eq_intCast, Int.cast_eq_zero] at h
        exact hr.ne_zero h
    have hRirr : Irreducible R := UniqueFactorizationMonoid.irreducible_of_factor R hRmem
    have hRS : R ∣ S := UniqueFactorizationMonoid.dvd_of_mem_factors hRmem
    have hR0 : R ≠ 0 := hRirr.ne_zero
    have hRpos : 0 < R.natDegree := by
      by_contra hc
      push Not at hc
      have hRc : R = C (R.coeff 0) := eq_C_of_natDegree_eq_zero (by omega)
      rw [hRc, aeval_C, algebraMap_int_eq, eq_intCast, Int.cast_eq_zero] at hRβ
      have : R.coeff 0 = 0 := hRβ
      rw [this, C_0] at hRc
      exact hR0 hRc
    -- `P(x) P(-x) ∣ R(x²)`, so `deg R ≥ deg P`
    have hPR : P ∣ expand ℤ 2 R := dvd_of_aeval_eq_zero hP (by rw [expand_aeval]; exact hRβ)
    have hPmR : Pm ∣ expand ℤ 2 R := by
      rw [hPm, ← dvd_comp_neg_X_iff, expand_comp_neg_X]
      exact hPR
    have hER : E ∣ expand ℤ 2 R := mul_dvd_of_not_associated hP.1 hPmirr hassoc hPR hPmR
    have hexp0 : expand ℤ 2 R ≠ 0 := fun h => hR0 ((expand_eq_zero two_pos).mp h)
    have hdegR : P.natDegree ≤ R.natDegree := by
      have h1 := natDegree_le_of_dvd hER hexp0
      rw [natDegree_mul hP0 hPm0, hPmdeg, natDegree_expand] at h1
      omega
    have hdegR' : R.natDegree ≤ P.natDegree := hSdeg ▸ natDegree_le_of_dvd hRS hS0
    refine ⟨R, ⟨hRirr, hRpos, hRβ⟩, ?_, ?_⟩
    · refine allRootsPos_of hR0 fun w hw => ?_
      have hSw : eval (w ^ 2) (toC S) = 0 := by
        obtain ⟨T, hT⟩ := hRS
        rw [hT, toC_mul, eval_mul, hw, zero_mul]
      rw [← eval_toC_expand, hSE, hE, toC_mul, eval_mul] at hSw
      rcases mul_eq_zero.mp hSw with h | h
      · exact hroot w h
      · have h' : eval (-w) (toC P) = 0 := by rw [← eval_toC_comp_neg_X]; exact h
        obtain ⟨him, hne⟩ := hroot (-w) h'
        exact ⟨by simpa using him, by simpa using hne⟩
    · have hMPm : (toC Pm).mahlerMeasure = (toC P).mahlerMeasure := by
        rw [hPm, toC_comp_neg_X, mahlerMeasure_comp_neg_X]
      have hME : (toC E).mahlerMeasure = (toC P).mahlerMeasure ^ 2 := by
        rw [hE, toC_mul, mahlerMeasure_mul, hMPm, sq]
      have hM : (toC S).mahlerMeasure = (toC P).mahlerMeasure ^ 2 := by
        rw [← mahlerMeasure_expand_two (toC S), ← toC_expand, hSE, hME]
      exact logOmega_le_of hRS hS0 (le_antisymm hdegR' hdegR) hP.2.1 hM

/-! ## Corollary 1.2 from Theorem 1.1 -/

theorem trLow_subset (ε : ℝ) :
    TRLow (m0 / 2 - ε) ⊆ {0} ∪ ⋃ γ ∈ TPLow (m0 - 2 * ε), {z : ℂ | z ^ 2 = γ} := by
  rintro β ⟨P, hP, hreal, hlog⟩
  by_cases hβ : β = 0
  · exact Or.inl hβ
  right
  obtain ⟨R, hR, hpos, hle⟩ := exists_minpoly_sq hP hreal hβ
  simp only [Set.mem_iUnion, Set.mem_setOf_eq]
  exact ⟨β ^ 2, ⟨R, hR, hpos, by linarith⟩, rfl⟩

theorem cor_real_of (h : ∀ ε : ℝ, 0 < ε → (TPLow (m0 - ε)).Finite) (ε : ℝ) (hε : 0 < ε) :
    (TRLow (m0 / 2 - ε)).Finite := by
  refine Set.Finite.subset ?_ (trLow_subset ε)
  refine (Set.finite_singleton 0).union ((h (2 * ε) (by linarith)).biUnion fun γ _ => ?_)
  refine (Polynomial.nthRoots 2 γ).toFinset.finite_toSet.subset fun z hz => ?_
  simp only [Finset.mem_coe, Multiset.mem_toFinset, Polynomial.mem_nthRoots two_pos]
  exact hz

theorem cor_real_dec_of (h : ∀ ε : ℝ, 0 < ε → (TPLow (m0 - ε)).Finite) :
    (TRLow (2721673 / 10000000)).Finite := by
  have hε : (0 : ℝ) < m0 / 2 - 2721673 / 10000000 := by norm_num [m0]
  have h1 := cor_real_of h _ hε
  rwa [sub_sub_cancel] at h1

theorem log_EHalfM_lt : Real.log (13128067 / 10000000 : ℝ) < m0 / 2 := by
  have h1 : (13128067 / 10000000 : ℝ) ^ 2 < Real.exp m0 := lt_of_le_of_lt (by norm_num) lt_exp_m0
  have h2 : Real.log ((13128067 / 10000000 : ℝ) ^ 2) < m0 := (Real.log_lt_iff_lt_exp (by norm_num)).mpr h1
  rw [Real.log_pow] at h2
  push_cast at h2
  linarith

theorem cor_real_omega_of (h : ∀ ε : ℝ, 0 < ε → (TPLow (m0 - ε)).Finite) :
    {β : ℂ | ∃ P : ℤ[X], IsMinpolyZ P β ∧ AllRootsReal P ∧
      (toC P).mahlerMeasure ^ ((P.natDegree : ℝ)⁻¹) ≤ 13128067 / 10000000}.Finite := by
  refine (cor_real_of h (m0 / 2 - Real.log (13128067 / 10000000)) (by linarith [log_EHalfM_lt])).subset ?_
  rintro β ⟨P, hP, hreal, hle⟩
  refine ⟨P, hP, hreal, ?_⟩
  rw [sub_sub_cancel]
  exact logOmega_le_log hP.ne_zero hle

end TPMahler.Cor
