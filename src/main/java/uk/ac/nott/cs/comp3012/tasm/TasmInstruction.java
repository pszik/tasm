package uk.ac.nott.cs.comp3012.tasm;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Collection;

public interface TasmInstruction {

  record Instruction(TasmOpcode op, TasmRegister r, byte n, short d) implements TasmInstruction {

    public byte[] toBytes() {
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      out.write((byte) op.ordinal());
      out.write((byte) r.ordinal());
      out.write(n);
      out.write(d);
      return out.toByteArray();
    }
  }

  final class InstructionList extends ArrayList<Instruction> implements TasmInstruction {

    public InstructionList(Collection<Instruction> c) {
      super(c);
    }
  }

}
