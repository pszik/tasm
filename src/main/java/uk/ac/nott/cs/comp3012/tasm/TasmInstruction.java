package uk.ac.nott.cs.comp3012.tasm;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;

public interface TasmInstruction {

  /**
   * Represent this instruction as an array of bytes in TAM bytecode format.
   *
   * @return the bytes
   */
  byte[] toByteArray();


  record Instruction(TasmOpcode op, TasmRegister r, int n, int d) implements
      TasmInstruction {

    public byte[] toByteArray() {
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
    public byte[] toByteArray() {
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      for (Instruction instr : this) {
        out.writeBytes(instr.toByteArray());
      }
      return out.toByteArray();
    }
  }

}
