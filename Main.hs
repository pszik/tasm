module Main (main) where

import Control.Monad.State (evalStateT)
import Data.Binary (Word32)
import Data.Binary.Put (putWord32be, runPut)
import Data.Bits (shiftL, (.&.), (.|.))
import qualified Data.ByteString.Lazy as BIN
import ParseState (newContext)
import Parser (Instr (Instr), parse)
import System.Environment (getArgs)
import System.IO (IOMode (WriteMode), hClose, openFile)

main :: IO ()
main = do
  (infile : outfile : _) <- getArgs
  programText <- readFile infile
  case evalStateT parse (newContext programText) of
    Left err -> putStrLn $ "error: " ++ err
    Right prog -> do
      let codes = map instrToBinary (reverse prog)
      let bits = runPut $ mapM_ putWord32be codes
      writeBinary bits outfile

-- | Produce the binary representation of an instruction.
instrToBinary :: Instr -> Word32
instrToBinary (Instr op r n d) =
  fromIntegral $ op' .|. r' .|. n' .|. d'
  where
    op' = (op .&. 0xf) `shiftL` 28
    r' = (r .&. 0xf) `shiftL` 24
    n' = (n .&. 0xff) `shiftL` 16
    d' = d .&. 0xffff

-- | Write a bytestring to the named file.
writeBinary ::
  -- | bytes to write
  BIN.ByteString ->
  -- | name of file to write to
  String ->
  IO ()
writeBinary bits outfile = do
  hOutput <- openFile outfile WriteMode
  BIN.hPut hOutput bits
  hClose hOutput
