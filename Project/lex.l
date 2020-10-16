%{
#include <stdio.h>
%}

%optionyylineno
%optionyywrap

digit [0-9]

%%

"void"|"int"|"double"|"bool"|"string"|"class"|"interface"| {printf("%s",yytext);}

{digit}+ {printf("number");}
[a-zA-Z]{1,3} {printf("not accepted \"%s\"",yytext);}
"GURU"|"Guru"|"guru" {printf("accepted");}

%%

int main(){
    printf("start my friend :)\n");
    while(1){
        yylex();
    }
}