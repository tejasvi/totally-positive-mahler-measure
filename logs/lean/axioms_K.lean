import TPMahler.UncondK
import TPMahler.CorRealK
import TPMahler.Statement
import TPMahler.StatementCor
/-! Run from `lean/` after `lake build TPMahler.UncondK TPMahler.CorRealK`: `lake env lean ../logs/lean/axioms_K.lean`.
Prints, for each final theorem of the second version (`TPMahler.K`), whether its type is the statement proposition of
`TPMahler/Statement.lean` or `TPMahler/StatementCor.lean` of the same name, and the axioms it depends on. -/
open Lean Meta Elab Command in
elab "#stmt_is " a:ident b:ident : command => do
  let env ← getEnv
  let some ca := env.find? a.getId | throwError "no {a}"
  let some _ := env.find? b.getId | throwError "no {b}"
  logInfo m!"{a.getId} has type {b.getId}: {ca.type == Expr.const b.getId []}"
#stmt_is TPMahler.K.tpMain TPMahler.TpMain
#stmt_is TPMahler.K.tpOmega TPMahler.TpOmega
#stmt_is TPMahler.K.tpLimitPoint TPMahler.TpLimitPoint
#stmt_is TPMahler.K.expM0Gt TPMahler.ExpM0Gt
#stmt_is TPMahler.K.corReal TPMahler.CorReal
#stmt_is TPMahler.K.corRealDec TPMahler.CorRealDec
#stmt_is TPMahler.K.corRealOmega TPMahler.CorRealOmega
#print axioms TPMahler.K.tpMain
#print axioms TPMahler.K.tpOmega
#print axioms TPMahler.K.tpLimitPoint
#print axioms TPMahler.K.expM0Gt
#print axioms TPMahler.K.corReal
#print axioms TPMahler.K.corRealDec
#print axioms TPMahler.K.corRealOmega
