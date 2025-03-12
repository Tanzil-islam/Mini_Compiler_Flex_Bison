%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 100  // Maximum number of variables

typedef struct {
    char name[50];
    int value;
} Variable;

Variable symbol_table[MAX_VARS];  // Simple symbol table
int var_count = 0;

void store_variable(char *name, int value);
int get_variable(char *name);
void display_symbol_table();
void yyerror(const char *msg);
int yylex();
%}
 
/* Define union for values */
%union {
    int num;
    float fnum;
    char *str;
}

/* Token Definitions */
%token <num> NUMBER
%token <fnum> FLOAT_NUMBER
%token <str> IDENTIFIER
%token INT FLOAT CHAR STRING CONST
%token SCAN PRINT
%token IF ELSE ELSEIF
%token WHILE FOR DO
%token BREAK CONTINUE RETURN
%token TRUE FALSE
%token AND OR NOT
%token EQ NEQ GEQ LEQ GT LT ASSIGN
%token PLUS MINUS MULTIPLY DIVIDE MOD
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token NEWLINE

/* Declare return types for non-terminals */
%type <num> expression
%type <str> declaration assignment print_statement input_statement

/* Operator Precedence */
%left OR
%left AND
%left EQ NEQ
%left GT LT GEQ LEQ
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%right NOT

%%

program : statements { printf("Banglish program parsed successfully!\n"); display_symbol_table(); }
        ;

statements : statements statement
           | statement
           ;

statement : declaration SEMICOLON
          | assignment SEMICOLON
          | print_statement SEMICOLON
          | input_statement SEMICOLON
          | if_statement
          | loop_statement
          | control_statement SEMICOLON
          ;

declaration : INT IDENTIFIER { printf("Declaring integer variable: %s\n", $2); store_variable($2, 0); }
            | FLOAT IDENTIFIER { printf("Declaring float variable: %s\n", $2); store_variable($2, 0); }
            | CHAR IDENTIFIER { printf("Declaring char variable: %s\n", $2); store_variable($2, 0); }
            | STRING IDENTIFIER { printf("Declaring string variable: %s\n", $2); store_variable($2, 0); }
            ;

assignment : IDENTIFIER ASSIGN expression { 
    store_variable($1, $3); 
    printf("Assigning value to %s = %d\n", $1, $3); 
    display_symbol_table();
}
           ;

print_statement : PRINT LPAREN IDENTIFIER RPAREN SEMICOLON { 
    int value = get_variable($3);  // Retrieve variable value
    printf("Using variable: %s = %d\n", $3, value); 
    printf("Banglish Print: %d\n", value); 
}
;


input_statement : SCAN LPAREN IDENTIFIER RPAREN {
    printf("Taking input for %s: ", $3);
    int value;
    scanf("%d", &value);
    store_variable($3, value);
    display_symbol_table();
}
;

if_statement : IF LPAREN expression RPAREN LBRACE statements RBRACE 
             { 
               if ($3) {
                 printf("If condition is true, executing if block\n");
                 /* Execute the statements in the if block */
               } else {
                 printf("If condition is false, skipping if block\n");
               }
             }
             | IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE 
             { 
               if ($3) {
                 printf("If condition is true, executing if block\n");
                 /* Execute the statements in the if block */
               } else {
                 printf("If condition is false, executing else block\n");
                 /* Execute the statements in the else block */
               }
             }
             ;

loop_statement : WHILE LPAREN expression RPAREN LBRACE statements RBRACE { printf("While loop\n"); }
               | FOR LPAREN assignment SEMICOLON expression SEMICOLON assignment RPAREN LBRACE statements RBRACE { printf("For loop\n"); }
               ;

control_statement : BREAK { printf("Break statement\n"); }
                 | CONTINUE { printf("Continue statement\n"); }
                 | RETURN expression { printf("Return statement\n"); }
                 ;

expression : NUMBER { $$ = $1; }
           | FLOAT_NUMBER { $$ = (int)$1; }
           | IDENTIFIER { 
                $$ = get_variable($1);  
                printf("Fetching variable %s from symbol table, value: %d\n", $1, $$); 
            }
           | expression PLUS expression { $$ = $1 + $3; }
           | expression MINUS expression { $$ = $1 - $3; }
           | expression MULTIPLY expression { $$ = $1 * $3; }
           | expression DIVIDE expression { $$ = $1 / $3; }
           | expression GT expression { 
                $$ = ($1 > $3) ? 1 : 0; 
                printf("Evaluating %d > %d: result is %d\n", $1, $3, $$);
             }
           | expression LT expression { 
                $$ = ($1 < $3) ? 1 : 0; 
                printf("Evaluating %d < %d: result is %d\n", $1, $3, $$);
             }
           | expression GEQ expression { $$ = ($1 >= $3) ? 1 : 0; }
           | expression LEQ expression { $$ = ($1 <= $3) ? 1 : 0; }
           | expression EQ expression { $$ = ($1 == $3) ? 1 : 0; }
           | expression NEQ expression { $$ = ($1 != $3) ? 1 : 0; }
           | LPAREN expression RPAREN { $$ = $2; }
           ;

%%

void store_variable(char *name, int value) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    strcpy(symbol_table[var_count].name, name);
    symbol_table[var_count].value = value;
    var_count++;
}

int get_variable(char *name) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    printf("Error: Variable %s not found!\n", name);
    return 0;
}

void display_symbol_table() {
    printf("\nSymbol Table:\n");
    printf("---------------------\n");
    for (int i = 0; i < var_count; i++) {
        printf("%s = %d\n", symbol_table[i].name, symbol_table[i].value);
    }
    printf("---------------------\n");
}

int main() {
    printf("Enter Banglish code:\n");
    while(!feof(stdin)) {
        yyparse();
    }
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Syntax Error: %s\n", msg);
}
