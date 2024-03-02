Necessario a instalação do Flex, Bison e de um compilador em C (que nesse caso usamos o GCC)
com tudo isso instalador só ir no terminal executa o comando a seguir: ```flex lexer.l && bison -d -Wcounterexamples index.y && gcc index.tab.c -w  && ./a.out exemplo.txt``` para iniciar a execução do programa. 
