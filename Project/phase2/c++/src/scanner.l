%option noyywrap
%option header-file="lex.yy.h"

%{
#include <stdio.h>
#include "parser.tab.h"
#define YY_DECL int yylex()
int linenumber=0;
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
    
    linenumber++;
    return VOID;
}

"int" {
    
    linenumber++;
    return INT;
}

"double" {
    
    linenumber++;
    return DOUBLE;
}

"bool" {
    
    linenumber++;
    return BOOL;
}

"string" {
    
    linenumber++;
    return STRING;
}

"class" {
    
    linenumber++;
    return CLASS;
}

"interface" {
     
     linenumber++;
    return INTERFACE;
}

"null" {
    
    linenumber++;
    return NULL1;
}

"this" {
    
    linenumber++;
    return THIS;
}

"extends" {
    
    linenumber++;
    return EXTENDS;
}

"implements" {
    
    linenumber++;
    return IMPLEMENTS;
}

"for" {
    
    linenumber++;
    return FOR;
}

"while" {
    
    linenumber++;
    return WHILE;
}

"if" {
    
    linenumber++;
    return IF;
}

"else" {
    
    linenumber++;
    return ELSE;
}

"return" {
     
    linenumber++;
    return RETURN;
}

"break" {
      
    linenumber++;
    return BREAK;
}

"continue" {
    linenumber++;
    return CONTINUE;
}

"new" {
    
    linenumber++;
    return NEW;
}

"NewArray" {
    
    linenumber++;
    return NEWARRAY;
}

"print" {
    
    linenumber++;
    return PRINT;
}

"ReadInteger" {
    
    linenumber++;
    return READINTEGER;
}

"ReadLine" {
    
    linenumber++;
    return READLINE;
}

"dtoi" {
     
     linenumber++;
    return DTOI;
}

"itod" {
      
      linenumber++;
    return ITOD;
}

"btoi" {
       
       linenumber++;
    return BTOI;
}

"itob" {
    
    linenumber++;
    return ITOB;
}

"private" {
     
     linenumber++;
    return PRIVATE;
}

"protected" {
    
    linenumber++;
    return PROTECTED;
}

"public" {
     
     linenumber++;
    return PUBLIC;
}


"true"|"false" {
    linenumber++;
    return T_BOOLEANLITERAL;
}

{id} {
    linenumber++;
    return T_ID;
}

{integer} {
    linenumber++;
    return T_INTLITERAL;
}

{double} {
    linenumber++;
    return T_DOUBLELITERAL;
}

{string} {
    linenumber++;
    return  T_STRINGLITERAL;
}

">=" {
    
    linenumber++;
    return GEQ;
}

"<=" {
    linenumber++;
    return LEQ;
}

">" {
    
    linenumber++;
    return GR;
}

"<" {

    linenumber++;
    return LE;
}

"/" {

    linenumber++;
    return SLASH;
}

"+" {

    linenumber++;
    return PLUS;
}

"-" {

    linenumber++;
    return MINUS;
}

"*" {

    linenumber++;
    return MUL;
}

"%" {

    linenumber++;
    return PERCENT;
}
"=" {

    linenumber++;
    return EQ;
}
"==" {

    linenumber++;
    return CHECKEQ;
}
"!=" {

    linenumber++;
    return CHECKNOTEQ;
}
"||" {

    linenumber++;
    return OR;
}
"&&" {

    linenumber++;
    return AND;
}
"!" {

    linenumber++;
    return EXCLAMATION;
}
";" {

    linenumber++;
    return SEMICOLON;
}
"," {

    linenumber++;
    return COLON;
}
"." {

    linenumber++;
    return DOT;
}
"[" {

    linenumber++;
    return OPENBRACK;
}
"]" {

    linenumber++;
    return CLOSEBRACK;
}
"(" {

    linenumber++;
    return OPENPAR;
}
")" {

    linenumber++;
    return CLOSEPAR;
}
"{" {

    linenumber++;
    return OPENBRACE;
}
"}" {

    linenumber++;
    return CLOSEBRACE;
}

{comment_inline}|{comment_multiline} {}

. {return UNDEFINED;}


%%