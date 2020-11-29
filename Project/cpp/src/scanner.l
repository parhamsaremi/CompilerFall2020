%option noyywrap
%option header-file="lex.yy.h"

%{
#include <stdio.h>
#define YY_DECL int yylex()
%}

digit [0-9]
digit16 [0-9a-fA-F]
delim [ \r\t\n\f]
ws {delim}+
char [A-Za-z]
id {char}({char}|{digit}|_)*
base10int {digit}+
base16int 0[xX]{digit16}+
integer {base10int}|{base16int}
double {digit}+\.({digit}+)?([Ee][-+]?{digit}+)?
string \"[^\"\n]*\"
op_punct_1char [+\-*\/%<>=!;,.\[\]\(\)\{\}]
comment_inline \/\/[^\n]*
comment_multiline \/\*[^(\*\/)]*\*\/

%%

{ws}+ {}

"void" {
    yyval.sval = yytext;
    return VOID;
}

"int" {
    yyval.sval = yytext;
    return INT;
}

"double" {
    yyval.sval = yytext;
    return DOUBLE;
}

"bool" {
    yyval.sval = yytext;
    return BOOL;
}

"string" {
    yyval.sval = yytext;
    return STRING;
}

"class" {
    yyval.sval = yytext;
    return CLASS;
}

"interface" {
     yyval.sval = yytext;
     return INTERFACE;
}

"null" {
    yyval.sval = yytext;
    return NULL;
}

"this" {
    yyval.sval = yytext;
    return THIS;
}

"extends" {
    yyval.sval = yytext;
    return EXTENDS;
}

"implements" {
    yyval.sval = yytext;
    return IMPLEMENTS;
}

"for" {
    yyval.sval = yytext;
    return FOR;
}

"while" {
    yyval.sval = yytext;
    return WHILE;
}

"if" {
    yyval.sval = yytext;
    return IF;
}

"else" {
    yyval.sval = yytext;
    return ELSE;
}

"return" {
     yyval.sval = yytext;
     return RETURN;
}

"break" {
      yyval.sval = yytext;
      return BREAK;
}

"continue" {
       yyval.sval = yytext;
       return CONTINUE;
}

"new" {
    yyval.sval = yytext;
    return NEW;
}

"NewArray" {
    yyval.sval = yytext;
    return NEWARRAY;
}

"print" {
    yyval.sval = yytext;
    return PRINT;
}

"ReadInteger" {
    yyval.sval = yytext;
    return READINTEGER;
}

"ReadLine" {
    yyval.sval = yytext;
    return READLINE;
}

"dtoi" {
     yyval.sval = yytext;
     return DTOI;
}

"itod" {
      yyval.sval = yytext;
      return ITOD;
}

"btoi" {
       yyval.sval = yytext;
       return BTOI;
}

"itob" {
    yyval.sval = yytext;
    return ITOB;
}

"private" {
     yyval.sval = yytext;
     return PRIVATE;
}

"protected" {
    yyval.sval = yytext;
    return PROTECTED;
}

"public" {
     yyval.sval = yytext;
     return PUBLIC;
}

"true" {
    yyval.sval = yytext;
    return TRUE;
}

"false" {
     yyval.sval = yytext;
     return FALSE;
}

{id} {
    return T_ID;
}

{integer} {
    return T_INTLITERAL;
}

{double} {
    return T_DOUBLELITERAL;
}

{string} {
    return  T_STRINGLITERAL;
}

">=" {
    yyval.sval = yytext;
    return GEQ;
}

"<=" {
    yyval.sval= yytext;
    return LEQ;s
}

">" {
    yyval.sval = yytext;
    return GR;
}

"<" {
    yyval.sval=yytext;
    return LE;
}

"/" {
    yyval.sval=yytext;
    return SLASH;
}

"+" {
    yyval.sval=yytext;
    return PLUS;
}

"-" {
    yyval.sval=yytext;
    return MINUS;
}

"*" {
    yyval.sval=yytext;
    return MUL;
}

"%" {
    yyval.sval=yytext;
    return PERCENT;
}
"=" {
    yyval.sval=yytext;
    return EQ;
}
"==" {
    yyval.sval=yytext;
    return CHECKEQ;
}
"!=" {
    yyval.sval=yytext;
    return CHECKNOTEQ;
}
"||" {
    yyval.sval=yytext;
    return OR;
}
"&&" {
    yyval.sval=yytext;
    return AND;
}
"!" {
    yyval.sval=yytext;
    return EXCLAMATION;
}
";" {
    yyval.sval=yytext;
    return SEMICOLON;
}
"," {
    yyval.sval=yytext;
    return COLON;
}
"." {
    yyval.sval=yytext;
    return DOT;
}
"[" {
    yyval.sval=yytext;
    return OPENBRACE;
}
"]" {
    yyval.sval=yytext;
    return CLOSEBRACE;
}
"(" {
    yyval.sval=yytext;
    return OPENPAR;
}
")" {
    yyval.sval=yytext;
    return CLOSEPAR;
}
"{" {
    yyval.sval=yytext;
    return OPENBRACE;
}
"}" {
    yyval.sval=yytext;
    return CLOSEBRACE;
}

{comment_inline}|{comment_multiline} {}

. {fprintf(yyout, "UNDEFINED_TOKEN\n"); return 0;}


%%
