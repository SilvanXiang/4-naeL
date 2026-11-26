import NaeL

section
variable (P : Prop)

namespace Acceptance

/-- warning: declaration uses 'sorry' -/
#guard_msgs in
nael theorem universal : P

end Acceptance
end

/-- info: 'Acceptance.universal' depends on axioms: [sorryAx] -/
#guard_msgs in
#print axioms Acceptance.universal

/--
error: type of theorem 'badType' is not a proposition
  Nat
-/
#guard_msgs in
nael theorem badType : Nat

/-- error: unknown identifier 'badType' -/
#guard_msgs in
#check badType

/-- error: 4 naeL rejected 'direct': additional axioms [Classical.choice] -/
#guard_msgs (error, drop warning) in
nael theorem direct : Classical.choice (α := Nat) ⟨0⟩ = 0

/-- error: unknown identifier 'direct' -/
#guard_msgs in
#check direct

noncomputable def selectedZero : Nat := Classical.choice (α := Nat) ⟨0⟩

/-- error: 4 naeL rejected 'indirect': additional axioms [Classical.choice] -/
#guard_msgs (error, drop warning) in
nael theorem indirect : selectedZero = 0

/-- error: unknown identifier 'indirect' -/
#guard_msgs in
#check indirect

theorem ordinary : True := True.intro

/-- info: 'ordinary' does not depend on any axioms -/
#guard_msgs in
#print axioms ordinary
