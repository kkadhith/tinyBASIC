all: auto_test
	
manual_test:
	flex lexer.lex
	gcc lex.yy.c -lfl -o smp 

auto_test:
	flex lexer.lex
	gcc lex.yy.c -lfl -o smp 
	smp test.simp
clean:
	rm lex.yy.c smp 
