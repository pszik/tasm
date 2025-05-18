package uk.ac.nott.cs.comp3012.tasm;

import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.Instruction;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.InstructionList;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.ProgramContext;

public class ProgramBuilder extends TasmBaseVisitor<TasmInstruction> {

  @Override
  public TasmInstruction visitProgram(ProgramContext ctx) {
    return new InstructionList(ctx.children.stream().map(c -> (Instruction) visit(c)).toList());
  }
}
