%{
#include <stdio.h>
#include <string>
#include <string.h>
// #include <vector>
#include <iostream>
extern FILE* yyin;
extern int yylineno; 
void yyerror(const char* err);
extern "C" {
    int yylex(void);
}

struct CodeNode {
    std::string code = "";
    std::string name = "";
};


int num_vars_in_scope = 0;
int globTemp = 0;

// creates a unique temporary variable name
std::string create_temp() {
    static int temp_counter = 0;
    std::string temp = std::to_string(temp_counter++);
    std::string temp_name = "t" + temp;
    return temp_name;
}
std::string create_reg() {
    static int reg_counter = 0;
    std::string reg = std::to_string(reg_counter++);
    std::string reg_name = "$" + reg;
    return reg_name;
}
// generates code to declare a temporary variable with the given name
std::string decl_temp_code(std::string temp_name) {
    return "int " + temp_name + ";\n";
}

std::string begin_loop()
{
    static int labelCounter1 = 0;
    std::string label1 = "beginloop" + std::to_string(labelCounter1++);
    return label1;
}

std::string begin_body()
{
    static int labelCounter2 = 0;
    std::string label2 = "loopbody" + std::to_string(labelCounter2++);
    return label2;
}

std::string end_body()
{
    static int labelCounter3 = 0;
    std::string label3 = "endloop" + std::to_string(labelCounter3++);
    return label3;
}

std::string break_end()
{
    static int labelCounter4 = 0;
    std::string label3 = "endloop" + std::to_string(labelCounter4++);
    return label3;
}

%}

%define parse.error verbose
%union {
    struct CodeNode *code_node;
    char* id;
    int n;
}
%start prog_start
%token PLUS MINUS MULT DIV LEFT_PAREN RIGHT_PAREN EQUAL SEMICOLON COLON
    TRUE FALSE LESS_THAN LESS_THAN_EQ GREAT_THAN GREAT_THAN_EQ NOT_EQ INT BREAK
    EQUALS ARRAY FUNCTION RETURN ASSIGN TYPE WHILE BEGIN_LOOP END_LOOP BEGIN_PARAMS ELSE
    END_PARAMS BEGIN_FUNC_BODY END_FUNC_BODY BEGIN_LOCAL_VAR END_LOCAL_VAR IF THEN END_IF READ WRITE COMMA L_BRACKET R_BRACKET 

%token <id> IDENT
%token <n> NUM

%type <code_node> func
%type <code_node> declaration
%type <code_node> addop
%type <code_node> mullop
%type <code_node> input
%type <code_node> output
%type <code_node> assignment
%type <code_node> exp
%type <code_node> term
%type <code_node> compare
%type <code_node> factor
%type <code_node> param_list
%type <code_node> param
%type <code_node> local_list
%type <code_node> local
%type <code_node> body
%type <code_node> func_name
%type <code_node> statement
%type <code_node> statement_list
%type <code_node> arrayis
%type <code_node> return_statement
%type <code_node> while_statement
%type <code_node> if_statement
%type <code_node> boolexpression
%type <code_node> ifelse_statement


%left PLUS MINUS
%left MULT DIV
%left NOT_EQ LESS_THAN LESS_THAN_EQ GREAT_THAN GREAT_THAN_EQ
%right UNARY_MINUS
%nonassoc IF_PREC /* new precedence level for if_statement */

%%

prog_start: %empty /* epsilon */ 
    | func 
    {
        CodeNode *code_node = $1;
			printf("%s\n", code_node->code.c_str());
    }
    ;

func: FUNCTION IDENT SEMICOLON declaration 
{
    CodeNode *node = new CodeNode;
    std::string id = $2;
    node->code += "func " + id + "\n";
    CodeNode *d = $4;
    node->code += d->code;
    node->code += "endfunc";
    $$ = node;
}
    | func FUNCTION IDENT SEMICOLON declaration 
    {
    CodeNode *node = new CodeNode;
    CodeNode *f = $1;
    node->code += f->code;
    std::string id = $3;
    node->code += "func " + id + "\n";
    CodeNode *d = $5;
    node->code += d->code;
    node->code += "endfunc";
    $$ = node;
    }
    ;


declaration: BEGIN_PARAMS param_list END_PARAMS BEGIN_LOCAL_VAR local_list END_LOCAL_VAR BEGIN_FUNC_BODY body END_FUNC_BODY 
{
    CodeNode *node = new CodeNode;
    CodeNode *p = $2;
    CodeNode *l = $5;
    CodeNode *b = $8;
    node->code += p->code + l->code + b->code;
    $$ = node;

}
    ;

