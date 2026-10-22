import TPMahler.UncondN
import TPMahler.Statement
/-! Run from `lean/` after `lake build TPMahler.UncondN TPMahler.StatementCor`: `lake env lean ../logs/lean/axioms_N.lean`.
Prints, for each final theorem of the first version (`TPMahler.N`), whether its type is the statement proposition of
`TPMahler/Statement.lean` of the same name, and the axioms it depends on. -/
open Lean Meta Elab Command in
elab "#stmt_is " a:ident b:ident : command => do
  let env ← getEnv
  let some ca := env.find? a.getId | throwError "no {a}"
  let some _ := env.find? b.getId | throwError "no {b}"
  logInfo m!"{a.getId} has type {b.getId}: {ca.type == Expr.const b.getId []}"
#stmt_is TPMahler.N.tpMain TPMahler.TpMain
#stmt_is TPMahler.N.tpOmega TPMahler.TpOmega
#stmt_is TPMahler.N.tpLimitPoint TPMahler.TpLimitPoint
#stmt_is TPMahler.N.expM0Gt TPMahler.ExpM0Gt
#print axioms TPMahler.N.tpMain
#print axioms TPMahler.N.tpOmega
#print axioms TPMahler.N.tpLimitPoint
#print axioms TPMahler.N.expM0Gt
