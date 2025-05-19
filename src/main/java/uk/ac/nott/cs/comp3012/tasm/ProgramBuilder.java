package uk.ac.nott.cs.comp3012.tasm;

import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.Instruction;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.InstructionList;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.LoadInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.LoadaInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.ProgramContext;

public class ProgramBuilder extends TasmBaseVisitor<TasmInstruction> {

  @Override
  public TasmInstruction visitProgram(ProgramContext ctx) {
    return new InstructionList(ctx.children.stream().map(c -> (Instruction) visit(c)).toList());
  }

  @Override
  public TasmInstruction visitLoadInstr(LoadInstrContext ctx) {
    TasmRegister r = TasmRegister.valueOf(ctx.r.getText());
    int n = Integer.parseInt(ctx.n.getText());
    int d = Integer.parseInt(ctx.d.getText());
    return new Instruction(TasmOpcode.LOAD, r, n, d);
  }

  @Override
  public TasmInstruction visitLoadaInstr(LoadaInstrContext ctx) {
    TasmRegister r = TasmRegister.valueOf(ctx.r.getText());
    int d = Integer.parseInt(ctx.d.getText());
    return new Instruction(TasmOpcode.LOADA, r, 0, d);
  }
}
