grammar Tasm;

program: instruction+ EOF;

instruction
  : 'LOAD' '(' n=NUMBER ')' d=offset '[' r=REGISTER ']'         # loadInstr
  | 'LOADA' d=offset '[' r=REGISTER ']'                         # loadaInstr
  | 'LOADI' '(' n=NUMBER ')'                                    # loadiInstr
  | 'LOADL' d=offset                                            # loadlInstr
  | 'STORE' '(' n=NUMBER ')' d=offset '[' r=REGISTER ']'        # storeInstr
  | 'STOREI' '(' n=NUMBER ')'                                   # storeiInstr
  | 'CALL' '(' n=REGISTER ')' d=offset '[' r=REGISTER ']'       # callInstr
  | 'CALL' PRIMITIVE                                            # callPrimitiveInstr
  | 'CALLI'                                                     # calliInstr
  | 'RETURN' '(' n=NUMBER ')' d=NUMBER                          # returnInstr
  | 'PUSH' d=NUMBER                                             # pushInstr
  | 'POP' '(' n=NUMBER ')' d=NUMBER                             # popInstr
  | 'JUMP' d=offset '[' r=REGISTER ']'                          # jumpInstr
  | 'JUMPI'                                                     # jumpiInstr
  | 'JUMPIF' '(' n=NUMBER ')' d=offset '[' r=REGISTER ']'       # jumpifInstr
  | 'HALT'                                                      # haltInstr
  ;

offset
  : NUMBER
  | NEGNUMBER
  ;

REGISTER
  : 'CB'
  | 'CT'
  | 'PB'
  | 'PT'
  | 'SB'
  | 'ST'
  | 'HB'
  | 'HT'
  | 'LB'
  | 'L1'
  | 'L2'
  | 'L3'
  | 'L4'
  | 'L5'
  | 'L6'
  | 'CP'
  ;

PRIMITIVE
  : 'id'
  | 'not'
  | 'and'
  | 'or'
  | 'succ'
  | 'pred'
  | 'neg'
  | 'add'
  | 'sub'
  | 'mult'
  | 'div'
  | 'mod'
  | 'lt'
  | 'le'
  | 'ge'
  | 'gt'
  | 'eq'
  | 'ne'
  | 'eol'
  | 'eof'
  | 'get'
  | 'put'
  | 'geteol'
  | 'puteol'
  | 'getint'
  | 'putint'
  | 'new'
  | 'dispose'
  ;

fragment DIGIT: [0-9];

NUMBER: DIGIT+;
NEGNUMBER: '-' NUMBER;

COMMENT: ';' .*? '\n' -> skip;
WS: [ \t\r\n] -> skip;