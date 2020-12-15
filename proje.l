variable [a-z]+([0-9]|[a-z])*
integer [0-9]*
float [0-9]+"\."[0-9]+
string \".*\"
string_2 \'.*\'
comment \#(" "*|.*)*
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum;
%}
%%
"#!/bin/sh" return SSP;
{integer} {yylval.string=strdup(yytext); return INT;}
{float} {yylval.string=strdup(yytext); return FLOAT;}
{string} {yylval.string=strdup(yytext); return STRING;}
{string_2} {yylval.string=strdup(yytext); return STRING_2;}
"echo" return ECHO;
"if" return IF;
"elif" return ELIF;
"else" return ELSE;
"then" return THEN;
"while" return WHILE;
"do" return DO;
"fi" return FI;
"done" return DONE;
"=" return EQ;
"(" return OP_PAR;
")" return CLOSE_PAR;
"[" return OP_BR;
"]" return CLOSE_BR;
"{" return OP_C_BR;
"}" return CL_C_BR;
"+" return PLUS;
"-" return MINUS;
"*" return MULT;
"/" return DIVIDE;
"==" return EQ_CTRL;
"$" return DOLAR;
{comment} {yylval.string=strdup(yytext); return COMMENT;}
"-lt" return LESS_TH;
"-le" return LESS_EQ;
"-gt" return GREATER;
"-ge" return GRT_EQ;
"-eq" return EQ;
{variable} {yylval.string=strdup(yytext); return VAR;}
\n	linenum++;
[ \t]+
%%