param_list: param 
{
    CodeNode *node = new CodeNode;
    CodeNode *param = $1;
    node->code += param->code;
    $$ = node;
}
    | param param_list
    {
        CodeNode *node = new CodeNode;
        CodeNode *pl = $1;
        CodeNode *param = $2;
        node->code += pl->code + param->code;
        $$ = node;
    }
    | %empty
    {
        CodeNode* node = new CodeNode;
		$$ = node;
    }
    ;

param: IDENT COLON INT SEMICOLON 
{
    CodeNode *node = new CodeNode;
    std::string id = $1;
    node->code += ". " + id + "\n";
    node->code += "= " + id + ", " + create_reg() + "\n";
    $$ = node;
}
    ;

local_list: local 
    | local local_list
    {
        CodeNode* node = new CodeNode;
        CodeNode* ll = $1;
        CodeNode* l = $2;
        node->code += ll->code + l->code;
		$$ = node;
    }
    |  %empty
    {
        CodeNode* node = new CodeNode;
		$$ = node;
    }
    ;

local: IDENT COLON INT SEMICOLON 
{
    CodeNode *node = new CodeNode;
    std::string id = $1;
    node->code += ". " + id + "\n";
    // node->code += "= " + id + ", " + create_reg();
    $$ = node;
}
| IDENT COLON ARRAY L_BRACKET NUM R_BRACKET TYPE INT SEMICOLON {
	CodeNode *node = new CodeNode;
	std::string id = $1;
	node->code = ".[] " + id + ", " + std::to_string($5) + "\n";
	$$ = node;
}
    ;



body: statement_list 
    | %empty
    {
        CodeNode* node = new CodeNode;
		$$ = node;
    }
    ;

statement_list: statement 
    {
		CodeNode *node = new CodeNode;
		CodeNode *statement = $1;
		node->code = statement->code;
		$$ = node;
	}
    | statement statement_list {
		CodeNode *node = new CodeNode;
		CodeNode *statement = $1;
		CodeNode *statements = $2;
		node->code = statement->code + statements->code;
		$$ = node;
	}
    ;

statement: if_statement %prec IF_PREC 
    {
        CodeNode *node = new CodeNode;
        CodeNode *ifs = $1;
        node->code += ifs->code;
        $$ = node;
    }
    | while_statement 
    {
        CodeNode *node = new CodeNode;
        CodeNode *w = $1;
        node->code += w->code;
        $$ = node;
    }
    | assignment 
    {
        CodeNode *node = new CodeNode;
        CodeNode *a = $1;
        node->code += a->code;
        $$ = node;
    }
    | output
    {
        CodeNode *node = new CodeNode;
        CodeNode *o = $1;
        node->code += o->code;
        $$ = node;
    }
    | input
    {
        CodeNode *node = new CodeNode;
        CodeNode *i = $1;
        node->code += i->code;
        $$ = node;
    }
    | return_statement
    {
        CodeNode *node = new CodeNode;
        CodeNode *r = $1;
        node->code += r->code;
        $$ = node;
    }
    | ifelse_statement
    {
        CodeNode *node = new CodeNode;
        CodeNode *ife = $1;
        node->code += ife->code;
        $$ = node;
    }
    | BREAK
    {
        CodeNode *node = new CodeNode;
        std::string label_end = break_end();
        node->code += ":= " + label_end + "\n";
        $$ = node;
    }
    ;

if_statement: IF LEFT_PAREN boolexpression RIGHT_PAREN THEN statement END_IF SEMICOLON
    {
	CodeNode *node = new CodeNode;
	CodeNode *bexp = $3;
	CodeNode *st = $6;
	node->code += bexp->code;
	node->code += "?:= if_true0, " + bexp->name + "\n";
    node->code += ":= endif0\n";
    node->code += ": if_true0\n";
    node->code += st->code;
    node->code += ": endif0\n";
	$$ = node;
    }
    ;

ifelse_statement: IF LEFT_PAREN boolexpression RIGHT_PAREN THEN statement ELSE statement END_IF SEMICOLON
    {
	CodeNode *node = new CodeNode;
	CodeNode *bexp = $3;
    CodeNode *st = $6;
    CodeNode *st2 = $8;
	node->code += bexp->code;
	node->code += "?:= if_true0, " + bexp->name + "\n";
    node->code += ":= else0\n";
    node->code += ": if_true0\n";
    node->code += st->code;
    node->code += ":= endif0\n";
    node->code += ": else0\n";
    node->code += st2->code;
    node->code += ": endif0\n";
	$$ = node;
    }
    ;

