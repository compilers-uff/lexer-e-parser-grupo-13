package chocopy.pa1;
import java_cup.runtime.*;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
    }

%}

/* Macros (regexes used in rules below) */

WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n

IntegerLiteral = 0 | [1-9][0-9]*

DoubleQuote = \"
Backslash = \\
/* 
Segundo ao item 3.4.1 da documentação, são aceitos os caracteres ASCII: [32-126, menos \ e "]
32 = \u0020
126 = \u007E
\ = \u0022
" = \u005C
*/
AsciiChar = [\u0020-\u0021\u0023-\u005B\u005D-\u007E]

/* 
Ainda no item 3.4.1 da documentação, são aceitos somente as seguintes sequencias de escape:
\" = double quote
\n = newline
\t = tab
\\ = backslash
*/
EscapedChar = {Backslash}([\"nt\\])

/*
Juntando temos a StringLiteral.
*/
StringLiteral = {DoubleQuote}({AsciiChar}|{EscapedChar})*{DoubleQuote}

/*
Identifier: o nome de variavel ou função
*/
IdString = [_a-zA-Z][_a-z0-9A-Z]*

/*
Comment: Comentário de linha única (sem multiline) -> python regex equivalent -> (?P<comment>#.*#)
*/
Comment = #.*#

/* TODO
- NEWLINE, INDENT, DEDENT (usar variavel global, entender melhor no item 3.1.5).
*/

%%


<YYINITIAL> {

  /* Delimiters */
    {LineBreak}                 { return symbol(ChocoPyTokens.NEWLINE); }

  /* Operators (item 3.5 da documentação) */
  /* + - * // % < > <= >= == != = ( ) [ ] , : . -> */
    "+"                         { return symbol(ChocoPyTokens.PLUS); }
    "-"                         { return symbol(ChocoPyTokens.MINUS); }
    "*"                         { return symbol(ChocoPyTokens.STAR); }
    "//"                        { return symbol(ChocoPyTokens.DOUBLE_SLASH); }
    "%"                         { return symbol(ChocoPyTokens.PERCENT); }
    "<"                         { return symbol(ChocoPyTokens.LESS_THAN); }
    ">"                         { return symbol(ChocoPyTokens.GREATER_THAN); }
    "<="                        { return symbol(ChocoPyTokens.LESS_THAN_EQUAL); }
    ">="                        { return symbol(ChocoPyTokens.GREATER_THAN_EQUAL); }
    "=="                        { return symbol(ChocoPyTokens.EQUAL_EQUAL); }
    "!="                        { return symbol(ChocoPyTokens.NOT_EQUAL); }
    "="                         { return symbol(ChocoPyTokens.ASSIGN); }
    "("                         { return symbol(ChocoPyTokens.LEFT_PAREN); }
    ")"                         { return symbol(ChocoPyTokens.RIGHT_PAREN); }
    "["                         { return symbol(ChocoPyTokens.LEFT_BRACKET); }
    "]"                         { return symbol(ChocoPyTokens.RIGHT_BRACKET); }
    ","                         { return symbol(ChocoPyTokens.COMMA); }
    ":"                         { return symbol(ChocoPyTokens.COLON); }
    "."                         { return symbol(ChocoPyTokens.DOT); }
    "->"                        { return symbol(ChocoPyTokens.ARROW); }

  /* Whitespace. */
    {WhiteSpace}                { /* ignore */ }

  /* TODO Keywords (item 3.3 da documentação) */
    "False"                     { return symbol(ChocoPyTokens.FALSE); }
    "None"                      { return symbol(ChocoPyTokens.NONE); }
    "True"                      { return symbol(ChocoPyTokens.TRUE); }
    "and"                       { return symbol(ChocoPyTokens.AND); }
    "as"                        { return symbol(ChocoPyTokens.AS); }
    "assert"                    { return symbol(ChocoPyTokens.ASSERT); }
    "async"                     { return symbol(ChocoPyTokens.ASYNC); }
    "await"                     { return symbol(ChocoPyTokens.AWAIT); }
    "break"                     { return symbol(ChocoPyTokens.BREAK); }
    "class"                     { return symbol(ChocoPyTokens.CLASS); }
    "continue"                  { return symbol(ChocoPyTokens.CONTINUE); }
    "def"                       { return symbol(ChocoPyTokens.DEF); }
    "del"                       { return symbol(ChocoPyTokens.DEL); }
    "elif"                      { return symbol(ChocoPyTokens.ELIF); }
    "else"                      { return symbol(ChocoPyTokens.ELSE); }
    "except"                    { return symbol(ChocoPyTokens.EXCEPT); }
    "finally"                   { return symbol(ChocoPyTokens.FINALLY); }
    "for"                       { return symbol(ChocoPyTokens.FOR); }
    "from"                      { return symbol(ChocoPyTokens.FROM); }
    "global"                    { return symbol(ChocoPyTokens.GLOBAL); }
    "if"                        { return symbol(ChocoPyTokens.IF); }
    "import"                    { return symbol(ChocoPyTokens.IMPORT); }
    "in"                        { return symbol(ChocoPyTokens.IN); }
    "is"                        { return symbol(ChocoPyTokens.IS); }
    "lambda"                    { return symbol(ChocoPyTokens.LAMBDA); }
    "nonlocal"                  { return symbol(ChocoPyTokens.NONLOCAL); }
    "not"                       { return symbol(ChocoPyTokens.NOT); }
    "or"                        { return symbol(ChocoPyTokens.OR); }
    "pass"                      { return symbol(ChocoPyTokens.PASS); }
    "raise"                     { return symbol(ChocoPyTokens.RAISE); }
    "return"                    { return symbol(ChocoPyTokens.RETURN); }
    "try"                       { return symbol(ChocoPyTokens.TRY); }
    "while"                     { return symbol(ChocoPyTokens.WHILE); }
    "with"                      { return symbol(ChocoPyTokens.WITH); }
    "yield"                     { return symbol(ChocoPyTokens.YIELD); }

  /*
  Literal: to denote a constant literal such as an integer literal, a string literal.
  */
    {IntegerLiteral}            { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
    {StringLiteral}             { return symbol(ChocoPyTokens.STRING, yytext()); }

  /* Identifiers */
    {IdString}                  { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

}

<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }


/*
links importantes:
https://jflex.de/manual.html
https://classroom.google.com/c/NzU5OTA0OTQ1NDA1/m/NzU5OTM1NTExMzk2/details
https://docs.google.com/document/d/1wqPQzb4nLzOB8LDCB8lRMzFOSLDb0n4tsnLgZQOu8AY/edit?tab=t.0
https://github.com/compilers-uff/lexer-e-parser-grupo-13
*/