/***********/
/* PURPOSE */
/***********/

This project was an introduction to file manipulation (specifically photos in the .pgm format). 
It involved using either C or C++ to read in a .pgm formatted file, manipulating the image's intensity resolution
or spatial resolution, and writing the changes to the image to a second .pgm file.

/*********************/
/* SOURCE CODE FILES */
/*********************/
program1.cpp

/*******************/
/* EXECUTABLE FILE */
/*******************/
program1.exe

/**************************/
/* RUNNING THE EXECUTABLE */
/**************************/
If the executable is not created, the command "make" must be run to compile the program.
the makefile is located at the top directory.
Make compiles the single source file into an object file. It also generated a dependency file, storing both in the obj directory
If "make" is ran while an executable is present, it will determine if changes have been made to the source code or include files
before re-compiling. If no changes have been made, the user will be informed and no object files will change, which will result in
no changes to the executable

EX. root@DESKTOP-TVJPO3M:/mnt/c/Users/Trever/Desktop/Comp Vision# make
	g++ -std=c++11 -Wall -Wextra -Iinc -MM src/program1.cpp \
	| tr '\n\r\\' ' ' \
	| sed -e 's%^%obj/program1.d %' -e 's% % obj/%'\
	> obj/program1.d
	g++ -std=c++11 -Wall -Wextra -Iinc -c src/program1.cpp -o obj/program1.o
	g++ -std=c++11 -Wall -Wextra obj/program1.o  -o bin/program1.exe
	
	
	root@DESKTOP-TVJPO3M:/mnt/c/Users/Trever/Desktop/Comp Vision# make
	make: 'bin/program1.exe' is up to date.
	
Once the executable is present, running a command of the form "./program1 ../images/arg1 ../images/arg2 arg3" from the 
bin directory will be used to run the program. 
	
ARG1 - the name of the .pgm file to read in
ARG2 - the name of the .pgm file to create and write to
ARG3 - whether "part1" or "part2" of the assignment is to be run

The "../images/" portion is needed for the first two arguments to navigate up a directory and then traverse into the images 
directory to locate the files. If this is not done correctly for arg1, an error will be presented. If it is not done correctly
for arg2, the image will not save in the same directory as the other images but will still execute

If arguments are missing, the user will be informed by the program to include them before continuing 

EX. ./program1 
	ERROR: Add first argument for input file name
	ERROR: Add second argument for output file name
	ERROR: Add third argument of "part1" or "part2" to specify which image to produce
	
	./program1 ../images/clover.pgm
	ERROR: Add second argument for output file name
	ERROR: Add third argument of "part1" or "part2" to specify which image to produce
	
	./program1 ../images/clover.pgm ../images/output.pgm
	ERROR: Add third argument of "part1" or "part2" to specify which image to produce
	
	./program1 ../images/clover.pgm ../images/output.pgm part3
	ERROR: Add third argument of "part1" or "part2" to specify which image to produce
	
	./program1 not_an_image.pgm ../images/output.pgm part1
	ERROR: Failed to open input image file (argument 1). Confirm argument or file existence in specified directory