%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
extern FILE *yyin;
extern int linenum;
FILE *out;
%}

%union { char *string; }

%type <string> statements statement assign value echo_st condition_st operator condition compare ident

%token SSP INT FLOAT STRING STRING_2 VAR OP_PAR CLOSE_PAR OP_BR CLOSE_BR OP_C_BR CL_C_BR EQ PLUS MINUS MULT DIVIDE EQ_CTRL DOLAR COMMENT LESS_TH LESS_EQ GREATER GRT_EQ EQ ELIF ECHO ELSE IF THEN WHILE DO FI DONE

%token <string> INT FLOAT STRING STRING_2 VAR COMMENT 

%%

begin: SSP statements | SSP;

statements: statement statements {char *p= calloc(2000, sizeof(char));strcat(p,$1);strcat(p,$2);strcat(p,";\n");$$=p;} | statement {$$=$1;};
 
statement: echo_st {$$=$1;fprintf(out,"%s",$1);} | condition_st {$$=$1;fprintf(out,"%s",$1);} | assign {$$=$1;fprintf(out,"%s",$1);} | value {$$=$1;fprintf(out,"%s",$1);} | COMMENT {$$=$1;fprintf(out,"%s\n",$1);} | FI {$$="";} | DONE {$$="";};

assign: VAR EQ ident {char *p= calloc(2000, sizeof(char));strcat(p,"$");strcat(p,$1);strcat(p," = ");strcat(p,$3);strcat(p,";\n");$$=p;} | VAR EQ value{char *p= calloc(2000, sizeof(char));strcat(p,"$");strcat(p,$1);strcat(p," = ");strcat(p,$3);strcat(p,";\n");$$=p;}; 

value: OP_PAR ident operator ident CLOSE_PAR {char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$2);strcat(p,$3);strcat(p,$4);strcat(p,")");$$=p;}
	| OP_PAR ident operator value CLOSE_PAR {char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$2);strcat(p,$3);strcat(p,$4);strcat(p,")");$$=p;}
	| DOLAR OP_PAR value CLOSE_PAR {char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$3);strcat(p,")");$$=p;}
	| OP_PAR value operator ident CLOSE_PAR {char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$2); strcat(p,$3);strcat(p,$4);strcat(p,")");$$=p;}
	| OP_PAR value operator value CLOSE_PAR {char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$2); strcat(p,$3);strcat(p,$4);strcat(p,")");$$=p;}
	| OP_PAR value operator OP_PAR ident operator ident operator value CLOSE_PAR CLOSE_PAR{char *p= calloc(2000, sizeof(char));strcat(p,"(");strcat(p,$2); strcat(p,$3);strcat(p,"(");strcat(p,$5);strcat(p,$6);strcat(p,$7);strcat(p,$8);strcat(p,$9);strcat(p,")");strcat(p,")");$$=p;};

echo_st: ECHO DOLAR VAR {char *p= calloc(2000, sizeof(char));strcat(p,"print $"); strcat(p,$3);strcat(p,";\n");$$=p;}| ECHO STRING {char *p= calloc(2000, sizeof(char)); strcat(p,"print "); strcat(p,$2);strcat(p,";\n");$$=p;} | ECHO value {char *p= calloc(2000, sizeof(char));strcat(p,"print  $"); strcat(p,$2);strcat(p,";\n");$$=p;}| ECHO STRING_2{char *p= calloc(2000,sizeof(char));strcat(p,"print "); strcat(p,$2);strcat(p,";\n");$$=p;};

condition_st: condition OP_BR DOLAR VAR compare ident CLOSE_BR condition {char *p= calloc(2000, sizeof(char));strcat(p,$1);strcat(p,"(");strcat(p,"$");strcat(p,$4);strcat(p,$5);strcat(p,$6);strcat(p,"){");strcat(p,$8);$$=p;} | condition {$$=$1;} ;

operator: PLUS {$$=" + ";} | MINUS {$$=" - ";} | MULT {$$=" * ";} | DIVIDE {$$=" / ";};

condition: IF {$$="if ";} | ELSE {$$="	else ";} | ELIF {$$="	elsif ";} | THEN {$$=" ";} | WHILE {$$="while ";} | DO {$$=" ";};

compare: LESS_TH {$$=" < ";} | LESS_EQ {$$=" <= ";} | GREATER {$$=" > ";} | GRT_EQ {$$=" >= ";}  | EQ {$$=" == ";};

ident: INT {$$=$1;} | FLOAT {$$=$1;} | VAR {char *p= calloc(2000, sizeof(char));strcat(p,"$");strcat(p,$1);$$=p;} | DOLAR VAR {char *p= calloc(2000, sizeof(char));strcat(p,"$");strcat(p,$2);$$=p;};


%%
void yyerror(char *p){
	fprintf(stderr,"Error at line: %d\n",linenum);
}
int yywrap(){
	return 1;
}

int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    out=fopen(argv[2],"w");
    yyparse();
    fclose(yyin);
    fclose(out);
    return 0;
}
