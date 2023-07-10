-----------------------CS202 Project--------------------------
-------------------- B-- Lexer and Parser --------------------

Hitesh Singla 2021CSB1094
Kartik Tiwari 2021CSB1102

1. Usage :
	Use the makefile provided as follows :
	a) make all -> compiles all the required files
	b) make clean -> cleans all generated files and clears terminal
	
	after compiling, use as follows :
	./a.out [filename.bmm]
	
2. Folder contents :
	a) BMM_Scanner.l : Lex file that provides the syntax and generates the lex output
	b) BMM_Parser.l : Yacc file that parses the given code and returns parsed output with errors, if any
	c) BMM_Main.c : Helper file with utility function and structs to aid for parsing
	d) Sample1.bmm : Correct sample
	e) Sample2.bmm : Incorrect sample 4 Errors
	
3. Brief Description :
	a) Variable names, declarations, expressions etc all taken as given in the doc.
	b) Two type of errors : Fatal and other. Program stops if a fatal error found, and all other errors are displayed in between till it stops.
	c) Due to infinite loop in the possible grammar case, PRINT statements ending in delimiter not supported
	d) Program stops if tab character encountered
	
4. Points for each instruction :
	All commands work , just the point regarding NEXT as mentioned above.
	
5. Additional errors taken care of :
	a) If line numbers not in ascending order, error given
	b) If a goto, gosub, or if statement points to a line no that doesn't exist, then error
	c) Single NEXT statements also show errors