boolexpression: IDENT compare NUM
{
	CodeNode *node = new CodeNode;
	std::string id = $1;
	CodeNode *cc = $2;
	std::string numval = std::to_string($3);
	std::string tempp = "_temp" + std::to_string(globTemp);
	node->code += ". " + tempp + "\n";
	node->code += cc->code + " " + tempp + ", " + id + ", " + numval + "\n";
	node->name = tempp;
	globTemp++;
	$$ = node;
}
| IDENT compare IDENT
{
    CodeNode *node = new CodeNode;
	std::string id = $1;
	CodeNode *cc = $2;
    std::string id2 = $3;
	std::string tempp = "_temp" + std::to_string(globTemp);
	node->code += ". " + tempp + "\n";
	node->code += cc->code + " " + tempp + ", " + id + ", " + id2 + "\n";
	node->name = tempp;
	globTemp++;
	$$ = node;
}
;


while_statement: WHILE LEFT_PAREN boolexpression RIGHT_PAREN BEGIN_LOOP statement_list END_LOOP SEMICOLON 
    {
    CodeNode *node = new CodeNode;
    CodeNode *b = $3;
    CodeNode *statement_node = $6;
    std::string label_start = begin_loop();
    std::string label_body = begin_body();
    std::string label_end = end_body();
    node->code += ": " + label_start + "\n";
    //node->code = ". " + b->name + "\n";
    node->code += b->code;
    node->code += "?:= " + label_body + ", " + b->name + "\n";
    node->code += ":= " + label_end + "\n";
    node->code += ": " + label_body + "\n";
    node->code += statement_node->code;
    node->code += ":= " + label_start + "\n";
    node->code += ": " + label_end + "\n";
    $$ = node;
    }
    ;

assignment: IDENT ASSIGN NUM SEMICOLON {
	std::string id = $1;
	CodeNode *node = new CodeNode;
	node->code += "= " + id + ", " + std::to_string($3) + "\n";
	$$ = node; 
}
|IDENT ASSIGN IDENT SEMICOLON 
{
	std::string id = $1;
    std::string id2 = $3;
	CodeNode *node = new CodeNode;
	node->code += "= " + id + ", " + id2 + "\n";
	$$ = node;
}
|IDENT ASSIGN exp SEMICOLON 
{
	std::string id = $1;
	CodeNode *node = new CodeNode;
    node->code += $3->code;
	node->code += "= " + id + ", " + $3->name + "\n";
	$$ = node;
}
| arrayis ASSIGN exp SEMICOLON
{
	CodeNode *ais = $1;
	CodeNode *e = $3;
	CodeNode *node = new CodeNode;
	node->code += ais->code + ", " + e->code + "\n";
	$$ = node;	
}
    ;

arrayis: IDENT L_BRACKET exp R_BRACKET
{
	std::string id = $1;
	CodeNode *ex = $3;
	CodeNode *node = new CodeNode;
	node->code += "[]= " + id + ", " + ex->code;
	$$ = node;
}
;


output: WRITE IDENT SEMICOLON
{
    CodeNode *node = new CodeNode;
    std::string id = $2;
    node->code += ".> " + id + "\n";
    $$ = node;
}
| WRITE IDENT L_BRACKET exp R_BRACKET SEMICOLON
{
	CodeNode *node = new CodeNode;
	std::string id = $2;
	std::string tp = "_temp" + std::to_string(globTemp);
	node->code += "=[] " + tp  + ", " + id + ", " + $4->code + "\n";
	node->code += ".> " + tp + "\n";
	globTemp++;
	$$ = node;
}
    ;

input: READ IDENT SEMICOLON 
{
    CodeNode *node = new CodeNode;
    std::string id = $2;
    node->code += ".< " + id + "\n";
    $$ = node;
}
    ;

exp: exp compare term 
{
    CodeNode *node = new CodeNode;
    CodeNode *e = $1;
    CodeNode *c = $2;
    CodeNode *t = $3;
    node->code += e->code + t->code;
    /*std::string compareString = c->code;
	node->name = "_temp" + std::to_string(globTemp);
	globTemp++;
	node->code += ". " + node->name + "\n";
	node->code += compareString + " " + node->name + ", " + e->name + ", " + t->name + "\n";*/
    $$ = node;
}
    | term
    {
        CodeNode *node = new CodeNode;
        CodeNode *t = $1;
	node->name = $1->name;
        node->code += t->code;
        $$ = node;
    }
    ;

