%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "index.tab.h"
#include "lex.yy.c"
%} 
%union {
    char *str;
}
%token<str> PRINT E OU NEGACAO ABREP DIVISAO VEZES FECHAP VIRGULA ID STR NUM FIM_ENTRADA MAIORIGUAL MENOS FIM_DE_LINHA MAIS ATRIB IF ELIF ELSE MAIOR MENORIGUAL MENOR IGUAL WHILE MAISIGUAL DOISP  DEF RETURN  
%type<str> COMANDOS  EXPRESSAOCONDICAO COMANDO VALOR CHAMARFUNCAO FUNCAO COMANDO_PRINT COMANDO_VARIAVEIS_SEM_D CONDICAO IF_ELSE VARIAVEIS COMANDO_VARIAVEIS LOOP DENTRO_DO_LOOP
%%  
COMANDOS : COMANDO COMANDOS
         | FIM_ENTRADA ;
COMANDO:   FUNCAO
         | COMANDO_PRINT
         | IF_ELSE
         | COMANDO_VARIAVEIS
         | LOOP
         | CHAMARFUNCAO 
         | COMANDO_VARIAVEIS_SEM_D 
         ;
DENTRO_DO_LOOP : COMANDO_PRINT
                | COMANDO_PRINT DENTRO_DO_LOOP
                | IF_ELSE 
                | IF_ELSE DENTRO_DO_LOOP
                | COMANDO_VARIAVEIS_SEM_D
                | COMANDO_VARIAVEIS_SEM_D DENTRO_DO_LOOP  ; 
VARIAVEIS : VALOR
          | ID ATRIB VALOR 
          | ID ATRIB VALOR VARIAVEIS ;

FUNCAO : 
    DEF VALOR ABREP FECHAP DOISP FIM_DE_LINHA
    {
        printf("void * %s(){ \n", $2);  
    } 
    |DEF VALOR ABREP VALOR FECHAP DOISP FIM_DE_LINHA
    {
       printf("void * %s(%s){\n", $2,$4);  
    } 
    | 
    DEF VALOR ABREP VALOR VIRGULA VALOR FECHAP DOISP FIM_DE_LINHA
    {
       printf("void * %s(%s,%s){\n", $2,$4,$6);  
    } 
    | RETURN VALOR FIM_DE_LINHA
    {
       printf("return %s;\n }\n",$2);  
    } 
    ;

COMANDO_PRINT : PRINT  ABREP VARIAVEIS FECHAP FIM_DE_LINHA
    { 
        printf("printf(%s);\n", $3);
    }
    |PRINT  ABREP FECHAP FIM_DE_LINHA
    { 
        printf("printf();\n");
    }  
    | PRINT  ABREP VARIAVEIS VIRGULA  VALOR FECHAP FIM_DE_LINHA
    {
        printf("printf(%s,%s);\n", $3,$5);
    }
    ;

IF_ELSE :  IF EXPRESSAOCONDICAO FIM_DE_LINHA
    {
        printf("if (%s) {\n", $2);
    }
    | IF ABREP EXPRESSAOCONDICAO FECHAP FIM_DE_LINHA
    {
        printf("if (%s) {\n", $3);
    }
    | ELIF ABREP EXPRESSAOCONDICAO FECHAP FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $3);
    }
    | ELIF EXPRESSAOCONDICAO FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $2);
    }
    | ELSE FIM_DE_LINHA
    {
        printf("} else {\n"); 
    } | ELSE DOISP FIM_DE_LINHA
    {
        printf("} else {\n"); 
    }
     | IF EXPRESSAOCONDICAO DOISP FIM_DE_LINHA
    {
        printf("if (%s) {\n", $2);
    }
    | IF ABREP EXPRESSAOCONDICAO FECHAP DOISP FIM_DE_LINHA
    {
        printf("if (%s) {\n", $3);
    }
    | ELIF ABREP EXPRESSAOCONDICAO FECHAP DOISP FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $3);
    }
    | ELIF EXPRESSAOCONDICAO DOISP FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $2);
    }
    ;

