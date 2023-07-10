%{
#include <stdio.h>
#include <stdlib.h>
#include "BMM_Main.c"
void yyerror(const char* message);
int yylex();
extern FILE* yyout,* yyin;
FILE* lexout;
char aa; int ac = 0;
int maxi = 0, endc = 0, isend = 0, fn = 0;
int_vector* indices;
int curi = 0, errcount = 0;
size_t indn = 0, indj = 0, inds = 0; 
int_vector* jumps, * subs;
int fors[26];
%}
%union{
    int num;
    char *str;
}
%token <num> INT_VAL
%token <str> CHAR TEXT VAR NUM_VAL
%token DATA END STOP DIM LET REM PRINT INPUT DEF GOTO IF FOR GOSUB RETURN TO STEP NEXT THEN FN COMMA LPAREN RPAREN EQUALS QUOT EXPON NEG PLUS MULT DIV UNEQ LESST GREAT LEQT GEQT NOT AND OR XOR SEMICO
%left PLUS NEG
%left MULT DEF
%left EXPON

%%
program :
	STMTS {
		for(int i = 0; i < 26; ++i) if(fors[i]>0) {fprintf(yyout, "INVALID! No NEXT for %c\n", 'A'+i); errcount++;}
		if(jumps) {for(int i = 0; i <= jumps->size; ++i) {
			int found = 0; 
			if(jumps->data[i]==0)  continue;
			for(int j = 0; j <= indices->size; ++j) {
				if(jumps->data[i] == indices->data[j]) {found = 1; break;}
			}
			if(!found) {fprintf(yyout, "INVALID! Line number %d doesn't exist!\n", jumps->data[i]); ++errcount;}
		}}
		delete_vector(indices);
		delete_vector(jumps);
		printf("Program reaches end!");
		fprintf(yyout, "--- TOTAL %d errors ---", errcount);
		}
	;
STMTS :
	INT_VAL CMD {
		maxi = $1; indices = create_vector(1); set_vector(indices, indn, maxi); ++indn;
		curi = $1; 
		}
	|
	INT_VAL CMD STMTS {
			set_vector(indices, indn, $1); ++indn;
			if(maxi <= $1) {fprintf(yyout, "INVALID! Line number %d <= Line number %d", maxi, $1); ++errcount; exit(0);}
			maxi = min(maxi, $1); 
			curi = $1;
			}
	;
CMD :
	RETURN {fprintf(yyout, "RETURN statement %d", curi);}
	|
	END { if(isend) {fprintf(yyout, "INVALID! Multiple END statements\n"); ++errcount;}
		fprintf(yyout, "END Statement. Program Terminates\n\n"); isend = 1;}
	|
	STOP {fprintf(yyout, "STOP encountered. Program Terminates\n\n");}
	|
	DATA VALS {fprintf(yyout, "DATA Statement. Values passed\n\n");}
	|
	DIM DECL {fprintf(yyout, "DIM Statement. Arrays defined\n\n");}
	|
	LET ASSIGN {fprintf(yyout, "LET Statement. Values Stored\n\n");}
	|
	REM {fprintf(yyout, "REM Statement. Comment\n\n");}
	|
	PRINT PRINTVALS SEPC{fprintf(yyout, "PRINT Statement. Values Printed\n\n");}
	|
	PRINT PRINTVALS {fprintf(yyout, "PRINT Statement. Values Printed\n\n");}
	|
	INPUT INPUTVALS {fprintf(yyout, "INPUT Statement. Values Taken\n\n");}
	|
	DEF FN FNVALS {fprintf(yyout, "DEF Statement. Function defined\n\n");}
	|
	GOSUB INT_VAL {
			if(!jumps) {jumps = create_vector(1);}
			set_vector(jumps, indj, $2); 
			if(!subs) {subs = create_vector(1);}
			if(subs) for(int i = 0; i < subs->size; ++i) {if($2==subs->data[i]) fn = 1;} 
			if(fn!=1) {set_vector(subs, inds, $2); ++inds;}
			fn = 0;
			++indj; 
			fprintf(yyout, "GOSUB %d Statement. Jump\n\n", $2);}
	|
	GOTO INT_VAL {
			if(!jumps) {jumps = create_vector(1);}
			set_vector(jumps, indj, $2); 
			++indj; 
			fprintf(yyout, "GOTO %d Statement. Jump\n\n", $2);}
	;
	|
	IF IFCON THEN INT_VAL {
			if(!jumps) {jumps = create_vector(1);}
			set_vector(jumps, indj, $4); 
			++indj; 
			fprintf(yyout, "IF Statement.\n\n");
			}
	|
	FOR CHAR EQUALS NUMEX TO NUMEX {
					int temp = $2[0]-'A';
					fors[temp]++; fprintf(yyout, "\tIdentifier %s\nFOR statement.\n\n", $2);
					}
	|
	FOR CHAR EQUALS NUMEX TO NUMEX STEP NUMEX {
					int temp = $2[0]-'A';
					fors[temp]++; fprintf(yyout, "\tIdentifier %s\nFOR statement.\n\n", $2);
					}
	|
	NEXT CHAR {
			fors[$2[0]-'A']--; 
			for(int i = 0; i < 26; ++i) if(fors[i]<0) {fprintf(yyout, "INVALID! NEXT for %c\n", 'A'+i);errcount++;}	
		}
	;
	
