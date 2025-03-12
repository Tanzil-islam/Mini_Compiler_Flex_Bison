%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "banglish.tab.h"  /* Include the parser's header file */
%}

%%
purnosongkha      { return INT; }
doshomiksongkha   { return FLOAT; }
borno             { return CHAR; }
bakko             { return STRING; }
dhrubok           { return CONST; }
poro              { return SCAN; }
bolo              { return PRINT; }
jodi              { return IF; }
naholejodi        { return ELSEIF; }
nahole            { return ELSE; }
jotokhon          { return WHILE; }
chokro            { return FOR; }
koro              { return DO; }
thamo             { return BREAK; }
cholo             { return CONTINUE; }
ferotdao          { return RETURN; }
shotto            { return TRUE; }
mittha            { return FALSE; }
ebong             { return AND; }
ba                { return OR; }
"!"               { return NOT; }
"=="              { return EQ; }
"!="              { return NEQ; }
">="              { return GEQ; }
"<="              { return LEQ; }
">"               { return GT; }
"<"               { return LT; }
"="               { return ASSIGN; }
"+"               { return PLUS; }
"-"               { return MINUS; }
"*"               { return MULTIPLY; }
"/"               { return DIVIDE; }
"%"               { return MOD; }
"("               { return LPAREN; }
")"               { return RPAREN; }
"{"               { return LBRACE; }
"}"               { return RBRACE; }
";"               { return SEMICOLON; }
","               { return COMMA; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+            { yylval.num = atoi(yytext); return NUMBER; }
[0-9]+\.[0-9]+    { yylval.fnum = atof(yytext); return FLOAT_NUMBER; }
[ \t]             { /* ignore whitespace */ }
\n                { /* ignore newlines */ }
.                 { printf("Unrecognized character: %s\n", yytext); }
%%

int yywrap() { 
    return 1; 
}