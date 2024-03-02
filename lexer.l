%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "index.tab.h"
%}

%option noyywrap
%option nodefault
%option yylineno 
BRANCO [ \t] 
ESPACO {BRANCO}+ 
DIGITO [0-9]
NUMERO {DIGITO}+ 
LETRA [A-Za-z]
STRING_SIMPLES \'[^']*\'
STRING \"[^"]*\"
IDENTIFICADOR {LETRA}+

%%
"def"       { return DEF; }
"return"    { return RETURN; }
","          { return VIRGULA; }
"print"      { return PRINT; }
"("          { return ABREP; }
")"          { return FECHAP; } 
"="          { return ATRIB; }
"+="         { return MAISIGUAL; }
"+"          { return MAIS; }
"-"          { return MENOS; }
"*"          {return VEZES;}
"/"          {return DIVISAO;}
"if"         { return IF; } 
"elif"       { return ELIF; }
"else"       { return ELSE; }
">"          { return MAIOR; }
"<="         { return MENORIGUAL; }
">="         { return MAIORIGUAL; }
"<"          { return MENOR; }
"=="         { return IGUAL; }
"and"        { return E; }
"or"         { return OU; }
"not"        { return NEGACAO; }
"while"      { return WHILE; }
":"          { return DOISP; }
{IDENTIFICADOR} { yylval.str = strdup(yytext); return ID;}
{STRING}     { yylval.str = strdup(yytext); return STR;}
{STRING_SIMPLES} { yylval.str = strdup(yytext); return STR;}
{NUMERO}     { yylval.str = strdup(yytext); return NUM; }
<<EOF>>      { return FIM_ENTRADA; }
{ESPACO}+   { /* Ignore whitespace */ }
.           { printf(yytext) ; }
"\n"+        { yylineno++; return FIM_DE_LINHA; }
%%