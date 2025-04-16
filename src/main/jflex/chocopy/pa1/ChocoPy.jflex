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

%state LINE_START

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
    /*inicio da pilha de indentação no nivel zero*/
    private java.util.Stack<Integer> indentStack = new java.util.Stack<>();
    private int pendingDedents = 0;
    private boolean emitNewline = false;
    private boolean startOfLine = true;

    {
        indentStack.push(0);
    }
    /* contador de whitespaces no inicio da linha*/
    private int computeIndentation(String line) {
        int count = 0;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == ' ') count++;
            else if (c == '\t') count += 8 - (count % 8);
            else break;
        }
        return count;
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
Comment: 
No item 3.1.3 diz: A comment starts with a hash character (#) that is not part of a string literal, and ends at the end of the
physical line. Comments are ignored by the lexical analyzer; they are not emitted as tokens.
E seguindo o 3.1.1 que diz que uma linha pode ser \n, \r ou \r\n
*/
Comment = #[^\n\r]*

/* TODO
- NEWLINE, INDENT, DEDENT (usar variavel global, entender melhor no item 3.1.5).
*/

%%


<YYINITIAL> {
    // Gera dedents pendentes
    if (pendingDedents > 0) {
        pendingDedents--;
        return symbol(ChocoPyTokens.DEDENT);
    }
    /* Whitespace. */
    {WhiteSpace}                { /* ignore */ }

    /* Comment. */
    {Comment}                   { /* ignore */ }

    /* Delimiters */
    {LineBreak} {
        emitNewline = true;
        startOfLine = true;
        yybegin(LINE_START);
    }
  
	/* Operators (item 3.5 da documentação) */
	/* + - * // % < > <= >= == != = ( ) [ ] , : . -> */
    "+"                         { return symbol(ChocoPyTokens.PLUS, yytext()); }
    "-"                         { return symbol(ChocoPyTokens.MINUS, yytext()); }
    "*"                         { return symbol(ChocoPyTokens.STAR, yytext()); }
    "//"                        { return symbol(ChocoPyTokens.DOUBLE_SLASH, yytext()); }
    "%"                         { return symbol(ChocoPyTokens.PERCENT, yytext()); }
    "<"                         { return symbol(ChocoPyTokens.LESS_THAN, yytext()); }
    ">"                         { return symbol(ChocoPyTokens.GREATER_THAN, yytext()); }
    "<="                        { return symbol(ChocoPyTokens.LESS_THAN_EQUAL, yytext()); }
    ">="                        { return symbol(ChocoPyTokens.GREATER_THAN_EQUAL, yytext()); }
    "=="                        { return symbol(ChocoPyTokens.EQUAL_EQUAL, yytext()); }
    "!="                        { return symbol(ChocoPyTokens.NOT_EQUALS, yytext()); }
    "="                         { return symbol(ChocoPyTokens.ASSIGN, yytext()); }
    "("                         { return symbol(ChocoPyTokens.LEFT_PAREN, yytext()); }
    ")"                         { return symbol(ChocoPyTokens.RIGHT_PAREN, yytext()); }
    "["                         { return symbol(ChocoPyTokens.LEFT_BRACKET, yytext()); }
    "]"                         { return symbol(ChocoPyTokens.RIGHT_BRACKET, yytext()); }
    ","                         { return symbol(ChocoPyTokens.COMMA, yytext()); }
    ":"                         { return symbol(ChocoPyTokens.COLON, yytext()); }
    "."                         { return symbol(ChocoPyTokens.DOT, yytext()); }
    "->"                        { return symbol(ChocoPyTokens.RIGHT_ARROW, yytext()); }


	/* TODO Keywords (item 3.3 da documentação) */
    "False"                     { return symbol(ChocoPyTokens.FALSE, yytext()); }
    "None"                      { return symbol(ChocoPyTokens.NONE, yytext()); }
    "True"                      { return symbol(ChocoPyTokens.TRUE, yytext()); }
    "and"                       { return symbol(ChocoPyTokens.AND, yytext()); }
    "as"                        { return symbol(ChocoPyTokens.AS, yytext()); }
    "assert"                    { return symbol(ChocoPyTokens.ASSERT, yytext()); }
    "async"                     { return symbol(ChocoPyTokens.ASYNC, yytext()); }
    "await"                     { return symbol(ChocoPyTokens.AWAIT, yytext()); }
    "break"                     { return symbol(ChocoPyTokens.BREAK, yytext()); }
    "class"                     { return symbol(ChocoPyTokens.CLASS, yytext()); }
    "continue"                  { return symbol(ChocoPyTokens.CONTINUE, yytext()); }
    "def"                       { return symbol(ChocoPyTokens.DEF, yytext()); }
    "del"                       { return symbol(ChocoPyTokens.DEL, yytext()); }
    "elif"                      { return symbol(ChocoPyTokens.ELIF, yytext()); }
    "else"                      { return symbol(ChocoPyTokens.ELSE, yytext()); }
    "except"                    { return symbol(ChocoPyTokens.EXCEPT, yytext()); }
    "finally"                   { return symbol(ChocoPyTokens.FINALLY, yytext()); }
    "for"                       { return symbol(ChocoPyTokens.FOR, yytext()); }
    "from"                      { return symbol(ChocoPyTokens.FROM, yytext()); }
    "global"                    { return symbol(ChocoPyTokens.GLOBAL, yytext()); }
    "if"                        { return symbol(ChocoPyTokens.IF, yytext()); }
    "import"                    { return symbol(ChocoPyTokens.IMPORT, yytext()); }
    "in"                        { return symbol(ChocoPyTokens.IN, yytext()); }
    "is"                        { return symbol(ChocoPyTokens.IS, yytext()); }
    "lambda"                    { return symbol(ChocoPyTokens.LAMBDA, yytext()); }
    "nonlocal"                  { return symbol(ChocoPyTokens.NONLOCAL, yytext()); }
    "not"                       { return symbol(ChocoPyTokens.NOT, yytext()); }
    "or"                        { return symbol(ChocoPyTokens.OR, yytext()); }
    "pass"                      { return symbol(ChocoPyTokens.PASS, yytext()); }
    "raise"                     { return symbol(ChocoPyTokens.RAISE, yytext()); }
    "return"                    { return symbol(ChocoPyTokens.RETURN, yytext()); }
    "try"                       { return symbol(ChocoPyTokens.TRY, yytext()); }
    "while"                     { return symbol(ChocoPyTokens.WHILE, yytext()); }
    "with"                      { return symbol(ChocoPyTokens.WITH, yytext()); }
    "yield"                     { return symbol(ChocoPyTokens.YIELD, yytext()); }

  /*
  Literal: to denote a constant literal such as an integer literal, a string literal.
  */
    {IntegerLiteral}            { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
    {StringLiteral}             { return symbol(ChocoPyTokens.STRING, yytext()); }

  /* Identifiers */
    {IdString}                  { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

}
<LINE_START> {
    {WhiteSpace}* {
        String indentText = yytext();
        int currentIndent = computeIndentation(indentText);

        int lookahead;
        try {
            lookahead = yycharat(yylength());
        } catch (Exception e) {
            lookahead = -1;
        }
        // Leia o próximo caractere para ver se a linha é vazia/comentário
        if (lookahead == '#' || lookahead == '\n' || lookahead == '\r' || lookahead == -1) {
            startOfLine = false;
            yybegin(YYINITIAL);
        } else {
            int prevIndent = indentStack.peek();
            if (currentIndent == prevIndent) {
                if (emitNewline) {
                    emitNewline = false;
                    yybegin(YYINITIAL);
                    return symbol(ChocoPyTokens.NEWLINE);
                }
                yybegin(YYINITIAL);
            } else if (currentIndent > prevIndent) {
                indentStack.push(currentIndent);
                yybegin(YYINITIAL);
                return symbol(ChocoPyTokens.INDENT);
            } else {
                pendingDedents = 0;
                while (indentStack.peek() > currentIndent) {
                    indentStack.pop();
                    pendingDedents++;
                }
                if (indentStack.peek() != currentIndent) {
                    throw new Error("Indentation Error");
                }
                if (emitNewline) {
                    emitNewline = false;
                    return symbol(ChocoPyTokens.NEWLINE);
                }
                if (pendingDedents > 0) {
                    pendingDedents--;
                    return symbol(ChocoPyTokens.DEDENT);
                }
                yybegin(YYINITIAL);
            }
        }
    }
}

<<EOF>>                       {
  while (indentStack.size() > 1) {
        indentStack.pop();
        return symbol(ChocoPyTokens.DEDENT);
    }
    return symbol(ChocoPyTokens.EOF);
}

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }


/*
links importantes:
https://jflex.de/manual.html
https://classroom.google.com/c/NzU5OTA0OTQ1NDA1/m/NzU5OTM1NTExMzk2/details
https://docs.google.com/document/d/1wqPQzb4nLzOB8LDCB8lRMzFOSLDb0n4tsnLgZQOu8AY/edit?tab=t.0
https://github.com/compilers-uff/lexer-e-parser-grupo-13
*/