module Lexer (Token (..), lexer) where

import Control.Applicative (Alternative ((<|>)))
import Control.Monad.State (gets, lift)
import Data.Char (isDigit, isSpace)
import Data.List (isPrefixOf)
import ParseState
  ( ParseContext (lineNo, programText),
    ParseState,
    skipWhitespace,
    updateText,
  )
import Text.Printf (printf)

data Token
  = TokLoad
  | TokLoada
  | TokLoadi
  | TokLoadl
  | TokStore
  | TokStorei
  | TokCall
  | TokCalli
  | TokReturn
  | TokPush
  | TokPop
  | TokJump
  | TokJumpi
  | TokJumpif
  | TokHalt
  | TokLPar
  | TokRPar
  | TokLBracket
  | TokRBracket
  | TokNum Int
  | TokReg Int
  | EOF

lexer :: (Token -> ParseState a) -> ParseState a
lexer f = do
  skipWhitespace
  txt <- gets programText
  case txt of
    "" -> f EOF
    ('[' : txt') -> updateText txt' >> f TokLBracket
    (']' : txt') -> updateText txt' >> f TokRBracket
    ('(' : txt') -> updateText txt' >> f TokLPar
    (')' : txt') -> updateText txt' >> f TokRPar
    _ -> do
      (tok, txt') <- lexInstruction txt <|> lexRegister txt <|> lexNumber txt
      updateText txt'
      f tok

lexInstruction :: String -> ParseState (Token, String)
lexInstruction cs
  | "LOADA" `isPrefixOf` cs = return (TokLoada, drop 5 cs)
  | "LOADI" `isPrefixOf` cs = return (TokLoadi, drop 5 cs)
  | "LOADL" `isPrefixOf` cs = return (TokLoadl, drop 5 cs)
  | "LOAD" `isPrefixOf` cs = return (TokLoad, drop 4 cs)
  | "STOREI" `isPrefixOf` cs = return (TokStorei, drop 6 cs)
  | "STORE" `isPrefixOf` cs = return (TokStore, drop 5 cs)
  | "CALLI" `isPrefixOf` cs = return (TokCalli, drop 5 cs)
  | "CALL" `isPrefixOf` cs = return (TokCall, drop 4 cs)
  | "RETURN" `isPrefixOf` cs = return (TokReturn, drop 6 cs)
  | "PUSH" `isPrefixOf` cs = return (TokPush, drop 4 cs)
  | "POP" `isPrefixOf` cs = return (TokPop, drop 3 cs)
  | "JUMPIF" `isPrefixOf` cs = return (TokJumpif, drop 6 cs)
  | "JUMPI" `isPrefixOf` cs = return (TokJumpi, drop 5 cs)
  | "JUMP" `isPrefixOf` cs = return (TokJump, drop 4 cs)
  | "HALT" `isPrefixOf` cs = return (TokHalt, drop 4 cs)
  | otherwise = do err <- makeError cs; lift $ Left err

lexRegister :: String -> ParseState (Token, String)
lexRegister cs =
  let (r, txt') = splitAt 2 cs
   in case r of
        "CB" -> return (TokReg 0, txt')
        "CT" -> return (TokReg 1, txt')
        "PB" -> return (TokReg 2, txt')
        "PT" -> return (TokReg 3, txt')
        "SB" -> return (TokReg 4, txt')
        "ST" -> return (TokReg 5, txt')
        "HB" -> return (TokReg 6, txt')
        "HT" -> return (TokReg 7, txt')
        "LB" -> return (TokReg 8, txt')
        "L1" -> return (TokReg 9, txt')
        "L2" -> return (TokReg 10, txt')
        "L3" -> return (TokReg 11, txt')
        "L4" -> return (TokReg 12, txt')
        "L5" -> return (TokReg 13, txt')
        "L6" -> return (TokReg 14, txt')
        "CP" -> return (TokReg 15, txt')
        _ -> do err <- makeError cs; lift $ Left err

lexNumber :: String -> ParseState (Token, String)
lexNumber "" = return (EOF, "")
lexNumber txt@(c : cs)
  | isDigit c =
      let (ns, txt') = span isDigit txt
       in return (TokNum (read ns), txt')
  | c == '-' && isDigit (head cs) =
      let (ns, txt') = span isDigit cs
       in return (TokNum (-(read ns)), txt')
  | otherwise = do err <- makeError txt; lift $ Left err

makeError :: String -> ParseState String
makeError cs = do
  line <- gets lineNo
  let sym = takeWhile (not . isSpace) cs
  return $ printf "unrecognised symbol '%s' on line %d" sym line