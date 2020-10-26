%option noyywrap

%{
#include <iostream>
#define YY_DECL int yylex()
%}

%%
[1-9]\d+ {printf("10base: %d",  strtol(yytext, NULL, 10));}
"0"\d+ {printf("10base: %d", strtol(yytext, NULL, 8));}
("0x"|"0X")[0-9a-fA-F]+ {printf("10base: %d", strtol(yytext, NULL, ));}

%%
int main(){
    yylex();
    return 0;
}