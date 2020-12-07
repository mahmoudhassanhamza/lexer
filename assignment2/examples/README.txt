Bison examples for the course "Compiler Design", Technische Universitaet Berlin

The folder contains a couple of examples:

 1. calc
 2. hello

For each code, you can create a lexer by invoking flex by command line, e.g.:

> flex -ocalc.c calc.lex

where calc.lex is the input lex file and calc.c the generated source for the lexer.

Then, you create the parser using bison with the following command:

> bison -vd calc.y -o calc.yy.c

Then, you compile the lexer and parser with the following commands:

> gcc -g calc.yy.c calc.c -o calc.out

Once you have compiled, you can test it with an input file:

> ./calc.out < input.txt

or, instead, with a input string provided by the standard input:

> ./calc.out 
(press CTRL+D to add a EOF)

