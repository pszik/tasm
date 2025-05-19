grammar Tasm;

program: instruction+ EOF;

instruction
  : 'LOAD' '(' n=NUMBER ')' d=offset '[' r=REGISTER ']'         # loadInstr
  | 'LOADA' d=offset '[' r=REGISTER ']'                       # loadaInstr
  ;

offset
  : NUMBER
  | '-' NUMBER
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
  ;

fragment DIGIT: [0-9];
fragment HEXDIGIT: [0-9a-fA-F];

NUMBER: DIGIT+;