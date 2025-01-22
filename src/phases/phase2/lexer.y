%{
#include <stdio.h>
extern FILE* yyin;
extern int yylineno; 
%}

%start prog_start
%token NUM PLUS MINUS MULT DIV LEFT_PAREN RIGHT_PAREN EQUAL SEMICOLON COLON
    TRUE FALSE LESS_THAN LESS_THAN_EQ GREAT_THAN GREAT_THAN_EQ NOT_EQ INT
    EQUALS ARRAY FUNCTION RETURN ASSIGN TYPE WHILE BEGIN_LOOP END_LOOP BEGIN_PARAMS
    END_PARAMS BEGIN_FUNC_BODY END_FUNC_BODY BEGIN_LOCAL_VAR END_LOCAL_VAR IF THEN END_IF IDENT READ WRITE COMMA

%left PLUS MINUS
%left MULT DIV
%left NOT_EQ LESS_THAN LESS_THAN_EQ GREAT_THAN GREAT_THAN_EQ
%right UNARY_MINUS
%nonassoc IF_PREC /* new precedence level for if_statement */

%%

prog_start: %empty /* epsilon */ {printf("prog_start->epsilon\n");}
    | func {printf("prog_start->func\n");}
    ;

func: FUNCTION IDENT SEMICOLON declaration {printf("func->FUNCTION IDENT declaration SEMICOLON\n");} 
    | func FUNCTION IDENT SEMICOLON declaration {printf("func -> function ident declaration SEMICOLON\n");}
    ;


declaration: BEGIN_PARAMS param_list END_PARAMS BEGIN_LOCAL_VAR local_list END_LOCAL_VAR BEGIN_FUNC_BODY body END_FUNC_BODY {printf("declaration->begin_params paramlist END_PARAMS BEGIN_LOCAL_VAR local_list END_LOCAL_VAR BEGIN_FUNC_BODY body END_FUNC_BODY \n");}
    ;

param_list: param {printf("param_list->param\n");}
    | param_list COMMA param {printf("param_list->param_list COMMA param\n");}
    | %empty
    ;

param: IDENT COLON INT SEMICOLON {printf("param->ident colon int semicolon\n");}
    ;

local_list: local {printf("local_list->local\n");}
    | local_list local {printf("local_list->local_list local\n");}
    |  %empty
    ;

local: IDENT COLON INT SEMICOLON {printf("local->ident colon int semicolon\n");}
    ;

body: statement_list {printf("body-> statement_list\n");}
    | %empty
    ;

statement_list: statement {printf("statement_list->statement\n");}
    | statement_list statement {printf("statement_list->statement_list statement\n");}
    ;

statement: if_statement %prec IF_PREC
    | while_statement 
    | assignment 
    | output
    | input
    | return_statement
    ;

if_statement: IF LEFT_PAREN exp RIGHT_PAREN THEN statement END_IF SEMICOLON {printf("if_statement->IF LEFT_PAREN exp RIGHT_PAREN THEN statement SEMICOLON END_IF SEMICOLON\n");} 
    ;

while_statement: WHILE LEFT_PAREN exp RIGHT_PAREN BEGIN_LOOP statement_list END_LOOP SEMICOLON {printf("while_statement->WHILE LEFT_PAREN exp RIGHT_PAREN BEGIN_LOOP statement_list END_LOOP SEMICOLON\n");}
    ;

assignment: IDENT ASSIGN exp SEMICOLON {printf("assignment->ident assign exp semicolon\n");}
    ;

output: WRITE IDENT SEMICOLON {printf("output->write ident semicolon\n");}
    ;

input: READ IDENT SEMICOLON {printf("input->read ident semicolon\n");}
    ;

exp: exp compare term {printf("exp->exp compare term\n");}
    | term {printf("exp->term\n");}
    ;

compare: EQUAL {printf("compare->==\n");}
    | LESS_THAN {printf("compare-><\n");}
    | LESS_THAN_EQ {printf("compare-><=\n");}
    | GREAT_THAN {printf("compare->>\n");}
    | GREAT_THAN_EQ {printf("compare->>=\n");}
    | NOT_EQ {printf("compare->!=\n");}
    ;

term: term addop factor {printf("term->term addop factor\n");}
    | term mullop factor {printf("term->term mullop factor\n");}
    | factor {printf("term->factor\n");}
    ;

addop: PLUS {printf("addop->+\n");}
    | MINUS {printf("addop->-\n");}
    | UNARY_MINUS {printf("addop->UNARY_MINUS\n");}
    ;

mullop: MULT {printf("mullop->*\n");}
    | DIV {printf("mullop->-/\n");}
    ;

factor: LEFT_PAREN exp RIGHT_PAREN {printf("factor->( exp )\n");}
    | NUM {printf("factor-> NUMBER\n");}
    | IDENT {printf("factor->IDENT\n");}
    | func_name
    ;

return_statement: RETURN exp SEMICOLON {printf("return_statement->RETURN exp SEMICOLON\n");}
    ;

func_name: IDENT LEFT_PAREN exp RIGHT_PAREN; 
    ;

%%

void main(int argc, char** argv) {
    if(argc >= 2){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL)
            yyin = stdin;
    } else {
        yyin = stdin;
    }
    yyparse();
}
int yyerror(const char* err) {
    printf("lineNO: %d",yylineno);
}