Create a lexical analyzer that will parse a made up language. Each token is defined below:
```
 Identifier -> ( letter | _ ) { letter | digit | _ }

 Number -> digit { digit }

 String -> " { char_not_quotes | \" } "

 End_Token -> ?

 Operator -> nonwhitechar_notLetter_notDigit_not?not"not_not#  |
             two_char_op | three_char_op

 two_char_op -> += | -= | *= | /= | <= | >= | == | != | ~= | ^= | %= | &= | |= | ..

 three_char_op -> ...
```
The End_Token is the termination character for the program.
Wherever it appears (except in a string or comment), it signals 
the end of the program.
For simplicity, assume the input will always have an end character.

If a String doesn't terminate before the end of the line, it is
recognized as a bad string.  Everything else "tokenizes.”

A comment starts with a # and continues to the end of the line.
Tokens are terminated by whitespace or when the pattern no longer matches.
The keywords and their integer representations are:

         "begin" => 1,
         "end" => 2,
         "require" => 3,
         "def" => 4,
         "class" => 5,
         "if" => 6,
         "while" => 7,
         "else" => 8,
         "elsif" => 9,
         "for" => 10,
         "return" => 11,
         "and" => 12,
         "or" => 13

-------------------------------------------------------------
Your program must parse the given input defined in "input.in"
Your program must match the given sample output defined in "sample_output.out"

Note: Use of any version of Antlr is prohibited for this challenge!
