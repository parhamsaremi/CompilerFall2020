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

"void"|"int"|"double"|"bool"|"string"|"class"|"interface" {fprintf(yyout, "%s\n",yytext);}
"null"|"this"|"extends"|"implements"|"for"|"while"|"if" {fprintf(yyout,"%s\n",yytext);}
"else"|"return"|"break"|"continue"|"new"|"NewArray"|"Print" {fprintf(yyout, "%s\n",yytext);}
"ReadInteger"|"ReadLine"|"dtoi"|"itod"|"btoi"|"itob"|"private" {fprintf(yyout,"%s\n",yytext);}
"protected"|"public" {fprintf(yyout,"%s\n",yytext);}

"true"|"false" {fprintf(yyout, "T_BOOLEANLITERAL %s\n",yytext);}

{id} {fprintf(yyout,"T_ID %s\n",yytext);}

{integer} {fprintf(yyout,"T_INTLITERAL %s\n",yytext);}

{double} {fprintf(yyout,"T_DOUBLELITERAL %s\n",yytext);}

{string} {fprintf(yyout,"T_STRINGLITERAL %s\n",yytext);}

{op_punct_1char}|"<="|">="|"=="|"!="|"||"|"&&" {fprintf(yyout,"%s\n",yytext);}

{comment_inline}|{comment_multiline} {}

. {fprintf(yyout, "UNDEFINED_TOKEN\n"); return 0;}

%%
