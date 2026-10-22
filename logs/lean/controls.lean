import TPCore
/-! Negative controls for the checking program. Run from `lean/` after the first build:
`lake env lean ../logs/lean/controls.lean`. Each line evaluates a check on the data of the certificate (unmodified) or on
a modified copy, and prints OK if the result is the expected one: `true` for the unmodified data, `false` for each
modification. -/
open TPCore

def report (name : String) (expected got : Bool) : IO Unit :=
  IO.println s!"{if expected == got then "OK " else "BAD"} {name}: expected {expected}, got {got}"

def ctx : Ctx := mkCtx iLoNum 128
def l0 : Leaf := leaves.getD 0 ⟨0, 0, 0, 0, false, 0⟩
def lLast : Leaf := leaves.getLastD ⟨0, 0, 0, 0, false, 0⟩

-- the tiling of [2^-30, 21]: one interval, and the end of the tiling
#eval report "first interval" true (leafOK ctx l0)
#eval report "first interval widened to [2^-30, 1]" false (leafOK ctx { l0 with X2 := 10000000000 * 2 ^ 30 })
#eval report "last interval, ending at 21" true (leavesOK ctx lLast.X1 lLast.k [lLast] 210000000000 0)
#eval report "last interval, end point moved by 2^-64/10^10" false
  (leavesOK ctx lLast.X1 lLast.k [lLast] (210000000000 * 2 ^ 64 + 1) 64)
-- the two tails
#eval report "left tail (0, 2^-30]" true (decide (0 < leftTailLB ctx DEC 30))
#eval report "left tail claimed on (0, 1/2]" false (decide (0 < leftTailLB ctx DEC 1))
#eval report "right tail [21, oo)" true (decide (0 < rightTailLB ctx (XT * DEC)))
-- the condition on the weights
#eval report "weights" true budgetOK