compare: EQUAL {
	CodeNode *node = new CodeNode;
	node->code = "==";
	$$ = node;
}
    | LESS_THAN {
	CodeNode *node = new CodeNode;	
	node->code = "<";
	$$ = node;
}
    | LESS_THAN_EQ {
	CodeNode *node = new CodeNode;
	node->code = "<=";
	$$ = node;	
}
    | GREAT_THAN {
	CodeNode *node = new CodeNode;
	node->code = ">";
	$$ = node;	
}
    | GREAT_THAN_EQ {
	CodeNode *node = new CodeNode;
	node->code = ">=";
	$$ = node;	
}
    | NOT_EQ {
	CodeNode *node = new CodeNode;
	node->code = "!=";
	$$ = node;	
}
    ;

term: factor addop term 
{
	CodeNode *pp = $1;
	CodeNode *aop = $2;
	CodeNode *tm = $3;
	CodeNode *node = new CodeNode;
	std::string temp = "_temp" + std::to_string(globTemp);
	node->code = ". " + temp + "\n" + aop->code + " " + temp + ", " + pp->code + ", " + tm->code + "\n";
	node->name = temp;
	globTemp++;
	//$$->name = node->name;
	//std::cout << "THE NAME IS : " << node->name << " AND ITS WEQUAL TO " << temp << std::endl;
	$$ = node;

	//node->code = (syntax.c_str());
	//node->name = (tempv.c_str());
	//$$->code = node->code.c_str();
	//$$->name = node->name.c_str();
	//$$ = node;
}
    | factor mullop term 
{
	CodeNode *pp = $1;
	CodeNode *aop = $2;
	CodeNode *tm = $3;
	CodeNode *node = new CodeNode;
	std::string temp = "_temp" + std::to_string(globTemp);
	node->code = ". " + temp + "\n" + aop->code + " " + temp + ", " + pp->code + ", " + tm->code + "\n";
	node->name = temp;
	globTemp = globTemp + 1;
/*
    std::string temp = create_temp();
    CodeNode *node = new CodeNode;
    node->code += $1->code + $3->code + decl_temp_code(temp);
    node->code += $2->code + temp + ", " + $1->name + ", " + $3->name + "\n";
    node->name = temp;*/
	//std::cout << "THE NAME IS : " << node->name << " AND ITS WEQUAL TO " << temp << std::endl;
    $$ = node;
}
    | factor 
    {
        CodeNode *node = new CodeNode;
	node->code = $1->code;
	$$ = node;
	//$$->name = $1->name.c_str();
	//$$->code = $1->code.c_str();
	//$$ = node;
        //CodeNode *f = $1;
        //node->code += f->code;
        //$$ = node;
    }
    ;

addop: PLUS 
{
    CodeNode *node = new CodeNode;
    node->code = "+";
    $$ = node;
}
    | MINUS 
{
    CodeNode *node = new CodeNode;
    node->code = "-";
    $$ = node;
}
    | UNARY_MINUS
    ;

mullop: MULT 
{
    CodeNode *node = new CodeNode;
    node->code = "*";
    $$ = node;
}
    | DIV
{
    CodeNode *node = new CodeNode;
    node->code = "/";
    $$ = node;
}
    ;

factor: LEFT_PAREN exp RIGHT_PAREN 

    | NUM 
    {
        CodeNode* node = new CodeNode; 
		node->code += std::to_string($1);
		node->name = std::to_string($1);
		$$ = node; 
    }
    | IDENT 
    {
        CodeNode* node = new CodeNode; 
		std::string id = $1;
        node->code += id;
	node->name += id;
	//std::cout << "NAME -> " << node->name << std::endl;

        $$ = node;
    }
    | func_name
    {
        CodeNode *node = new CodeNode;
        CodeNode *fn = $1;
        node->code += fn->code;
        $$ = node;
    }
    ;

return_statement: RETURN exp SEMICOLON {
	CodeNode *node = new CodeNode;
	CodeNode *expression = $2;
	node->code += expression->code;
	node->code += "ret " + expression->name + "\n";
	$$ = node;}
    ;

func_name: IDENT LEFT_PAREN exp RIGHT_PAREN
{
    CodeNode *node = new CodeNode;
    std::string id = $1;
    CodeNode *e = $3;
    node->code += e->code;
    $$ = node;
}
    ;

%%

int main(int argc, char** argv) {
   yyparse();
   return 0;
}

extern int lineNumber;
void yyerror(const char* err) {
    printf("Syntax error on line %d: %s\n", lineNumber, err);
}