VALS :	
	TEXT COMMA VALS {fprintf(yyout, "\tValue: %s\n", $1);}
	|
	INT_VAL COMMA VALS {fprintf(yyout, "\tValue: %d\n", $1);}
	|
	NUM_VAL COMMA VALS {fprintf(yyout, "\tValue: %s\n", $1);}
	|
	INT_VAL {fprintf(yyout, "\tValue: %d\n", $1);}
	|
	TEXT {fprintf(yyout, "\tValue: %s\n", $1);}
	|
	NUM_VAL {fprintf(yyout, "\tValue: %s\n", $1);}
	;
	
DECL : 
	CHAR LPAREN INT_VAL RPAREN COMMA DECL {fprintf(yyout, "\tArray Name: %s Array Size: %d\n", $1, $3);}
	|
	CHAR LPAREN INT_VAL COMMA INT_VAL RPAREN COMMA DECL {fprintf(yyout, "\tArray Name: %s Array Size: (%d, %d)\n", $1, $3, $5);}
	|
	CHAR LPAREN INT_VAL RPAREN {fprintf(yyout, "\tArray Name: %s Array Size: %d\n", $1, $3);}
	|
	CHAR LPAREN INT_VAL COMMA INT_VAL RPAREN {fprintf(yyout, "\tArray Name: %s Array Size: (%d, %d)\n", $1, $3, $5);}
	;
	
PRINTVALS :
	PRINTVALS SEPC PARAC
	| 
	PARAC
	;

PARAC :
	CHAR | TEXT | NUMEX | SEPC
	;
	
SEPC :
	COMMA | SEMICO
	;

INPUTVALS :
	PARAI COMMA INPUTVALS
	|
	PARAI
	;
PARAI :
	CHAR LPAREN INT_VAL RPAREN {fprintf(yyout, "\t Input Value : %s(%d)\n", $1, $3);}
	|
	CHAR LPAREN CHAR RPAREN {fprintf(yyout, "\t Input Value : %s(%d)\n", $1, $3);}
	|
	CHAR {fprintf(yyout, "\t Input Value : %s\n", $1);}
	|
	VAR {fprintf(yyout, "\t Input Value : %s\n", $1);}
	;
	
FNVALS :
	CHAR EQUALS NUMEX
	|
	CHAR LPAREN CHAR RPAREN EQUALS NUMEX {aa = $3[0]; ac = 1;}
	;
	
NUMEX :
	NEG NUMEX
	|
	LPAREN NUMEX RPAREN
	|
	NUMEX NUMOP NUMEX
	|
	PARAMS
	;

ASSIGN : 
	CHAR EQUALS NUMEX {fprintf(yyout, "\tVar %s\n", $1);}
	|
	VAR EQUALS NUMEX {
				if(!strcheck($1)) fprintf(yyout, "\tVar %s\n", $1);
				else {fprintf(yyout, "INVALID!! Var %s is string\n", $1); errcount++;}
			}
	|
	VAR EQUALS TEXT {
				if(strcheck($1)) fprintf(yyout, "\tVar %s = %s\n", $1, $3);
				else {fprintf(yyout, "INVALID!! Var %s is string\n", $1); ++errcount;}
			}
	;

IFCON : 
	VAR SLOGOP TEXT {
				if(strcheck($1)) fprintf(yyout, "\tVar %s %s\n", $1, $3);
				else {fprintf(yyout, "INVALID!! Var %s is string\n", $1); ++errcount;}
			}
	|
	TEXT SLOGOP TEXT
	|
	TEXT SLOGOP VAR {
				if(strcheck($1)) fprintf(yyout, "\tVar %s %s\n", $1, $3);
				else {fprintf(yyout, "INVALID!! Var %s is string\n", $3); ++errcount;}
			}
	|
	NUMEX LOGOP NUMEX
	;

PARAMS :
	CHAR {if(ac) {if($1[0]!=aa) fprintf(yyout, "Wrong! %c not in expression", aa);} ac = 0;}| VAR | INT_VAL | NUM_VAL | CHAR LPAREN CHAR RPAREN | CHAR LPAREN INT_VAL RPAREN
	;
NUMOP :
	PLUS | NEG | MULT | DIV | EXPON;
LOGOP :
	EQUALS | UNEQ | LESST | GREAT | LEQT | GEQT; 
SLOGOP :
	EQUALS | UNEQ;

%%

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    yyout = fopen("out.txt","w");
    lexout = fopen("lexer.txt", "w");
    yyparse();
    return 0;
}

void yyerror(const char* message)
{
	fprintf(yyout, "FATAL : %s", message);
}
