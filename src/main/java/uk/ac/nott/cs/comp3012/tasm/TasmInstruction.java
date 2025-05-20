package uk.ac.nott.cs.comp3012.tasm;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Collection;

public interface TasmInstruction {

  byte[] toBytes();

  record Instruction(TasmOpcode op, TasmRegister r, int n, int d) implements TasmInstruction {

    public byte[] toBytes() {
      return new byte[]{
          (byte) ((op.value << 4) | r.value),
          (byte) n,
          (byte) ((d & 0xff00) >>> 8),
          (byte) (d & 0xff),
      };
    }
  }

  final class InstructionList extends ArrayList<Instruction> implements TasmInstruction {
    public InstructionList() {
      super();
    }

    public InstructionList(Collection<Instruction> c) {
      super(c);
    }

    @Override
    public byte[] toBytes() {
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      for (Instruction instr : this) {
        out.writeBytes(instr.toBytes());
      }
      return out.toByteArray();
    }
  }

}
