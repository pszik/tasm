tasm: Main.hs Lexer.hs ParseState.hs Parser.hs
	ghc -Wall -O2 -o bin/tasm Main.hs -odir obj -hidir obj

Parser.hs: Parser.y
	happy --ghc Parser.y -o Parser.hs