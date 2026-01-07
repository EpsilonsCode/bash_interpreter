import java_cup.runtime.*;

%%

%state ASSIGN_VALUE

%cup

%%

<YYINITIAL> {
    // Commands
    echo       { return new Symbol(sym.ECHO_KEYWORD); }
    cat        { return new Symbol(sym.CAT_KEYWORD); }
    wc         { return new Symbol(sym.WC_KEYWORD); }

    for       { return new Symbol(sym.FOR_KEYWORD); }
    in        { return new Symbol(sym.IN_KEYWORD); }
    do         { return new Symbol(sym.DO_KEYWORD); }
    done         { return new Symbol(sym.DONE_KEYWORD); }

    "$(" { return new Symbol(sym.OPEN_PARENTHESIS); }
    ")" { return new Symbol(sym.CLOSE_PARENTHESIS); }
    "&&" { return new Symbol(sym.AND); }
    "||" { return new Symbol(sym.OR); }
    // Redirects
    ">>"       { return new Symbol(sym.DOUBLE_GREATER); }
    ">"        { return new Symbol(sym.GREATER); }

    // Line terminators
    [\r\n]+   { return new Symbol(sym.NEW_LINE); }
    ";"       { return new Symbol(sym.SEMICOLON); }

    // Last exit code
    "$?"   { return new Symbol(sym.LAST_CODE); }

    // Comments / strings
    \"([^\"\\]|\\.|[\r\n])*\" {
        String text = yytext();
        text = text.substring(1, text.length() - 1);
        text = text.replace("\\\\", "\\").replace("\\\"", "\"");
        return new Symbol(sym.COMMENT, text);
    }

    // Assignment start: matches name= and switches state
    [a-zA-Z_][a-zA-Z0-9_]*= {
        String text = yytext();
        text = text.substring(0, text.length() - 1); // remove '='
        yybegin(ASSIGN_VALUE); // switch to value-reading mode
        return new Symbol(sym.ASSIGN_NAME, text);   // new token for "name="
    }

    // Regular identifier
    [a-zA-Z0-9_.-]+ { return new Symbol(sym.IDENTIFIER, yytext()); }

    \$[a-zA-Z_][a-zA-Z0-9_]* { return new Symbol(sym.VARIABLE, yytext().substring(1, yytext().length())); }

    // Skip horizontal spaces
    [ \t]+  { /* skip */ }
}

// ======================
// ASSIGN VALUE MODE
// ======================
<ASSIGN_VALUE> {
    // Last exit code
    "$?"   {
     yybegin(YYINITIAL);
     return new Symbol(sym.LAST_CODE);
      }

    // Comments / strings
    \"([^\"\\]|\\.|[\r\n])*\" {
     yybegin(YYINITIAL);
        String text = yytext();
        text = text.substring(1, text.length() - 1);
        text = text.replace("\\\\", "\\").replace("\\\"", "\"");
        return new Symbol(sym.COMMENT, text);
    }

        // Regular identifier
        [a-zA-Z0-9_.-]+ {
         yybegin(YYINITIAL);
         return new Symbol(sym.IDENTIFIER, yytext());
          }

            \$[a-zA-Z_][a-zA-Z0-9_]* {
             yybegin(YYINITIAL);
            return new Symbol(sym.VARIABLE, yytext().substring(1, yytext().length()));
             }

    // Anything else (including space) is an error
    .|[ \t\r\n]+ {
        throw new Error("Invalid value after '=' in assignment: '" + yytext() + "'");
    }
}