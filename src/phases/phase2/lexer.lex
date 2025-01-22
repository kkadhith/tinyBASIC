%{
#include <stdio.h>
#include "y.tab.h"
int lineNumber = 0;
int rowNumber = 0;
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
%%

{DIGIT}+ {return NUM;}
"+"      {return PLUS;}
"-"      {return MINUS;}
"*"      {return MULT;}
"/"      {return DIV;}
"("      {return LEFT_PAREN;}
")"      {return RIGHT_PAREN;}
"="      {return EQUAL;}
";"      {return SEMICOLON;}
":"      {return COLON;}
"true"	 {return TRUE;}
"false"	 {return FALSE;}
"<"	     {return LESS_THAN;}
"<="	 {return LESS_THAN_EQ;}
">"	     {return GREAT_THAN;}
">="	 {return GREAT_THAN_EQ;}
"!="	 {return NOT_EQ;}
"int"    {return INT;}
"=="     {return EQUALS;}
"array"  {return ARRAY;}
"function" {return FUNCTION;}
"return" {return RETURN;}
"?="     {return ASSIGN;}
"type"   {return TYPE;}
"input"  {return READ;}
"\n"	 {lineNumber++;rowNumber=0;}
" " 	 {}
"\t"	 {}
"while"  {return WHILE;}
"beginwhile"    {return BEGIN_LOOP;}
"endwhile"      {return END_LOOP;}
"beginparams"   {return BEGIN_PARAMS;}
"endparams"     {return END_PARAMS;}
"beginfuncbody" {return BEGIN_FUNC_BODY;}
"endfuncbody"   {return END_FUNC_BODY;}
"beginlocals"   {return BEGIN_LOCAL_VAR;}
"endlocals"     {return END_LOCAL_VAR;}
"print"         {return WRITE;}
"if"            {return IF;}
"then"          {return THEN;}
"endif"         {return END_IF;}
$[^\n]*\n	{lineNumber++;}
({DIGIT}{ALPHA}*) {printf("Invalid Identifier on Line %d\n", lineNumber);return;}
({ALPHA}({ALPHA}|{DIGIT})*) {rowNumber+=yyleng;return IDENT;}
.       {/*printf("ERROR: unrecognized character on Line: %d, Row: %d\n", lineNumber, rowNumber);*/return;}
%%


