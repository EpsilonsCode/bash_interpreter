import java_cup.runtime.*;

%%

%cup

%%



echo { return new Symbol(sym.ECHO_KEYWORD); }
cat { return new Symbol(sym.CAT_KEYWORD); }
wc { return new Symbol(sym.WC_KEYWORD); }

>> { return new Symbol(sym.DOUBLE_GREATER); }
> { return new Symbol(sym.GREATER); }


[\r\n]+ { return new Symbol(sym.NEW_LINE); }
";" { return new Symbol(sym.SEMICOLON); }

"$?" { return new Symbol(sym.LAST_CODE); }

\"([^\"\\]|\\.|[\r\n])*\" {
    String text = yytext();
    text = text.substring(1, text.length() - 1);
    text = text.replace("\\\\", "\\").replace("\\\"", "\"");
    return new Symbol(sym.COMMENT, text);
}

[a-zA-Z0-9_.-]+ { return new Symbol(sym.IDENTIFIER, yytext()); }



\s { /* nic */ }

"="                       { return new Symbol(sym.EQUAL); }
