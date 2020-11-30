# NOTE1: You can use wildcards in dependencies and g++ command.
# NOTE2: main should depend on all headers and code files. (*.h and *.cpp if you have multiple files)
all: ../main

../main: parser.tab.c parser.tab.h lex.yy.c lex.yy.h main.cpp
	g++ -o ../main -std=c++14 parser.tab.c lex.yy.c main.cpp

parser.tab.c parser.tab.h:
	bison -vd parser.y
	
lex.yy.c lex.yy.h: scanner.l
	flex scanner.l

clean:
	rm ../main lex.yy.c lex.yy.h parser.tab.c parser.tab.h parser.output
