/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_LEXER_TAB_H_INCLUDED
# define YY_YY_LEXER_TAB_H_INCLUDED
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
    PLUS = 258,
    MINUS = 259,
    MULT = 260,
    DIV = 261,
    LEFT_PAREN = 262,
    RIGHT_PAREN = 263,
    EQUAL = 264,
    SEMICOLON = 265,
    COLON = 266,
    TRUE = 267,
    FALSE = 268,
    LESS_THAN = 269,
    LESS_THAN_EQ = 270,
    GREAT_THAN = 271,
    GREAT_THAN_EQ = 272,
    NOT_EQ = 273,
    INT = 274,
    EQUALS = 275,
    ARRAY = 276,
    FUNCTION = 277,
    RETURN = 278,
    ASSIGN = 279,
    TYPE = 280,
    WHILE = 281,
    BEGIN_LOOP = 282,
    END_LOOP = 283,
    BEGIN_PARAMS = 284,
    END_PARAMS = 285,
    BEGIN_FUNC_BODY = 286,
    END_FUNC_BODY = 287,
    BEGIN_LOCAL_VAR = 288,
    END_LOCAL_VAR = 289,
    IF = 290,
    THEN = 291,
    END_IF = 292,
    READ = 293,
    WRITE = 294,
    COMMA = 295,
    IDENT = 296,
    NUM = 297,
    UNARY_MINUS = 298,
    IF_PREC = 299
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 88 "lexer.y" /* yacc.c:1909  */

    struct CodeNode *code_node;
    char* id;
    int n;

#line 105 "lexer.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LEXER_TAB_H_INCLUDED  */
