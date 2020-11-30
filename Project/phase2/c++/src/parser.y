%{
  #include <stdio.h>
//   using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern FILE *yyout;
  void yyerror(const char *s);
  extern int linenumber;
  extern char* yytext;
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
  // int ival;
  // float fval;
  // char *sval;
  // char *bval;
}

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token VOID
%token INT
%token DOUBLE
%token BOOL
%token STRING
%token CLASS
%token INTERFACE
%token NULL1
%token THIS
%token EXTENDS
%token IMPLEMENTS
%token FOR
%token WHILE
%token IF
%token ELSE
%token RETURN
%token BREAK
%token CONTINUE
%token NEW
%token NEWARRAY
%token PRINT
%token READINTEGER
%token READLINE
%token DTOI
%token ITOD
%token BTOI
%token ITOB
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token GEQ
%token LEQ
%token GR
%token LE
%token SLASH
%token PLUS
%token MINUS
%token MUL
%token PERCENT
%token EQ
%token CHECKEQ
%token CHECKNOTEQ
%token OR
%token AND
%token EXCLAMATION
%token SEMICOLON
%token COLON
%token DOT
%token OPENBRACK
%token CLOSEBRACK
%token OPENPAR
%token CLOSEPAR
%token OPENBRACE
%token CLOSEBRACE
%token T_INTLITERAL
%token T_DOUBLELITERAL
%token T_STRINGLITERAL
%token T_BOOLEANLITERAL
%token T_ID
%token UNDEFINED

%nonassoc NoELSE
%nonassoc ELSE
%nonassoc NoEQ
%left PLUS MINUS MUL SLASH PERCENT DOT EQ OPENBRACK OPENBRACE
%right GEQ LE LEQ GR CHECKEQ CHECKNOTEQ AND OR T_ID
%nonassoc EXCLAMATION

%%

start:
	program {fprintf(yyout,"OK");}
	;

program:
	program decl {}
	| decl {}
	;

decl:
	variableDecl
	| functionDecl
	| classDecl 
	| interfaceDecl
	;

variableDecl:
	variable SEMICOLON
	;

variable:
	type T_ID
	| new_type T_ID
	;

type:
	INT
	| DOUBLE
	| BOOL
	| STRING
	| type OPENBRACK CLOSEBRACK
	;
new_type:
	T_ID
	;
functionDecl:
	type T_ID OPENPAR formals CLOSEPAR stmtBlock
	| VOID T_ID OPENPAR formals CLOSEPAR stmtBlock
	;

formals:
	variable1ToInfColon
	| %empty
	;

variable1ToInfColon:
	variable1ToInfColon COLON variable
	| variable
	;

classDecl:
	CLASS T_ID extendsIdent0Or1 implementsIdentPlusColon0Or1 OPENBRACE fields0ToInf CLOSEBRACE
	;

extendsIdent0Or1:
	%empty
	| EXTENDS T_ID
	;

implementsIdentPlusColon0Or1:
	%empty
	| IMPLEMENTS ids1ToInfColon
	;

fields0ToInf:
	fields0ToInf field
	| %empty
	;

field:
	accessMode variableDecl
	| accessMode functionDecl
	;

ids1ToInfColon:
	ids1ToInfColon COLON T_ID
	| T_ID
	;

accessMode:
	PRIVATE
	| PROTECTED
	| PUBLIC
	| %empty
	;

interfaceDecl:
	INTERFACE T_ID OPENBRACE prototype0ToInf CLOSEBRACE
	;

prototype0ToInf:
	prototype0ToInf prototype 
	| %empty
	;

prototype:
	type T_ID OPENPAR formals CLOSEPAR SEMICOLON
	| VOID T_ID OPENPAR formals CLOSEPAR SEMICOLON
	;

stmtBlock:
	OPENBRACE variableDecl0ToInf stmt0ToInf CLOSEBRACE
	;

variableDecl0ToInf:
	variableDecl0ToInf variableDecl
	| %empty
	;

stmt0ToInf:
	stmt stmt0ToInf
	| %empty
	;

stmt:
	expr0Or1 SEMICOLON
	| ifStmt
	| whileStmt
	| forStmt
	| breakStmt
	| continueStmt
	| returnStmt
	| printStmt
	| stmtBlock
	;

expr0Or1:
	%empty
	| expr
	;

ifStmt:
	IF OPENPAR expr CLOSEPAR stmt elseStmt0Or1
	;

elseStmt0Or1:
	%empty %prec NoELSE
	| ELSE stmt
	;

whileStmt:
	WHILE OPENPAR expr CLOSEPAR stmt
	;

forStmt:
	FOR OPENPAR expr0Or1 SEMICOLON expr SEMICOLON expr0Or1 CLOSEPAR stmt
	;

returnStmt:
	RETURN expr0Or1 SEMICOLON
	;

breakStmt:
	BREAK SEMICOLON
	;

continueStmt:
	CONTINUE SEMICOLON
	;

printStmt:
	PRINT OPENPAR expr1ToInfColon CLOSEPAR SEMICOLON
	;

expr1ToInfColon:
	expr1ToInfColon COLON expr
	| expr
	;

expr:
	lValue %prec NoEQ
	| constant
	| lValue EQ expr
	| THIS
	| call
	| OPENPAR expr CLOSEPAR
	| expr PLUS expr
	| expr MINUS expr
	| expr MUL expr
	| expr SLASH expr
	| expr PERCENT expr
	| MINUS expr
	| expr LE expr
	| expr LEQ expr
	| expr GR expr
	| expr GEQ expr
	| expr CHECKEQ expr
	| expr CHECKNOTEQ expr
	| expr AND expr
	| expr OR expr
	| EXCLAMATION expr
	| READINTEGER OPENPAR CLOSEPAR
	| READLINE OPENPAR CLOSEPAR
	| NEW T_ID 
	| NEWARRAY OPENPAR expr COLON type CLOSEPAR
	| ITOD OPENPAR expr CLOSEPAR
	| DTOI OPENPAR expr CLOSEPAR
	| ITOB OPENPAR expr CLOSEPAR
	| BTOI OPENPAR expr CLOSEPAR
	;

lValue:
	T_ID
	| expr DOT T_ID
	| expr OPENBRACK expr CLOSEBRACK
	;

call:
	T_ID OPENPAR actuals CLOSEPAR
	| expr DOT T_ID OPENPAR actuals CLOSEPAR
	;

actuals:
	expr1ToInfColon
	| %empty
	;

constant:
	T_INTLITERAL
	| T_DOUBLELITERAL
	| T_BOOLEANLITERAL
	| T_STRINGLITERAL
	| NULL1
  ;

%%
void yyerror(const char *s) {
//   fprintf(yyout, "Syntax Error in token %d, %s",linenumber , yytext);
  fprintf(yyout, "Syntax Error");
}