all:
	flex lexer.lex
	bison -v -t -d --file-prefix=y lexer.y
	g++ -std=c++11 -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f parser lex.yy.c y.tab.c y.tab.h y.output