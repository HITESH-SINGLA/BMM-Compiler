all:
	lex BMM_Scanner.l
	yacc -d BMM_Parser.y
	gcc lex.yy.c y.tab.c -ll -ggdb3
clean:
	rm -f ./a.out lex.yy.c y.tab.h y.tab.c y.tab.h.gch
	clear
