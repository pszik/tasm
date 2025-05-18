package uk.ac.nott.cs.comp3012.tasm;

import java.util.ArrayList;

public interface TasmInstruction {

  record Instruction(TasmOpcode op, TasmRegister r, byte n, short d) implements TasmInstruction {

  }

  final class InstructionList extends ArrayList<Instruction> implements TasmInstruction {

  }

}
