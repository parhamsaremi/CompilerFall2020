%option noyywrap
%option header-file="lex.yy.h"

%{
#include <stdio.h>
#include "parser.tab.h"
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
    
    return VOID;
}

"int" {
    
    return INT;
}

"double" {
    
    return DOUBLE;
}

"bool" {
    
    return BOOL;
}

"string" {
    
    return STRING;
}

"class" {
    
    return CLASS;
}

"interface" {
     
     return INTERFACE;
}

"null" {
    
    return NULL1;
}

"this" {
    
    return THIS;
}

"extends" {
    
    return EXTENDS;
}

"implements" {
    
    return IMPLEMENTS;
}

"for" {
    
    return FOR;
}

"while" {
    
    return WHILE;
}

"if" {
    
    return IF;
}

"else" {
    
    return ELSE;
}

"return" {
     
    return RETURN;
}

"break" {
      
    return BREAK;
}

"continue" {
    return CONTINUE;
}

"new" {
    
    return NEW;
}

"NewArray" {
    
    return NEWARRAY;
}

"print" {
    
    return PRINT;
}

"ReadInteger" {
    
    return READINTEGER;
}

"ReadLine" {
    
    return READLINE;
}

"dtoi" {
     
     return DTOI;
}

"itod" {
      
      return ITOD;
}

"btoi" {
       
       return BTOI;
}

"itob" {
    
    return ITOB;
}

"private" {
     
     return PRIVATE;
}

"protected" {
    
    return PROTECTED;
}

"public" {
     
     return PUBLIC;
}


"true"|"false" {
    return T_BOOLEANLITERAL;
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
    
    return GEQ;
}

"<=" {
    return LEQ;
}

">" {
    
    return GR;
}

"<" {

    return LE;
}

"/" {

    return SLASH;
}

"+" {

    return PLUS;
}

"-" {

    return MINUS;
}

"*" {

    return MUL;
}

"%" {

    return PERCENT;
}
"=" {

    return EQ;
}
"==" {

    return CHECKEQ;
}
"!=" {

    return CHECKNOTEQ;
}
"||" {

    return OR;
}
"&&" {

    return AND;
}
"!" {

    return EXCLAMATION;
}
";" {

    return SEMICOLON;
}
"," {

    return COLON;
}
"." {

    return DOT;
}
"[" {

    return OPENBRACE;
}
"]" {

    return CLOSEBRACE;
}
"(" {

    return OPENPAR;
}
")" {

    return CLOSEPAR;
}
"{" {

    return OPENBRACE;
}
"}" {

    return CLOSEBRACE;
}

{comment_inline}|{comment_multiline} {}

. {fprintf(yyout, "UNDEFINED_TOKEN\n"); return 0;}


%%