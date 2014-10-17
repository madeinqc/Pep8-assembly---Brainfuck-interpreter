Pep8-assembly---Brainfuck-interpreter
=====================================

This program read a string of brainfuck and interpret it according to the specification at http://en.wikipedia.org/wiki/Brainfuck.
To do so, we store the program in a table of 265 bytes.
We use a table of 256 bytes for the memory of the brainfuck program.

LIMITS
This program is limited to read brainfuck programs of 256 characters.
It is also limited at 256 memory cells usable by the brainfuck program.
There is no overflow protection and the memory cells dont loop.