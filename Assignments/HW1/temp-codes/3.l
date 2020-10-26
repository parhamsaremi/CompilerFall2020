%option noyywrap

%{
#include <stdio.h>
#define YY_DECL int yylex()
%}

%%
"a"+ {printf("1");}
("a"|"b")+"b" {printf("2");}
"b"+ {printf("3");}
"c" {printf("4");}
"a"{2} {printf("5");}
%%
int main(){
    yylex();
    return 0;
}