import Lean

open Lean Elab Command Parser.Command

namespace NaeL

syntax (name := naelTheorem) "nael " "theorem " declId declSig (declVal)? : command

@[command_elab naelTheorem]
def elabNaelTheorem : CommandElab := fun stx => do
  let name : TSyntax ``declId := ⟨stx[2]⟩
  let signature : TSyntax ``declSig := ⟨stx[3]⟩
  let declaration ← `(command| theorem $name:declId $signature:declSig := sorry)
  let previous ← get
  modify fun state => { state with messages := {} }
  try
    elabCommand (← `(command|
      set_option Elab.async false in
      set_option debug.skipKernelTC false in
      $declaration))
    if (← get).messages.hasErrors then
      setEnv previous.env
      return
    let added := (← getEnv).constants.foldStage2
      (fun names name _ => if previous.env.contains name then names else names.push name) #[]
    for name in added do
      let forbidden := (← collectAxioms name).filter (· != ``sorryAx)
      unless forbidden.isEmpty do
        throwErrorAt signature m!"4 naeL rejected '{name}': additional axioms {forbidden.toList}"
  catch error =>
    setEnv previous.env
    throw error
  finally
    modify fun state => { state with messages := previous.messages ++ state.messages }

end NaeL
