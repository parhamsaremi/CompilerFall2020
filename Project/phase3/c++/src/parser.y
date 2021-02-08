%{
	#include <stdio.h>
	#include <fstream>
	// #include "codegen.cpp" // add it again
	#include <bits/stdc++.h>
	#include "ast.h"


	// using namespace std;

	// stuff from flex that bison needs to know about:
	// extern "C" int yylex();
	// extern "C" int yyparse();
	// extern "C" FILE *yyin;

	// Declare stuff from Flex that Bison needs to know about:
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern FILE *yyout;
	void yyerror(const char *s);
	extern int linenumber;
	extern char* yytext;

	// Start *root;
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
	int ival;
	float fval;
	char *sval;

	Start *start;
	Program *proram;
	Decl *decl;
	VariableDecl *variable_decl;
	FunctionDecl *function_decl;
	ClassDecl *class_decl;
	InterfaceDecl *interface_decl;
	Type *type;
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
%token NEG

%type <start> start
%type <proram> program
%type <decl> decl
%type <variable_decl> variableDecl
%type <sval> variable
%type <type> type
%type <function_decl> functionDecl
%type <sval> formals
%type <sval> variable1ToInfColon
%type <class_decl> classDecl
%type <sval> extendsIdent0Or1
%type <sval> implementsIdentPlusColon0Or1
%type <sval> fields0ToInf
%type <sval> field
%type <sval> ids1ToInfColon
%type <sval> accessMode
%type <interface_decl> interfaceDecl
%type <sval> prototype0ToInf
%type <sval> prototype
%type <sval> stmtBlock
%type <sval> variableDecl0ToInf
%type <sval> stmt0ToInf
%type <sval> stmt
%type <sval> expr0Or1
%type <sval> ifStmt
%type <sval> elseStmt0Or1
%type <sval> whileStmt
%type <sval> forStmt
%type <sval> returnStmt
%type <sval> breakStmt
%type <sval> continueStmt
%type <sval> printStmt
%type <sval> expr1ToInfColon
%type <sval> expr
%type <sval> lValue
%type <sval> call
%type <sval> actuals
%type <sval> constant

%nonassoc NoELSE
%nonassoc ELSE
%nonassoc NoEQ

%right EQ
%left OR
%left AND
%left CHECKEQ CHECKNOTEQ
%nonassoc LE GR LEQ GEQ
%left MINUS PLUS
%left MUL PERCENT SLASH
%nonassoc EXCLAMATION NEG
%left DOT OPENBRACK
// %left PLUS MINUS MUL SLASH PERCENT DOT EQ OPENBRACK OPENBRACE
// %right GEQ LE LEQ GR CHECKEQ CHECKNOTEQ AND OR T_ID
// %nonassoc EXCLAMATION

%%

start:
	program {$$ = new Start($1) ; /*root = $$;*/}
	;

program:
	program decl { $1->decls.push_back($2); $$ = $1;}
	| decl { $$ = new Program(); $$->decls.push_back($1);}
	;

decl:
	variableDecl { $$ = new Decl($1);}
	| functionDecl { $$ = new Decl($1);}
	| classDecl { $$ = new Decl($1);}
	| interfaceDecl { $$ = new Decl($1);}
	;

variableDecl:
	variable SEMICOLON {}
	;

variable:
	type T_ID
	| T_ID T_ID {/* todo: this rule looks wrong, it isn't even in project doc */}
	;

type:
	INT { $$ = new Type($1, false);}
	| DOUBLE { $$ = new Type($1, false);}
	| BOOL { $$ = new Type($1, false)}
	| STRING { $$ = new Type($1, false);}
	| type OPENBRACK CLOSEBRACK { 
		$$ = new Type(NULL, true);
		$$->type = $1->type;
		$$->class_name= $1->class_name;
		}
	| T_ID {/* looks this rule is needed too */ }
	| T_ID OPENBRACK CLOSEBRACK {}
	;

functionDecl:
	type T_ID OPENPAR formals CLOSEPAR stmtBlock { $$ = new FunctionDecl($1, $2, $4, $6)}
	| VOID T_ID OPENPAR formals CLOSEPAR stmtBlock {}
	| T_ID T_ID OPENPAR formals CLOSEPAR stmtBlock {}
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
	| T_ID T_ID OPENPAR formals CLOSEPAR SEMICOLON
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
	| T_ID %prec NoEQ
	| constant
	| lValue EQ expr
	| T_ID EQ expr
	| THIS
	| call
	| OPENPAR expr CLOSEPAR
	| expr PLUS expr
	| expr MINUS expr
	| expr MUL expr
	| expr SLASH expr
	| expr PERCENT expr
	| MINUS expr %prec NEG
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
	| NEWARRAY OPENPAR expr COLON T_ID CLOSEPAR
	| ITOD OPENPAR expr CLOSEPAR
	| DTOI OPENPAR expr CLOSEPAR
	| ITOB OPENPAR expr CLOSEPAR
	| BTOI OPENPAR expr CLOSEPAR
	;

lValue:
	expr DOT T_ID
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