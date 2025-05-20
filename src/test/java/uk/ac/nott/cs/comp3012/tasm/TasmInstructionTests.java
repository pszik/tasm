package uk.ac.nott.cs.comp3012.tasm;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import org.junit.jupiter.api.Test;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.Instruction;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.InstructionList;

public class TasmInstructionTests {

  @Test
  public void testInstructionToBytes() {
    Instruction instr = new Instruction(TasmOpcode.JUMPIF, TasmRegister.LB, 104, -77);

    byte[] bytes = instr.toBytes();

    assertEquals(4, bytes.length, "Wrong number of bytes");
    assertArrayEquals(new byte[]{(byte) 0xe8, 0x68, (byte) 0xff, (byte) 0xb3}, bytes);
  }

  @Test
  public void testInstructionListToBytes() {
    InstructionList instrs = new InstructionList(Arrays.asList(
        new Instruction(TasmOpcode.JUMPIF, TasmRegister.LB, 104, -77),
        new Instruction(TasmOpcode.CALL, TasmRegister.CB, 1, 23)
    ));

    byte[] bytes = instrs.toBytes();

    assertEquals(8, bytes.length, "Wrong number of bytes");
    assertArrayEquals(
        new byte[]{(byte) 0xe8, 0x68, (byte) 0xff, (byte) 0xb3, 0x60, 0x01, 0x00, 0x17}, bytes);
  }
}
