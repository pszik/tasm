package uk.ac.nott.cs.comp3012.tasm;

import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.Instruction;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.InstructionList;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.CallInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.HaltInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.InstructionContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.JumpifInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.LoadInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.LoadaInstrContext;
import uk.ac.nott.cs.comp3012.tasm.TasmParser.ProgramContext;

public class ProgramBuilder extends TasmBaseVisitor<TasmInstruction> {

  @Override
  public TasmInstruction visitProgram(ProgramContext ctx) {
    InstructionList instrs = new InstructionList();
    for (InstructionContext instrCtx : ctx.instruction()) {
      Instruction instr = (Instruction) visit(instrCtx);
      instrs.add(instr);
    }

    return instrs;
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

  @Override
  public TasmInstruction visitCallInstr(CallInstrContext ctx) {
    TasmRegister r = TasmRegister.valueOf(ctx.r.getText());
    int n = TasmRegister.valueOf(ctx.n.getText()).value;
    int d = Integer.parseInt(ctx.d.getText());
    return new Instruction(TasmOpcode.CALL, r, n, d);
  }

  @Override
  public TasmInstruction visitJumpifInstr(JumpifInstrContext ctx) {
    TasmRegister r = TasmRegister.valueOf(ctx.r.getText());
    int n = Integer.parseInt(ctx.n.getText());
    int d = Integer.parseInt(ctx.d.getText());
    return new Instruction(TasmOpcode.JUMPIF, r, n, d);
  }

  @Override
  public TasmInstruction visitHaltInstr(HaltInstrContext ctx) {
    return new Instruction(TasmOpcode.HALT, TasmRegister.CB, 0, 0);
  }
}
