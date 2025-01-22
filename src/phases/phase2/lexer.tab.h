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
    NUM = 258,
    PLUS = 259,
    MINUS = 260,
    MULT = 261,
    DIV = 262,
    LEFT_PAREN = 263,
    RIGHT_PAREN = 264,
    EQUAL = 265,
    SEMICOLON = 266,
    COLON = 267,
    TRUE = 268,
    FALSE = 269,
    LESS_THAN = 270,
    LESS_THAN_EQ = 271,
    GREAT_THAN = 272,
    GREAT_THAN_EQ = 273,
    NOT_EQ = 274,
    INT = 275,
    EQUALS = 276,
    ARRAY = 277,
    FUNCTION = 278,
    RETURN = 279,
    ASSIGN = 280,
    TYPE = 281,
    WHILE = 282,
    BEGIN_LOOP = 283,
    END_LOOP = 284,
    BEGIN_PARAMS = 285,
    END_PARAMS = 286,
    BEGIN_FUNC_BODY = 287,
    END_FUNC_BODY = 288,
    BEGIN_LOCAL_VAR = 289,
    END_LOCAL_VAR = 290,
    IF = 291,
    THEN = 292,
    END_IF = 293,
    IDENT = 294,
    READ = 295,
    WRITE = 296,
    COMMA = 297,
    UNARY_MINUS = 298,
    IF_PREC = 299
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LEXER_TAB_H_INCLUDED  */
