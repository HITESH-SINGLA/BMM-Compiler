%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"
extern YYSTYPE yylval;
extern FILE* lexout;
void yyerror(const char* message);
%}

%x COMMENT
%%

[0-9]+ {fprintf(lexout, "NUM : %d\n",yylval.num = atoi(yytext)); return INT_VAL;}
[0-9]+[.]?[0-9]+? {fprintf(lexout, "NUM : %s\n",yytext); yylval.str=strdup(yytext); return NUM_VAL;}
"DATA" {fprintf(lexout, "ID : DATA\n"); return DATA;}
"DIM" {fprintf(lexout, "ID : DIM\n"); return DIM;}
"END" {fprintf(lexout, "ID : END\n"); return END;}
"STOP" {fprintf(lexout, "ID : END\n"); return STOP;}
"LET" {fprintf(lexout, "ID : LET\n"); return LET;}
"PRINT" {fprintf(lexout, "ID : PRINT\n"); return PRINT;}
"REM" {BEGIN(COMMENT); fprintf(lexout, "ID : REM\n"); return REM;}
"DEF" {fprintf(lexout, "ID : DEF\n"); return DEF;}
"FN" {fprintf(lexout, "FUNC : FN\n"); return FN;}
"INPUT" {fprintf(lexout, "ID : INPUT\n"); return INPUT;}
"GOTO" {fprintf(lexout, "ID : GOTO\n"); return GOTO;}
"IF" {fprintf(lexout, "ID : IF\n"); return IF;}
"THEN" {fprintf(lexout, "ID : THEN\n"); return THEN;}
"FOR" {fprintf(lexout, "ID : FOR\n"); return FOR;}
"TO" {fprintf(lexout, "ID : TO\n"); return TO;}
"STEP" {fprintf(lexout, "ID : STEP\n"); return STEP;}
"NEXT" {fprintf(lexout, "ID : NEXT\n"); return NEXT;}
"GOSUB" {fprintf(lexout, "ID : GOSUB\n"); return GOSUB;}
"RETURN" {fprintf(lexout, "ID : RETURN\n"); return RETURN;}
<COMMENT>{
	"\n" {BEGIN(INITIAL); }
	. {}
}
[A-Z] {fprintf(lexout, "NAME : %s\n", yytext); yylval.str=strdup(yytext); return CHAR;}
[A-Z][0-9]?[%|!|#|$]? {fprintf(lexout, "VAR : %s\n", yytext); yylval.str=strdup(yytext); return VAR;}
"=" {fprintf(lexout, "EQ_OP : =\n"); return EQUALS;}
"," {fprintf(lexout, "COMMA : ,\n"); return COMMA;}
";" {fprintf(lexout, "SEMICOLON : ;\n"); return SEMICO;}
"(" {fprintf(lexout, "LPAREN : (\n"); return LPAREN;}
")" {fprintf(lexout, "RPAREN : )\n"); return RPAREN;}
"^" {fprintf(lexout, "EXP_OP : ^\n"); return EXPON;}
"-" {fprintf(lexout, "SUB_OP : -\n"); return NEG;}
"+" {fprintf(lexout, "ADD_OP : +\n"); return PLUS;}
"*" {fprintf(lexout, "MUL_OP : *\n"); return MULT;}
"/" {fprintf(lexout, "DIV_OP : /\n"); return DIV;}
"<>" {fprintf(lexout, "UNEQ_OP : <>\n"); return UNEQ;}
"<" {fprintf(lexout, "LT_OP : <\n"); return LESST;}
">" {fprintf(lexout, "GT_OP : >\n"); return GREAT;}
"<=" {fprintf(lexout, "LEQ_OP : <=\n"); return LEQT;}
">=" {fprintf(lexout, "GEQ_OP : <=\n"); return GEQT;}
"NOT" {fprintf(lexout, "NOT_OP : NOT\n"); return NOT;}
"AND" {fprintf(lexout, "AND_OP : AND\n"); return AND;}
"OR" {fprintf(lexout, "OR_OP : OR\n"); return OR;}
"XOR" {fprintf(lexout, "XOR_OP : XOR\n"); return XOR;}
[\t]	{printf("Tab! Error\n"); exit(0);}
[ ]+    { /* skip whitespace */ }
\"(\\.|[^\\"])*\" {fprintf(lexout, "STR : %s\n", yytext); yylval.str=strdup(yytext); return TEXT;}

%%

int yywrap() {
	return 1;
}