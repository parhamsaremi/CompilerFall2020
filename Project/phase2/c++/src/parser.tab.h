/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VOID = 258,
    INT = 259,
    DOUBLE = 260,
    BOOL = 261,
    STRING = 262,
    CLASS = 263,
    INTERFACE = 264,
    NULL1 = 265,
    THIS = 266,
    EXTENDS = 267,
    IMPLEMENTS = 268,
    FOR = 269,
    WHILE = 270,
    IF = 271,
    ELSE = 272,
    RETURN = 273,
    BREAK = 274,
    CONTINUE = 275,
    NEW = 276,
    NEWARRAY = 277,
    PRINT = 278,
    READINTEGER = 279,
    READLINE = 280,
    DTOI = 281,
    ITOD = 282,
    BTOI = 283,
    ITOB = 284,
    PRIVATE = 285,
    PROTECTED = 286,
    PUBLIC = 287,
    GEQ = 288,
    LEQ = 289,
    GR = 290,
    LE = 291,
    SLASH = 292,
    PLUS = 293,
    MINUS = 294,
    MUL = 295,
    PERCENT = 296,
    EQ = 297,
    CHECKEQ = 298,
    CHECKNOTEQ = 299,
    OR = 300,
    AND = 301,
    EXCLAMATION = 302,
    SEMICOLON = 303,
    COLON = 304,
    DOT = 305,
    OPENBRACK = 306,
    CLOSEBRACK = 307,
    OPENPAR = 308,
    CLOSEPAR = 309,
    OPENBRACE = 310,
    CLOSEBRACE = 311,
    T_INTLITERAL = 312,
    T_DOUBLELITERAL = 313,
    T_STRINGLITERAL = 314,
    T_BOOLEANLITERAL = 315,
    T_ID = 316
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 21 "parser.y"

  // int ival;
  // float fval;
  // char *sval;
  // char *bval;

#line 126 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
