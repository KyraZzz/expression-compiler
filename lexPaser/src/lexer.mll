{
  open Parser
}
let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let id = letter+
let semicolon = ';'

(* pattern matching follows the order *)
rule read = 
  parse
  | white { read lexbuf }
  | "true" { TRUE }
  | "false" { FALSE }
  | "=>" { MAPTO }
  | "<=" { LEQ }
  | "*" { TIMES }
  | "+" { PLUS }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "[" { SLPAREN }
  | "]" { SRPAREN }
  | "fn" { FUNCT }
  | "let" { LET }
  | "rec" { REC }
  | "=" { EQUALS }
  | semicolon { SEMICOLON }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "skip" { SKIP }
  | "while" { WHILE }
  | "do" { DO }
  | id { ID (Lexing.lexeme lexbuf) }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }