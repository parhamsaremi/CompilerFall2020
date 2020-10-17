%{
#include <stdio.h>
%}

%optionyylineno
%optionyywrap

digit [0-9]
digit16 [0-9a-fA-F]
delim [ \t\n]
ws {delim}+
char [A-Za-z]
id {char}({char}|{digit}|_)*
base10int {digit}+
base16int 0[xX]{digit16}+
integer {base10int}|{base16int}
double {digit}+\.({digit}+)?([Ee][-+]?{digit}+)?
string \"[^\"\n]*\"

%%

{ws}+

"void"|"int"|"double"|"bool"|"string"|"class"|"interface" {printf("%s\n",yytext);}
"null"|"this"|"extends"|"implements"|"for"|"while"|"if" {printf("%s\n",yytext);}
"else"|"return"|"break"|"continue"|"new"|"NewArray"|"Print" {printf("%s\n",yytext);}
"ReadInteger"|"ReadLine"|"dtoi"|"itod"|"btoi"|"itob"|"private" {printf("%s\n",yytext);}
"protected"|"public"|"true"|"false" {printf("%s\n",yytext);}

{id} {printf("T_ID %s\n",yytext);}

{integer} {printf("T_INTLITERAL %s\n",yytext);}

{double} {printf("T_DOUBLELITERAL %s\n",yytext);}

{string} {printf("T_STRINGLITERAL %s\n",yytext);}

%%

int main(){
    printf("start my friend :)\n");
    while(1){
        yylex();
    }
}