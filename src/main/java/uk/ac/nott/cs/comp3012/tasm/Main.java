package uk.ac.nott.cs.comp3012.tasm;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.TokenStream;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.Instruction;
import uk.ac.nott.cs.comp3012.tasm.TasmInstruction.InstructionList;

public class Main {

  public static void main(String[] args) throws IOException {
    Main assembler = new Main();
    assembler.assemble(args[0], args[1]);
  }

  public void assemble(String inFile, String outFile) throws IOException {
    // construct lexer and parser
    CharStream chars = CharStreams.fromFileName(inFile);
    TasmLexer lexer = new TasmLexer(chars);
    TokenStream tokens = new CommonTokenStream(lexer);
    TasmParser parser = new TasmParser(tokens);

    // read program
    InstructionList program = (InstructionList) new ProgramBuilder().visitProgram(parser.program());

    // emit program
    try (BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(outFile))) {
      for (Instruction instr : program) {
        out.write(instr.toBytes());
      }
    }
  }
}
