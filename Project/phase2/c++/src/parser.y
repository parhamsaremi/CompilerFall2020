%{
  #include <stdio.h>
//   using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern FILE *yyout;
  void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:
%union {
//   int ival;
//   float fval;
  char *sval;
}

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
// %token <ival> INT
// %token <fval> FLOAT
%token <sval> HI
%token <sval> NAME

%%
msg:
    HI NAME {fprintf(yyout, "OK1 %s\n",$1);}
    ;
names:
    names NAME{
        fprintf(yyout, "OK2 %s\n",$2);}
    | NAME{
        fprintf(yyout, "OK3 %s\n",$1);
    }
    ;

%%


int main() {
  while(1){
      yyparse();
  };
  
}

void yyerror(const char *s) {
  fprintf(yyout, "NO");
}