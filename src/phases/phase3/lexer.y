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

//enum Type { Integer, Array };

// struct Symbol {
//   std::string name;
//   Type type;
// };
// struct Function {
//   std::string name;
//   std::vector<Symbol> declarations;
// };

// std::vector <Function> symbol_table;

int num_vars_in_scope = 0;
int globTemp = 0;
// Function *get_function() {
//   int last = symbol_table.size()-1;
//   return &symbol_table[last];
// }

// bool find(std::string &value) {
//   Function *f = get_function();
//   for(int i=0; i < f->declarations.size(); i++) {
//     Symbol *s = &f->declarations[i];
//     if (s->name == value) {
//       return true;
//     }
//   }
//   return false;
// }

// bool find_function(std::string &func_name) {
// 	for (int i = 0; i < symbol_table.size(); i++) {
// 		if (symbol_table[i].name == func_name) {
// 			return true;
// 		}
// 	}
// 	return false; 
// }


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


%}
%union {
    struct CodeNode *code_node;
    char* id;
    int n;
}
%start prog_start
%token PLUS MINUS MULT DIV LEFT_PAREN RIGHT_PAREN EQUAL SEMICOLON COLON
    TRUE FALSE LESS_THAN LESS_THAN_EQ GREAT_THAN GREAT_THAN_EQ NOT_EQ INT
    EQUALS ARRAY FUNCTION RETURN ASSIGN TYPE WHILE BEGIN_LOOP END_LOOP BEGIN_PARAMS
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
    | statement statement_list {
		CodeNode *node = new CodeNode;
		CodeNode *statement = $1;
		CodeNode *statements = $2;
		node->code = statement->code + statements->code;
		$$ = node;
	}
    ;

statement: if_statement %prec IF_PREC
    | while_statement 
    | assignment 
    | output
    | input
    | return_statement
    ;

if_statement: IF LEFT_PAREN exp RIGHT_PAREN THEN statement END_IF SEMICOLON
    ;

while_statement: WHILE LEFT_PAREN exp RIGHT_PAREN BEGIN_LOOP statement_list END_LOOP SEMICOLON 
    ;

assignment: IDENT ASSIGN NUM SEMICOLON {
	std::string id = $1;
	CodeNode *node = new CodeNode;
	node->code += "= " + id + ", " + std::to_string($3) + "\n";
	$$ = node; 
}
|IDENT ASSIGN exp SEMICOLON 
{
    /*std::string id = $1;
    CodeNode *e = $3;
    CodeNode *node = new CodeNode;
	node->code += id;
	node->code += e->code;
    node->code += "= " + id + ", " + e->name + "\n";
    $$ = node;*/
	//std::cout << "Name of exp: "<< $3->name << std::endl;
	std::string id = $1;
	CodeNode *node = new CodeNode;
	node->code = $3->code;
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
    node->code += e->code + c->code + t->code;
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

compare: EQUAL 
    | LESS_THAN 
    | LESS_THAN_EQ 
    | GREAT_THAN 
    | GREAT_THAN_EQ 
    | NOT_EQ 
    ;

term: factor addop term 
{
    /*std::string temp = create_temp();
    CodeNode *node = new CodeNode;
    node->code += $1->code + $3->code + temp;
    node->code += $2->code + " " + temp + ", " + $1->name + ", " + $3->name + "\n";
    node->name = temp;
    $$ = node;*/
/*	CodeNode *pp = $1;
    std::string tempv = "_temp0";
    std::string syntax = "";
    syntax += ". ";
    syntax += tempv;
	syntax+= "\n";
	syntax += "+ ";
	syntax += tempv;
	syntax += ", ";
	syntax += $3->code;
	syntax += ", ";
	syntax += pp->code;
	syntax += "\n";
	CodeNode *node = new CodeNode;
	node->code = syntax;
	node->name = tempv;
	$$ = node;*/
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
void yyerror(const char* err) {
    printf("Syntax error on line %d: %s\n", yylineno, err);
}




