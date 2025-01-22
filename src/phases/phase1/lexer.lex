%{
#include <stdio.h>
int lineNumber = 0;
int rowNumber = 0;
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
%%

{DIGIT}+ {printf("NUMBER %s\n", yytext);}
"+"      {printf("PLUS\n"); rowNumber+=yyleng;}
"-"      {printf("MINUS\n"); rowNumber+=yyleng;}
"*"      {printf("MULT\n"); rowNumber+=yyleng;}
"/"      {printf("DIV\n");rowNumber+=yyleng;}
"("      {printf("L_PAREN\n");rowNumber+=yyleng;}
")"      {printf("R_PAREN\n");rowNumber+=yyleng;}
"="      {printf("EQUAL\n");rowNumber+=yyleng;}
";"      {printf("SEMICOLON\n");rowNumber+=yyleng;}
":"      {printf("COLON\n");rowNumber+=yyleng;}
"true"	 {printf("TRUE\n");rowNumber+=yyleng;}
"false"	 {printf("FALSE\n");rowNumber+=yyleng;}
"<"	 {printf("LESS_THAN\n");rowNumber+=yyleng;}
"<="	 {printf("LESS_THAN_EQ\n");rowNumber+=yyleng;}
">"	 {printf("GREAT_THAN\n");rowNumber+=yyleng;}
">="	 {printf("GREAT_THAN_EQ\n");rowNumber+=yyleng;}
"!="	 {printf("NOT_EQ\n");rowNumber+=yyleng;}
"int" {printf("INT\n");rowNumber+=yyleng;}
"=="     {printf("EQUALS\n");rowNumber+=yyleng;}
"array"  {printf("ARRAY\n");rowNumber+=yyleng;}
"function" {printf("FUNCTION\n");rowNumber+=yyleng;}
"return" {printf("RETURN\n");rowNumber+=yyleng;}
"?="     {printf("ASSIGN\n");rowNumber+=yyleng;}
"type"   {printf("TYPE\n");rowNumber+=yyleng;}
"\n"	 {lineNumber++;rowNumber=0;}
" " 	 {}
"\t"	 {}
"while"  {printf("WHILE\n");rowNumber+=yyleng;}
"beginwhile"    {printf("BEGIN_LOOP\n");rowNumber+=yyleng;}
"endwhile"      {printf("END_LOOP\n");rowNumber+=yyleng;}
"beginparams"   {printf("BEGIN_PARAMS\n");rowNumber+=yyleng;}
"endparams"     {printf("END_PARAMS\n");rowNumber+=yyleng;}
"beginfuncbody" {printf("BEGIN_FUNC_BODY\n");rowNumber+=yyleng;}
"endfuncbody"   {printf("END_FUNC_BODY\n");rowNumber+=yyleng;}
"beginlocals"   {printf("BEGIN_LOCAL_VAR\n");rowNumber+=yyleng;}
"endlocals"     {printf("END_LOCAL_VAR\n");rowNumber+=yyleng;}
$[^\n]*\n	{lineNumber++;}
({DIGIT}{ALPHA}*) {printf("Invalid Identifier on Line %d\n", lineNumber);return;}
({ALPHA}({ALPHA}|{DIGIT})*) {printf("IDENT %s\n", yytext);rowNumber+=yyleng;}
.        {printf("ERROR: unrecognized character on Line: %d, Row: %d\n", lineNumber, rowNumber);return;}
%%
/*
main(void) {
	yyin = stdin;
	yylex();
}
*/
main(int argc, char*argv[]) {

	if (argc == 2) {
		yyin = fopen(argv[1], "r");
		yylex();
		fclose(yyin);
	}
	else {
		yylex();
	}
}
