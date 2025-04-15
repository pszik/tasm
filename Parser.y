{
module Parser (parse, Instr (Instr)) where

import Control.Monad.State (evalStateT, lift, gets)
import Lexer (Token (..), lexer)
import ParseState (ParseState, ParseContext (lineNo))
}

%name parse 
%tokentype { Token }
%error { parseError }

%monad { ParseState }
%lexer { lexer } { EOF }

%token 
    load        { TokLoad }
    loada       { TokLoada }
    loadi       { TokLoadi }
    loadl       { TokLoadl }
    store       { TokStore }
    storei      { TokStorei }
    call        { TokCall }
    calli       { TokCalli }
    return      { TokReturn }
    push        { TokPush }
    pop         { TokPop }
    jump        { TokJump }
    jumpi       { TokJumpi }
    jumpif      { TokJumpif }
    halt        { TokHalt }
    num         { TokNum $$ }
    reg         { TokReg $$ }
    id          { TokPrimId }
    not         { TokPrimNot }
    and         { TokPrimAnd }
    or          { TokPrimOr }
    succ        { TokPrimSucc }
    pred        { TokPrimPred }
    neg         { TokPrimNeg }
    add         { TokPrimAdd }
    sub         { TokPrimSub }
    mult        { TokPrimMult }
    div         { TokPrimDiv }
    mod         { TokPrimMod }
    lt          { TokPrimLt }
    le          { TokPrimLe }
    ge          { TokPrimGe }
    gt          { TokPrimGt }
    eq          { TokPrimEq }
    ne          { TokPrimNe }
    eol         { TokPrimEol }
    eof         { TokPrimEof }
    get         { TokPrimGet }
    put         { TokPrimPut }
    geteol      { TokPrimGeteol }
    puteol      { TokPrimPuteol }
    getint      { TokPrimGetint }
    putint      { TokPrimPutint }
    new         { TokPrimNew }
    dispose     { TokPrimDispose }
    "["         { TokLBracket }
    "]"         { TokRBracket }
    "("         { TokLPar }
    ")"         { TokRPar }

%%

Prog
    : Instr                                 { [$1] } 
    | Prog Instr                            { $2 : $1 }

Instr
    : load "(" num ")" num "[" reg "]"      { Instr 0 $7 $3 $5 }
    | loada num "[" reg "]"                 { Instr 1 $4 0 $2 }
    | loadi "(" num ")"                     { Instr 2 0 $3 0 }
    | loadl num                             { Instr 3 0 0 $2 }
    | store "(" num ")" num "[" reg "]"     { Instr 4 $7 $3 $5 }
    | storei "(" num ")"                    { Instr 5 0 $3 0 }
    | call "(" reg ")" num "[" reg "]"      { Instr 6 $7 $3 $5 }
    | call Prim                             { Instr 6 2 0 $2 }
    | calli "(" reg ")"                     { Instr 7 0 $3 0 }
    | return "(" num ")" num                { Instr 8 0 $3 $5 }
    | push num                              { Instr 10 0 0 $2 }
    | pop "(" num ")" num                   { Instr 11 0 $3 $5 }
    | jump num "[" reg "]"                  { Instr 12 $4 0 $2 }
    | jumpi                                 { Instr 13 0 0 0 }
    | jumpif "(" num ")" num "[" reg "]"    { Instr 14 $7 $3 $5 }
    | halt                                  { Instr 15 0 0 0 }

Prim
    : id        { 1 }
    | not       { 2 }
    | and       { 3 }
    | or        { 4 }
    | succ      { 5 }
    | pred      { 6 }
    | neg       { 7 }
    | add       { 8 }
    | sub       { 9 }
    | mult      { 10 }
    | div       { 11 }
    | mod       { 12 }
    | lt        { 13 }
    | le        { 14 }
    | ge        { 15 }
    | gt        { 16 }
    | eq        { 17 }
    | ne        { 18 }
    | eol       { 19 }
    | eof       { 20 }
    | get       { 21 }
    | put       { 22 }
    | geteol    { 23 }
    | puteol    { 24 }
    | getint    { 25 }
    | putint    { 26 }
    | new       { 27 }
    | dispose   { 28 }

{
data Instr = Instr Int Int Int Int

parseError :: Token -> ParseState a
parseError _ = do 
    line <- gets lineNo
    lift $ Left ("parse error on line " ++ show line)
}