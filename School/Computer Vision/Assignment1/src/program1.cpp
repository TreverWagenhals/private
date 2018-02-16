#include <iostream>
#include <string>
#include <cstring>
#include <fstream>	
#include <ctype.h>

using namespace std;
int main(int argc, char *argv[])
{	
	unsigned char pixel;
	unsigned size_X;
	unsigned size_Y;
	unsigned image_intensity;
	string file_type;
	ifstream input_file;
	ofstream output_file;
	
	// If argc == 1, no arguments were given, output errors about 3 missing arguments
	if (argc == 1)
	{
		cout << "ERROR: Add first argument for input file name" << endl;
		cout << "ERROR: Add second argument for output file name" << endl;
		cout << "ERROR: Add third argument of \"part1\" or \"part2\" to specify which image to produce" << endl;
	}	
	// If argc == 2, one argument was given, output errors about 2 missing arguments
	else if (argc == 2)
	{
		cout << "ERROR: Add second argument for output file name" << endl;
		cout << "ERROR: Add third argument of \"part1\" or \"part2\" to specify which image to produce" << endl;
	}
	// If argc == 3, two arguments were given, output error about 1 missing argument
	else if (argc == 3 || ((strcmp(argv[3], "part1") && strcmp(argv[3], "part2"))))
		cout << "ERROR: Add third argument of \"part1\" or \"part2\" to specify which image to produce" << endl;
	
	// If not enough arguments, exit program
	if (argc < 4)
		return 0;
	
	// Open input file to get image to modify
	input_file.open(argv[1]);
	
	// If file properly opens, read header from file and store in proper variables
	if (input_file.is_open())
		input_file >> file_type >> size_X >> size_Y >> image_intensity;
	else
	{
		cout << "ERROR: Failed to open input image file (argument 1). Confirm argument or file existence in specified directory" << endl;
		return 0;
	}
	
	// Open output file to store modified image
	output_file.open(argv[2]);
	
	// Make sure output file was created
	if (!output_file.is_open())
	{
		cout << "ERROR: Failed to create output file. Try again";
		return 0;
	}
	
	// If part1 argument used, produce image to match part1 requirements. Third quadrant
	// will be blacked out
	if (!strcmp(argv[3], "part1"))
	{
		// Print the three header lines to new file in the same format they were in
		output_file << file_type << endl << size_X << " " << size_Y << endl << image_intensity << endl;
		for (unsigned y = 0; y < size_Y; y++)
		{
			for (unsigned x = 0; x < size_X; x++)
			{
				// Read in each pixel and then decide whether to present it to the write file
				pixel = input_file.get();
				// Output pixel for Quadrants 1, 2, and 4
				if ((y <= size_Y / 2) || ((y > size_Y / 2) && (x > size_X / 2)))
					output_file << pixel;
				// store a byte of value 0 in all Quadrant 3 bytes
				else 
					output_file.put(0);
			}
		}
	}
	// Part2, every other row and column is skipped, changing the resolution from size_X * size_Y
	// to (size_X / 2) * (size_Y / 2)
	else if (!strcmp(argv[3], "part2"))
	{
		// Print the three header lines to new file and edit the #row and #columns to be correct
		output_file << file_type << endl << size_X/2 << " " << size_Y/2 << endl << image_intensity << endl;
		for (unsigned y = 0; y < size_Y; y++)
		{
			for (unsigned x = 0; x < size_X; x++)
			{
				// Read in each pixel and then decide whether to present it to the write file
				pixel = input_file.get();
				// Only write odd column and row pixels
				if ((y % 2 == 1) && (x % 2 == 1))
					output_file.write((char *) &pixel, 1);
			}
		}
	}
	
	// Close files before exiting
	input_file.close();
	output_file.close();
	return 0;
}