COMANDO_VARIAVEIS : 
/*
 ID ATRIB STR FIM_DE_LINHA
    { 
        printf("chat %s[] = %s;\n", $1, $3); 
    } 
    | ID ATRIB NUM FIM_DE_LINHA
    { 
        printf("int %s = %s;\n", $1, $3); 
    } 
    |
*/
     ID ATRIB VALOR FIM_DE_LINHA
    {
        printf("void * %s = %s;\n", $1, $3); 
    } 
    |
    ID ATRIB VALOR MAIS VALOR FIM_DE_LINHA
    {
        printf("void * %s = %s + %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB VALOR MENOS VALOR FIM_DE_LINHA
    {
        printf("void * %s = %s - %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB VALOR DIVISAO VALOR FIM_DE_LINHA
    {
        printf("void * %s = %s / %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB VALOR VEZES VALOR FIM_DE_LINHA
    {
        printf("void * %s = %s * %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB EXPRESSAOCONDICAO FIM_DE_LINHA
    {
        printf("void * %s;\nif (%s) {\n", $1, $3);
    } ;

COMANDO_VARIAVEIS_SEM_D : 
    /* ID ATRIB VALOR FIM_DE_LINHA
    {
        printf(" %s = %s;\n", $1, $3);
    } */
    //|
     ID MAISIGUAL VALOR FIM_DE_LINHA
    {
        printf(" %s++;\n", $1);
    }
    ;
CHAMARFUNCAO : ID ATRIB ID ABREP VALOR VIRGULA VALOR FECHAP FIM_DE_LINHA
            {
                 printf("void * %s = %s(%s,%s);\n", $1, $3,$5,$7);
            }
            |ID ATRIB ID ABREP VALOR FECHAP FIM_DE_LINHA
            {
                 printf("void * %s = %s(%s);\n", $1, $3,$5);
            } 
            |ID ATRIB ID ABREP FECHAP FIM_DE_LINHA
            {
                 printf("void * %s = %s();\n", $1, $3,$5);
            } 
;


LOOP : WHILE ABREP EXPRESSAOCONDICAO  
    {
            printf("while (%s) {\n", $3);
    }
    FECHAP DOISP FIM_DE_LINHA   
    {
            printf("}\n");
    }
    FIM_DE_LINHA
    |WHILE EXPRESSAOCONDICAO DOISP FIM_DE_LINHA 
    {
        printf("while (%s) {\n", $2);
    }DENTRO_DO_LOOP
    {
            printf("}\n");
    }FIM_DE_LINHA
    ;
EXPRESSAOCONDICAO:
 NEGACAO CONDICAO {
    char *temp = (char *)malloc(strlen($2) + strlen(" ! ") + 1);
    sprintf(temp, " !%s",  $2);
    $$ = temp;
} 
| CONDICAO E CONDICAO {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" && ") + 1);
    sprintf(temp, "%s && %s", $1, $3);
    $$ = temp;
}
| CONDICAO OU CONDICAO {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" || ") + 1);
    sprintf(temp, "%s || %s", $1, $3);
    $$ = temp;
}
| CONDICAO  
; 
CONDICAO : 
ID MAIOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" > ") + 1);
    sprintf(temp, "%s > %s", $1, $3);
    $$ = temp;
}
| ID MENOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" < ") + 1);
    sprintf(temp, "%s < %s", $1, $3);
    $$ = temp;
}
| ID IGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" == ") + 1);
    sprintf(temp, "%s == %s", $1, $3);
    $$ = temp;
}| ID MENORIGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" <= ") + 1);
    sprintf(temp, "%s <= %s", $1, $3);
    $$ = temp;
}| ID MAIORIGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" >= ") + 1);
    sprintf(temp, "%s >= %s", $1, $3);
    $$ = temp;
}
; 
VALOR : ID { $$ = $1; }
      | STR { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%
void yyerror(const char *msg) {
    if (strcmp(msg, "syntax error") != 0 || yytext[0] != '\0') {
        fprintf(stderr, "Erro na linha %d: %s\n", yylineno, msg);
    }
} 
int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: ./parser expressao.print\n");
        return -1;
    } 
    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("expressao %s não encontrado!\n", argv[1]);
        return -1;
    }
    yyin = file;

    printf("\n\nIniciando a conversao do codigo python para C!\n\n");
    while (yyparse() == 0) {
    }
    printf("\nSeu codigo foi convertido para C!\n");
    fclose(yyin);
    return 0;
}
